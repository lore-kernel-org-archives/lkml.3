Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3IJHtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 03:49:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52764 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab3IJHtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 03:49:39 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>, <kishon@ti.com>,
        <ldewangan@nvidia.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH] extcon: palmas: Dont set USB state if ID pin is grounded
Date: Tue, 10 Sep 2013 13:19:29 +0530
Message-ID: <1378799369-15803-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In OMAP5 when USB-HOST is set true, the VBUS regulator  is turned ON.
This causes a VBUS interrupt, ignore the same if we are already in
USB-HOST.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/extcon/extcon-palmas.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 9672f31..91b31af 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -50,6 +50,9 @@ static irqreturn_t palmas_vbus_irq_handler(int irq, void *_palmas_usb)
 	struct palmas_usb *palmas_usb = _palmas_usb;
 	unsigned int vbus_line_state;
 
+	if (palmas_usb->linkstat == PALMAS_USB_STATE_ID)
+		return IRQ_HANDLED;
+
 	palmas_read(palmas_usb->palmas, PALMAS_INTERRUPT_BASE,
 		PALMAS_INT3_LINE_STATE, &vbus_line_state);
 
-- 
1.8.1.4

