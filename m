Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab3FNPmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:42:53 -0400
Received: from gloria.sntech.de ([95.129.55.99]:34433 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab3FNPmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:42:52 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/5] pinctrl: clarify some dt pinconfig options
Date: Fri, 14 Jun 2013 17:42:49 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org,
        James Hogan <james.hogan@imgtec.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <201306141741.46077.heiko@sntech.de>
In-Reply-To: <201306141741.46077.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306141742.49923.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bias-pull-* options use values > 0 to indicate that the pull should
be activated and optionally also indicate the strength of the pull.
Therefore use an default value of 1 for these options.

Split the low-power-mode option into low-power-enable and -disable.

Update the documentation to describe the param arguments better.

Wrong default options
Reported-by: James Hogan <james.hogan@imgtec.com>

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 .../bindings/pinctrl/pinctrl-bindings.txt          |   22 +++++++++++++++++++-
 drivers/pinctrl/pinconf-generic.c                  |    9 ++++----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index ef7cd57..2d730e3 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -158,9 +158,29 @@ input-schmitt		- run in schmitt-trigger mode with hysteresis X
 input-debounce		- debounce mode with debound time X
 power-source		- select power source X
 slew-rate		- use slew-rate X
-low-power-mode		- low power mode
+low-power-enable	- enable low power mode
+low-power-disable	- disable low power mode
 output-low		- set the pin to output mode with low level
 output-high		- set the pin to output mode with high level
 
+Arguments for parameters:
+
+- bias-pull-up, -down and -pin-default take as optional argument 0 to disable
+  the pull, on hardware supporting it the pull strength in Ohm. bias-disable
+  will also disable any active pull.
+
+- drive-strength takes as argument the target strength in mA.
+
+- input-schmitt takes as argument the adjustable hysteresis in a
+  driver-specific format
+
+- input-debounce takes the debounce time as argument or 0 to disable debouncing
+
+- power-source argument is the custom value describing the source to select
+
+- slew-rate takes as argument the target rate in a driver-specific format
+
+All parameters not listed here, do not take an argument.
+
 More in-depth documentation on these parameters can be found in
 <include/linux/pinctrl/pinconfig-generic.h>
diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index d3c693c..dcf0371 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -152,9 +152,9 @@ static struct pinconf_generic_dt_params dt_params[] = {
 	{ "bias-disable", PIN_CONFIG_BIAS_DISABLE, 0 },
 	{ "bias-high-impedance", PIN_CONFIG_BIAS_HIGH_IMPEDANCE, 0 },
 	{ "bias-bus-hold", PIN_CONFIG_BIAS_BUS_HOLD, 0 },
-	{ "bias-pull-up", PIN_CONFIG_BIAS_PULL_UP, 0 },
-	{ "bias-pull-down", PIN_CONFIG_BIAS_PULL_DOWN, 0 },
-	{ "bias-pull-pin-default", PIN_CONFIG_BIAS_PULL_PIN_DEFAULT, 0 },
+	{ "bias-pull-up", PIN_CONFIG_BIAS_PULL_UP, 1 },
+	{ "bias-pull-down", PIN_CONFIG_BIAS_PULL_DOWN, 1 },
+	{ "bias-pull-pin-default", PIN_CONFIG_BIAS_PULL_PIN_DEFAULT, 1 },
 	{ "drive-push-pull", PIN_CONFIG_DRIVE_PUSH_PULL, 0 },
 	{ "drive-open-drain", PIN_CONFIG_DRIVE_OPEN_DRAIN, 0 },
 	{ "drive-open-source", PIN_CONFIG_DRIVE_OPEN_SOURCE, 0 },
@@ -165,7 +165,8 @@ static struct pinconf_generic_dt_params dt_params[] = {
 	{ "input-debounce", PIN_CONFIG_INPUT_DEBOUNCE, 0 },
 	{ "power-source", PIN_CONFIG_POWER_SOURCE, 0 },
 	{ "slew-rate", PIN_CONFIG_SLEW_RATE, 0 },
-	{ "low-power-mode", PIN_CONFIG_LOW_POWER_MODE, 0 },
+	{ "low-power-enable", PIN_CONFIG_LOW_POWER_MODE, 1 },
+	{ "low-power-disable", PIN_CONFIG_LOW_POWER_MODE, 0 },
 	{ "output-low", PIN_CONFIG_OUTPUT, 0, },
 	{ "output-high", PIN_CONFIG_OUTPUT, 1, },
 };
-- 
1.7.10.4

