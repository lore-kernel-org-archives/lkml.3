Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaHSVKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 17:10:00 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:39736 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbaHSVJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 17:09:54 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        sparclinux@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] sparc: i8042-sparcio.h: fix unused kbd_res warning
Date: Tue, 19 Aug 2014 23:09:37 +0200
Message-Id: <1408482577-17837-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 2.1.0.rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kbd_res is used only when CONFIG_PCI is defined; condition its declaration as
well. This fixes the following compilation warning:

  drivers/input/serio/i8042-sparcio.h:20:25: warning: ‘kbd_res’ defined but not used [-Wunused-variable]

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
---

Hi,

This can be seen with e.g. sparc alldefconfig.

Best regards,

V.

 drivers/input/serio/i8042-sparcio.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/serio/i8042-sparcio.h b/drivers/input/serio/i8042-sparcio.h
index d6aa4c6..93cb791 100644
--- a/drivers/input/serio/i8042-sparcio.h
+++ b/drivers/input/serio/i8042-sparcio.h
@@ -17,7 +17,6 @@ static int i8042_aux_irq = -1;
 #define I8042_MUX_PHYS_DESC "sparcps2/serio%d"
 
 static void __iomem *kbd_iobase;
-static struct resource *kbd_res;
 
 #define I8042_COMMAND_REG	(kbd_iobase + 0x64UL)
 #define I8042_DATA_REG		(kbd_iobase + 0x60UL)
@@ -44,6 +43,8 @@ static inline void i8042_write_command(int val)
 
 #ifdef CONFIG_PCI
 
+static struct resource *kbd_res;
+
 #define OBP_PS2KBD_NAME1	"kb_ps2"
 #define OBP_PS2KBD_NAME2	"keyboard"
 #define OBP_PS2MS_NAME1		"kdmouse"
-- 
2.1.0.rc1

