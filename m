Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaEVAf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 20:35:57 -0400
Received: from mx9.pku.edu.cn ([162.105.129.172]:52009 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751260AbaEVAfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 20:35:55 -0400
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2014 20:35:54 EDT
X-Spam-Flag: NO
X-Spam-Score: -307.483
Date: Thu, 22 May 2014 08:26:39 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: gerrit@erg.abdn.ac.uk, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Miller <davem@davemloft.net>, dccp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <1546102096.46113.1400718399706.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <537BF116.9000900@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH_linux-next]_?=
 =?utf-8?Q?net/dccp/timer.c:_use_'u?=
 =?utf-8?Q?64'_instead_of_'s64'_to_avoid_compiler's_warning?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> 'dccp_timestamp_seed' is initialized once by ktime_get_real() in
> dccp_timestamping_init(). It is always less than ktime_get_real()
> in dccp_timestamp().
> 
> Then, ktime_us_delta() in dccp_timestamp() will always return positive
> number. So can use manual type cast to let compiler and do_div() know
> about it to avoid warning.
> 
> The related warning (with allmodconfig under unicore32):
> 
>     CC [M]  net/dccp/timer.o
>   net/dccp/timer.c: In function ‘dccp_timestamp’:
>   net/dccp/timer.c:285: warning: comparison of distinct pointer types lacks a cast
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  net/dccp/timer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/dccp/timer.c b/net/dccp/timer.c
> index 16f0b22..1cd46a3 100644
> --- a/net/dccp/timer.c
> +++ b/net/dccp/timer.c
> @@ -280,7 +280,7 @@ static ktime_t dccp_timestamp_seed;
>   */
>  u32 dccp_timestamp(void)
>  {
> -	s64 delta = ktime_us_delta(ktime_get_real(), dccp_timestamp_seed);
> +	u64 delta = (u64)ktime_us_delta(ktime_get_real(), dccp_timestamp_seed);

Do you assume that delta should be very small?
Otherwise, return value will be different if data type is changed.

>  
>  	do_div(delta, 10);
>  	return delta;
> -- 
> 1.9.2.459.g68773ac
