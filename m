Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaIKOkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:40:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46998 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751481AbaIKOka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:40:30 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wenyou Yang <wenyou.yang@atmel.com>
Subject: [PATCH] pinctrl: at91: disable Pull-Down or Pull-Up property before enabling Pull-Up or Pull-Down.
Date: Thu, 11 Sep 2014 16:40:15 +0200
Message-Id: <1410446415-29410-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wenyou Yang <wenyou.yang@atmel.com>

Because the pin's Pull-Up and Pull-Down property is mutually exclusive.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/pinctrl/pinctrl-at91.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index a3d8902438c7..ee9c0b7aad14 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -371,6 +371,9 @@ static unsigned at91_mux_get_pullup(void __iomem *pio, unsigned pin)
 
 static void at91_mux_set_pullup(void __iomem *pio, unsigned mask, bool on)
 {
+	if (on)
+		writel_relaxed(mask, pio + PIO_PPDDR);
+
 	writel_relaxed(mask, pio + (on ? PIO_PUER : PIO_PUDR));
 }
 
@@ -499,6 +502,9 @@ static bool at91_mux_pio3_get_pulldown(void __iomem *pio, unsigned pin)
 
 static void at91_mux_pio3_set_pulldown(void __iomem *pio, unsigned mask, bool is_on)
 {
+	if (is_on)
+		__raw_writel(mask, pio + PIO_PUDR);
+
 	__raw_writel(mask, pio + (is_on ? PIO_PPDER : PIO_PPDDR));
 }
 
-- 
1.9.1

