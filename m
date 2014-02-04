Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934939AbaBDVRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:17:41 -0500
Received: from smtprelay0252.hostedemail.com ([216.40.44.252]:37747 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933325AbaBDVRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:17:35 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:2901:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:4250:4321:5007:6119:7652:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12679:12740:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: twist98_5e9a03ab3e645
X-Filterd-Recvd-Size: 1905
Message-ID: <1391548648.2538.32.camel@joe-AO722>
Subject: Re: [Patch v5 1/2] dmaengine: add Qualcomm BAM dma driver
From: Joe Perches <joe@perches.com>
To: Andy Gross <agross@codeaurora.org>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Date: Tue, 04 Feb 2014 13:17:28 -0800
In-Reply-To: <1391546556-27702-2-git-send-email-agross@codeaurora.org>
References: <1391546556-27702-1-git-send-email-agross@codeaurora.org>
	 <1391546556-27702-2-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-04 at 14:42 -0600, Andy Gross wrote:
> Add the DMA engine driver for the QCOM Bus Access Manager (BAM) DMA controller
> found in the MSM 8x74 platforms.

trivia: fixable later.

> diff --git a/drivers/dma/qcom_bam_dma.c b/drivers/dma/qcom_bam_dma.c
[]
> +	/* allocate enough room to accomodate the number of entries */
> +	async_desc = kzalloc(sizeof(*async_desc) +
> +			(sg_len * sizeof(struct bam_desc_hw)), GFP_NOWAIT);
> +
> +	if (!async_desc) {
> +		dev_err(bdev->dev, "failed to allocate async descriptor\n");

Unnecessary OOM message as generic alloc has an
OOM message with a dump_stack();

> +static int bam_dma_probe(struct platform_device *pdev)
> +{
[]
> +	ret = clk_prepare_enable(bdev->bamclk);
> +	if (ret) {
> +		dev_err(bdev->dev, "failed to prepare/enable clock");

Missing terminating \n newline


