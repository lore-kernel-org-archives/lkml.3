Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbaBRPET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:04:19 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49423 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbaBRO5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:57:04 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, DCG_UPD_stlinux_kernel@list.st.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        computersforpeace@gmail.com, Angus.Clark@st.com,
        devicetree@vger.kernel.org
Subject: [PATCH 13/35] mtd: st_spi_fsm: Add device-tree binding documentation
Date: Tue, 18 Feb 2014 14:55:40 +0000
Message-Id: <1392735362-1245-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
References: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: devicetree@vger.kernel.org
Acked-by Angus Clark <angus.clark@st.com>
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

