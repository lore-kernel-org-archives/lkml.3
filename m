Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3EIMjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 08:39:39 -0400
Received: from 6.mo1.mail-out.ovh.net ([46.105.43.205]:38550 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751567Ab3EIMjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 08:39:37 -0400
X-Greylist: delayed 20399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 May 2013 08:39:37 EDT
Date: Thu, 9 May 2013 08:35:03 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Christian Daudt <csd@broadcom.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, Chris Ball <cjb@laptop.org>,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wei WANG <wei_wang@realsil.com.cn>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Arnd Bergmann <arnd@arndb.de>, "Mike A. Chan" <mikechan@google.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, csd_b@daudt.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH] ARM: mmc: bcm281xx SDHCI driver
Message-ID: <20130509063503.GF3041@game.jcrosoft.org>
References: <1368078942-31265-1-git-send-email-csd@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368078942-31265-1-git-send-email-csd@broadcom.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 4938196993054780207
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrieelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrieelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22:55 Wed 08 May     , Christian Daudt wrote:
> Add SDHCI driver for the Broadcom 281xx SoCs. Also
> add bindings for it into bcm281xx dts files.
> Still missing:
>  - power managemement

split the dts/dtsi in an other patch
> 
> Signed-off-by: Christian Daudt <csd@broadcom.com>
> 
> diff --git a/Documentation/devicetree/bindings/mmc/bcm,kona-sdhci.txt b/Documentation/devicetree/bindings/mmc/bcm,kona-sdhci.txt
> new file mode 100644
> index 0000000..ad1c4bd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mmc/bcm,kona-sdhci.txt
> @@ -0,0 +1,16 @@
> +Broadcom BCM281xx SDHCI driver
> +
> +This file documents differences between the core properties in mmc.txt
> +and the properties in the bcm281xx driver.
> +
> +Required properties:
> +- compatible : Should be "bcm,kona-sdhci"
> +
> +Example:
> +
> +sdio2: sdio@0x3f1a0000 {
> +	compatible = "bcm,kona-sdhci";
> +	reg = <0x3f1a0000 0x10000>;
> +	interrupts = <0x0 74 0x4>;
> +};
> +
> diff --git a/arch/arm/boot/dts/bcm11351-brt.dts b/arch/arm/boot/dts/bcm11351-brt.dts
> index 248067c..9ae3404 100644
> --- a/arch/arm/boot/dts/bcm11351-brt.dts
> +++ b/arch/arm/boot/dts/bcm11351-brt.dts
> @@ -27,4 +27,21 @@
>  		status = "okay";
>  	};
>  
> +	sdio0: sdio@0x3f180000 {
> +		max-frequency = <48000000>;
> +		status = "okay";
> +	};
> +
> +	sdio1: sdio@0x3f190000 {
> +		non-removable;
> +		max-frequency = <48000000>;
> +		status = "okay";
> +	};
> +
> +	sdio3: sdio@0x3f1b0000 {
> +		max-frequency = <48000000>;
> +		status = "okay";
> +	};
> +
> +
>  };
> diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
> index ad13588..6606b41 100644
> --- a/arch/arm/boot/dts/bcm11351.dtsi
> +++ b/arch/arm/boot/dts/bcm11351.dtsi
> @@ -47,4 +47,33 @@
>  		    cache-unified;
>  		    cache-level = <2>;
>  	};
> +
> +	sdio0: sdio@0x3f180000 {
> +		compatible = "bcm,kona-sdhci";
> +		reg = <0x3f180000 0x10000>;
> +		interrupts = <0x0 77 0x4>;
> +		status = "disabled";
> +	};
> +
> +	sdio1: sdio@0x3f190000 {
> +		compatible = "bcm,kona-sdhci";
> +		reg = <0x3f190000 0x10000>;
> +		interrupts = <0x0 76 0x4>;
> +		status = "disabled";
> +	};
> +
> +	sdio2: sdio@0x3f1a0000 {
> +		compatible = "bcm,kona-sdhci";
> +		reg = <0x3f1a0000 0x10000>;
> +		interrupts = <0x0 74 0x4>;
> +		status = "disabled";
> +	};
> +
> +	sdio3: sdio@0x3f1b0000 {
> +		compatible = "bcm,kona-sdhci";
> +		reg = <0x3f1b0000 0x10000>;
> +		interrupts = <0x0 73 0x4>;
> +		status = "disabled";
> +	};
> +
>  };
> diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
> index e3bf2d6..65edf6d 100644
> --- a/arch/arm/configs/bcm_defconfig
> +++ b/arch/arm/configs/bcm_defconfig
> @@ -78,6 +78,13 @@ CONFIG_BACKLIGHT_LCD_SUPPORT=y
>  CONFIG_LCD_CLASS_DEVICE=y
>  CONFIG_BACKLIGHT_CLASS_DEVICE=y
>  # CONFIG_USB_SUPPORT is not set
> +CONFIG_MMC=y
> +CONFIG_MMC_UNSAFE_RESUME=y
> +CONFIG_MMC_BLOCK_MINORS=32
> +CONFIG_MMC_TEST=y
> +CONFIG_MMC_SDHCI=y
> +CONFIG_MMC_SDHCI_PLTFM=y
> +CONFIG_MMC_SDHCI_BCM_KONA=y
>  CONFIG_NEW_LEDS=y
>  CONFIG_LEDS_CLASS=y
>  CONFIG_LEDS_TRIGGERS=y
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index d88219e..e067c5a 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -238,6 +238,16 @@ config MMC_SDHCI_S3C_DMA
>  
>  	  YMMV.
>  
> +config MMC_SDHCI_BCM_KONA
> +	tristate "SDHCI support on Broadcom KONA platform"
> +	depends on ARCH_BCM && MMC_SDHCI_PLTFM
select MMC_SDHCI_PLTFM
will be better
> +	help
> +	  This selects the Broadcom Kona Secure Digital Host Controller
> +	  Interface(SDHCI) support.
> +	  This is used in Broadcom mobile SoCs.
> +
> +	  If you have a controller with this interface, say Y or M here.
> +
>  config MMC_SDHCI_BCM2835
>  	tristate "SDHCI platform support for the BCM2835 SD/MMC Controller"
>  	depends on ARCH_BCM2835
> diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
> index c380e3c..a9f582b 100644
> --- a/drivers/mmc/host/Makefile
> +++ b/drivers/mmc/host/Makefile
> @@ -59,6 +59,7 @@ obj-$(CONFIG_MMC_SDHCI_DOVE)		+= sdhci-dove.o
>  obj-$(CONFIG_MMC_SDHCI_TEGRA)		+= sdhci-tegra.o
>  obj-$(CONFIG_MMC_SDHCI_OF_ESDHC)	+= sdhci-of-esdhc.o
>  obj-$(CONFIG_MMC_SDHCI_OF_HLWD)		+= sdhci-of-hlwd.o
> +obj-$(CONFIG_MMC_SDHCI_BCM_KONA)	+= sdhci-bcm-kona.o
>  obj-$(CONFIG_MMC_SDHCI_BCM2835)		+= sdhci-bcm2835.o
>  
>  ifeq ($(CONFIG_CB710_DEBUG),y)
> diff --git a/drivers/mmc/host/sdhci-bcm-kona.c b/drivers/mmc/host/sdhci-bcm-kona.c
> new file mode 100644
> index 0000000..27188b9
> --- /dev/null
> +++ b/drivers/mmc/host/sdhci-bcm-kona.c
> @@ -0,0 +1,486 @@
> +/*
> + * Copyright (C) 2013 Broadcom Corporation
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/highmem.h>
> +#include <linux/platform_device.h>
> +#include <linux/mmc/host.h>
> +#include <linux/io.h>
> +#include <linux/gpio.h>
> +#include <linux/clk.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_gpio.h>
> +#include <linux/version.h>
> +
> +#include "sdhci-pltfm.h"
> +#include "sdhci.h"
> +
> +#define SDHCI_SOFT_RESET			0x01000000
> +#define KONA_SDHOST_CORECTRL			0x8000
> +#define KONA_SDHOST_CD_PINCTRL			0x00000008
> +#define KONA_SDHOST_STOP_HCLK			0x00000004
> +#define KONA_SDHOST_RESET			0x00000002
> +#define KONA_SDHOST_EN				0x00000001
> +
> +#define KONA_SDHOST_CORESTAT			0x8004
> +#define KONA_SDHOST_WP				0x00000002
> +#define KONA_SDHOST_CD_SW			0x00000001
> +
> +#define KONA_SDHOST_COREIMR			0x8008
> +#define KONA_SDHOST_IP				0x00000001
> +
> +#define KONA_SDHOST_COREISR			0x800C
> +#define KONA_SDHOST_COREIMSR			0x8010
> +#define KONA_SDHOST_COREDBG1			0x8014
> +#define KONA_SDHOST_COREGPO_MASK		0x8018
> +
> +#define SD_DETECT_GPIO_DEBOUNCE_128MS		128
> +
> +#define KONA_MMC_AUTOSUSPEND_DELAY		(50)
> +
> +struct sdhci_bcm_kona_cfg {
> +	unsigned int	max_freq;
> +	int		is_8bit;
> +	int		irq;
> +	int		cd_gpio;
> +	int		wp_gpio;
> +	int		non_removable;
> +};
> +
> +struct sdhci_bcm_kona_dev {
> +	struct sdhci_bcm_kona_cfg *cfg;
> +	struct device *dev;
> +	struct sdhci_host *host;
> +	struct clk *peri_clk;
> +	struct clk *sleep_clk;
> +};
> +
> +
> +static int sdhci_bcm_kona_sd_reset(struct sdhci_host *host)
> +{
> +	unsigned int val;
> +	unsigned long timeout;
> +
> +	/* This timeout should be sufficent for core to reset */
> +	timeout = jiffies + msecs_to_jiffies(100);
> +
> +	/* reset the host using the top level reset */
> +	val = sdhci_readl(host, KONA_SDHOST_CORECTRL);
> +	val |= KONA_SDHOST_RESET;
> +	sdhci_writel(host, val, KONA_SDHOST_CORECTRL);
> +
> +	while (!(sdhci_readl(host, KONA_SDHOST_CORECTRL) & KONA_SDHOST_RESET)) {
> +		if (time_is_before_jiffies(timeout)) {
> +			pr_err("Error: sd host is stuck in reset!!!\n");
> +			return -EFAULT;
> +		}
> +	}
> +
> +	/* bring the host out of reset */
> +	val = sdhci_readl(host, KONA_SDHOST_CORECTRL);
> +	val &= ~KONA_SDHOST_RESET;
> +
> +	/*
> +	 * Back-to-Back register write needs a delay of 1ms at bootup (min 10uS)
> +	 * Back-to-Back writes to same register needs delay when SD bus clock
> +	 * is very low w.r.t AHB clock, mainly during boot-time and during card
> +	 * insert-removal.
> +	 */
> +	udelay(1000);
really a udelay of 1ms
> +	sdhci_writel(host, val, KONA_SDHOST_CORECTRL);
> +
> +	return 0;
> +}
> +
> +static void sdhci_bcm_kona_sd_init(struct sdhci_host *host)
> +{
> +	unsigned int val;
> +
> +	/* enable the interrupt from the IP core */
> +	val = sdhci_readl(host, KONA_SDHOST_COREIMR);
> +	val |= KONA_SDHOST_IP;
> +	sdhci_writel(host, val, KONA_SDHOST_COREIMR);
> +
> +	/* Enable the AHB clock gating module to the host */
> +	val = sdhci_readl(host, KONA_SDHOST_CORECTRL);
> +	val |= KONA_SDHOST_EN;
> +
> +	/*
> +	 * Back-to-Back register write needs a delay of 1ms at bootup (min 10uS)
> +	 * Back-to-Back writes to same register needs delay when SD bus clock
> +	 * is very low w.r.t AHB clock, mainly during boot-time and during card
> +	 * insert-removal.
> +	 */
> +	udelay(1000);
ditto
> +	sdhci_writel(host, val, KONA_SDHOST_CORECTRL);
> +}
> +
> +/*
> + * Software emulation of the SD card insertion/removal. Set insert=1 for insert
> + * and insert=0 for removal. The card detection is done by GPIO. For Broadcom
> + * IP to function properly the bit 0 of CORESTAT register needs to be set/reset
> + * to generate the CD IRQ handled in sdhci.c which schedules card_tasklet.
> + */
> +static int sdhci_bcm_kona_sd_card_emulate(struct sdhci_host *host, int insert)
> +{
> +	struct sdhci_pltfm_host *pltfm_priv = sdhci_priv(host);
> +	struct sdhci_bcm_kona_dev *kona_dev = pltfm_priv->priv;
> +	u32 val;
> +	unsigned long flags;
> +
> +	/* this function can be called from various contexts including ISR */
> +	spin_lock_irqsave(&host->lock, flags);
> +	/* Ensure SD bus scanning to detect media change */
> +	host->mmc->rescan_disable = 0;
> +
> +	/*
> +	 * Back-to-Back register write needs a delay of min 10uS.
> +	 * Back-to-Back writes to same register needs delay when SD bus clock
> +	 * is very low w.r.t AHB clock, mainly during boot-time and during card
> +	 * insert-removal.
> +	 * We keep 20uS
> +	 */
> +	udelay(20);
> +	val = sdhci_readl(host, KONA_SDHOST_CORESTAT);
> +
> +	if (insert) {
> +		if (kona_dev->cfg->wp_gpio >= 0) {
gpio_is_valid
> +			int wp_status = gpio_get_value(kona_dev->cfg->wp_gpio);
> +
> +			if (wp_status)
> +				val |= KONA_SDHOST_WP;
> +			else
> +				val &= ~KONA_SDHOST_WP;
> +		}
> +
> +		val |= KONA_SDHOST_CD_SW;
> +		sdhci_writel(host, val, KONA_SDHOST_CORESTAT);
> +	} else {
> +		val &= ~KONA_SDHOST_CD_SW;
> +		sdhci_writel(host, val, KONA_SDHOST_CORESTAT);
> +	}
> +	spin_unlock_irqrestore(&host->lock, flags);
> +
> +	return 0;
> +}
> +
> +/*
> + * SD card detection interrupt handler
> + */
> +static irqreturn_t sdhci_bcm_kona_pltfm_cd_interrupt(int irq, void *host)
> +{
> +	struct sdhci_pltfm_host *pltfm_priv = sdhci_priv(host);
> +	struct sdhci_bcm_kona_dev *kona_dev = pltfm_priv->priv;
> +
> +	if (gpio_get_value_cansleep(kona_dev->cfg->cd_gpio) == 0) {
> +		pr_debug("card inserted\n");
dev_dbg
> +		sdhci_bcm_kona_sd_card_emulate(host, 1);
> +	} else {
> +		pr_debug("card removed\n");
ditto
> +		sdhci_bcm_kona_sd_card_emulate(host, 0);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/*
> + * Get the base clock. Use central clock source for now. Not sure if different
> + * clock speed to each dev is allowed
> + */
> +static unsigned int sdhci_bcm_kona_get_max_clk(struct sdhci_host *host)
> +{
> +	struct sdhci_bcm_kona_dev *kona_dev;
> +	struct sdhci_pltfm_host *pltfm_priv = sdhci_priv(host);
> +	kona_dev = pltfm_priv->priv;
> +
> +	return kona_dev->cfg->max_freq;
> +}
> +
> +static unsigned int sdhci_bcm_kona_get_timeout_clock(struct sdhci_host *host)
> +{
> +	return sdhci_bcm_kona_get_max_clk(host);
> +}
> +
> +static void sdhci_bcm_kona_init_74_clocks(struct sdhci_host *host,
> +				u8 power_mode)
> +{
> +	if (power_mode == MMC_POWER_OFF)
> +		return;
> +	else
> +		mdelay(10);
> +}
> +
> +static struct sdhci_ops sdhci_bcm_kona_ops = {
> +	.get_max_clock = sdhci_bcm_kona_get_max_clk,
> +	.get_timeout_clock = sdhci_bcm_kona_get_timeout_clock,
> +	.platform_send_init_74_clocks = sdhci_bcm_kona_init_74_clocks,
> +};
> +
> +static struct sdhci_pltfm_data sdhci_pltfm_data_kona = {
> +	.ops    = &sdhci_bcm_kona_ops,
> +	.quirks = SDHCI_QUIRK_NO_CARD_NO_RESET |
> +		SDHCI_QUIRK_BROKEN_TIMEOUT_VAL | SDHCI_QUIRK_32BIT_DMA_ADDR |
> +		SDHCI_QUIRK_32BIT_DMA_SIZE | SDHCI_QUIRK_32BIT_ADMA_SIZE |
> +		SDHCI_QUIRK_FORCE_BLK_SZ_2048 |
> +		SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
> +};
> +
> +static const struct of_device_id sdhci_bcm_kona_of_match[] __initdata = {
> +	{ .compatible = "bcm,kona-sdhci", .data = &sdhci_pltfm_data_kona },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, sdhci_bcm_kona_of_match);
> +
> +static struct sdhci_bcm_kona_cfg * __init sdhci_bcm_kona_parse_dt(
> +			struct platform_device *pdev)
> +{
> +	struct sdhci_bcm_kona_cfg *cfg;
> +	struct device_node *np = pdev->dev.of_node;
> +	u32 temp;
> +
> +	if (!np)
> +		return NULL;
> +
> +	cfg = devm_kzalloc(&pdev->dev, sizeof(*cfg), GFP_KERNEL);
> +	if (!cfg) {
> +		dev_err(&pdev->dev, "Can't allocate platform cfg\n");
> +		return NULL;
> +	}
> +
> +	cfg->cd_gpio = of_get_named_gpio(np, "cd-gpios", 0);
> +	cfg->wp_gpio = of_get_named_gpio(np, "wp-gpios", 0);
> +	if (of_get_property(np, "non-removable", NULL))
> +		cfg->non_removable = 1;
use of_property_read_bool
> +
> +	if (of_property_read_u32(np, "bus-width", &temp) == 0 && temp == 8)
> +		cfg->is_8bit = 1;
> +
> +	if (of_property_read_u32(np, "max-frequency", &cfg->max_freq)) {
> +		dev_err(&pdev->dev, "Missing max-freq for SDHCI cfg\n");
> +		return NULL;
> +	}
> +	return cfg;
> +}
> +
> +static int __init sdhci_bcm_kona_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *match;
> +	struct sdhci_bcm_kona_cfg *kona_cfg = NULL;
> +	const struct sdhci_pltfm_data *plat_data;
> +	struct sdhci_bcm_kona_dev *kona_dev = NULL;
> +	struct sdhci_pltfm_host *pltfm_priv;
> +	struct device *dev = &pdev->dev;
> +	struct sdhci_host *host;
> +	int ret;
> +	unsigned int irq;
> +	ret = 0;
> +
> +	match = of_match_device(sdhci_bcm_kona_of_match, &pdev->dev);
> +	if (!match)
> +		plat_data = &sdhci_pltfm_data_kona;
> +	else
> +		plat_data = match->data;
> +
> +	host = sdhci_pltfm_init(pdev, (struct sdhci_pltfm_data *)plat_data);
> +	if (IS_ERR(host))
> +		return PTR_ERR(host);
> +
> +	kona_cfg = dev->platform_data;
> +	if (!kona_cfg)
> +		kona_cfg = sdhci_bcm_kona_parse_dt(pdev);
> +
> +	if (!kona_cfg) {
> +		ret = -ENXIO;
> +		goto err_pltfm_free;
> +	}
> +
> +	dev_dbg(dev, "%s: inited. IOADDR=%p\n", __func__, host->ioaddr);
> +
> +	pltfm_priv = sdhci_priv(host);
> +
> +	kona_dev = devm_kzalloc(dev, sizeof(*kona_dev), GFP_KERNEL);
> +	if (!kona_dev) {
> +		dev_err(dev, "Can't allocate kona_dev\n");
> +		ret = -ENOMEM;
> +		goto err_pltfm_free;
> +	}
> +	kona_dev->cfg = kona_cfg;
> +	kona_dev->dev = dev;
> +	pltfm_priv->priv = kona_dev;
> +
> +	dev_dbg(dev, "non-removable=%c\n",
> +		 (kona_cfg->non_removable) ? 'Y' : 'N');
> +	dev_dbg(dev, "cd_gpio %d, wp_gpio %d\n", kona_cfg->cd_gpio,
> +		 kona_cfg->wp_gpio);
> +
> +	if (kona_cfg->non_removable) {
> +		host->mmc->caps |= MMC_CAP_NONREMOVABLE;
> +		host->quirks |= SDHCI_QUIRK_BROKEN_CARD_DETECTION;
> +	}
> +
> +	dev_dbg(dev, "is_8bit=%c\n", (kona_cfg->is_8bit) ? 'Y' : 'N');
> +	if (kona_cfg->is_8bit)
> +		host->mmc->caps |= MMC_CAP_8_BIT_DATA;
> +
> +	ret = sdhci_bcm_kona_sd_reset(host);
> +	if (ret)
> +		goto err_pltfm_free;
> +
> +	sdhci_bcm_kona_sd_init(host);
> +
> +	ret = sdhci_add_host(host);
> +	if (ret) {
> +		dev_err(dev, "Failed sdhci_add_host\n");
> +		goto err_reset;
> +	}
> +
> +	/* if device is eMMC, emulate card insert right here */
> +	if (kona_cfg->non_removable) {
> +		ret = sdhci_bcm_kona_sd_card_emulate(host, 1);
> +		if (ret) {
> +			dev_err(dev,
> +				"unable to emulate card insertion\n");
> +			goto err_remove_host;
> +		}
> +	} else if (kona_dev->cfg->cd_gpio >= 0) {
> +		ret = devm_gpio_request(dev, kona_dev->cfg->cd_gpio, "sdio cd");
> +		if (ret < 0) {
> +			dev_err(kona_dev->dev,
> +				"Unable to request GPIO pin %d\n",
> +				kona_dev->cfg->cd_gpio);
> +			goto err_remove_host;
> +		}
> +
> +		gpio_direction_input(kona_dev->cfg->cd_gpio);
> +
> +		/* Set debounce for SD Card detect to maximum value (128ms)
> +		 *
> +		 * NOTE-1: If gpio_set_debounce() returns error we still
> +		 * continue with the default debounce value set. Another reason
> +		 * for doing this is that on rhea-ray boards the SD Detect GPIO
> +		 * is on GPIO Expander and gpio_set_debounce() will return error
> +		 * and if we return error from here, then probe() would fail and
> +		 * SD detection would always fail.
> +		 *
> +		 * NOTE-2: We also give a msleep() of the "debounce" time here
> +		 * so that we give enough time for the debounce to stabilize
> +		 * before we read the gpio value in gpio_get_value_cansleep().
> +		 */
> +		ret = gpio_set_debounce(kona_dev->cfg->cd_gpio,
> +				(SD_DETECT_GPIO_DEBOUNCE_128MS * 1000));
> +		if (ret < 0) {
> +			dev_err(kona_dev->dev,
> +				"%s: gpio set debounce failed."
> +				"default debounce value assumed\n", __func__);
> +		}
> +
> +		/* Sleep for 128ms to allow debounce to stabilize */
> +		msleep(SD_DETECT_GPIO_DEBOUNCE_128MS);
> +		/* request irq for cd_gpio after the gpio debounce is
> +		 * stabilized, otherwise, some bogus gpio interrupts might be
> +		 * triggered.
> +		 */
> +		irq = gpio_to_irq(kona_dev->cfg->cd_gpio);
> +		ret = devm_request_threaded_irq(dev,
> +				irq,
> +				NULL,
> +				sdhci_bcm_kona_pltfm_cd_interrupt,
> +				IRQF_TRIGGER_FALLING|
> +				IRQF_TRIGGER_RISING |
> +				IRQF_ONESHOT |
> +				IRQF_NO_SUSPEND, "sdio cd", host);
> +		if (ret) {
> +			dev_err(kona_dev->dev,
> +				"Unable to request card detection irq=%d"
> +				" for gpio=%d  ret=%d\n",
put the sting of the dev_err on one line so we can grep
> +				gpio_to_irq(kona_dev->cfg->cd_gpio),
> +				kona_dev->cfg->cd_gpio, ret);
> +			goto err_remove_host;
> +		}
> +		if (kona_dev->cfg->wp_gpio >= 0) {
> +			ret = devm_gpio_request(dev,
> +				kona_dev->cfg->wp_gpio, "sdio wp");
> +			if (ret < 0) {
> +				dev_err(&pdev->dev,
> +					"Unable to request WP pin %d\n",
> +					kona_dev->cfg->wp_gpio);
> +				kona_dev->cfg->wp_gpio = -1;
> +			} else {
> +				gpio_direction_input(kona_dev->cfg->wp_gpio);
> +			}
> +		}
> +
> +		/*
> +		 * Since the card detection GPIO interrupt is configured to be
> +		 * edge sensitive, check the initial GPIO value here, emulate
> +		 * only if the card is present
> +		 */
> +		if (gpio_get_value_cansleep(kona_dev->cfg->cd_gpio) == 0)
> +			sdhci_bcm_kona_sd_card_emulate(host, 1);
> +	}
> +
> +	dev_dbg(dev, "initialized properly\n");
> +	return 0;
> +
> +err_remove_host:
> +	sdhci_remove_host(host, 0);
> +
> +err_reset:
> +	sdhci_bcm_kona_sd_reset(host);
> +
> +err_pltfm_free:
> +	sdhci_pltfm_free(pdev);
> +
> +	dev_err(dev, "Probing of sdhci-pltfm failed: %d\n", ret);
> +	return ret;
> +}
> +
> +static int __exit sdhci_bcm_kona_remove(struct platform_device *pdev)
> +{
> +	struct sdhci_host *host = platform_get_drvdata(pdev);
> +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +	struct sdhci_bcm_kona_dev *kona_dev = pltfm_host->priv;
> +	int dead;
> +	u32 scratch;
> +
> +	dead = 0;
> +	scratch = readl(host->ioaddr + SDHCI_INT_STATUS);
> +	if (scratch == (u32)-1)
> +		dead = 1;
> +	sdhci_remove_host(host, dead);
> +
> +	sdhci_free_host(host);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver sdhci_bcm_kona_driver = {
> +	.driver		= {
> +		.name	= "sdhci-kona",
> +		.owner	= THIS_MODULE,
> +		.pm	= SDHCI_PLTFM_PMOPS,
> +		.of_match_table = of_match_ptr(sdhci_bcm_kona_of_match),
> +	},
> +	.probe		= sdhci_bcm_kona_probe,
> +	.remove		= __exit_p(sdhci_bcm_kona_remove),
> +};
> +module_platform_driver(sdhci_bcm_kona_driver);
> +
> +MODULE_DESCRIPTION("SDHCI driver for Broadcom Kona platform");
> +MODULE_AUTHOR("Broadcom");
> +MODULE_LICENSE("GPL v2");
> +
> -- 
> 1.7.10.4
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
