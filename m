Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaCJBrJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 21:47:09 -0400
Received: from smtprelay0084.hostedemail.com ([216.40.44.84]:50439 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752179AbaCJBrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 21:47:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:966:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1981:2194:2196:2199:2200:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3868:4250:4321:4385:4605:5007:7652:9040:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rose14_38dbbd634055
X-Filterd-Recvd-Size: 1914
Message-ID: <1394416022.30791.7.camel@joe-AO722>
Subject: Re: [PATCH v2][RESENT] dma: add R-Car Audio DMAC peri peri driver
From: Joe Perches <joe@perches.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux-SH <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, dmaengine@vger.kernel.org
Date: Sun, 09 Mar 2014 18:47:02 -0700
In-Reply-To: <874n36supd.wl%kuninori.morimoto.gx@gmail.com>
References: <878uu6gle8.wl%kuninori.morimoto.gx@gmail.com>
	 <874n36supd.wl%kuninori.morimoto.gx@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-09 at 18:34 -0700, Kuninori Morimoto wrote:
> Add support Audio DMAC peri peri driver
> for Renesas R-Car Gen2 SoC, using 'shdma-base'
> DMA driver framework.

Trivial notes:

> diff --git a/drivers/dma/sh/rcar-audmapp.c b/drivers/dma/sh/rcar-audmapp.c
[]
> +static int audmapp_chan_probe(struct platform_device *pdev,
> +			      struct audmapp_device *audev, int id)
> +{
[]
> +	auchan = devm_kzalloc(dev, sizeof(struct audmapp_chan), GFP_KERNEL);
> +	if (!auchan) {
> +		dev_err(dev, "No free memory for allocating dma channels!\n");

Unnecessary OOM as the alloc has a generic OOM
and a dump_stack()

[]
> +static int audmapp_probe(struct platform_device *pdev)
> +{
[]
> +	audev = devm_kzalloc(&pdev->dev, sizeof(struct audmapp_device),
> +			     GFP_KERNEL);
> +	if (!audev) {
> +		dev_err(&pdev->dev, "Not enough memory\n");

here too


