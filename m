Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbaGBP3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:29:50 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:56482 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbaGBP3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:29:47 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/12] mfd: ab8500-core: Resolve code style issues
Date: Wed,  2 Jul 2014 16:28:44 +0100
Message-Id: <1404314924-23564-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
References: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soothes the following checkpatch warnings:

    WARNING: line over 80 characters
    #151: FILE: drivers/mfd/ab8500-core.c:151:
    +	0, 1, 2, 3, 4, -1, -1, -1, -1, 11, 18, 19, 20, 21, 12, 13, 24, 5, 22, 23,

    ERROR: spaces required around that '=' (ctx:VxW)
    #325: FILE: drivers/mfd/ab8500-core.c:325:
    +	ret= mask_and_set_register_interruptible(ab8500, bank, reg,
     	   ^

    WARNING: line over 80 characters
    #418: FILE: drivers/mfd/ab8500-core.c:418:
    +		else if (offset >= AB9540_INT_GPIO50R && offset <= AB9540_INT_GPIO54R)

    WARNING: line over 80 characters
    #420: FILE: drivers/mfd/ab8500-core.c:420:
    +		else if (offset == AB8540_INT_GPIO43R || offset == AB8540_INT_GPIO44R)

    ERROR: spaces required around that '==' (ctx:VxV)
    #454: FILE: drivers/mfd/ab8500-core.c:454:
    +	if ((i==3) && (*offset >= 24))
     	      ^

    ERROR: code indent should use tabs where possible
    #576: FILE: drivers/mfd/ab8500-core.c:576:
    +        .map    = ab8500_irq_map,$

    WARNING: please, no spaces at the start of a line
    #576: FILE: drivers/mfd/ab8500-core.c:576:
    +        .map    = ab8500_irq_map,$

    ERROR: code indent should use tabs where possible
    #577: FILE: drivers/mfd/ab8500-core.c:577:
    +        .xlate  = irq_domain_xlate_twocell,$

    WARNING: please, no spaces at the start of a line
    #577: FILE: drivers/mfd/ab8500-core.c:577:
    +        .xlate  = irq_domain_xlate_twocell,$

    WARNING: char * array declaration might be better as static const
    #1554: FILE: drivers/mfd/ab8500-core.c:1554:
    +	static char *switch_off_status[] = {

    WARNING: char * array declaration might be better as static const
    #1563: FILE: drivers/mfd/ab8500-core.c:1563:
    +	static char *turn_on_status[] = {

    WARNING: sizeof *ab8500 should be sizeof(*ab8500)
    #1582: FILE: drivers/mfd/ab8500-core.c:1582:
    +	ab8500 = devm_kzalloc(&pdev->dev, sizeof *ab8500, GFP_KERNEL);

    ERROR: space required after that close brace '}'
    #1639: FILE: drivers/mfd/ab8500-core.c:1639:
    +	}/* Configure AB8500 or AB9540 IRQ */

    WARNING: line over 80 characters
    #1652: FILE: drivers/mfd/ab8500-core.c:1652:
    +	ab8500->oldmask = devm_kzalloc(&pdev->dev, ab8500->mask_size, GFP_KERNEL);

    WARNING: Prefer [subsystem eg: netdev]_cont([subsystem]dev, ... then dev_cont(dev, ... then pr_cont(...  to printk(KERN_CONT ...
    #1677: FILE: drivers/mfd/ab8500-core.c:1677:
    +				printk(KERN_CONT " \"%s\"",

    WARNING: Prefer [subsystem eg: netdev]_cont([subsystem]dev, ... then dev_cont(dev, ... then pr_cont(...  to printk(KERN_CONT ...
    #1682: FILE: drivers/mfd/ab8500-core.c:1682:
    +		printk(KERN_CONT "\n");

    WARNING: Prefer [subsystem eg: netdev]_cont([subsystem]dev, ... then dev_cont(dev, ... then pr_cont(...  to printk(KERN_CONT ...
    #1684: FILE: drivers/mfd/ab8500-core.c:1684:
    +		printk(KERN_CONT " None\n");

    WARNING: printk() should include KERN_ facility level
    #1695: FILE: drivers/mfd/ab8500-core.c:1695:
    +				printk("\"%s\" ", turn_on_status[i]);

    WARNING: printk() should include KERN_ facility level
    #1700: FILE: drivers/mfd/ab8500-core.c:1700:
    +		printk("None\n");

    total: 5 errors, 14 warnings, 1869 lines checked

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-core.c | 45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 857f19a..ce48aa7 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -148,8 +148,8 @@ static const int ab9540_irq_regoffset[AB9540_NUM_IRQ_REGS] = {
 
 /* AB8540 support */
 static const int ab8540_irq_regoffset[AB8540_NUM_IRQ_REGS] = {
-	0, 1, 2, 3, 4, -1, -1, -1, -1, 11, 18, 19, 20, 21, 12, 13, 24, 5, 22, 23,
-	25, 26, 27, 28, 29, 30, 31,
+	0, 1, 2, 3, 4, -1, -1, -1, -1, 11, 18, 19, 20, 21, 12, 13, 24, 5, 22,
+	23, 25, 26, 27, 28, 29, 30, 31,
 };
 
 static const char ab8500_version_str[][7] = {
@@ -322,7 +322,7 @@ static int ab8500_mask_and_set_register(struct device *dev,
 	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
 
 	atomic_inc(&ab8500->transfer_ongoing);
-	ret= mask_and_set_register_interruptible(ab8500, bank, reg,
+	ret = mask_and_set_register_interruptible(ab8500, bank, reg,
 						 bitmask, bitvalues);
 	atomic_dec(&ab8500->transfer_ongoing);
 	return ret;
@@ -415,9 +415,11 @@ static void ab8500_irq_unmask(struct irq_data *data)
 	if (type & IRQ_TYPE_EDGE_FALLING) {
 		if (offset >= AB8500_INT_GPIO6R && offset <= AB8500_INT_GPIO41R)
 			ab8500->mask[index + 2] &= ~mask;
-		else if (offset >= AB9540_INT_GPIO50R && offset <= AB9540_INT_GPIO54R)
+		else if (offset >= AB9540_INT_GPIO50R &&
+			 offset <= AB9540_INT_GPIO54R)
 			ab8500->mask[index + 1] &= ~mask;
-		else if (offset == AB8540_INT_GPIO43R || offset == AB8540_INT_GPIO44R)
+		else if (offset == AB8540_INT_GPIO43R ||
+			 offset == AB8540_INT_GPIO44R)
 			/* Here the falling IRQ is one bit lower */
 			ab8500->mask[index] &= ~(mask << 1);
 		else
@@ -451,7 +453,7 @@ static void update_latch_offset(u8 *offset, int i)
 	/* Fix inconsistent ab8540 bit mapping... */
 	if (unlikely(*offset == 16))
 			*offset = 25;
-	if ((i==3) && (*offset >= 24))
+	if ((i == 3) && (*offset >= 24))
 			*offset += 2;
 }
 
@@ -573,8 +575,8 @@ static int ab8500_irq_map(struct irq_domain *d, unsigned int virq,
 }
 
 static struct irq_domain_ops ab8500_irq_ops = {
-        .map    = ab8500_irq_map,
-        .xlate  = irq_domain_xlate_twocell,
+	.map    = ab8500_irq_map,
+	.xlate  = irq_domain_xlate_twocell,
 };
 
 static int ab8500_irq_init(struct ab8500 *ab8500, struct device_node *np)
@@ -1551,7 +1553,7 @@ static struct attribute_group ab9540_attr_group = {
 
 static int ab8500_probe(struct platform_device *pdev)
 {
-	static char *switch_off_status[] = {
+	static const char *switch_off_status[] = {
 		"Swoff bit programming",
 		"Thermal protection activation",
 		"Vbat lower then BattOk falling threshold",
@@ -1560,7 +1562,7 @@ static int ab8500_probe(struct platform_device *pdev)
 		"Battery level lower than power on reset threshold",
 		"Power on key 1 pressed longer than 10 seconds",
 		"DB8500 thermal shutdown"};
-	static char *turn_on_status[] = {
+	static const char *turn_on_status[] = {
 		"Battery rising (Vbat)",
 		"Power On Key 1 dbF",
 		"Power On Key 2 dbF",
@@ -1579,7 +1581,7 @@ static int ab8500_probe(struct platform_device *pdev)
 	int i;
 	u8 value;
 
-	ab8500 = devm_kzalloc(&pdev->dev, sizeof *ab8500, GFP_KERNEL);
+	ab8500 = devm_kzalloc(&pdev->dev, sizeof(*ab8500), GFP_KERNEL);
 	if (!ab8500)
 		return -ENOMEM;
 
@@ -1636,7 +1638,7 @@ static int ab8500_probe(struct platform_device *pdev)
 		ab8500->mask_size = AB8540_NUM_IRQ_REGS;
 		ab8500->irq_reg_offset = ab8540_irq_regoffset;
 		ab8500->it_latchhier_num = AB8540_IT_LATCHHIER_NUM;
-	}/* Configure AB8500 or AB9540 IRQ */
+	} /* Configure AB8500 or AB9540 IRQ */
 	else if (is_ab9540(ab8500) || is_ab8505(ab8500)) {
 		ab8500->mask_size = AB9540_NUM_IRQ_REGS;
 		ab8500->irq_reg_offset = ab9540_irq_regoffset;
@@ -1646,10 +1648,12 @@ static int ab8500_probe(struct platform_device *pdev)
 		ab8500->irq_reg_offset = ab8500_irq_regoffset;
 		ab8500->it_latchhier_num = AB8500_IT_LATCHHIER_NUM;
 	}
-	ab8500->mask = devm_kzalloc(&pdev->dev, ab8500->mask_size, GFP_KERNEL);
+	ab8500->mask = devm_kzalloc(&pdev->dev, ab8500->mask_size,
+				    GFP_KERNEL);
 	if (!ab8500->mask)
 		return -ENOMEM;
-	ab8500->oldmask = devm_kzalloc(&pdev->dev, ab8500->mask_size, GFP_KERNEL);
+	ab8500->oldmask = devm_kzalloc(&pdev->dev, ab8500->mask_size,
+				       GFP_KERNEL);
 	if (!ab8500->oldmask)
 		return -ENOMEM;
 
@@ -1674,14 +1678,13 @@ static int ab8500_probe(struct platform_device *pdev)
 	if (value) {
 		for (i = 0; i < ARRAY_SIZE(switch_off_status); i++) {
 			if (value & 1)
-				printk(KERN_CONT " \"%s\"",
-				       switch_off_status[i]);
+				pr_cont(" \"%s\"", switch_off_status[i]);
 			value = value >> 1;
 
 		}
-		printk(KERN_CONT "\n");
+		pr_cont("\n");
 	} else {
-		printk(KERN_CONT " None\n");
+		pr_cont(" None\n");
 	}
 	ret = get_register_interruptible(ab8500, AB8500_SYS_CTRL1_BLOCK,
 		AB8500_TURN_ON_STATUS, &value);
@@ -1692,12 +1695,12 @@ static int ab8500_probe(struct platform_device *pdev)
 	if (value) {
 		for (i = 0; i < ARRAY_SIZE(turn_on_status); i++) {
 			if (value & 1)
-				printk("\"%s\" ", turn_on_status[i]);
+				pr_cont("\"%s\" ", turn_on_status[i]);
 			value = value >> 1;
 		}
-		printk("\n");
+		pr_cont("\n");
 	} else {
-		printk("None\n");
+		pr_cont("None\n");
 	}
 
 	if (plat && plat->init)
-- 
1.8.3.2

