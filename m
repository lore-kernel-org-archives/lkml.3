Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab3EJPUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:20:15 -0400
Received: from 13.mo5.mail-out.ovh.net ([87.98.182.191]:43524 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752957Ab3EJPUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:20:12 -0400
Date: Fri, 10 May 2013 16:37:01 +0200
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
Message-ID: <20130510143701.GC22508@game.jcrosoft.org>
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
X-Ovh-Tracer-Id: 508906759276833583
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrjeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrjeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
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

so you do not need to enable MMC_SDHCI_PLTFM

and you can drop one line in the savdefconfig

if tomorrow you need regulator select it so a old defconfig will continue to
work

Best Regards,
J.
