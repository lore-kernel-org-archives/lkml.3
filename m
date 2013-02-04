Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab3BDL4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:56:22 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35454 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab3BDL4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:17 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 15/73] ARM: ux500: Update displays in vaux1 consumer list
Date: Mon,  4 Feb 2013 11:53:30 +0000
Message-Id: <1359978868-28736-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
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
index 76f5f4c..c58fc86 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -53,8 +53,12 @@ struct regulator_init_data tps61052_regulator = {
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

