Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3IMHrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 03:47:12 -0400
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:42834 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755072Ab3IMHrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 03:47:10 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [RFC PATCH 1/4] pinctrl: at91: fix typos
Date: Fri, 13 Sep 2013 09:45:33 +0200
Message-Id: <1379058333-3286-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379058213-3245-1-git-send-email-b.brezillon@overkiz.com>
References: <1379058213-3245-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 14113999758678128864
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix AT91_PINCTRL_DEBOUNCE_VAL dt macro typo.
Fix at91_pinctrl_mux_ops callback typos.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/pinctrl/pinctrl-at91.c     |    6 +++---
 include/dt-bindings/pinctrl/at91.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 19afb9a..50b555a 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -144,11 +144,11 @@ struct at91_pinctrl_mux_ops {
 	void (*mux_C_periph)(void __iomem *pio, unsigned mask);
 	void (*mux_D_periph)(void __iomem *pio, unsigned mask);
 	bool (*get_deglitch)(void __iomem *pio, unsigned pin);
-	void (*set_deglitch)(void __iomem *pio, unsigned mask, bool in_on);
+	void (*set_deglitch)(void __iomem *pio, unsigned mask, bool is_on);
 	bool (*get_debounce)(void __iomem *pio, unsigned pin, u32 *div);
-	void (*set_debounce)(void __iomem *pio, unsigned mask, bool in_on, u32 div);
+	void (*set_debounce)(void __iomem *pio, unsigned mask, bool is_on, u32 div);
 	bool (*get_pulldown)(void __iomem *pio, unsigned pin);
-	void (*set_pulldown)(void __iomem *pio, unsigned mask, bool in_on);
+	void (*set_pulldown)(void __iomem *pio, unsigned mask, bool is_on);
 	bool (*get_schmitt_trig)(void __iomem *pio, unsigned pin);
 	void (*disable_schmitt_trig)(void __iomem *pio, unsigned mask);
 	/* irq */
diff --git a/include/dt-bindings/pinctrl/at91.h b/include/dt-bindings/pinctrl/at91.h
index d7988b4..0fee6ff 100644
--- a/include/dt-bindings/pinctrl/at91.h
+++ b/include/dt-bindings/pinctrl/at91.h
@@ -16,7 +16,7 @@
 #define AT91_PINCTRL_PULL_DOWN		(1 << 3)
 #define AT91_PINCTRL_DIS_SCHMIT		(1 << 4)
 #define AT91_PINCTRL_DEBOUNCE		(1 << 16)
-#define AT91_PINCTRL_DEBOUNCE_VA(x)	(x << 17)
+#define AT91_PINCTRL_DEBOUNCE_VAL(x)	(x << 17)
 
 #define AT91_PINCTRL_PULL_UP_DEGLITCH	(AT91_PINCTRL_PULL_UP | AT91_PINCTRL_DEGLITCH)
 
-- 
1.7.9.5

