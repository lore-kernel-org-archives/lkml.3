Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbaFNRu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 13:50:59 -0400
Received: from 1wt.eu ([62.212.114.60]:42771 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbaFNRu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 13:50:58 -0400
Date: Sat, 14 Jun 2014 19:50:47 +0200
From: Willy Tarreau <w@1wt.eu>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michal Tesar <mtesar@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, tyler.hicks@canonical.com
Subject: Re: [ 059/143] sysctl net: Keep tcp_syn_retries inside the boundary
Message-ID: <20140614175047.GH15102@1wt.eu>
References: <f07e5fe6d87f172fc73580b9c86ba9a2@local> <20140512003203.088027167@1wt.eu> <20140611184644.GA5442@hercules> <20140611194657.GU28551@1wt.eu> <87sinanv6u.fsf@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sinanv6u.fsf@canonical.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

On Thu, Jun 12, 2014 at 01:55:53PM +0100, Luis Henriques wrote:
> I was finally able to spend some more time with this and tried (a
> modified) Tyler's patch on top of 2.6.32.62, and it seems to work.
> Although I haven't done any extended testing, I don't see the two
> stack traces and the /proc/sys/net/ipv4/ directory seems to be
> correctly populated.
> 
> I'm attaching the patch I've used, based on Tyler's.

Would any of you or Tyler please kindly pass me a signed-off-by with
a commit message ? That would be great. Alternately I'd do it myself
and mention you authored them.

> Cheers,
> -- 
> Luís

Thanks,
Willy

> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index e2eaf29..e6bf72c 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -121,7 +121,8 @@ static struct ctl_table netns_core_table[] = {
>  		.mode		= 0644,
>  		.extra1		= &zero,
>  		.extra2		= &ushort_max,
> -		.proc_handler	= proc_dointvec_minmax
> +		.proc_handler	= proc_dointvec_minmax,
> +		.strategy	= &sysctl_intvec
>  	},
>  	{ .ctl_name = 0 }
>  };
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 910fa54..d957371 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -241,7 +241,8 @@ static struct ctl_table ipv4_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= &tcp_syn_retries_min,
> -		.extra2		= &tcp_syn_retries_max
> +		.extra2		= &tcp_syn_retries_max,
> +		.strategy	= &sysctl_intvec
>  	},
>  	{
>  		.ctl_name	= NET_IPV4_NONLOCAL_BIND,
