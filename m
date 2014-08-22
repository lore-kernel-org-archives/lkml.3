Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbaHVJpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:45:07 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59842 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaHVJpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:45:05 -0400
Date: Fri, 22 Aug 2014 10:44:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Mark Brown <broonie@linaro.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        kbuild-all@01.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: wm8994: Export symbols ready for built-in => modular
 build
Message-ID: <20140822094458.GV4266@lee--X1>
References: <53f62a3b.Rzd7pzhWx4p+Vvnr%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53f62a3b.Rzd7pzhWx4p+Vvnr%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'd like to be able to build the WM8994 family as modules, but the
build will fail if the external symbols aren't exported first.

Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/drivers/mfd/wm8994-irq.c b/drivers/mfd/wm8994-irq.c
index e74dedd..a14407e 100644
--- a/drivers/mfd/wm8994-irq.c
+++ b/drivers/mfd/wm8994-irq.c
@@ -262,8 +262,10 @@ int wm8994_irq_init(struct wm8994 *wm8994)
 
 	return 0;
 }
+EXPORT_SYMBOL(wm8994_irq_init);
 
 void wm8994_irq_exit(struct wm8994 *wm8994)
 {
 	regmap_del_irq_chip(wm8994->irq, wm8994->irq_data);
 }
+EXPORT_SYMBOL(wm8994_irq_exit);
diff --git a/drivers/mfd/wm8994-regmap.c b/drivers/mfd/wm8994-regmap.c
index 770a256..300e9b6 100644
--- a/drivers/mfd/wm8994-regmap.c
+++ b/drivers/mfd/wm8994-regmap.c
@@ -1252,6 +1252,7 @@ struct regmap_config wm1811_regmap_config = {
 	.volatile_reg = wm1811_volatile_register,
 	.readable_reg = wm1811_readable_register,
 };
+EXPORT_SYMBOL(wm1811_regmap_config);
 
 struct regmap_config wm8994_regmap_config = {
 	.reg_bits = 16,
@@ -1266,6 +1267,7 @@ struct regmap_config wm8994_regmap_config = {
 	.volatile_reg = wm8994_volatile_register,
 	.readable_reg = wm8994_readable_register,
 };
+EXPORT_SYMBOL(wm8994_regmap_config);
 
 struct regmap_config wm8958_regmap_config = {
 	.reg_bits = 16,
@@ -1280,8 +1282,10 @@ struct regmap_config wm8958_regmap_config = {
 	.volatile_reg = wm8958_volatile_register,
 	.readable_reg = wm8958_readable_register,
 };
+EXPORT_SYMBOL(wm8958_regmap_config);
 
 struct regmap_config wm8994_base_regmap_config = {
 	.reg_bits = 16,
 	.val_bits = 16,
 };
+EXPORT_SYMBOL(wm8994_base_regmap_config);
