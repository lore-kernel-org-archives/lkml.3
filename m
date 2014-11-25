Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbaKYMIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:08:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57969 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaKYKkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 003/254] pinctrl: baytrail: show output gpio state correctly on Intel Baytrail
Date: Tue, 25 Nov 2014 10:35:53 +0000
Message-Id: <1416912004-5928-4-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Cohen <david.a.cohen@linux.intel.com>

commit d90c33818967c5e5371961604ad98b4dea4fa3f4 upstream.

Even if a gpio pin is set to output, we still need to set INPUT_EN
functionality (by clearing INPUT_EN bit) to be able to read the pin's
level.

E.g. without this change, we'll always read low level state from sysfs.

Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pinctrl/pinctrl-baytrail.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 975572e2f260..ecbfec9e54d9 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -310,7 +310,7 @@ static int byt_gpio_direction_output(struct gpio_chip *chip,
 	spin_lock_irqsave(&vg->lock, flags);
 
 	reg_val = readl(reg) | BYT_DIR_MASK;
-	reg_val &= ~BYT_OUTPUT_EN;
+	reg_val &= ~(BYT_OUTPUT_EN | BYT_INPUT_EN);
 
 	if (value)
 		writel(reg_val | BYT_LEVEL, reg);
-- 
2.1.0

