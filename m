Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaJBHxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:53:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48367 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbaJBHxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:53:46 -0400
From: Jyri Sarha <jsarha@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        <kernel-janitors@vger.kernel.org>
CC: <dan.carpenter@oracle.com>, <detheridge@ti.com>,
        Jyri Sarha <jsarha@ti.com>
Subject: [PATCH 2/2] clk: gpio-gate: Rename the struct from clk_gpio to clk_gpio_gate
Date: Thu, 2 Oct 2014 10:53:32 +0300
Message-ID: <5ca791d0bda38fe4cc3da4d6bde7e0a374822ee1.1412234778.git.jsarha@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1412234778.git.jsarha@ti.com>
References: <cover.1412234778.git.jsarha@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to change this when changing the clk name from clk_gpio to
clk_gpio_gate. Since I already changed the comment above the
struct definition it is better to go all the way.

Signed-off-by: Jyri Sarha <jsarha@ti.com>
---
 drivers/clk/clk-gpio-gate.c  |   22 +++++++++++-----------
 include/linux/clk-provider.h |    2 +-
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/clk-gpio-gate.c b/drivers/clk/clk-gpio-gate.c
index a648761..053939a 100644
--- a/drivers/clk/clk-gpio-gate.c
+++ b/drivers/clk/clk-gpio-gate.c
@@ -28,11 +28,11 @@
  * parent - fixed parent.  No clk_set_parent support
  */
 
-#define to_clk_gpio(_hw) container_of(_hw, struct clk_gpio, hw)
+#define to_clk_gpio(_hw) container_of(_hw, struct clk_gpio_gate, hw)
 
 static int clk_gpio_gate_enable(struct clk_hw *hw)
 {
-	struct clk_gpio *clk = to_clk_gpio(hw);
+	struct clk_gpio_gate *clk = to_clk_gpio(hw);
 
 	gpiod_set_value(clk->gpiod, 1);
 
@@ -41,14 +41,14 @@ static int clk_gpio_gate_enable(struct clk_hw *hw)
 
 static void clk_gpio_gate_disable(struct clk_hw *hw)
 {
-	struct clk_gpio *clk = to_clk_gpio(hw);
+	struct clk_gpio_gate *clk = to_clk_gpio(hw);
 
 	gpiod_set_value(clk->gpiod, 0);
 }
 
 static int clk_gpio_gate_is_enabled(struct clk_hw *hw)
 {
-	struct clk_gpio *clk = to_clk_gpio(hw);
+	struct clk_gpio_gate *clk = to_clk_gpio(hw);
 
 	return gpiod_get_value(clk->gpiod);
 }
@@ -71,7 +71,7 @@ struct clk *clk_register_gpio_gate(struct device *dev, const char *name,
 		const char *parent_name, struct gpio_desc *gpiod,
 		unsigned long flags)
 {
-	struct clk_gpio *clk_gpio = NULL;
+	struct clk_gpio_gate *clk_gpio_gate = NULL;
 	struct clk *clk = ERR_PTR(-EINVAL);
 	struct clk_init_data init = { NULL };
 	unsigned long gpio_flags;
@@ -89,9 +89,9 @@ struct clk *clk_register_gpio_gate(struct device *dev, const char *name,
 		return ERR_PTR(err);
 	}
 
-	clk_gpio = kzalloc(sizeof(struct clk_gpio), GFP_KERNEL);
+	clk_gpio_gate = kzalloc(sizeof(struct clk_gpio_gate), GFP_KERNEL);
 
-	if (!clk_gpio) {
+	if (!clk_gpio_gate) {
 		clk = ERR_PTR(-ENOMEM);
 		goto clk_register_gpio_gate_err;
 	}
@@ -102,15 +102,15 @@ struct clk *clk_register_gpio_gate(struct device *dev, const char *name,
 	init.parent_names = (parent_name ? &parent_name : NULL);
 	init.num_parents = (parent_name ? 1 : 0);
 
-	clk_gpio->gpiod = gpiod;
-	clk_gpio->hw.init = &init;
+	clk_gpio_gate->gpiod = gpiod;
+	clk_gpio_gate->hw.init = &init;
 
-	clk = clk_register(dev, &clk_gpio->hw);
+	clk = clk_register(dev, &clk_gpio_gate->hw);
 
 	if (!IS_ERR(clk))
 		return clk;
 
-	kfree(clk_gpio);
+	kfree(clk_gpio_gate);
 
 clk_register_gpio_gate_err:
 	gpiod_put(gpiod);
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index ec1581b..860cb0c 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -498,7 +498,7 @@ struct clk *clk_register_composite(struct device *dev, const char *name,
  * Implements .enable, .disable and .is_enabled
  */
 
-struct clk_gpio {
+struct clk_gpio_gate {
 	struct clk_hw	hw;
 	struct gpio_desc *gpiod;
 };
-- 
1.7.9.5

