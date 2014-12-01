Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaLASs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 13:48:58 -0500
Received: from muin.pair.com ([209.68.1.55]:62380 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbaLASs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 13:48:57 -0500
Message-ID: <547CB817.10806@tabi.org>
Date: Mon, 01 Dec 2014 12:48:55 -0600
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>, Markus Pargmann <mpa@pengutronix.de>,
        Jiada Wang <jiada_wang@mentor.com>
CC: alsa-devel@alsa-project.org, lgirdwood@gmail.com, tiwai@suse.de,
        Li.Xiubo@freescale.com, nicoleotsuka@gmail.com, broonie@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: fsl_ssi: free irq before irq_dispose_mapping()
References: <1417402251-6596-1-git-send-email-jiada_wang@mentor.com> <20141201065046.GB27289@pengutronix.de> <547C9C34.9080602@metafoo.de>
In-Reply-To: <547C9C34.9080602@metafoo.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 10:49 AM, Lars-Peter Clausen wrote:
> The driver creates the mapping by calling irq_of_parse_and_map(), so it
> also has to dispose the mapping.

I agree with Markus, this does seem weird.  It sounds like you're saying 
that irq_of_parse_and_map() and devm_request_irq() are incompatible.  A 
quick grep shows the following drivers that call both functions:

ata/pata_mpc52xx.c
built-in.o
cpufreq/exynos5440-cpufreq.c
crypto/omap-sham.c
dma/moxart-dma.c
edac/mpc85xx_edac.c
hsi/clients/nokia-modem.c
i2c/busses/i2c-wmt.c
input/serio/apbps2.c
mmc/host/omap_hsmmc.c
mmc/host/moxart-mmc.c
mtd/nand/mpc5121_nfc.c
net/ethernet/arc/emac_main.c
net/ethernet/moxa/moxart_ether.c
pci/host/pcie-rcar.c
pinctrl/samsung/pinctrl-exynos5440.c
pinctrl/samsung/pinctrl-exynos.c
pinctrl/pinctrl-bcm2835.c
spi/spi-bcm2835.c
spi/spi-mpc512x-psc.c
staging/xillybus/xillybus_of.c
thermal/samsung/exynos_tmu.c

