Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaI3HOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:14:34 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:42005 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaI3HOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:14:31 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/3] pinctrl: nomadik: use utils map free function
Date: Tue, 30 Sep 2014 09:14:26 +0200
Message-Id: <1412061266-20790-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop brewing our own map free function and rely on the pinctrl
utils helpers.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/nomadik/pinctrl-nomadik.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/nomadik/pinctrl-nomadik.c b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
index 9fe31daf9230..6c9667a44b7b 100644
--- a/drivers/pinctrl/nomadik/pinctrl-nomadik.c
+++ b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
@@ -1339,17 +1339,6 @@ static void nmk_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
 	nmk_gpio_dbg_show_one(s, pctldev, chip, offset - chip->base, offset);
 }
 
-static void nmk_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
-		struct pinctrl_map *map, unsigned num_maps)
-{
-	int i;
-
-	for (i = 0; i < num_maps; i++)
-		if (map[i].type == PIN_MAP_TYPE_CONFIGS_PIN)
-			kfree(map[i].data.configs.configs);
-	kfree(map);
-}
-
 static int nmk_dt_add_map_mux(struct pinctrl_map **map, unsigned *reserved_maps,
 		unsigned *num_maps, const char *group,
 		const char *function)
@@ -1581,7 +1570,7 @@ static int nmk_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
 		ret = nmk_pinctrl_dt_subnode_to_map(pctldev, np, map,
 				&reserved_maps, num_maps);
 		if (ret < 0) {
-			nmk_pinctrl_dt_free_map(pctldev, *map, *num_maps);
+			pinctrl_utils_dt_free_map(pctldev, *map, *num_maps);
 			return ret;
 		}
 	}
@@ -1595,7 +1584,7 @@ static const struct pinctrl_ops nmk_pinctrl_ops = {
 	.get_group_pins = nmk_get_group_pins,
 	.pin_dbg_show = nmk_pin_dbg_show,
 	.dt_node_to_map = nmk_pinctrl_dt_node_to_map,
-	.dt_free_map = nmk_pinctrl_dt_free_map,
+	.dt_free_map = pinctrl_utils_dt_free_map,
 };
 
 static int nmk_pmx_get_funcs_cnt(struct pinctrl_dev *pctldev)
-- 
1.9.3

