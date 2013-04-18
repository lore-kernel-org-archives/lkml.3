Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab3DRJah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:30:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33607 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609Ab3DRJad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:30:33 -0400
Date: Thu, 18 Apr 2013 10:30:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: mmci: Allow MMCI to request channels with
	information acquired from DT
Message-ID: <20130418093012.GI14496@n2100.arm.linux.org.uk>
References: <1366205534-25079-1-git-send-email-lee.jones@linaro.org> <20130418080238.GB3137@gmail.com> <20130418081549.GE14496@n2100.arm.linux.org.uk> <201304181125.44983.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304181125.44983.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:25:44AM +0200, Arnd Bergmann wrote:
> +static void mmci_dma_setup(struct device *dev, struct mmci_host *host)
> +{
> +	const char *rxname, *txname;
> +
> +	host->dma_rx_channel = dma_request_slave_channel(dev, "rx");
> +	host->dma_tx_channel = dma_request_slave_channel(dev, "tx");
> +
> +	if (!host->dma_rx_channel && !host->dma_tx_channel) {
> +		if (host->plat && host->plat->dma_filter)
> +			mmci_dma_plat_setup(host);
> +		else
> +			dev_info(mmc_dev(host->mmc), "no DMA platform data\n");
> +			return;

You may like to fix the sillies in this patch... but yes, the above
would be better.
