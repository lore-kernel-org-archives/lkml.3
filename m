Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbaDPM4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:56:40 -0400
Received: from smtprelay0097.hostedemail.com ([216.40.44.97]:50473 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755262AbaDPM4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:56:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:4250:4321:5007:6119:7652:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:13894,0,RBL:none,CacheIP:none,Bayes
X-HE-Tag: girls45_90e8f2293da5d
X-Filterd-Recvd-Size: 2703
Message-ID: <1397652994.30935.5.camel@joe-AO722>
Subject: Re: [PATCH 1/4] mmc: sdhci: add a driver for Berlin SoCs
From: Joe Perches <joe@perches.com>
To: Antoine =?ISO-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, chris@printf.net, anton@enomsg.org,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 16 Apr 2014 05:56:34 -0700
In-Reply-To: <1397652011-21284-2-git-send-email-antoine.tenart@free-electrons.com>
References: <1397652011-21284-1-git-send-email-antoine.tenart@free-electrons.com>
	 <1397652011-21284-2-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-16 at 14:40 +0200, Antoine Ténart wrote:
> Add a Driver to support the SDHCI controller of the Marvell Berlin SoCs.
> This controller supports 3 sockets.

trivial notes:

> diff --git a/drivers/mmc/host/sdhci-berlin.c b/drivers/mmc/host/sdhci-berlin.c
[]
> +static struct sdhci_ops sdhci_berlin_ops = {
> +	.get_max_clock = sdhci_pltfm_clk_get_max_clock,
> +};
> +
> +static struct sdhci_pltfm_data sdhci_berlin2_pdata = {
> +	.quirks	= SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN |
> +		  SDHCI_QUIRK_BROKEN_ADMA |
> +		  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
> +	.ops = &sdhci_berlin_ops,
> +};
> +
> +static struct sdhci_pltfm_data sdhci_berlin2q_pdata = {
> +	.quirks	= SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN |
> +		  SDHCI_QUIRK_INVERTED_WRITE_PROTECT |
> +		  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
> +	.ops = &sdhci_berlin_ops,
> +};

Perhaps const?

> +static int sdhci_berlin_probe(struct platform_device *pdev)
> +{
[]
> +	host = sdhci_pltfm_init(pdev,
> +				(struct sdhci_pltfm_data *)device->data, 0);

Unnecessary cast?  Maybe:

	host = sdhci_pltfm_init(pdev, device->data, 0);

> +	if (IS_ERR(host))
> +		return PTR_ERR(host);
> +
> +	pltfm_host = sdhci_priv(host);
> +
> +	clk = devm_clk_get(dev, NULL);
> +	if (IS_ERR(clk)) {
> +		dev_err(dev, "could not get clock: %ld\n", PTR_ERR(clk));
> +		ret = PTR_ERR(clk);

PTR_ERR is an int.  Does this produce a compile warning?
Maybe reverse these lines and use ret?

		ret = PTR_ERR(clk);
		dev_err(dev, count not get clock: %d\n", ret);


