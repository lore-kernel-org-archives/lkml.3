Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab3K1IKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:10:46 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:49495 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab3K1IKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:10:01 -0500
X-AuditID: cbfec7f4-b7fea6d0000026ac-6a-5296fa5669f5
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 5/5] mfd: sec: Constify regmap configs and regmap irqs
Date: Thu, 28 Nov 2013 09:09:43 +0100
Message-id: <1385626183-22990-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
References: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t/xK7phv6YFGVx6o2mx5OJVdoupD5+w
	WTy7tZfJ4vULQ4uzTW/YLe5/Pcpo8e1KB5PF5V1z2CzWHrnLbrG/s4PR4nQ3q8XFFV+YHHg8
	ds66y+6xZ+JJNo9NqzrZPO5c28PmcehwB6PHvJOBHn1bVjF6TJ/3k8nj8ya5AM4oLpuU1JzM
	stQifbsEroyfv0+wFJyQrOjYeJitgfGlSBcjJ4eEgInEv963bBC2mMSFe+uBbC4OIYGljBIP
	/31jhnD6mCSOrLoPVsUmYCyxefkSsCoRgblMEtPfnmUEcZgFdjFKvP25ixGkSljAU2LS239M
	IDaLgKrEk0O9YHFeAXeJ9ddbWLoYOYD2KUjMmWQDEuYU8JDYM38fK4gtBFTy8/MctgmMvAsY
	GVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihATrlx2Mi49ZHWIU4GBU4uE9oDktSIg1say4
	MvcQowQHs5IIr0IxUIg3JbGyKrUoP76oNCe1+BAjEwenVANjbaIOw8RXB5YvevVl1UNj1ROn
	ljSv3/zvuPzsUwbzhRkNO//uCDIN2H2jJNu0pn1q05N3u59UvZ6/28Txs9kK3YfOnsdT3wfG
	i+0tl3ybezH+4N6Qq1s0XfltjvItWtD21jWt4MmWV2enqK6Vl4qbZ/nB4u/k9TJWYaGp39ZN
	mf/oUMMM5v+MgUosxRmJhlrMRcWJACFXKcg0AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "const" to "static struct regmap_irq" and "static struct
regmap_config".

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/sec-core.c |    8 ++++----
 drivers/mfd/sec-irq.c  |   12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 54cc255..207a9dc 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -134,12 +134,12 @@ static bool s5m8763_volatile(struct device *dev, unsigned int reg)
 	}
 }
 
-static struct regmap_config sec_regmap_config = {
+static const struct regmap_config sec_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 };
 
-static struct regmap_config s2mps11_regmap_config = {
+static const struct regmap_config s2mps11_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
@@ -148,7 +148,7 @@ static struct regmap_config s2mps11_regmap_config = {
 	.cache_type = REGCACHE_FLAT,
 };
 
-static struct regmap_config s5m8763_regmap_config = {
+static const struct regmap_config s5m8763_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
@@ -157,7 +157,7 @@ static struct regmap_config s5m8763_regmap_config = {
 	.cache_type = REGCACHE_FLAT,
 };
 
-static struct regmap_config s5m8767_regmap_config = {
+static const struct regmap_config s5m8767_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
index b441b1b..4de494f 100644
--- a/drivers/mfd/sec-irq.c
+++ b/drivers/mfd/sec-irq.c
@@ -22,7 +22,7 @@
 #include <linux/mfd/samsung/s5m8763.h>
 #include <linux/mfd/samsung/s5m8767.h>
 
-static struct regmap_irq s2mps11_irqs[] = {
+static const struct regmap_irq s2mps11_irqs[] = {
 	[S2MPS11_IRQ_PWRONF] = {
 		.reg_offset = 0,
 		.mask = S2MPS11_IRQ_PWRONF_MASK,
@@ -90,7 +90,7 @@ static struct regmap_irq s2mps11_irqs[] = {
 };
 
 
-static struct regmap_irq s5m8767_irqs[] = {
+static const struct regmap_irq s5m8767_irqs[] = {
 	[S5M8767_IRQ_PWRR] = {
 		.reg_offset = 0,
 		.mask = S5M8767_IRQ_PWRR_MASK,
@@ -161,7 +161,7 @@ static struct regmap_irq s5m8767_irqs[] = {
 	},
 };
 
-static struct regmap_irq s5m8763_irqs[] = {
+static const struct regmap_irq s5m8763_irqs[] = {
 	[S5M8763_IRQ_DCINF] = {
 		.reg_offset = 0,
 		.mask = S5M8763_IRQ_DCINF_MASK,
@@ -236,7 +236,7 @@ static struct regmap_irq s5m8763_irqs[] = {
 	},
 };
 
-static struct regmap_irq_chip s2mps11_irq_chip = {
+static const struct regmap_irq_chip s2mps11_irq_chip = {
 	.name = "s2mps11",
 	.irqs = s2mps11_irqs,
 	.num_irqs = ARRAY_SIZE(s2mps11_irqs),
@@ -246,7 +246,7 @@ static struct regmap_irq_chip s2mps11_irq_chip = {
 	.ack_base = S2MPS11_REG_INT1,
 };
 
-static struct regmap_irq_chip s5m8767_irq_chip = {
+static const struct regmap_irq_chip s5m8767_irq_chip = {
 	.name = "s5m8767",
 	.irqs = s5m8767_irqs,
 	.num_irqs = ARRAY_SIZE(s5m8767_irqs),
@@ -256,7 +256,7 @@ static struct regmap_irq_chip s5m8767_irq_chip = {
 	.ack_base = S5M8767_REG_INT1,
 };
 
-static struct regmap_irq_chip s5m8763_irq_chip = {
+static const struct regmap_irq_chip s5m8763_irq_chip = {
 	.name = "s5m8763",
 	.irqs = s5m8763_irqs,
 	.num_irqs = ARRAY_SIZE(s5m8763_irqs),
-- 
1.7.9.5

