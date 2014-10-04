Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaJDOCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 10:02:39 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:46609 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaJDOCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 10:02:38 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] mfd: stmpe: fix STMPE24xx GPMR LSB
Date: Sat,  4 Oct 2014 16:02:27 +0200
Message-Id: <1412431347-27230-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The least significat byte of the GPIO value read register
on the STMPE24xx series is on addres 0xA4 not 0xA5. Correct
against datasheet and tested on the STMPE2401 hardware.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Hi Lee, Sam: this should go in for fixes I think.
---
 drivers/mfd/stmpe.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
index 2d045f26f193..bee0abf82040 100644
--- a/drivers/mfd/stmpe.h
+++ b/drivers/mfd/stmpe.h
@@ -269,7 +269,7 @@ int stmpe_remove(struct stmpe *stmpe);
 #define STMPE24XX_REG_CHIP_ID		0x80
 #define STMPE24XX_REG_IEGPIOR_LSB	0x18
 #define STMPE24XX_REG_ISGPIOR_MSB	0x19
-#define STMPE24XX_REG_GPMR_LSB		0xA5
+#define STMPE24XX_REG_GPMR_LSB		0xA4
 #define STMPE24XX_REG_GPSR_LSB		0x85
 #define STMPE24XX_REG_GPCR_LSB		0x88
 #define STMPE24XX_REG_GPDR_LSB		0x8B
-- 
1.9.3

