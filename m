Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbaJNRyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 13:54:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:20966 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbaJNRyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 13:54:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,718,1406617200"; 
   d="scan'208";a="618574233"
From: David Cohen <david.a.cohen@linux.intel.com>
To: linus.walleij@linaro.org
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        David Cohen <david.a.cohen@linux.intel.com>, <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH v2] pinctrl: baytrail: show output gpio state correctly on Intel Baytrail
Date: Tue, 14 Oct 2014 10:54:37 -0700
Message-Id: <1413309277-32485-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413224639-21552-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1413224639-21552-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if a gpio pin is set to output, we still need to set INPUT_EN
functionality (by clearing INPUT_EN bit) to be able to read the pin's
level.

E.g. without this change, we'll always read low level state from sysfs.

Cc: <stable@vger.kernel.org> # v3.14+
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---

v1 to v2: improved patch's body description as requested by Felipe Balbi
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

