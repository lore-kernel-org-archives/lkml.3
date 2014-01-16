Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaAPBS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:18:27 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:41596 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaAPBSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:18:25 -0500
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
To: linus.walleij@linaro.org
Cc: mpa@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm@lists.infradead.org, Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: [PATCH] imx27: pinctrl: fix wrong offset to ICONFB
Date: Thu, 16 Jan 2014 09:18:23 +0800
Message-Id: <1389835103-14811-1-git-send-email-chris.ruehl@gtsys.com.hk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The offset to ICONFB was incorrect, this patch set the correct value 0x14.
dev_dbg in function imx1_write_2bit print the wrong address and had been
moved after address calculation.

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
---
 drivers/pinctrl/pinctrl-imx1-core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-imx1-core.c b/drivers/pinctrl/pinctrl-imx1-core.c
index f77914a..8dfc3dc 100644
--- a/drivers/pinctrl/pinctrl-imx1-core.c
+++ b/drivers/pinctrl/pinctrl-imx1-core.c
@@ -45,7 +45,7 @@ struct imx1_pinctrl {
 #define MX1_DDIR 0x00
 #define MX1_OCR 0x04
 #define MX1_ICONFA 0x0c
-#define MX1_ICONFB 0x10
+#define MX1_ICONFB 0x14
 #define MX1_GIUS 0x20
 #define MX1_GPR 0x38
 #define MX1_PUEN 0x40
@@ -97,13 +97,13 @@ static void imx1_write_2bit(struct imx1_pinctrl *ipctl, unsigned int pin_id,
 	u32 old_val;
 	u32 new_val;
 
-	dev_dbg(ipctl->dev, "write: register 0x%p offset %d value 0x%x\n",
-			reg, offset, value);
-
 	/* Use the next register if the pin's port pin number is >=16 */
 	if (pin_id % 32 >= 16)
 		reg += 0x04;
 
+	dev_dbg(ipctl->dev, "write: register 0x%p offset %d value 0x%x\n",
+			reg, offset, value);
+
 	/* Get current state of pins */
 	old_val = readl(reg);
 	old_val &= mask;
-- 
1.7.10.4

