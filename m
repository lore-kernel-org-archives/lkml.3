Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab3EJKdC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:33:02 -0400
Received: from 3.mo5.mail-out.ovh.net ([46.105.40.108]:43238 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750914Ab3EJKdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:33:00 -0400
Date: Fri, 10 May 2013 12:26:58 +0200
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
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH] ARM: mmc: bcm281xx SDHCI driver
Message-ID: <20130510102658.GK3041@game.jcrosoft.org>
References: <1368078942-31265-1-git-send-email-csd@broadcom.com>
 <20130509063503.GF3041@game.jcrosoft.org>
 <518CA1DF.5050008@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518CA1DF.5050008@broadcom.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 14728459632964184879
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrjeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrjedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 00:29 Fri 10 May     , Christian Daudt wrote:
> Thanks for the feedback.
> 
> On 13-05-08 11:35 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >On 22:55 Wed 08 May     , Christian Daudt wrote:
> >>Add SDHCI driver for the Broadcom 281xx SoCs. Also
> >>add bindings for it into bcm281xx dts files.
> >>Still missing:
> >>  - power managemement
> >split the dts/dtsi in an other patch
> ok.
> >>Signed-off-by: Christian Daudt <csd@broadcom.com>
> >>
> >>diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
> >>index e3bf2d6..65edf6d 100644
> >>--- a/arch/arm/configs/bcm_defconfig
> >>+++ b/arch/arm/configs/bcm_defconfig
> >>@@ -78,6 +78,13 @@ CONFIG_BACKLIGHT_LCD_SUPPORT=y
> >>  CONFIG_LCD_CLASS_DEVICE=y
> >>  CONFIG_BACKLIGHT_CLASS_DEVICE=y
> >>  # CONFIG_USB_SUPPORT is not set
> >>+CONFIG_MMC=y
> >>+CONFIG_MMC_UNSAFE_RESUME=y
> >>+CONFIG_MMC_BLOCK_MINORS=32
> >>+CONFIG_MMC_TEST=y
> >>+CONFIG_MMC_SDHCI=y
> >>+CONFIG_MMC_SDHCI_PLTFM=y
> >>+CONFIG_MMC_SDHCI_BCM_KONA=y
> >>  CONFIG_NEW_LEDS=y
> >>  CONFIG_LEDS_CLASS=y
> >>  CONFIG_LEDS_TRIGGERS=y
> >>diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> >>index d88219e..e067c5a 100644
> >>--- a/drivers/mmc/host/Kconfig
> >>+++ b/drivers/mmc/host/Kconfig
> >>@@ -238,6 +238,16 @@ config MMC_SDHCI_S3C_DMA
> >>  	  YMMV.
> >>+config MMC_SDHCI_BCM_KONA
> >>+	tristate "SDHCI support on Broadcom KONA platform"
> >>+	depends on ARCH_BCM && MMC_SDHCI_PLTFM
> >select MMC_SDHCI_PLTFM
> >will be better
> Ok - changed it. Why is the select is better than the depends ?
> >>+
> >>+static int sdhci_bcm_kona_sd_reset(struct sdhci_host *host)
> >>+{
> >>+	unsigned int val;
> >>+	unsigned long timeout;
> >>+
> >>+	/* This timeout should be sufficent for core to reset */
> >>+	timeout = jiffies + msecs_to_jiffies(100);
> >>+
> >>+	/* reset the host using the top level reset */
> >>+	val = sdhci_readl(host, KONA_SDHOST_CORECTRL);
> >>+	val |= KONA_SDHOST_RESET;
> >>+	sdhci_writel(host, val, KONA_SDHOST_CORECTRL);
> >>+
> >>+	while (!(sdhci_readl(host, KONA_SDHOST_CORECTRL) & KONA_SDHOST_RESET)) {
> >>+		if (time_is_before_jiffies(timeout)) {
> >>+			pr_err("Error: sd host is stuck in reset!!!\n");
> >>+			return -EFAULT;
> >>+		}
> >>+	}
> >>+
> >>+	/* bring the host out of reset */
> >>+	val = sdhci_readl(host, KONA_SDHOST_CORECTRL);
> >>+	val &= ~KONA_SDHOST_RESET;
> >>+
> >>+	/*
> >>+	 * Back-to-Back register write needs a delay of 1ms at bootup (min 10uS)
> >>+	 * Back-to-Back writes to same register needs delay when SD bus clock
> >>+	 * is very low w.r.t AHB clock, mainly during boot-time and during card
> >>+	 * insert-removal.
> >>+	 */
> >>+	udelay(1000);
> >really a udelay of 1ms
> I'm trying to clarify on whether this is really necessary but it
> does seem that this is the case. I'll send a follow-up patch if I
> manage to get confirmation on a smaller safe number.

a smaller delay will be better otherwise a msleep(1)

Best Regards,
J.
> 
> >>+	sdhci_writel(host, val, KONA_SDHOST_CORECTRL);
> >>+
> >>+	return 0;
> >>+}
> >>+
> >>+static void sdhci_bcm_kona_sd_init(struct sdhci_host *host)
> >>+{
> >>+	unsigned int val;
> >>+
> >>+	/* enable the interrupt from the IP core */
> >>+	val = sdhci_readl(host, KONA_SDHOST_COREIMR);
> >>+	val |= KONA_SDHOST_IP;
> >>+	sdhci_writel(host, val, KONA_SDHOST_COREIMR);
> >>+
> >>+	/* Enable the AHB clock gating module to the host */
> >>+	val = sdhci_readl(host, KONA_SDHOST_CORECTRL);
> >>+	val |= KONA_SDHOST_EN;
> >>+
> >>+	/*
> >>+	 * Back-to-Back register write needs a delay of 1ms at bootup (min 10uS)
> >>+	 * Back-to-Back writes to same register needs delay when SD bus clock
> >>+	 * is very low w.r.t AHB clock, mainly during boot-time and during card
> >>+	 * insert-removal.
> >>+	 */
> >>+	udelay(1000);
> >ditto
> see above
> >>+	sdhci_writel(host, val, KONA_SDHOST_CORECTRL);
> >>+}
> >>+
> >>+/*
> >>+ * Software emulation of the SD card insertion/removal. Set insert=1 for insert
> >>+ * and insert=0 for removal. The card detection is done by GPIO. For Broadcom
> >>+ * IP to function properly the bit 0 of CORESTAT register needs to be set/reset
> >>+ * to generate the CD IRQ handled in sdhci.c which schedules card_tasklet.
> >>+ */
> >>+static int sdhci_bcm_kona_sd_card_emulate(struct sdhci_host *host, int insert)
> >>+{
> >>+	struct sdhci_pltfm_host *pltfm_priv = sdhci_priv(host);
> >>+	struct sdhci_bcm_kona_dev *kona_dev = pltfm_priv->priv;
> >>+	u32 val;
> >>+	unsigned long flags;
> >>+
> >>+	/* this function can be called from various contexts including ISR */
> >>+	spin_lock_irqsave(&host->lock, flags);
> >>+	/* Ensure SD bus scanning to detect media change */
> >>+	host->mmc->rescan_disable = 0;
> >>+
> >>+	/*
> >>+	 * Back-to-Back register write needs a delay of min 10uS.
> >>+	 * Back-to-Back writes to same register needs delay when SD bus clock
> >>+	 * is very low w.r.t AHB clock, mainly during boot-time and during card
> >>+	 * insert-removal.
> >>+	 * We keep 20uS
> >>+	 */
> >>+	udelay(20);
> >>+	val = sdhci_readl(host, KONA_SDHOST_CORESTAT);
> >>+
> >>+	if (insert) {
> >>+		if (kona_dev->cfg->wp_gpio >= 0) {
> >gpio_is_valid
> done
> >>+			int wp_status = gpio_get_value(kona_dev->cfg->wp_gpio);
> >>+
> >>+			if (wp_status)
> >>+				val |= KONA_SDHOST_WP;
> >>+			else
> >>+				val &= ~KONA_SDHOST_WP;
> >>+		}
> >>+
> >>+		val |= KONA_SDHOST_CD_SW;
> >>+		sdhci_writel(host, val, KONA_SDHOST_CORESTAT);
> >>+	} else {
> >>+		val &= ~KONA_SDHOST_CD_SW;
> >>+		sdhci_writel(host, val, KONA_SDHOST_CORESTAT);
> >>+	}
> >>+	spin_unlock_irqrestore(&host->lock, flags);
> >>+
> >>+	return 0;
> >>+}
> >>+
> >>+/*
> >>+ * SD card detection interrupt handler
> >>+ */
> >>+static irqreturn_t sdhci_bcm_kona_pltfm_cd_interrupt(int irq, void *host)
> >>+{
> >>+	struct sdhci_pltfm_host *pltfm_priv = sdhci_priv(host);
> >>+	struct sdhci_bcm_kona_dev *kona_dev = pltfm_priv->priv;
> >>+
> >>+	if (gpio_get_value_cansleep(kona_dev->cfg->cd_gpio) == 0) {
> >>+		pr_debug("card inserted\n");
> >dev_dbg
> done
> >>+		sdhci_bcm_kona_sd_card_emulate(host, 1);
> >>+	} else {
> >>+		pr_debug("card removed\n");
> >ditto
> done
> >>+static struct sdhci_bcm_kona_cfg * __init sdhci_bcm_kona_parse_dt(
> >>+			struct platform_device *pdev)
> >>+{
> >>+	struct sdhci_bcm_kona_cfg *cfg;
> >>+	struct device_node *np = pdev->dev.of_node;
> >>+	u32 temp;
> >>+
> >>+	if (!np)
> >>+		return NULL;
> >>+
> >>+	cfg = devm_kzalloc(&pdev->dev, sizeof(*cfg), GFP_KERNEL);
> >>+	if (!cfg) {
> >>+		dev_err(&pdev->dev, "Can't allocate platform cfg\n");
> >>+		return NULL;
> >>+	}
> >>+
> >>+	cfg->cd_gpio = of_get_named_gpio(np, "cd-gpios", 0);
> >>+	cfg->wp_gpio = of_get_named_gpio(np, "wp-gpios", 0);
> >>+	if (of_get_property(np, "non-removable", NULL))
> >>+		cfg->non_removable = 1;
> >use of_property_read_bool
> done
> >>+		/* Sleep for 128ms to allow debounce to stabilize */
> >>+		msleep(SD_DETECT_GPIO_DEBOUNCE_128MS);
> >>+		/* request irq for cd_gpio after the gpio debounce is
> >>+		 * stabilized, otherwise, some bogus gpio interrupts might be
> >>+		 * triggered.
> >>+		 */
> >>+		irq = gpio_to_irq(kona_dev->cfg->cd_gpio);
> >>+		ret = devm_request_threaded_irq(dev,
> >>+				irq,
> >>+				NULL,
> >>+				sdhci_bcm_kona_pltfm_cd_interrupt,
> >>+				IRQF_TRIGGER_FALLING|
> >>+				IRQF_TRIGGER_RISING |
> >>+				IRQF_ONESHOT |
> >>+				IRQF_NO_SUSPEND, "sdio cd", host);
> >>+		if (ret) {
> >>+			dev_err(kona_dev->dev,
> >>+				"Unable to request card detection irq=%d"
> >>+				" for gpio=%d  ret=%d\n",
> >put the sting of the dev_err on one line so we can grep
> merged it into single line
> 
> 
>  Thanks,
>    csd
> 
> 
