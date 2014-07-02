Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbaGBPca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:32:30 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:35500 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbaGBP3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:29:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/12] mfd: ab8500-debugfs: Simplify invalid debugfs data checking
Date: Wed,  2 Jul 2014 16:28:34 +0100
Message-Id: <1404314924-23564-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
References: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed during a coding review, if we reorganised the checking a
little, we can rid the code of a pointless 'else'.  Whilst looking
for this particular code hunk I noticed another pointless 'else',
which I've subsequently fixed in this patch.

Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-debugfs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index e23fcba..f7f271c 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -2503,14 +2503,14 @@ static ssize_t ab8500_gpadc_trig_timer_write(struct file *file,
 	if (err)
 		return err;
 
-	if (user_trig_timer <= 255) {
-		trig_timer = (u8) user_trig_timer;
-	} else {
-		dev_err(dev, "debugfs error input: "
-			"should be beetween 0 to 255\n");
+	if (user_trig_timer & ~0xFF) {
+		dev_err(dev,
+			"debugfs error input: should be beetween 0 to 255\n");
 		return -EINVAL;
 	}
 
+	trig_timer = (u8) user_trig_timer;
+
 	return count;
 }
 
@@ -2764,8 +2764,8 @@ static ssize_t show_irq(struct device *dev,
 	irq_index = name - irq_first;
 	if (irq_index >= num_irqs)
 		return -EINVAL;
-	else
-		return sprintf(buf, "%u\n", irq_count[irq_index]);
+
+	return sprintf(buf, "%u\n", irq_count[irq_index]);
 }
 
 static ssize_t ab8500_subscribe_write(struct file *file,
-- 
1.8.3.2

