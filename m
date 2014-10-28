Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaJ1U5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:57:42 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:41356 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaJ1U5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:57:39 -0400
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: Sonny Rao <sonnyrao@chromium.org>, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        iivanov@mm-sol.com, syin@broadcom.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [RFC PATCH 1/2] pinctrl: Add output-disable
Date: Tue, 28 Oct 2014 13:57:14 -0700
Message-Id: <1414529835-16207-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pinctrl bindings / API allow you to specify that:
- a pin should be an output
- a pin should have its input path enabled / disabled

...but they don't allow you to tell a pin to stop outputting.  Lets
add a new setting for that just in case the bootloader (or the default
state) left a pin as an output and we don't want it that way anymore.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt | 1 +
 drivers/pinctrl/pinconf-generic.c                              | 1 +
 include/linux/pinctrl/pinconf-generic.h                        | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index 98eb94d..9ac8591 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -183,6 +183,7 @@ low-power-enable	- enable low power mode
 low-power-disable	- disable low power mode
 output-low		- set the pin to output mode with low level
 output-high		- set the pin to output mode with high level
+output-disable		- disable output to the pin
 slew-rate		- set the slew rate
 
 For example:
diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 29ff77f..ec4d95f 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -171,6 +171,7 @@ static struct pinconf_generic_dt_params dt_params[] = {
 	{ "low-power-disable", PIN_CONFIG_LOW_POWER_MODE, 0 },
 	{ "output-low", PIN_CONFIG_OUTPUT, 0, },
 	{ "output-high", PIN_CONFIG_OUTPUT, 1, },
+	{ "output-disable", PIN_CONFIG_OUTPUT_DISABLE, 1, },
 	{ "slew-rate", PIN_CONFIG_SLEW_RATE, 0},
 };
 
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index d578a60..52b0429 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -89,6 +89,8 @@
  *	1 to indicate high level, argument 0 to indicate low level. (Please
  *	see Documentation/pinctrl.txt, section "GPIO mode pitfalls" for a
  *	discussion around this parameter.)
+ * @PIN_CONFIG_OUTPUT_DISABLE: this will configure the pin _not_ to output.
+ *	Parameter should be 1.
  * @PIN_CONFIG_END: this is the last enumerator for pin configurations, if
  *	you need to pass in custom configurations to the pin controller, use
  *	PIN_CONFIG_END+1 as the base offset.
@@ -112,6 +114,7 @@ enum pin_config_param {
 	PIN_CONFIG_SLEW_RATE,
 	PIN_CONFIG_LOW_POWER_MODE,
 	PIN_CONFIG_OUTPUT,
+	PIN_CONFIG_OUTPUT_DISABLE,
 	PIN_CONFIG_END = 0x7FFF,
 };
 
-- 
2.1.0.rc2.206.gedb03e5

