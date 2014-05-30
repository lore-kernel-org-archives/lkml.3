Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbaE3JlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:41:01 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:54022 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbaE3JjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:39:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, rui.zhang@intel.com,
        eduardo.valentin@ti.com, ajitpal.singh@st.com,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com
Subject: [PATCH 1/6] thermal: sti: Supply Device Tree documentation
Date: Fri, 30 May 2014 10:38:30 +0100
Message-Id: <1401442715-6350-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401442715-6350-1-git-send-email-lee.jones@linaro.org>
References: <1401442715-6350-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ajit Pal Singh <ajitpal.singh@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../devicetree/bindings/thermal/st-thermal.txt     | 42 ++++++++++++++++++++++
 1 file changed, 42 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/st-thermal.txt

diff --git a/Documentation/devicetree/bindings/thermal/st-thermal.txt b/Documentation/devicetree/bindings/thermal/st-thermal.txt
new file mode 100644
index 0000000..8537fdc
--- /dev/null
+++ b/Documentation/devicetree/bindings/thermal/st-thermal.txt
@@ -0,0 +1,42 @@
+Binding for Thermal Sensor driver for STMicroelectronics STi series of SoCs.
+
+Required parameters:
+-------------------
+
+compatible : 	st,<SoC>-<module>-thermal; should be one of:
+		  "st,stih415-sas-thermal",
+		  "st,stih415-mpe-thermal",
+		  "st,stih416-sas-thermal"
+		  "st,stih416-mpe-thermal"
+		  "st,stid127-thermal" or
+		  "st,stih407-thermal"
+		according to the SoC type (stih415, stih416, stid127, stih407)
+		and module type (sas or mpe). On stid127 & stih407 there is only
+		one die/module, so there is no module type in the compatible
+		string.
+clock-names : 	Should be "thermal".
+		  See: Documentation/devicetree/bindings/resource-names.txt
+clocks : 	Phandle of the clock used by the thermal sensor.
+		  See: Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Optional parameters:
+-------------------
+
+reg : 		For non-sysconf based sensors, this should be the physical base
+		address and length of the sensor's registers.
+interrupts :	Standard way to define interrupt number.
+		Interrupt is mandatory to be defined when compatible is
+		"stih416-mpe-thermal".
+		  NB: For thermal sensor's for which no interrupt has been
+		  defined, a polling delay of 1000ms will be used to read the
+		  temperature from device.
+
+Example:
+
+	temp1@fdfe8000 {
+		compatible	= "st,stih416-mpe-thermal";
+		reg		= <0xfdfe8000 0x10>;
+		clock-names	= "thermal";
+		clocks		= <&CLK_M_MPETHSENS>;
+		interrupts	= <GIC_SPI 23 IRQ_TYPE_NONE>;
+	};
-- 
1.8.3.2

