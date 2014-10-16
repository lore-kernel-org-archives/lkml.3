Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaJPRNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:13:43 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41690 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaJPRMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:12:08 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH RFC v2 3/8] pinctrl: pinconf-generic: Add parameter 'IO standard'
Date: Thu, 16 Oct 2014 10:11:30 -0700
Message-Id: <1413479495-14206-4-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.2.1.g5e69ed6
In-Reply-To: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For HW that can select the IO standard for pins, add the infrastructure
in pinconf generic to parse this parameter.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt | 3 +++
 drivers/pinctrl/pinconf-generic.c                              | 2 ++
 include/linux/pinctrl/pinconf-generic.h                        | 4 ++++
 3 files changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index 98eb94d91a1c..862c4fe17d04 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -184,6 +184,7 @@ low-power-disable	- disable low power mode
 output-low		- set the pin to output mode with low level
 output-high		- set the pin to output mode with high level
 slew-rate		- set the slew rate
+io-standard		- set the IO standard
 
 For example:
 
@@ -215,5 +216,7 @@ arguments are described below.
 - input-debounce takes the debounce time in usec as argument
   or 0 to disable debouncing
 
+- io-standard takes a driver specific argument to select an IO standard
+
 More in-depth documentation on these parameters can be found in
 <include/linux/pinctrl/pinconfig-generic.h>
diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index e28ef957ca2d..17ac8f00e16b 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -58,6 +58,7 @@ static struct pin_config_item conf_items[] = {
 	PCONFDUMP(PIN_CONFIG_SLEW_RATE, "slew rate", NULL, true),
 	PCONFDUMP(PIN_CONFIG_LOW_POWER_MODE, "pin low power", "mode", true),
 	PCONFDUMP(PIN_CONFIG_OUTPUT, "pin output", "level", true),
+	PCONFDUMP(PIN_CONFIG_IOSTANDARD, "io standard", NULL, true),
 };
 
 void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
@@ -181,6 +182,7 @@ static struct pinconf_generic_dt_params dt_params[] = {
 	{ "output-low", PIN_CONFIG_OUTPUT, 0, },
 	{ "output-high", PIN_CONFIG_OUTPUT, 1, },
 	{ "slew-rate", PIN_CONFIG_SLEW_RATE, 0},
+	{ "io-standard", PIN_CONFIG_IOSTANDARD, 0},
 };
 
 /**
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index d578a60eff23..dd1d3251fb93 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -92,6 +92,9 @@
  * @PIN_CONFIG_END: this is the last enumerator for pin configurations, if
  *	you need to pass in custom configurations to the pin controller, use
  *	PIN_CONFIG_END+1 as the base offset.
+ * @PIN_CONFIG_IOSTANDARD: if the pin can select an IO standard, the argument to
+ *	this parameter (on a custom format) tells the driver which alternative
+ *	IO standard to use.
  */
 enum pin_config_param {
 	PIN_CONFIG_BIAS_DISABLE,
@@ -112,6 +115,7 @@ enum pin_config_param {
 	PIN_CONFIG_SLEW_RATE,
 	PIN_CONFIG_LOW_POWER_MODE,
 	PIN_CONFIG_OUTPUT,
+	PIN_CONFIG_IOSTANDARD,
 	PIN_CONFIG_END = 0x7FFF,
 };
 
-- 
2.1.2.1.g5e69ed6

