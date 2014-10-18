Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaJRM42 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 08:56:28 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:42073 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaJRM4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 08:56:25 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/3] mfd: stmpe: add pull up/down register offsets for STMPE
Date: Sat, 18 Oct 2014 14:56:14 +0200
Message-Id: <1413636974-3244-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the register offsets for pull up/down for the STMPE
1601, 1801 and 24xx expanders. This is used to bias GPIO lines
and keypad lines.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Hi Sam, Lee: I think you should just ACK this so Dmitry can take the
patch series through the input tree, where the registers need to be
used to enable the keypad on the STMPE2401.
---
 drivers/mfd/stmpe.c       | 4 ++++
 drivers/mfd/stmpe.h       | 3 +++
 include/linux/mfd/stmpe.h | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 3004d5ba0b82..497505bad4c4 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -547,6 +547,7 @@ static const u8 stmpe1601_regs[] = {
 	[STMPE_IDX_GPDR_LSB]	= STMPE1601_REG_GPIO_SET_DIR_LSB,
 	[STMPE_IDX_GPRER_LSB]	= STMPE1601_REG_GPIO_RE_LSB,
 	[STMPE_IDX_GPFER_LSB]	= STMPE1601_REG_GPIO_FE_LSB,
+	[STMPE_IDX_GPPUR_LSB]	= STMPE1601_REG_GPIO_PU_LSB,
 	[STMPE_IDX_GPAFR_U_MSB]	= STMPE1601_REG_GPIO_AF_U_MSB,
 	[STMPE_IDX_IEGPIOR_LSB]	= STMPE1601_REG_INT_EN_GPIO_MASK_LSB,
 	[STMPE_IDX_ISGPIOR_MSB]	= STMPE1601_REG_INT_STA_GPIO_MSB,
@@ -695,6 +696,7 @@ static const u8 stmpe1801_regs[] = {
 	[STMPE_IDX_GPDR_LSB]	= STMPE1801_REG_GPIO_SET_DIR_LOW,
 	[STMPE_IDX_GPRER_LSB]	= STMPE1801_REG_GPIO_RE_LOW,
 	[STMPE_IDX_GPFER_LSB]	= STMPE1801_REG_GPIO_FE_LOW,
+	[STMPE_IDX_GPPUR_LSB]	= STMPE1801_REG_GPIO_PULL_UP_LOW,
 	[STMPE_IDX_IEGPIOR_LSB]	= STMPE1801_REG_INT_EN_GPIO_MASK_LOW,
 	[STMPE_IDX_ISGPIOR_LSB]	= STMPE1801_REG_INT_STA_GPIO_LOW,
 };
@@ -778,6 +780,8 @@ static const u8 stmpe24xx_regs[] = {
 	[STMPE_IDX_GPDR_LSB]	= STMPE24XX_REG_GPDR_LSB,
 	[STMPE_IDX_GPRER_LSB]	= STMPE24XX_REG_GPRER_LSB,
 	[STMPE_IDX_GPFER_LSB]	= STMPE24XX_REG_GPFER_LSB,
+	[STMPE_IDX_GPPUR_LSB]	= STMPE24XX_REG_GPPUR_LSB,
+	[STMPE_IDX_GPPDR_LSB]	= STMPE24XX_REG_GPPDR_LSB,
 	[STMPE_IDX_GPAFR_U_MSB]	= STMPE24XX_REG_GPAFR_U_MSB,
 	[STMPE_IDX_IEGPIOR_LSB]	= STMPE24XX_REG_IEGPIOR_LSB,
 	[STMPE_IDX_ISGPIOR_MSB]	= STMPE24XX_REG_ISGPIOR_MSB,
diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
index bee0abf82040..84adb46b3e2f 100644
--- a/drivers/mfd/stmpe.h
+++ b/drivers/mfd/stmpe.h
@@ -188,6 +188,7 @@ int stmpe_remove(struct stmpe *stmpe);
 #define STMPE1601_REG_GPIO_ED_MSB		0x8A
 #define STMPE1601_REG_GPIO_RE_LSB		0x8D
 #define STMPE1601_REG_GPIO_FE_LSB		0x8F
+#define STMPE1601_REG_GPIO_PU_LSB		0x91
 #define STMPE1601_REG_GPIO_AF_U_MSB		0x92
 
 #define STMPE1601_SYS_CTRL_ENABLE_GPIO		(1 << 3)
@@ -276,6 +277,8 @@ int stmpe_remove(struct stmpe *stmpe);
 #define STMPE24XX_REG_GPEDR_MSB		0x8C
 #define STMPE24XX_REG_GPRER_LSB		0x91
 #define STMPE24XX_REG_GPFER_LSB		0x94
+#define STMPE24XX_REG_GPPUR_LSB		0x97
+#define STMPE24XX_REG_GPPDR_LSB		0x9a
 #define STMPE24XX_REG_GPAFR_U_MSB	0x9B
 
 #define STMPE24XX_SYS_CTRL_ENABLE_GPIO		(1 << 3)
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index af9e1b07a630..976e1a390177 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -50,6 +50,8 @@ enum {
 	STMPE_IDX_GPEDR_MSB,
 	STMPE_IDX_GPRER_LSB,
 	STMPE_IDX_GPFER_LSB,
+	STMPE_IDX_GPPUR_LSB,
+	STMPE_IDX_GPPDR_LSB,
 	STMPE_IDX_GPAFR_U_MSB,
 	STMPE_IDX_IEGPIOR_LSB,
 	STMPE_IDX_ISGPIOR_LSB,
-- 
1.9.3

