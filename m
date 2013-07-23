Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690Ab3GWQKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:10:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54077 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933439Ab3GWQKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:10:09 -0400
From: Illia Smyrnov <illia.smyrnov@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <balbi@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH v2 3/3] Input: omap-keypad: Clear pending interrupts on open
Date: Tue, 23 Jul 2013 19:09:58 +0300
Message-ID: <1374595798-15492-4-git-send-email-illia.smyrnov@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1374595798-15492-1-git-send-email-illia.smyrnov@ti.com>
References: <1374595798-15492-1-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear pending interrupts when open keypad.

Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
---
 drivers/input/keyboard/omap4-keypad.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index b876a0d..62abc3e 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -185,13 +185,14 @@ static int omap4_keypad_open(struct input_dev *input)
 			(OMAP4_VAL_PVT << OMAP4_DEF_CTRL_PTV_SHIFT));
 	kbd_writel(keypad_data, OMAP4_KBD_DEBOUNCINGTIME,
 			OMAP4_VAL_DEBOUNCINGTIME);
-	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS,
-			OMAP4_VAL_IRQDISABLE);
 	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQENABLE,
 			OMAP4_DEF_IRQENABLE_EVENTEN |
 				OMAP4_DEF_IRQENABLE_LONGKEY);
 	kbd_writel(keypad_data, OMAP4_KBD_WAKEUPENABLE,
 			OMAP4_DEF_WUP_EVENT_ENA | OMAP4_DEF_WUP_LONG_KEY_ENA);
+	/* clear pending interrupts */
+	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS,
+			 kbd_read_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS));
 
 	enable_irq(keypad_data->irq);
 
-- 
1.7.0.4

