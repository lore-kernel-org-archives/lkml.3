Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab3IRMRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:17:15 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:54613 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3IRMPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:22 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 35/41] ARM: ux500: Relocate AUXDATA relating to MSP (Audio)
Date: Wed, 18 Sep 2013 13:14:32 +0100
Message-Id: <1379506478-16625-36-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSP no longer requires clock-name bindings, so we need to move them to
a more appropriate header indicating that we're still passing DMA
related platform data to them.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 44b4879..dd6af6c 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -224,6 +224,14 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("arm,pl18x", 0x80118000, "sdi1",  &mop500_sdi1_data),
 	OF_DEV_AUXDATA("arm,pl18x", 0x80005000, "sdi2",  &mop500_sdi2_data),
 	OF_DEV_AUXDATA("arm,pl18x", 0x80114000, "sdi4",  &mop500_sdi4_data),
+	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80123000,
+		       "ux500-msp-i2s.0", &msp0_platform_data),
+	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80124000,
+		       "ux500-msp-i2s.1", &msp1_platform_data),
+	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80117000,
+		       "ux500-msp-i2s.2", &msp2_platform_data),
+	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80125000,
+		       "ux500-msp-i2s.3", &msp3_platform_data),
 	/* Requires clock name bindings. */
 	OF_DEV_AUXDATA("stericsson,db8500-musb", 0xa03e0000, "musb-ux500.0", NULL),
 	OF_DEV_AUXDATA("stericsson,db8500-prcmu", 0x80157000, "db8500-prcmu",
@@ -236,15 +244,6 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	/* Requires device name bindings. */
 	OF_DEV_AUXDATA("stericsson,db8500-pinctrl", U8500_PRCMU_BASE,
 		"pinctrl-db8500", NULL),
-	/* Requires clock name and DMA bindings. */
-	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80123000,
-		"ux500-msp-i2s.0", &msp0_platform_data),
-	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80124000,
-		"ux500-msp-i2s.1", &msp1_platform_data),
-	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80117000,
-		"ux500-msp-i2s.2", &msp2_platform_data),
-	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80125000,
-		"ux500-msp-i2s.3", &msp3_platform_data),
 	/* Requires clock name bindings and channel address lookup table. */
 	OF_DEV_AUXDATA("stericsson,db8500-dma40", 0x801C0000, "dma40.0", NULL),
 	{},
-- 
1.8.1.2

