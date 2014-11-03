Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaKCTIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:08:13 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:39043 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaKCTGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:06:00 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org, linux-sh@vger.kernel.org
Subject: [PATCH 1/7] pinctrl: pinconf-generic: Declare dt_params/conf_items const
Date: Mon,  3 Nov 2014 11:05:25 -0800
Message-Id: <1415041531-15520-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/pinctrl/pinconf-generic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index e28ef957ca2d..f78b416d7984 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -38,7 +38,7 @@ struct pin_config_item {
 #define PCONFDUMP(a, b, c, d) { .param = a, .display = b, .format = c, \
 				.has_arg = d }
 
-static struct pin_config_item conf_items[] = {
+static const struct pin_config_item conf_items[] = {
 	PCONFDUMP(PIN_CONFIG_BIAS_DISABLE, "input bias disabled", NULL, false),
 	PCONFDUMP(PIN_CONFIG_BIAS_HIGH_IMPEDANCE, "input bias high impedance", NULL, false),
 	PCONFDUMP(PIN_CONFIG_BIAS_BUS_HOLD, "input bias bus hold", NULL, false),
@@ -159,7 +159,7 @@ struct pinconf_generic_dt_params {
 	u32 default_value;
 };
 
-static struct pinconf_generic_dt_params dt_params[] = {
+static const struct pinconf_generic_dt_params dt_params[] = {
 	{ "bias-disable", PIN_CONFIG_BIAS_DISABLE, 0 },
 	{ "bias-high-impedance", PIN_CONFIG_BIAS_HIGH_IMPEDANCE, 0 },
 	{ "bias-bus-hold", PIN_CONFIG_BIAS_BUS_HOLD, 0 },
@@ -209,7 +209,7 @@ int pinconf_generic_parse_dt_config(struct device_node *np,
 		return -ENOMEM;
 
 	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
-		struct pinconf_generic_dt_params *par = &dt_params[i];
+		const struct pinconf_generic_dt_params *par = &dt_params[i];
 		ret = of_property_read_u32(np, par->property, &val);
 
 		/* property not found */
-- 
1.9.1

