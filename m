Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab3KNSvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:51:37 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:61659 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab3KNSva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:51:30 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: nomadik: always display IRQ in debugfs
Date: Thu, 14 Nov 2013 19:51:18 +0100
Message-Id: <1384455078-21233-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we now grab IRQs also without first reserving the GPIO
line, let's print the mapped IRQ unconditionally in the
debugfs file as well.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 7111c3b59130..cea951f5fa49 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -846,14 +846,14 @@ static void nmk_gpio_dbg_show_one(struct seq_file *s,
 		   (mode < 0) ? "unknown" : modes[mode],
 		   pull ? "pull" : "none");
 
-	if (label && !is_out) {
-		int		irq = gpio_to_irq(gpio);
+	if (!is_out) {
+		int irq = gpio_to_irq(gpio);
 		struct irq_desc	*desc = irq_to_desc(irq);
 
 		/* This races with request_irq(), set_irq_type(),
 		 * and set_irq_wake() ... but those are "rare".
 		 */
-		if (irq >= 0 && desc->action) {
+		if (irq > 0 && desc && desc->action) {
 			char *trigger;
 			u32 bitmask = nmk_gpio_get_bitmask(gpio);
 
-- 
1.8.3.1

