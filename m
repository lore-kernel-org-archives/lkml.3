Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbaAHNsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:48:53 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:62252 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256AbaAHNsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:48:46 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, angus.clark@st.com,
        Lee Jones <lee.jones@linaro.org>, devicetree@vger.kernel.org
Subject: [PATCH v4 14/37] mtd: st_spi_fsm: Add device-tree binding documentation
Date: Wed,  8 Jan 2014 13:46:57 +0000
Message-Id: <1389188840-14306-15-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389188840-14306-1-git-send-email-lee.jones@linaro.org>
References: <1389188840-14306-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: devicetree@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/mtd/st-fsm.txt | 26 ++++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/st-fsm.txt

diff --git a/Documentation/devicetree/bindings/mtd/st-fsm.txt b/Documentation/devicetree/bindings/mtd/st-fsm.txt
new file mode 100644
index 0000000..c248939
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/st-fsm.txt
@@ -0,0 +1,26 @@
+* ST-Microelectronics SPI FSM Serial (NOR) Flash Controller
+
+Required properties:
+  - compatible : Should be "st,spi-fsm"
+  - reg        : Contains register's location and length.
+  - reg-names  : Should contain the reg names "spi-fsm"
+  - interrupts : The interrupt number
+  - pinctrl-0  : Standard Pinctrl phandle (see: pinctrl/pinctrl-bindings.txt)
+
+Optional properties:
+  - st,syscfg          : Phandle to boot-device system configuration registers
+  - st,boot-device-reg : Address of the aforementioned boot-device register(s)
+  - st,boot-device-spi : Expected boot-device value if booted via this device
+
+Example:
+	spifsm: spifsm@fe902000{
+	        compatible         = "st,spi-fsm";
+	        reg                =  <0xfe902000 0x1000>;
+	        reg-names          = "spi-fsm";
+	        pinctrl-0          = <&pinctrl_fsm>;
+		st,syscfg	   = <&syscfg_rear>;
+	        st,boot-device-reg = <0x958>;
+	        st,boot-device-spi = <0x1a>;
+		status = "okay";
+	};
+
-- 
1.8.3.2

