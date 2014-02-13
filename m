Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaBMAbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 19:31:42 -0500
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:54870 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751390AbaBMAbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 19:31:40 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3873:4250:4321:4605:5007:7576:7652:9040:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12740:13019:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: quill42_485cb9e241721
X-Filterd-Recvd-Size: 2783
Message-ID: <1392251494.2214.11.camel@joe-AO722>
Subject: Re: [PATCH 08/14] net: axienet: Removed checkpatch errors/warnings
From: Joe Perches <joe@perches.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: netdev@vger.kernel.org, Srikanth Thokala <sthokal@xilinx.com>,
        Srikanth Thokala <srikanth.thokala@xilinx.com>,
        Michal Simek <monstr@monstr.eu>, Anirudha Sarangi <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 12 Feb 2014 16:31:34 -0800
In-Reply-To: <75b669c0a947effe74b291093abfa8c71f83736a.1392220536.git.michal.simek@xilinx.com>
References: <cover.1392220536.git.michal.simek@xilinx.com>
	 <75b669c0a947effe74b291093abfa8c71f83736a.1392220536.git.michal.simek@xilinx.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 16:55 +0100, Michal Simek wrote:
> From: Srikanth Thokala <srikanth.thokala@xilinx.com>

trivia:

> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c

> +			netdev_err(lp->ndev,
> +				"axienet_device_reset DMA reset timeout!\n");

could you please align multi-line arguments to the
appropriate open parenthesis?

			netdev_err(lp->ndev,
				   "axienet_device_reset DMA reset timeout!\n");

or maybe:

			netdev_err(lp->ndev, "%s: "DMA reset timeout!\n",
				   __func__);

> @@ -484,8 +484,8 @@ static void axienet_device_reset(struct net_device *ndev)
>  	}
> 
>  	if (axienet_dma_bd_init(ndev)) {
> -		dev_err(&ndev->dev, "axienet_device_reset descriptor "
> -			"allocation failed\n");
> +		netdev_err(ndev,
> +			"axienet_device_reset descriptor allocation failed\n");

etc, et al.

> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
[]
> @@ -161,19 +161,19 @@ int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
> 
>  	np1 = of_find_node_by_name(NULL, "cpu");
>  	if (!np1) {
> -		printk(KERN_WARNING "%s(): Could not find CPU device node.",
> -		       __func__);
> -		printk(KERN_WARNING "Setting MDIO clock divisor to "
> -		       "default %d\n", DEFAULT_CLOCK_DIVISOR);
> +		netdev_warn(lp->ndev, "Could not find CPU device node.");

missing trailing "\n" to terminate message.

> +		netdev_warn(lp->ndev,
> +			 "Could not find clock ethernet controller property.");

here too. (and alignment)



