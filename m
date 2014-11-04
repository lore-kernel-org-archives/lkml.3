Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaKDDGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 22:06:43 -0500
Received: from smtprelay0060.hostedemail.com ([216.40.44.60]:49920 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751187AbaKDDGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 22:06:42 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3622:3865:3870:4321:5007:6261:10004:10400:10848:11026:11232:11473:11658:11914:12043:12291:12517:12519:12683:12740:13069:13161:13229:13311:13357:14110:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fork50_3a496924f7f2f
X-Filterd-Recvd-Size: 1422
Message-ID: <1415070399.17743.49.camel@perches.com>
Subject: Re: [PATCH] quota: Add log level to printk
From: Joe Perches <joe@perches.com>
To: Anton Blanchard <anton@samba.org>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org
Date: Mon, 03 Nov 2014 19:06:39 -0800
In-Reply-To: <20141104120501.0318cc7d@kryten>
References: <20141104120501.0318cc7d@kryten>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 12:05 +1100, Anton Blanchard wrote:
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> Index: b/fs/quota/dquot.c
> ===================================================================
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -2743,7 +2743,7 @@ static int __init dquot_init(void)
>  	for (i = 0; i < nr_hash; i++)
>  		INIT_HLIST_HEAD(dquot_hash + i);
>  
> -	printk("Dquot-cache hash table entries: %ld (order %ld, %ld bytes)\n",
> +	pr_info("Dquot-cache hash table entries: %ld (order %ld, %ld bytes)\n",
>  			nr_hash, order, (PAGE_SIZE << order));

The other printks in the file have a "VFS: " prefix.
Maybe this one too?


