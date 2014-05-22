Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaEVBHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 21:07:00 -0400
Received: from mx9.pku.edu.cn ([162.105.129.172]:32972 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750796AbaEVBG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 21:06:59 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.494
Date: Thu, 22 May 2014 09:06:46 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: gerrit@erg.abdn.ac.uk, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Miller <davem@davemloft.net>, dccp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <579164883.46799.1400720806850.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <537D4C73.40901@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re:_=E5=9B=9E=E5=A4=8D=EF=BC=9A_?=
 =?utf-8?Q?[PATCH_linux-?= =?utf-8?Q?next]_net/dccp/timer.c:_us?=
 =?utf-8?Q?e_'u64'_instead_of_'s64'_to_avoid_compiler's_warning?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> On 05/22/2014 08:26 AM, 管雪涛 wrote:
> > 
> > ----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> >> 'dccp_timestamp_seed' is initialized once by ktime_get_real() in
> >> dccp_timestamping_init(). It is always less than ktime_get_real()
> >> in dccp_timestamp().
> >>
> >> Then, ktime_us_delta() in dccp_timestamp() will always return positive
> >> number. So can use manual type cast to let compiler and do_div() know
> >> about it to avoid warning.
> >>
> >> The related warning (with allmodconfig under unicore32):
> >>
> >>     CC [M]  net/dccp/timer.o
> >>   net/dccp/timer.c: In function ‘dccp_timestamp’:
> >>   net/dccp/timer.c:285: warning: comparison of distinct pointer types lacks a cast
> >>
> >>
> >> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> >> ---
> >>  net/dccp/timer.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/net/dccp/timer.c b/net/dccp/timer.c
> >> index 16f0b22..1cd46a3 100644
> >> --- a/net/dccp/timer.c
> >> +++ b/net/dccp/timer.c
> >> @@ -280,7 +280,7 @@ static ktime_t dccp_timestamp_seed;
> >>   */
> >>  u32 dccp_timestamp(void)
> >>  {
> >> -	s64 delta = ktime_us_delta(ktime_get_real(), dccp_timestamp_seed);
> >> +	u64 delta = (u64)ktime_us_delta(ktime_get_real(), dccp_timestamp_seed);
> > 
> > Do you assume that delta should be very small?
> > Otherwise, return value will be different if data type is changed.
> > 
> 
> 'u64' is a very very large number. after calculation, if it is based on
> nano second (although I am not quite sure whether it is based on it).
> 
>         a hour,            3,600,000,000,000ns
>         a day,            90,000,000,000,000ns
>         a year,       50,000,000,000,000,000ns
>         10 years,    500,000,000,000,000,000ns
>         100 years, 5,000,000,000,000,000,000ns
>         4G * 4G = 16,000,000,000,000,000,000ns
> 
> So we can assume it will never overflow for 'u64'.

However, return value of dccp_timestamp function is u32.

> 
> 
> Thanks.
> -- 
> Chen Gang
> 
> Open, share, and attitude like air, water, and life which God blessed
