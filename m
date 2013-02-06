Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab3BFLGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:06:24 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:56071 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab3BFKyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:54:51 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/49] ARM: ux500: Update displays in vaux1 consumer list
Date: Wed,  6 Feb 2013 10:53:31 +0000
Message-Id: <1360148051-7560-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
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
index 7cb52e6..dbbeb20 100644
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
1.7.9.5

