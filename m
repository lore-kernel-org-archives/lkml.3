Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3GXOfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:35:34 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:61954 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3GXOf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:35:29 -0400
Message-ID: <51EFE62A.70901@cogentembedded.com>
Date: Wed, 24 Jul 2013 18:35:22 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Francesco Fusco <ffusco@redhat.com>
CC: davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] sysctl: range checking in do_proc_dointvec_ms_jiffies_conv
References: <cover.1374654531.git.ffusco@redhat.com> <de72e4265ab874b70b127011bb1ef8c2d27bfe63.1374654531.git.ffusco@redhat.com>
In-Reply-To: <de72e4265ab874b70b127011bb1ef8c2d27bfe63.1374654531.git.ffusco@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-07-2013 12:39, Francesco Fusco wrote:

> When (integer) sysctl values are expressed in ms and have to be
> represented internally as jiffies. The msecs_to_jiffies function
> returns an unsigned long, which gets assigned to the integer.
> This patch prevents the value to be assigned if bigger than
> INT_MAX, done in a similar way as in cba9f3 ("Range checking in
> do_proc_dointvec_(userhz_)jiffies_conv").

> Signed-off-by: Francesco Fusco <ffusco@redhat.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: linux-kernel@vger.kernel.org
> ---
>   kernel/sysctl.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)

> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index ac09d98..00813e5 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -2346,7 +2346,11 @@ static int do_proc_dointvec_ms_jiffies_conv(bool *negp, unsigned long *lvalp,
>   					    int write, void *data)
>   {
>   	if (write) {
> -		*valp = msecs_to_jiffies(*negp ? -*lvalp : *lvalp);
> +		unsigned long jif = 0;

    Pointless initializer. And an empty line wouldn't hurt after declaration.

> +		jif =  msecs_to_jiffies(*negp ? -*lvalp : *lvalp);

    One space after = is enough.

> +		if (jif > INT_MAX)
> +			return 1;
> +		*valp = (int)jif;

WBR, Sergei

