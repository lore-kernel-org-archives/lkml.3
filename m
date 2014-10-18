Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaJRM6E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 08:58:04 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:64993 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaJRM6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 08:58:02 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: nomadik: amend MMC/SD pins
Date: Sat, 18 Oct 2014 14:57:53 +0200
Message-Id: <1413637073-3443-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a missing MMC/SD pin for MCDATDIR2 which is routed as
alt B, add it to the MMC/SD pin group and functions.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/nomadik/pinctrl-nomadik-stn8815.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/nomadik/pinctrl-nomadik-stn8815.c b/drivers/pinctrl/nomadik/pinctrl-nomadik-stn8815.c
index ed39dcafd4f8..2cd71470f270 100644
--- a/drivers/pinctrl/nomadik/pinctrl-nomadik-stn8815.c
+++ b/drivers/pinctrl/nomadik/pinctrl-nomadik-stn8815.c
@@ -291,6 +291,7 @@ static const unsigned u0_a_1_pins[] = { STN8815_PIN_B4, STN8815_PIN_D5,
 static const unsigned mmcsd_a_1_pins[] = { STN8815_PIN_B10, STN8815_PIN_A10,
 	STN8815_PIN_C11, STN8815_PIN_B11, STN8815_PIN_A11, STN8815_PIN_C12,
 	STN8815_PIN_B12, STN8815_PIN_A12, STN8815_PIN_C13, STN8815_PIN_C15 };
+static const unsigned mmcsd_b_1_pins[] = { STN8815_PIN_D15 };
 static const unsigned u1_a_1_pins[] = { STN8815_PIN_M2, STN8815_PIN_L1,
 					STN8815_PIN_F3, STN8815_PIN_F2 };
 static const unsigned i2c1_a_1_pins[] = { STN8815_PIN_L4, STN8815_PIN_L3 };
@@ -305,6 +306,7 @@ static const unsigned i2cusb_b_1_pins[] = { STN8815_PIN_C21, STN8815_PIN_C20 };
 static const struct nmk_pingroup nmk_stn8815_groups[] = {
 	STN8815_PIN_GROUP(u0_a_1, NMK_GPIO_ALT_A),
 	STN8815_PIN_GROUP(mmcsd_a_1, NMK_GPIO_ALT_A),
+	STN8815_PIN_GROUP(mmcsd_b_1, NMK_GPIO_ALT_B),
 	STN8815_PIN_GROUP(u1_a_1, NMK_GPIO_ALT_A),
 	STN8815_PIN_GROUP(i2c1_a_1, NMK_GPIO_ALT_A),
 	STN8815_PIN_GROUP(i2c0_a_1, NMK_GPIO_ALT_A),
@@ -317,7 +319,7 @@ static const struct nmk_pingroup nmk_stn8815_groups[] = {
 static const char * const a##_groups[] = { b };
 
 STN8815_FUNC_GROUPS(u0, "u0_a_1");
-STN8815_FUNC_GROUPS(mmcsd, "mmcsd_a_1");
+STN8815_FUNC_GROUPS(mmcsd, "mmcsd_a_1", "mmcsd_b_1");
 STN8815_FUNC_GROUPS(u1, "u1_a_1", "u1_b_1");
 STN8815_FUNC_GROUPS(i2c1, "i2c1_a_1");
 STN8815_FUNC_GROUPS(i2c0, "i2c0_a_1");
-- 
1.9.3

