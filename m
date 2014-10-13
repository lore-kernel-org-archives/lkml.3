Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaJMSXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 14:23:50 -0400
Received: from mga03.intel.com ([134.134.136.65]:19007 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbaJMSXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 14:23:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,712,1406617200"; 
   d="scan'208";a="588182831"
From: David Cohen <david.a.cohen@linux.intel.com>
To: linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>, <stable@vger.kernel.org>
Subject: [PATCH] pinctrl: baytrail: show output gpio state correctly on Intel Baytrail
Date: Mon, 13 Oct 2014 11:23:59 -0700
Message-Id: <1413224639-21552-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412355319-18946-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1412355319-18946-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if a gpio pin is set to output, we still need to set INPUT_EN bit
to be able to read its value. Without this change, we'll always read low
level state.

Cc: <stable@vger.kernel.org> # v3.14+
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---

Hi,

I'm resending same v1 patch but now copying linux stable and linux gpio.
This patch is meant for all linux stable trees >= v3.14.

Br, David
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

