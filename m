Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab3BDL5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:57:51 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:63306 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab3BDL5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:48 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Mattias Wallin <mattias.wallin@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 60/73] ARM: ux500: regulators: Add LDO USB consumer
Date: Mon,  4 Feb 2013 11:54:15 +0000
Message-Id: <1359978868-28736-61-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Wallin <mattias.wallin@stericsson.com>

This patch makes it possible to control the LDO USB by adding
a consumer to the regulator board file.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Rickard ANDERSSON <rickard.andersson@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index cc6ec35..793bdae 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -155,6 +155,11 @@ static struct regulator_consumer_supply ab8500_vintcore_consumers[] = {
 	REGULATOR_SUPPLY("vddulpivio18", "ab8500-usb.0"),
 };
 
+static struct regulator_consumer_supply ab8505_usb_consumers[] = {
+	/* HS USB OTG physical interface */
+	REGULATOR_SUPPLY("v-usb", NULL),
+};
+
 static struct regulator_consumer_supply ab8500_vana_consumers[] = {
 	/* External displays, connector on board, 1v8 power supply */
 	REGULATOR_SUPPLY("vsmps2", "mcde.0"),
@@ -915,6 +920,18 @@ struct regulator_init_data ab8505_regulators[AB8505_NUM_REGULATORS] = {
 		.num_consumer_supplies = ARRAY_SIZE(ab8500_vintcore_consumers),
 		.consumer_supplies = ab8500_vintcore_consumers,
 	},
+	/* supply for LDO USB */
+	[AB8505_LDO_USB] = {
+		.constraints = {
+			.name = "V-USB",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS |
+					  REGULATOR_CHANGE_MODE,
+			.valid_modes_mask = REGULATOR_MODE_NORMAL |
+					    REGULATOR_MODE_IDLE,
+		},
+		.num_consumer_supplies = ARRAY_SIZE(ab8505_usb_consumers),
+		.consumer_supplies = ab8505_usb_consumers,
+	},
 	/* supply for U8500 CSI-DSI, VANA LDO */
 	[AB8505_LDO_ANA] = {
 		.constraints = {
-- 
1.7.9.5

