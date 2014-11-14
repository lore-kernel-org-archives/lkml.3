Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161867AbaKNTjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:39:12 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38797 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422646AbaKNTjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:39:09 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Yunkang Tang <yunkang.tang@cn.alps.com>, Vadim Klishko <vadim@cirque.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 5/7] input: alps: Fix name, product and version of dev2 input device
Date: Fri, 14 Nov 2014 20:38:24 +0100
Message-Id: <1415993906-13307-6-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
References: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix name, product and version of dev2 input device based on format
used in function psmouse_switch_protocol() in file psmouse-base.c.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/input/mouse/alps.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 0176425..2b7b74d 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -2407,14 +2407,24 @@ int alps_init(struct psmouse *psmouse)
 		dev1->keybit[BIT_WORD(BTN_MIDDLE)] |= BIT_MASK(BTN_MIDDLE);
 	}
 
+	if (priv->flags & ALPS_DUALPOINT) {
+		/*
+		 * format of input device name is: "protocol vendor name"
+		 * see function psmouse_switch_protocol() in psmouse-base.c
+		 */
+		dev2->name = "AlpsPS/2 ALPS DualPoint Stick";
+		dev2->id.product = PSMOUSE_ALPS;
+		dev2->id.version = priv->proto_version;
+	} else {
+		dev2->name = "PS/2 ALPS Mouse";
+		dev2->id.product = PSMOUSE_PS2;
+		dev2->id.version = 0x0000;
+	}
+
 	snprintf(priv->phys, sizeof(priv->phys), "%s/input1", psmouse->ps2dev.serio->phys);
 	dev2->phys = priv->phys;
-	dev2->name = (priv->flags & ALPS_DUALPOINT) ?
-		     "DualPoint Stick" : "ALPS PS/2 Device";
 	dev2->id.bustype = BUS_I8042;
 	dev2->id.vendor  = 0x0002;
-	dev2->id.product = PSMOUSE_ALPS;
-	dev2->id.version = 0x0000;
 	dev2->dev.parent = &psmouse->ps2dev.serio->dev;
 
 	dev2->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
-- 
1.7.9.5

