Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaGFQbI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 12:31:08 -0400
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:51796 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751188AbaGFQbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 12:31:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3871:3872:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12679:12740:13069:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brass74_267f8be9f8b55
X-Filterd-Recvd-Size: 1697
Message-ID: <1404664263.27043.35.camel@joe-AO725>
Subject: Re: [PATCH] thunderbolt: Correct the size argument to devm_kzalloc
From: Joe Perches <joe@perches.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Date: Sun, 06 Jul 2014 09:31:03 -0700
In-Reply-To: <20140706161342.GA6267@himangi-Dell>
References: <20140706161342.GA6267@himangi-Dell>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-06 at 21:43 +0530, Himangi Saraogi wrote:
> nhi->rx_rings does not have type as struct tb_ring *, as it is a
> double pointer so the elements of the array should have pointer type,
> not structure type.
[]
> diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
[]
> @@ -570,10 +570,10 @@ static int nhi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	INIT_WORK(&nhi->interrupt_work, nhi_interrupt_work);
>  
>  	nhi->tx_rings = devm_kzalloc(&pdev->dev,
> -				     nhi->hop_count * sizeof(struct tb_ring),
> +				     nhi->hop_count * sizeof(*nhi->tx_rings),
>  				     GFP_KERNEL);
>  	nhi->rx_rings = devm_kzalloc(&pdev->dev,
> -				     nhi->hop_count * sizeof(struct tb_ring),
> +				     nhi->hop_count * sizeof(*nhi->rx_rings),
>  				     GFP_KERNEL);

It could use devm_kcalloc here too.

btw: are there many false positives with the cocci test?

