Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab3FRJUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:20:13 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:56064 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab3FRJTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:19:19 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 2/4] pinctrl: nomadik: Staticize local symbols
Date: Tue, 18 Jun 2013 14:34:25 +0530
Message-Id: <1371546267-22093-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371546267-22093-1-git-send-email-sachin.kamat@linaro.org>
References: <1371546267-22093-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some symbols referenced only in this file are made static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 7c44f1a5..73b14df 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1309,7 +1309,7 @@ static int nmk_gpio_irq_map(struct irq_domain *d, unsigned int irq,
 	return 0;
 }
 
-const struct irq_domain_ops nmk_gpio_irq_simple_ops = {
+static const struct irq_domain_ops nmk_gpio_irq_simple_ops = {
 	.map = nmk_gpio_irq_map,
 	.xlate = irq_domain_xlate_twocell,
 };
@@ -1681,7 +1681,7 @@ static bool nmk_pinctrl_dt_get_config(struct device_node *np,
 	return has_config;
 }
 
-int nmk_pinctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
+static int nmk_pinctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		struct device_node *np,
 		struct pinctrl_map **map,
 		unsigned *reserved_maps,
@@ -1740,7 +1740,7 @@ exit:
 	return ret;
 }
 
-int nmk_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
+static int nmk_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
 				 struct device_node *np_config,
 				 struct pinctrl_map **map, unsigned *num_maps)
 {
-- 
1.7.9.5

