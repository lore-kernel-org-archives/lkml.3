Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbaE1QRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:17:03 -0400
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:39268 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752074AbaE1QRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:17:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:1801:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:4321:4605:5007:7652:7903:8603:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: card13_76fc6695fdc36
X-Filterd-Recvd-Size: 1622
Message-ID: <1401293816.19335.3.camel@joe-AO725>
Subject: Re: [PATCH 2/2] lpc_eth: Use resource_size instead of computation
From: Joe Perches <joe@perches.com>
To: Benoit Taine <benoit.taine@lip6.fr>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Wed, 28 May 2014 09:16:56 -0700
In-Reply-To: <1401290047-30005-3-git-send-email-benoit.taine@lip6.fr>
References: <1401290047-30005-1-git-send-email-benoit.taine@lip6.fr>
	 <1401290047-30005-3-git-send-email-benoit.taine@lip6.fr>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 17:14 +0200, Benoit Taine wrote:
> This issue was reported by coccicheck using the semantic patch 
> at scripts/coccinelle/api/resource_size.cocci

Slightly associated trivial note:

> diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
[]
> @@ -1419,8 +1419,7 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
>  
>  	netdev_dbg(ndev, "IO address start     :0x%08x\n",
>  			res->start);
> -	netdev_dbg(ndev, "IO address size      :%d\n",
> -			res->end - res->start + 1);
> +	netdev_dbg(ndev, "IO address size      :%d\n", resource_size(res));

May be better using:

	netdev_dbg(ndev, "IO                       :%pR\n", res)


