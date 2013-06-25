Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3FYM4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:56:16 -0400
Received: from gloria.sntech.de ([95.129.55.99]:60341 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab3FYM4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:56:15 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/4] pinctrl: set unit for debounce time pinconfig to usec
Date: Tue, 25 Jun 2013 14:56:11 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        James Hogan <james.hogan@imgtec.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
References: <201306251455.01540.heiko@sntech.de>
In-Reply-To: <201306251455.01540.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306251456.12150.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the debounce time pinconfig option uses an unspecified
"time units" unit. As pinconfig options should use SI units and a
real unit is also necessary for generic dt bindings, change it
to usec. Currently no driver is using the generic pinconfig option
for this, so the unit change is safe to do.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt |    3 ++-
 drivers/pinctrl/pinconf-generic.c                              |    2 +-
 include/linux/pinctrl/pinconf-generic.h                        |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index 7498bdc..788ab09 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -173,7 +173,8 @@ Arguments for parameters:
 - input-schmitt takes as argument the adjustable hysteresis in a
   driver-specific format
 
-- input-debounce takes the debounce time as argument or 0 to disable debouncing
+- input-debounce takes the debounce time in usec as argument
+  or 0 to disable debouncing
 
 - power-source argument is the custom value describing the source to select
 
diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 794dad7..2b271d5 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -49,7 +49,7 @@ static struct pin_config_item conf_items[] = {
 	PCONFDUMP(PIN_CONFIG_DRIVE_STRENGTH, "output drive strength", "mA"),
 	PCONFDUMP(PIN_CONFIG_INPUT_SCHMITT_ENABLE, "input schmitt enabled", NULL),
 	PCONFDUMP(PIN_CONFIG_INPUT_SCHMITT, "input schmitt trigger", NULL),
-	PCONFDUMP(PIN_CONFIG_INPUT_DEBOUNCE, "input debounce", "time units"),
+	PCONFDUMP(PIN_CONFIG_INPUT_DEBOUNCE, "input debounce", "usec"),
 	PCONFDUMP(PIN_CONFIG_POWER_SOURCE, "pin power source", "selector"),
 	PCONFDUMP(PIN_CONFIG_SLEW_RATE, "slew rate", NULL),
 	PCONFDUMP(PIN_CONFIG_LOW_POWER_MODE, "pin low power", "mode"),
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index 48aa4ba..bf7e989 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -70,7 +70,7 @@
  *	setting pins to this mode.
  * @PIN_CONFIG_INPUT_DEBOUNCE: this will configure the pin to debounce mode,
  *	which means it will wait for signals to settle when reading inputs. The
- *	argument gives the debounce time on a custom format. Setting the
+ *	argument gives the debounce time in usecs. Setting the
  *	argument to zero turns debouncing off.
  * @PIN_CONFIG_POWER_SOURCE: if the pin can select between different power
  *	supplies, the argument to this parameter (on a custom format) tells
-- 
1.7.10.4

