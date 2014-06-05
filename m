Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaFEO41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:56:27 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:44839 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaFEO4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:56:25 -0400
Date: Thu, 5 Jun 2014 15:56:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@stlinux.com,
        linux-pm@vger.kernel.org, eduardo.valentin@ti.com, rui.zhang@intel.com
Subject: [PATCH v1 1/6] thermal: sti: Supply Device Tree documentation
Message-ID: <20140605145618.GF24240@lee--X1>
References: <1401442715-6350-1-git-send-email-lee.jones@linaro.org>
 <1401442715-6350-2-git-send-email-lee.jones@linaro.org>
 <20140605120147.GA7446@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605120147.GA7446@griffinp-ThinkPad-X1-Carbon-2nd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thermal: sti: Supply Device Tree documentation

Signed-off-by: Ajit Pal Singh <ajitpal.singh@st.com>
Acked-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/Documentation/devicetree/bindings/thermal/st-thermal.txt b/Documentation/devicetree/bindings/thermal/st-thermal.txt
new file mode 100644
index 0000000..3b9251b
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
+		clocks		= <&clk_m_mpethsens>;
+		interrupts	= <GIC_SPI 23 IRQ_TYPE_NONE>;
+	};
