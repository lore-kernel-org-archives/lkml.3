Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803Ab3CUQAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:00:19 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42322 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933734Ab3CUQAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:00:15 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/46] ARM: ux500: Update displays in vaux1 consumer list
Date: Thu, 21 Mar 2013 15:59:05 +0000
Message-Id: <1363881583-15234-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 3 more specific consumers pertaining to the displays found
on the u8500 and ST User Interface Boards (UIBs).

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index da96298..161edbc7 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -54,8 +54,12 @@ struct regulator_init_data tps61052_regulator = {
 };
 
 static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
-	/* External displays, connector on board 2v5 power supply */
-	REGULATOR_SUPPLY("vaux12v5", "mcde.0"),
+	/* Main display, u8500 R3 uib */
+	REGULATOR_SUPPLY("vddi", "mcde_disp_sony_acx424akp.0"),
+	/* Main display, u8500 uib and ST uib */
+	REGULATOR_SUPPLY("vdd1", "samsung_s6d16d0.0"),
+	/* Secondary display, ST uib */
+	REGULATOR_SUPPLY("vdd1", "samsung_s6d16d0.1"),
 	/* SFH7741 proximity sensor */
 	REGULATOR_SUPPLY("vcc", "gpio-keys.0"),
 	/* BH1780GLS ambient light sensor */
-- 
1.7.10.4

