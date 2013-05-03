Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569Ab3ECOpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:45:14 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:44955 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933392Ab3ECOeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:34:24 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 29/63] ARM: ux500: Stop passing MMC's platform data for Device Tree boots
Date: Fri,  3 May 2013 15:32:15 +0100
Message-Id: <1367591569-32197-30-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was required to pass DMA channel configuration information to the
MMC driver before the new DMA API was in place. Now that it is, and
is fully compatible with Device Tree we can stop doing that.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 91fcde8..bb8f58f 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -240,10 +240,10 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("arm,pl011", 0x80121000, "uart1", NULL),
 	OF_DEV_AUXDATA("arm,pl011", 0x80007000, "uart2", NULL),
 	OF_DEV_AUXDATA("arm,pl022", 0x80002000, "ssp0",  &ssp0_plat),
-	OF_DEV_AUXDATA("arm,pl18x", 0x80126000, "sdi0",  &mop500_sdi0_data),
-	OF_DEV_AUXDATA("arm,pl18x", 0x80118000, "sdi1",  &mop500_sdi1_data),
-	OF_DEV_AUXDATA("arm,pl18x", 0x80005000, "sdi2",  &mop500_sdi2_data),
-	OF_DEV_AUXDATA("arm,pl18x", 0x80114000, "sdi4",  &mop500_sdi4_data),
+	OF_DEV_AUXDATA("arm,pl18x", 0x80126000, "sdi0",  NULL),
+	OF_DEV_AUXDATA("arm,pl18x", 0x80118000, "sdi1",  NULL),
+	OF_DEV_AUXDATA("arm,pl18x", 0x80005000, "sdi2",  NULL),
+	OF_DEV_AUXDATA("arm,pl18x", 0x80114000, "sdi4",  NULL),
 	/* Requires clock name bindings. */
 	OF_DEV_AUXDATA("st,nomadik-gpio", 0x8012e000, "gpio.0", NULL),
 	OF_DEV_AUXDATA("st,nomadik-gpio", 0x8012e080, "gpio.1", NULL),
-- 
1.7.10.4

