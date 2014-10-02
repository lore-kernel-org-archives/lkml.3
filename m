Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaJBIkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:40:45 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40403 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaJBIkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:40:42 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/7] pinctrl: abx500: retire phandle config mechanism
Date: Thu,  2 Oct 2014 10:40:18 +0200
Message-Id: <1412239220-22495-6-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412239220-22495-1-git-send-email-linus.walleij@linaro.org>
References: <1412239220-22495-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The abx500 pin control driver supported a method of fetching the
generic config from a phandle to a separate node using the
"ste,config" as a phandle. This is not used in any device trees
and not documented in the bindings, so drop this support.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/nomadik/pinctrl-abx500.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/pinctrl/nomadik/pinctrl-abx500.c b/drivers/pinctrl/nomadik/pinctrl-abx500.c
index 93ded6e0e21a..3b3fbb4c21c9 100644
--- a/drivers/pinctrl/nomadik/pinctrl-abx500.c
+++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
@@ -892,9 +892,7 @@ static int abx500_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 	const char *function = NULL;
 	unsigned long *configs;
 	unsigned int nconfigs = 0;
-	bool has_config = 0;
 	struct property *prop;
-	struct device_node *np_config;
 
 	ret = of_property_read_string(np, "function", &function);
 	if (ret >= 0) {
@@ -918,17 +916,7 @@ static int abx500_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 	}
 
 	ret = pinconf_generic_parse_dt_config(np, &configs, &nconfigs);
-	if (nconfigs)
-		has_config = 1;
-	np_config = of_parse_phandle(np, "ste,config", 0);
-	if (np_config) {
-		ret = pinconf_generic_parse_dt_config(np_config, &configs,
-				&nconfigs);
-		if (ret)
-			goto exit;
-		has_config |= nconfigs;
-	}
-	if (has_config) {
+	if (nconfigs) {
 		const char *gpio_name;
 		const char *pin;
 
-- 
1.9.3

