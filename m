Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbaBRWum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:50:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbaBRWrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Ruehl <chris.ruehl@gtsys.com.hk>,
        Markus Pargmann <mpa@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.13 34/40] pinctrl: imx27: fix wrong offset to ICONFB
Date: Tue, 18 Feb 2014 14:47:35 -0800
Message-Id: <20140218224434.294244916@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224433.337299968@linuxfoundation.org>
References: <20140218224433.337299968@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Ruehl <chris.ruehl@gtsys.com.hk>

commit 795779df22afc8bdee4e9fbe5c18c47e44974d75 upstream.

The offset to ICONFB was incorrect, this patch set the correct value 0x14.
dev_dbg in function imx1_write_2bit print the wrong address and had been
moved after address calculation.

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Reviewed-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-imx1-core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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
@@ -97,13 +97,13 @@ static void imx1_write_2bit(struct imx1_
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


