Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab3FYM4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:56:40 -0400
Received: from gloria.sntech.de ([95.129.55.99]:60352 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab3FYM4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:56:39 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/4] pinctrl: remove slew-rate parameter from tz1090
Date: Tue, 25 Jun 2013 14:56:36 +0200
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
Message-Id: <201306251456.36499.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the binding for slew-rate is under discussion and seems to need
more tought it will get removed for now, so it doesn't get an offical
release.

Therefore remove it again from the only current user, tz1090.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 .../devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt      |    5 +----
 .../devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt          |    7 +------
 drivers/pinctrl/pinctrl-tz1090-pdc.c                            |    5 -----
 drivers/pinctrl/pinctrl-tz1090.c                                |    5 -----
 4 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-
pinctrl.txt
index 9f7a85b..a186181 100644
--- a/Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt
@@ -44,9 +44,6 @@ Optional subnode-properties:
   - bias-pull-down
   - input-schmitt-enable
   - input-schmitt-disable
-  - slew-rate: Integer, control slew rate of pins.
-      0: slow (half frequency)
-      1: fast
   - drive-strength: Integer, control drive strength of pins in mA.
       2: 2mA
       4: 4mA
@@ -83,7 +80,7 @@ Valid values for pin and group names are:
 
   drive groups:
 
-    These support input-schmitt-enable, input-schmitt-disable, slew-rate,
+    These support input-schmitt-enable, input-schmitt-disable,
     drive-strength, low-power-enable, and low-power-disable.
 
     pdc
diff --git a/Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt
index 39bfd9c..4b27c99 100644
--- a/Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt
@@ -44,9 +44,6 @@ Optional subnode-properties:
   - bias-pull-down
   - input-schmitt-enable
   - input-schmitt-disable
-  - slew-rate: Integer, control slew rate of pins.
-      0: slow (half frequency)
-      1: fast
   - drive-strength: Integer, control drive strength of pins in mA.
       2: 2mA
       4: 4mA
@@ -124,7 +121,6 @@ Valid values for pin and group names are:
         function:              afe, ts_out_0.
         input-schmitt-enable:  supported.
         input-schmitt-disable: supported.
-        slew-rate:             supported.
         drive-strength:        supported.
     pdm_d
         pins:                  pdm_d.
@@ -153,12 +149,11 @@ Valid values for pin and group names are:
                                lcd_trace, phy_ringosc.
         input-schmitt-enable:  supported.
         input-schmitt-disable: supported.
-        slew-rate:             supported.
         drive-strength:        supported.
 
   drive groups:
 
-    These all support input-schmitt-enable, input-schmitt-disable, slew-rate,
+    These all support input-schmitt-enable, input-schmitt-disable,
     and drive-strength.
 
     jtag
diff --git a/drivers/pinctrl/pinctrl-tz1090-pdc.c b/drivers/pinctrl/pinctrl-tz1090-pdc.c
index 12e4808..d4f12cc 100644
--- a/drivers/pinctrl/pinctrl-tz1090-pdc.c
+++ b/drivers/pinctrl/pinctrl-tz1090-pdc.c
@@ -809,11 +809,6 @@ static int tz1090_pdc_pinconf_group_reg(struct pinctrl_dev *pctldev,
 		*width = 1;
 		*map = tz1090_pdc_boolean_map;
 		break;
-	case PIN_CONFIG_SLEW_RATE:
-		*shift = REG_GPIO_CONTROL2_PDC_SR_S;
-		*width = 1;
-		*map = tz1090_pdc_boolean_map;
-		break;
 	case PIN_CONFIG_DRIVE_STRENGTH:
 		*shift = REG_GPIO_CONTROL2_PDC_DR_S;
 		*width = 2;
diff --git a/drivers/pinctrl/pinctrl-tz1090.c b/drivers/pinctrl/pinctrl-tz1090.c
index 02ff3a2..4edae08 100644
--- a/drivers/pinctrl/pinctrl-tz1090.c
+++ b/drivers/pinctrl/pinctrl-tz1090.c
@@ -1834,11 +1834,6 @@ static int tz1090_pinconf_group_reg(struct pinctrl_dev *pctldev,
 		*width = 1;
 		*map = tz1090_boolean_map;
 		break;
-	case PIN_CONFIG_SLEW_RATE:
-		*reg = REG_PINCTRL_SR;
-		*width = 1;
-		*map = tz1090_boolean_map;
-		break;
 	case PIN_CONFIG_DRIVE_STRENGTH:
 		*reg = REG_PINCTRL_DR;
 		*width = 2;
-- 
1.7.10.4

