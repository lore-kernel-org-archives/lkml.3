Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab3FNFXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:23:54 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:50409 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824Ab3FNFXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:23:51 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <yizhang@marvell.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V2 4/9] mfd: 88pm800/88pm805: remove "IRQF_TRIGGER_FALLING" flag
Date: Fri, 14 Jun 2013 01:21:48 -0400
Message-ID: <1371187313-5776-5-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
References: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Zhang <yizhang@marvell.com>

88pm800/88pm805 interrupt is asserted low if the events happened.
So remove IRQF_TRIGGER_FALLING for irq request.
How the interrupt is connected to SOC chip depends on the board design.
So do not set IRQF_TRIGGER flags.

Signed-off-by: Yi Zhang <yizhang@marvell.com>
Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/mfd/88pm800.c |    2 +-
 drivers/mfd/88pm805.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index cca63f2..d2951d7 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -318,7 +318,7 @@ out:
 static int device_irq_init_800(struct pm80x_chip *chip)
 {
 	struct regmap *map = chip->regmap;
-	unsigned long flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
+	unsigned long flags = IRQF_ONESHOT;
 	int data, mask, ret = -EINVAL;
 
 	if (!map || !chip->irq) {
diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
index d32b544..0e82c2a 100644
--- a/drivers/mfd/88pm805.c
+++ b/drivers/mfd/88pm805.c
@@ -138,7 +138,7 @@ static struct regmap_irq pm805_irqs[] = {
 static int device_irq_init_805(struct pm80x_chip *chip)
 {
 	struct regmap *map = chip->regmap;
-	unsigned long flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
+	unsigned long flags = IRQF_ONESHOT;
 	int data, mask, ret = -EINVAL;
 
 	if (!map || !chip->irq) {
-- 
1.7.4.1

