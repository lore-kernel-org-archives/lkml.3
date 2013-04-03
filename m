Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762567Ab3DCOC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:02:56 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:62588 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762417Ab3DCOCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:02:53 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/3] usb: phy: ab8500-usb: check regulator_enable return value
Date: Wed,  3 Apr 2013 16:02:25 +0200
Message-Id: <1364997747-20830-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364997747-20830-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364997747-20830-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since regulator_enable() is going to be marked as __must_check in the
next merge window, always check regulator_enable() return value and
print a warning if it fails.

Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index b8115b0..ac27ed2 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -170,7 +170,9 @@ static void ab8500_usb_regulator_enable(struct ab8500_usb *ab)
 {
 	int ret, volt;
 
-	regulator_enable(ab->v_ape);
+	ret = regulator_enable(ab->v_ape);
+	if (ret)
+		dev_err(ab->dev, "Failed to enable v-ape\n");
 
 	if (!is_ab8500_2p0_or_earlier(ab->ab8500)) {
 		ab->saved_v_ulpi = regulator_get_voltage(ab->v_ulpi);
@@ -188,7 +190,9 @@ static void ab8500_usb_regulator_enable(struct ab8500_usb *ab)
 					ret);
 	}
 
-	regulator_enable(ab->v_ulpi);
+	ret = regulator_enable(ab->v_ulpi);
+	if (ret)
+		dev_err(ab->dev, "Failed to enable vddulpivio18\n");
 
 	if (!is_ab8500_2p0_or_earlier(ab->ab8500)) {
 		volt = regulator_get_voltage(ab->v_ulpi);
@@ -197,7 +201,9 @@ static void ab8500_usb_regulator_enable(struct ab8500_usb *ab)
 					volt);
 	}
 
-	regulator_enable(ab->v_musb);
+	ret = regulator_enable(ab->v_musb);
+	if (ret)
+		dev_err(ab->dev, "Failed to enable musb_1v8\n");
 }
 
 static void ab8500_usb_regulator_disable(struct ab8500_usb *ab)
-- 
1.8.1.3

