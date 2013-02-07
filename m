Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab3BGHnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 02:43:41 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:45592 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3BGHnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 02:43:40 -0500
Date: Thu, 7 Feb 2013 16:43:38 +0900
From: Simon Horman <horms@verge.net.au>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, davem@davemloft.net,
        Julian Anastasov <ja@ssi.bg>, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: fix functions and variables related to
 netns_ipvs->sysctl_sync_qlen_max
Message-ID: <20130207074337.GB17306@verge.net.au>
References: <51131B88.6040809@cn.fujitsu.com>
 <51132A56.60906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51132A56.60906@cn.fujitsu.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 12:15:18PM +0800, Zhang Yanfei wrote:
> Since the type of netns_ipvs->sysctl_sync_qlen_max has been changed to
> unsigned long, type of its related proc var sync_qlen_max should be changed
> to unsigned long, too. Also the return type of function sysctl_sync_qlen_max().
> 
> Besides, the type of ipvs_master_sync_state->sync_queue_len should also be
> changed to unsigned long.
> 
> Changelog from V1:
> - change type of ipvs_master_sync_state->sync_queue_len to unsigned long
>   as Simon addressed.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Miller <davem@davemloft.net>
> Cc: Julian Anastasov <ja@ssi.bg>
> Cc: Simon Horman <horms@verge.net.au>
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Acked-by: Simon Horman <horms@verge.net.au>

> ---
>  include/net/ip_vs.h            |    6 +++---
>  net/netfilter/ipvs/ip_vs_ctl.c |    4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 68c69d5..1d56f92 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -874,7 +874,7 @@ struct ip_vs_app {
>  struct ipvs_master_sync_state {
>  	struct list_head	sync_queue;
>  	struct ip_vs_sync_buff	*sync_buff;
> -	int			sync_queue_len;
> +	unsigned long		sync_queue_len;
>  	unsigned int		sync_queue_delay;
>  	struct task_struct	*master_thread;
>  	struct delayed_work	master_wakeup_work;
> @@ -1052,7 +1052,7 @@ static inline int sysctl_sync_ports(struct netns_ipvs *ipvs)
>  	return ACCESS_ONCE(ipvs->sysctl_sync_ports);
>  }
>  
> -static inline int sysctl_sync_qlen_max(struct netns_ipvs *ipvs)
> +static inline unsigned long sysctl_sync_qlen_max(struct netns_ipvs *ipvs)
>  {
>  	return ipvs->sysctl_sync_qlen_max;
>  }
> @@ -1099,7 +1099,7 @@ static inline int sysctl_sync_ports(struct netns_ipvs *ipvs)
>  	return 1;
>  }
>  
> -static inline int sysctl_sync_qlen_max(struct netns_ipvs *ipvs)
> +static inline unsigned long sysctl_sync_qlen_max(struct netns_ipvs *ipvs)
>  {
>  	return IPVS_SYNC_QLEN_MAX;
>  }
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index ec664cb..d79a530 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -1747,9 +1747,9 @@ static struct ctl_table vs_vars[] = {
>  	},
>  	{
>  		.procname	= "sync_qlen_max",
> -		.maxlen		= sizeof(int),
> +		.maxlen		= sizeof(unsigned long),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec,
> +		.proc_handler	= proc_doulongvec_minmax,
>  	},
>  	{
>  		.procname	= "sync_sock_size",
> -- 
> 1.7.1
> 
