Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967793Ab3DRKMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:12:49 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52678 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967716Ab3DRKMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:12:44 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/32] ARM: ux500: Strip out duplicate USB DMA configuration
Date: Thu, 18 Apr 2013 11:11:48 +0100
Message-Id: <1366279934-30761-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the moment at least, the TX and RX channels for DB8500 USB are
identical, so this patch generalises them into a single structure
and passes it twice. Once as the TX and again for the RX configuration.
We're keeping the infrastructure the same i.e. passing the TX and RX
separately in case they start to differ on latter incarnations of the
platform.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index f72cc9b..a15678d 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -166,18 +166,7 @@ static void __init db8500_add_gpios(struct device *parent)
 	dbx500_add_pinctrl(parent, "pinctrl-db8500", U8500_PRCMU_BASE);
 }
 
-static int usb_db8500_rx_dma_cfg[] = {
-	DB8500_DMA_DEV38_USB_OTG_IEP_AND_OEP_1_9,
-	DB8500_DMA_DEV37_USB_OTG_IEP_AND_OEP_2_10,
-	DB8500_DMA_DEV36_USB_OTG_IEP_AND_OEP_3_11,
-	DB8500_DMA_DEV19_USB_OTG_IEP_AND_OEP_4_12,
-	DB8500_DMA_DEV18_USB_OTG_IEP_AND_OEP_5_13,
-	DB8500_DMA_DEV17_USB_OTG_IEP_AND_OEP_6_14,
-	DB8500_DMA_DEV16_USB_OTG_IEP_AND_OEP_7_15,
-	DB8500_DMA_DEV39_USB_OTG_IEP_AND_OEP_8
-};
-
-static int usb_db8500_tx_dma_cfg[] = {
+static int usb_db8500_dma_cfg[] = {
 	DB8500_DMA_DEV38_USB_OTG_IEP_AND_OEP_1_9,
 	DB8500_DMA_DEV37_USB_OTG_IEP_AND_OEP_2_10,
 	DB8500_DMA_DEV36_USB_OTG_IEP_AND_OEP_3_11,
@@ -219,7 +208,7 @@ struct device * __init u8500_init_devices(struct ab8500_platform_data *ab8500)
 
 	db8500_add_rtc(parent);
 	db8500_add_gpios(parent);
-	db8500_add_usb(parent, usb_db8500_rx_dma_cfg, usb_db8500_tx_dma_cfg);
+	db8500_add_usb(parent, usb_db8500_dma_cfg, usb_db8500_dma_cfg);
 
 	for (i = 0; i < ARRAY_SIZE(platform_devs); i++)
 		platform_devs[i]->dev.parent = parent;
@@ -238,7 +227,7 @@ static struct device * __init u8500_of_init_devices(void)
 {
 	struct device *parent = db8500_soc_device_init();
 
-	db8500_add_usb(parent, usb_db8500_rx_dma_cfg, usb_db8500_tx_dma_cfg);
+	db8500_add_usb(parent, usb_db8500_dma_cfg, usb_db8500_dma_cfg);
 
 	u8500_dma40_device.dev.parent = parent;
 
-- 
1.7.10.4

