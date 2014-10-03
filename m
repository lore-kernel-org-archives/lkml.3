Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaJCQzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 12:55:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:50732 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbaJCQzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 12:55:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,648,1406617200"; 
   d="scan'208";a="583124975"
From: David Cohen <david.a.cohen@linux.intel.com>
To: linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org, David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH] pinctrl: baytrail: show output gpio state correctly on Intel Baytrail
Date: Fri,  3 Oct 2014 09:55:19 -0700
Message-Id: <1412355319-18946-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if a gpio pin is set to output, we still need to set INPUT_EN bit
to be able to read its value. Without this change, we'll always read low
level state.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/pinctrl/pinctrl-baytrail.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index e12e5b07f6d7..c23d8ded936d 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -318,7 +318,7 @@ static int byt_gpio_direction_output(struct gpio_chip *chip,
 		"Potential Error: Setting GPIO with direct_irq_en to output");
 
 	reg_val = readl(reg) | BYT_DIR_MASK;
-	reg_val &= ~BYT_OUTPUT_EN;
+	reg_val &= ~(BYT_OUTPUT_EN | BYT_INPUT_EN);
 
 	if (value)
 		writel(reg_val | BYT_LEVEL, reg);
-- 
2.1.0

