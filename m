Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbbAUPZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:25:10 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:44871 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbbAUPYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:24:43 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        computersforpeace@gmail.com, devicetree@vger.kernel.org
Subject: [PATCH v4 01/10] mtd: st_spi_fsm: dt-bindings: Deprecate generic compatible string
Date: Wed, 21 Jan 2015 15:24:19 +0000
Message-Id: <1421853868-8262-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421853868-8262-1-git-send-email-lee.jones@linaro.org>
References: <1421853868-8262-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver now obtains platform information via DT matching, which requires
a compatible string per platform.  This change introduces the new specific
strings and deprecates the old generic one.

We also take out all of the old, unused properties which are no longer
required.

Cc: devicetree@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/mtd/st-fsm.txt | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/mtd/st-fsm.txt b/Documentation/devicetree/bindings/mtd/st-fsm.txt
index c248939..389e43d 100644
--- a/Documentation/devicetree/bindings/mtd/st-fsm.txt
+++ b/Documentation/devicetree/bindings/mtd/st-fsm.txt
@@ -1,26 +1,19 @@
 * ST-Microelectronics SPI FSM Serial (NOR) Flash Controller
 
 Required properties:
-  - compatible : Should be "st,spi-fsm"
+  - compatible : Should be one of;
+		   "st,stid127-spi-fsm"
+		   "st,stih407-spi-fsm"
+		   "st,stih416-spi-fsm"
   - reg        : Contains register's location and length.
-  - reg-names  : Should contain the reg names "spi-fsm"
   - interrupts : The interrupt number
   - pinctrl-0  : Standard Pinctrl phandle (see: pinctrl/pinctrl-bindings.txt)
-
-Optional properties:
-  - st,syscfg          : Phandle to boot-device system configuration registers
-  - st,boot-device-reg : Address of the aforementioned boot-device register(s)
-  - st,boot-device-spi : Expected boot-device value if booted via this device
+  - st,syscfg  : Phandle to boot-device system configuration registers
 
 Example:
 	spifsm: spifsm@fe902000{
-	        compatible         = "st,spi-fsm";
+		compatible         = "st,stih407-spi-fsm";
 	        reg                =  <0xfe902000 0x1000>;
-	        reg-names          = "spi-fsm";
 	        pinctrl-0          = <&pinctrl_fsm>;
 		st,syscfg	   = <&syscfg_rear>;
-	        st,boot-device-reg = <0x958>;
-	        st,boot-device-spi = <0x1a>;
-		status = "okay";
 	};
-
-- 
1.9.1

