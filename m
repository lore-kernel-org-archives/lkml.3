Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030417AbaGDJ4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:56:47 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38191 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030392AbaGDJ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:56:39 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v6 21/23] clk: max77802: Add DT binding documentation
Date: Fri,  4 Jul 2014 11:55:20 +0200
Message-Id: <1404467722-26687-22-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Device Tree binding documentation for the clocks
outputs in the Maxim 77802 Power Management IC.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since v5:
 - Fix typo error in DT binding. Suggested by Andreas Farber.
 - Add "clock-output-names" as an optional property since now is supported.

Changes since v4: None

Changes since v3:
 - Don't use the same clock driver name in clock-names since it's a consumer
   concept and most probably will be different. Suggested by Doug Anderson.

Changes since v2:
 - Split the DT binding documentation in a separate patch
---
 .../devicetree/bindings/clock/maxim,max77802.txt   | 44 ++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/maxim,max77802.txt

diff --git a/Documentation/devicetree/bindings/clock/maxim,max77802.txt b/Documentation/devicetree/bindings/clock/maxim,max77802.txt
new file mode 100644
index 0000000..c6dc783
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/maxim,max77802.txt
@@ -0,0 +1,44 @@
+Binding for Maxim MAX77802 32k clock generator block
+
+This is a part of device tree bindings of MAX77802 multi-function device.
+More information can be found in bindings/mfd/max77802.txt file.
+
+The MAX77802 contains two 32.768khz clock outputs that can be controlled
+(gated/ungated) over I2C.
+
+Following properties should be present in main device node of the MFD chip.
+
+Required properties:
+- #clock-cells: From common clock binding; shall be set to 1.
+
+Optional properties:
+- clock-output-names: From common clock binding.
+
+Each clock is assigned an identifier and client nodes can use this identifier
+to specify the clock which they consume. Following indices are allowed:
+     - 0: 32khz_ap clock,
+     - 1: 32khz_cp clock.
+
+Clocks are defined as preprocessor macros in dt-bindings/clock/maxim,max77802.h
+header and can be used in device tree sources.
+
+Example: Node of the MFD chip
+
+	max77802: max77802@09 {
+		compatible = "maxim,max77802";
+		interrupt-parent = <&wakeup_eint>;
+		interrupts = <26 0>;
+		reg = <0x09>;
+		#clock-cells = <1>;
+
+		/* ... */
+	};
+
+Example: Clock consumer node
+
+	foo@0 {
+		compatible = "bar,foo";
+		/* ... */
+		clock-names = "my-clock";
+		clocks = <&max77802 MAX77802_CLK_32K_AP>;
+	};
-- 
2.0.0.rc2

