Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3H0N0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:26:09 -0400
Received: from 15.mo1.mail-out.ovh.net ([188.165.38.232]:44339 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751957Ab3H0N0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:26:08 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH] pinctrl: at91: fix get_pullup/down function return
Date: Tue, 27 Aug 2013 15:19:21 +0200
Message-Id: <1377609561-22054-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 12059232429329250476
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In PIO_PUSR and PIO_PPDSR register if a given bit is set 1 this means the
pullup/down for this pin (pin is represented as a bit position) is
disabled.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/pinctrl/pinctrl-at91.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index b90a3a0..19afb9a 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -325,7 +325,7 @@ static void at91_mux_disable_interrupt(void __iomem *pio, unsigned mask)
 
 static unsigned at91_mux_get_pullup(void __iomem *pio, unsigned pin)
 {
-	return (readl_relaxed(pio + PIO_PUSR) >> pin) & 0x1;
+	return !((readl_relaxed(pio + PIO_PUSR) >> pin) & 0x1);
 }
 
 static void at91_mux_set_pullup(void __iomem *pio, unsigned mask, bool on)
@@ -445,7 +445,7 @@ static void at91_mux_pio3_set_debounce(void __iomem *pio, unsigned mask,
 
 static bool at91_mux_pio3_get_pulldown(void __iomem *pio, unsigned pin)
 {
-	return (__raw_readl(pio + PIO_PPDSR) >> pin) & 0x1;
+	return !((__raw_readl(pio + PIO_PPDSR) >> pin) & 0x1);
 }
 
 static void at91_mux_pio3_set_pulldown(void __iomem *pio, unsigned mask, bool is_on)
-- 
1.7.9.5

