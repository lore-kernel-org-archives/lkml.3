Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab3LOHCG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 02:02:06 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:5900 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879Ab3LOHCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 02:02:01 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Subject: [PATCH 1/4] pinctrl-msm: Fix spelling misstakes and missing consts
Date: Sat, 14 Dec 2013 23:01:51 -0800
Message-ID: <1387090914-4755-2-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1387090914-4755-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1387090914-4755-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/pinctrl/pinctrl-msm.c     |   14 +++++++-------
 drivers/pinctrl/pinctrl-msm8x74.c |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index 28b90ab..322bc0a 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -96,7 +96,7 @@ static int msm_get_group_pins(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
-static struct pinctrl_ops msm_pinctrl_ops = {
+static const struct pinctrl_ops msm_pinctrl_ops = {
 	.get_groups_count	= msm_get_groups_count,
 	.get_group_name		= msm_get_group_name,
 	.get_group_pins		= msm_get_group_pins,
@@ -190,7 +190,7 @@ static void msm_pinmux_disable(struct pinctrl_dev *pctldev,
 	spin_unlock_irqrestore(&pctrl->lock, flags);
 }
 
-static struct pinmux_ops msm_pinmux_ops = {
+static const struct pinmux_ops msm_pinmux_ops = {
 	.get_functions_count	= msm_get_functions_count,
 	.get_function_name	= msm_get_function_name,
 	.get_function_groups	= msm_get_function_groups,
@@ -378,7 +378,7 @@ static int msm_config_group_set(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
-static struct pinconf_ops msm_pinconf_ops = {
+static const struct pinconf_ops msm_pinconf_ops = {
 	.pin_config_get		= msm_config_get,
 	.pin_config_set		= msm_config_set,
 	.pin_config_group_get	= msm_config_group_get,
@@ -518,7 +518,7 @@ static void msm_gpio_dbg_show_one(struct seq_file *s,
 	int pull;
 	u32 ctl_reg;
 
-	const char *pulls[] = {
+	static const char * const pulls[] = {
 		"no pull",
 		"pull down",
 		"keeper",
@@ -545,7 +545,7 @@ static void msm_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 
 	for (i = 0; i < chip->ngpio; i++, gpio++) {
 		msm_gpio_dbg_show_one(s, NULL, chip, i, gpio);
-		seq_printf(s, "\n");
+		seq_puts(s, "\n");
 	}
 }
 
@@ -868,7 +868,7 @@ static void msm_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 	chained_irq_enter(chip, desc);
 
 	/*
-	 * Each pin have it's own IRQ status register, so use
+	 * Each pin has it's own IRQ status register, so use
 	 * enabled_irq bitmap to limit the number of reads.
 	 */
 	for_each_set_bit(i, pctrl->enabled_irqs, pctrl->chip.ngpio) {
@@ -881,7 +881,7 @@ static void msm_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 		}
 	}
 
-	/* No interrutps where flagged */
+	/* No interrupts were flagged */
 	if (handled == 0)
 		handle_bad_irq(irq, desc);
 
diff --git a/drivers/pinctrl/pinctrl-msm8x74.c b/drivers/pinctrl/pinctrl-msm8x74.c
index 762552b..c702e77 100644
--- a/drivers/pinctrl/pinctrl-msm8x74.c
+++ b/drivers/pinctrl/pinctrl-msm8x74.c
@@ -352,7 +352,7 @@ static const unsigned int sdc2_data_pins[] = { 151 };
 			MSM_MUX_##f6,			\
 			MSM_MUX_##f7			\
 		},					\
-		.ctl_reg = 0x1000 + 0x10 * id ,		\
+		.ctl_reg = 0x1000 + 0x10 * id,		\
 		.io_reg = 0x1004 + 0x10 * id,		\
 		.intr_cfg_reg = 0x1008 + 0x10 * id,	\
 		.intr_status_reg = 0x100c + 0x10 * id,	\
@@ -602,7 +602,7 @@ static int msm8x74_pinctrl_probe(struct platform_device *pdev)
 	return msm_pinctrl_probe(pdev, &msm8x74_pinctrl);
 }
 
-static struct of_device_id msm8x74_pinctrl_of_match[] = {
+static const struct of_device_id msm8x74_pinctrl_of_match[] = {
 	{ .compatible = "qcom,msm8x74-pinctrl", },
 	{ },
 };
-- 
1.7.9.5

