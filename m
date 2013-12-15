Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab3LOSbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 13:31:15 -0500
Received: from 10.mo1.mail-out.ovh.net ([178.32.96.102]:54068 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751853Ab3LOSa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 13:30:58 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH 2/2] pinctrl: at91: replace clk_prepare + clk_enable by clk_prepare_enable
Date: Sun, 15 Dec 2013 19:30:52 +0100
Message-Id: <1387132252-2584-3-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387132252-2584-1-git-send-email-b.brezillon@overkiz.com>
References: <1387132252-2584-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 17700272435941374126
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the clk_prepare and clk_enable calls by a single
clk_prepare_enable call.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/pinctrl/pinctrl-at91.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 82f6301..4deb9cb 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1359,10 +1359,8 @@ void at91_pinctrl_gpio_resume(void)
 
 		pio = gpio_chips[i]->regbase;
 
-		if (!wakeups[i]) {
-			if (clk_prepare(gpio_chips[i]->clock) == 0)
-				clk_enable(gpio_chips[i]->clock);
-		}
+		if (!wakeups[i])
+			clk_prepare_enable(gpio_chips[i]->clock);
 
 		__raw_writel(wakeups[i], pio + PIO_IDR);
 		__raw_writel(backups[i], pio + PIO_IER);
-- 
1.7.9.5

