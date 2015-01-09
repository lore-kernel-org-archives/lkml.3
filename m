Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128AbbAIKsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:48:12 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44582 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757454AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 76/78] mfd: stmpe: Fix STMPE24xx GPMR LSB
Date: Fri,  9 Jan 2015 11:32:25 +0100
Message-Id: <83ee596143c7f78fec7c8f36f92be2223d9a8bad.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 871c3cf4ea7d5baf58e0a40bce7431ca5525aa2a upstream.

The least significat byte of the GPIO value read register
on the STMPE24xx series is on addres 0xA4 not 0xA5. Correct
against datasheet and tested on the STMPE2401 hardware.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mfd/stmpe.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
index ff2b09ba8797..50a5c8697bf7 100644
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
2.2.1

