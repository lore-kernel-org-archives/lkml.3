Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaBKRPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:15:53 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:25121 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752043AbaBKRKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:10:46 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Pawel Moll <pawel.moll@arm.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 02/12] power/reset: vexpress: Use udelay instead of timers
Date: Tue, 11 Feb 2014 17:10:26 +0000
Message-Id: <1392138636-29240-3-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this stage of system shutdown procedure the jiffies may
not be updated anymore, so just use udelay instead.

Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/power/reset/vexpress-poweroff.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/power/reset/vexpress-poweroff.c b/drivers/power/reset/vexpress-poweroff.c
index 37e7799..195235c 100644
--- a/drivers/power/reset/vexpress-poweroff.c
+++ b/drivers/power/reset/vexpress-poweroff.c
@@ -11,7 +11,7 @@
  * Copyright (C) 2012 ARM Limited
  */
 
-#include <linux/jiffies.h>
+#include <linux/delay.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
@@ -26,13 +26,9 @@ static void vexpress_reset_do(struct device *dev, const char *what)
 	struct regmap *reg = dev_get_drvdata(dev);
 
 	if (reg) {
-		unsigned long timeout;
-
 		err = regmap_write(reg, 0, 0);
-
-		timeout = jiffies + HZ;
-		while (time_before(jiffies, timeout))
-			cpu_relax();
+		if (!err)
+			mdelay(1000);
 	}
 
 	dev_emerg(dev, "Unable to %s (%d)\n", what, err);
-- 
1.8.3.2

