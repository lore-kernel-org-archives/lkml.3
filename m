Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874Ab3D3Pl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 11:41:56 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:44593 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab3D3Plx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 11:41:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/5] ARM: ux500: Stop passing DMA platform data though AUXDATA
Date: Tue, 30 Apr 2013 16:41:35 +0100
Message-Id: <1367336497-10650-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367336497-10650-1-git-send-email-lee.jones@linaro.org>
References: <1367336497-10650-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMA platform data is now empty due to some recent refactoring,
so there is no longer a requirement to pass it though.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index a2c83c2..2b6cbde 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -264,8 +264,7 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80125000,
 		"ux500-msp-i2s.3", &msp3_platform_data),
 	/* Requires clock name bindings and channel address lookup table. */
-	OF_DEV_AUXDATA("stericsson,db8500-dma40", 0x801C0000,
-		       "dma40.0", &dma40_plat_data),
+	OF_DEV_AUXDATA("stericsson,db8500-dma40", 0x801C0000, "dma40.0", NULL),
 	{},
 };
 
-- 
1.7.10.4

