Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab3FYMzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:55:47 -0400
Received: from gloria.sntech.de ([95.129.55.99]:60317 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab3FYMzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:55:46 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/4] pinctrl: more clarifications for generic pull configs
Date: Tue, 25 Jun 2013 14:55:42 +0200
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
Message-Id: <201306251455.42495.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PULL_PIN_DEFAULT is meant for hardware completely hiding any pull
settings from the driver, so that it's really only possible to turn
the pull on or off, but it not being possible to determine any
pull settings from software.

Also the binding-documentation for the pull arguments did not match
the changes to the expected values.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt |    5 ++---
 include/linux/pinctrl/pinconf-generic.h                        |    5 ++++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index 2d730e3..7498bdc 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -165,9 +165,8 @@ output-high		- set the pin to output mode with high level
 
 Arguments for parameters:
 
-- bias-pull-up, -down and -pin-default take as optional argument 0 to disable
-  the pull, on hardware supporting it the pull strength in Ohm. bias-disable
-  will also disable any active pull.
+- bias-pull-up, -down and -pin-default take as optional argument on hardware
+  supporting it the pull strength in Ohm. bias-disable will disable the pull.
 
 - drive-strength takes as argument the target strength in mA.
 
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index 10ad996..48aa4ba 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -41,7 +41,10 @@
  *	impedance to GROUND). If the argument is != 0 pull-down is enabled,
  *	if it is 0, pull-down is total, i.e. the pin is connected to GROUND.
  * @PIN_CONFIG_BIAS_PULL_PIN_DEFAULT: the pin will be pulled up or down based
- *	on embedded knowledge of the controller, like current mux function.
+ *	on embedded knowledge of the controller hardware, like current mux
+ *	function. The pull direction and possibly strength too will normally
+ *	be decided completely inside the hardware block and not be readable
+ *	from the kernel side.
  *	If the argument is != 0 pull up/down is enabled, if it is 0, the
  *	configuration is ignored. The proper way to disable it is to use
  *	@PIN_CONFIG_BIAS_DISABLE.
-- 
1.7.10.4

