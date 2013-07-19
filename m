Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483Ab3GSNE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:04:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55134 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760025Ab3GSNDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:03:51 -0400
From: Illia Smyrnov <illia.smyrnov@globallogic.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH 1/2] Input: omap-keypad: Cleanup - use bitfiled instead of hardcoded values
Date: Fri, 19 Jul 2013 16:03:46 +0300
Message-ID: <1374239027-3927-2-git-send-email-illia.smyrnov@globallogic.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1374239027-3927-1-git-send-email-illia.smyrnov@globallogic.com>
References: <1374239027-3927-1-git-send-email-illia.smyrnov@globallogic.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Illia Smyrnov <illia.smyrnov@ti.com>

Use bitfiled instead of hardcoded values to set KBD_CTRL, use BIT macro,
remove unused defines.

Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
---
 drivers/input/keyboard/omap4-keypad.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index f4aa53a..c727548 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -53,21 +53,17 @@
 #define OMAP4_KBD_FULLCODE63_32		0x48
 
 /* OMAP4 bit definitions */
-#define OMAP4_DEF_IRQENABLE_EVENTEN	(1 << 0)
-#define OMAP4_DEF_IRQENABLE_LONGKEY	(1 << 1)
-#define OMAP4_DEF_IRQENABLE_TIMEOUTEN	(1 << 2)
-#define OMAP4_DEF_WUP_EVENT_ENA		(1 << 0)
-#define OMAP4_DEF_WUP_LONG_KEY_ENA	(1 << 1)
-#define OMAP4_DEF_CTRL_NOSOFTMODE	(1 << 1)
-#define OMAP4_DEF_CTRLPTVVALUE		(1 << 2)
-#define OMAP4_DEF_CTRLPTV		(1 << 1)
+#define OMAP4_DEF_IRQENABLE_EVENTEN	BIT(0)
+#define OMAP4_DEF_IRQENABLE_LONGKEY	BIT(1)
+#define OMAP4_DEF_WUP_EVENT_ENA		BIT(0)
+#define OMAP4_DEF_WUP_LONG_KEY_ENA	BIT(1)
+#define OMAP4_DEF_CTRL_NOSOFTMODE	BIT(1)
+#define OMAP4_DEF_CTRL_PTV_SHIFT	2
 
 /* OMAP4 values */
-#define OMAP4_VAL_IRQDISABLE		0x00
-#define OMAP4_VAL_DEBOUNCINGTIME	0x07
-#define OMAP4_VAL_FUNCTIONALCFG		0x1E
-
-#define OMAP4_MASK_IRQSTATUSDISABLE	0xFFFF
+#define OMAP4_VAL_IRQDISABLE		0x0
+#define OMAP4_VAL_DEBOUNCINGTIME	0x7
+#define OMAP4_VAL_PVT			0x7
 
 enum {
 	KBD_REVISION_OMAP4 = 0,
@@ -175,7 +171,8 @@ static int omap4_keypad_open(struct input_dev *input)
 	disable_irq(keypad_data->irq);
 
 	kbd_writel(keypad_data, OMAP4_KBD_CTRL,
-			OMAP4_VAL_FUNCTIONALCFG);
+			OMAP4_DEF_CTRL_NOSOFTMODE |
+			(OMAP4_VAL_PVT << OMAP4_DEF_CTRL_PTV_SHIFT));
 	kbd_writel(keypad_data, OMAP4_KBD_DEBOUNCINGTIME,
 			OMAP4_VAL_DEBOUNCINGTIME);
 	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS,
-- 
1.7.0.4

