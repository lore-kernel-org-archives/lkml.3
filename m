Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbaFWCVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 22:21:07 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42108 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaFWCVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 22:21:06 -0400
Date: Mon, 23 Jun 2014 11:20:56 +0900
From: Simon Horman <horms@verge.net.au>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Wensong Zhang <wensong@linux-vs.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net/netfilter/ipvs/ip_vs_sync.c: remove null test
 before kfree
Message-ID: <20140623022056.GA12564@verge.net.au>
References: <1403296542-5992-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403296542-5992-1-git-send-email-fabf@skynet.be>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 10:35:42PM +0200, Fabian Frederick wrote:
> Fix checkpatch warning:
> WARNING: kfree(NULL) is safe this check is probably not required
> 
> Cc: Wensong Zhang <wensong@linux-vs.org>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Thanks, applied.

> ---
>  net/netfilter/ipvs/ip_vs_sync.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> index db80126..eadffb2 100644
> --- a/net/netfilter/ipvs/ip_vs_sync.c
> +++ b/net/netfilter/ipvs/ip_vs_sync.c
> @@ -886,8 +886,7 @@ static void ip_vs_proc_conn(struct net *net, struct ip_vs_conn_param *param,
>  		cp = ip_vs_conn_new(param, daddr, dport, flags, dest, fwmark);
>  		rcu_read_unlock();
>  		if (!cp) {
> -			if (param->pe_data)
> -				kfree(param->pe_data);
> +			kfree(param->pe_data);
>  			IP_VS_DBG(2, "BACKUP, add new conn. failed\n");
>  			return;
>  		}
> -- 
> 1.8.4.5
> 
