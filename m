Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbaG3Rmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:42:33 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33265 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbaG3Rma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:42:30 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, airlied@linux.ie
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v8 01/11] drm: sti: add bindings for DRM driver
Date: Wed, 30 Jul 2014 19:41:57 +0200
Message-Id: <1406742127-27654-2-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406742127-27654-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1406742127-27654-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DRM/KMS driver bindings documentation.
Describe the required properties for each of the hardware IPs drivers.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Reviewed-by: Rob Clark <robdclark@gmail.com>
---
 .../devicetree/bindings/gpu/st,stih4xx.txt         | 189 +++++++++++++++++++++
 drivers/gpu/drm/sti/NOTES                          |  58 +++++++
 2 files changed, 247 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpu/st,stih4xx.txt
 create mode 100644 drivers/gpu/drm/sti/NOTES

diff --git a/Documentation/devicetree/bindings/gpu/st,stih4xx.txt b/Documentation/devicetree/bindings/gpu/st,stih4xx.txt
new file mode 100644
index 0000000..2d150c3
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpu/st,stih4xx.txt
@@ -0,0 +1,189 @@
+STMicroelectronics stih4xx platforms
+
+- sti-vtg: video timing generator
+  Required properties:
+  - compatible: "st,vtg"
+  - reg: Physical base address of the IP registers and length of memory mapped region.
+  Optional properties:
+  - interrupts : VTG interrupt number to the CPU.
+  - st,slave: phandle on a slave vtg
+
+- sti-vtac: video timing advanced inter dye communication Rx and TX
+  Required properties:
+  - compatible: "st,vtac-main" or "st,vtac-aux"
+  - reg: Physical base address of the IP registers and length of memory mapped region.
+  - clocks: from common clock binding: handle hardware IP needed clocks, the
+    number of clocks may depend of the SoC type.
+    See ../clocks/clock-bindings.txt for details.
+  - clock-names: names of the clocks listed in clocks property in the same
+    order.
+
+- sti-display-subsystem: Master device for DRM sub-components
+  This device must be the parent of all the sub-components and is responsible
+  of bind them.
+  Required properties:
+  - compatible: "st,sti-display-subsystem"
+  - ranges: to allow probing of subdevices
+
+- sti-compositor: frame compositor engine
+  must be a child of sti-display-subsystem
+  Required properties:
+  - compatible: "st,stih<chip>-compositor"
+  - reg: Physical base address of the IP registers and length of memory mapped region.
+  - clocks: from common clock binding: handle hardware IP needed clocks, the
+    number of clocks may depend of the SoC type.
+    See ../clocks/clock-bindings.txt for details.
+  - clock-names: names of the clocks listed in clocks property in the same
+    order.
+  - resets: resets to be used by the device
+    See ../reset/reset.txt for details.
+  - reset-names: names of the resets listed in resets property in the same
+    order.
+  - st,vtg: phandle(s) on vtg device (main and aux) nodes.
+
+- sti-tvout: video out hardware block
+  must be a child of sti-display-subsystem
+  Required properties:
+  - compatible: "st,stih<chip>-tvout"
+  - reg: Physical base address of the IP registers and length of memory mapped region.
+  - reg-names: names of the mapped memory regions listed in regs property in
+    the same order.
+  - resets: resets to be used by the device
+    See ../reset/reset.txt for details.
+  - reset-names: names of the resets listed in resets property in the same
+    order.
+  - ranges: to allow probing of subdevices
+
+- sti-hdmi: hdmi output block
+  must be a child of sti-tvout
+  Required properties:
+  - compatible: "st,stih<chip>-hdmi";
+  - reg: Physical base address of the IP registers and length of memory mapped region.
+  - reg-names: names of the mapped memory regions listed in regs property in
+    the same order.
+  - interrupts : HDMI interrupt number to the CPU.
+  - interrupt-names: name of the interrupts listed in interrupts property in
+    the same order
+  - clocks: from common clock binding: handle hardware IP needed clocks, the
+    number of clocks may depend of the SoC type.
+  - clock-names: names of the clocks listed in clocks property in the same
+    order.
+  - hdmi,hpd-gpio: gpio id to detect if an hdmi cable is plugged or not.
+
+sti-hda:
+  Required properties:
+  must be a child of sti-tvout
+  - compatible: "st,stih<chip>-hda"
+  - reg: Physical base address of the IP registers and length of memory mapped region.
+  - reg-names: names of the mapped memory regions listed in regs property in
+    the same order.
+  - clocks: from common clock binding: handle hardware IP needed clocks, the
+    number of clocks may depend of the SoC type.
+    See ../clocks/clock-bindings.txt for details.
+  - clock-names: names of the clocks listed in clocks property in the same
+    order.
+
+Example:
+
+/ {
+	...
+
+	vtg_main_slave: sti-vtg-main-slave@fe85A800 {
+		compatible	= "st,vtg";
+		reg		= <0xfe85A800 0x300>;
+		interrupts	= <GIC_SPI 175 IRQ_TYPE_NONE>;
+	};
+
+	vtg_main: sti-vtg-main-master@fd348000 {
+		compatible	= "st,vtg";
+		reg		= <0xfd348000 0x400>;
+		st,slave	= <&vtg_main_slave>;
+	};
+
+	vtg_aux_slave: sti-vtg-aux-slave@fd348400 {
+		compatible	= "st,vtg";
+		reg		= <0xfe858200 0x300>;
+		interrupts	= <GIC_SPI 176 IRQ_TYPE_NONE>;
+	};
+
+	vtg_aux: sti-vtg-aux-master@fd348400 {
+		compatible	= "st,vtg";
+		reg		= <0xfd348400 0x400>;
+		st,slave	= <&vtg_aux_slave>;
+	};
+
+
+	sti-vtac-rx-main@fee82800 {
+		compatible	= "st,vtac-main";
+		reg		= <0xfee82800 0x200>;
+		clock-names     = "vtac";
+		clocks          = <&clk_m_a2_div0 CLK_M_VTAC_MAIN_PHY>;
+	};
+
+	sti-vtac-rx-aux@fee82a00 {
+		compatible	= "st,vtac-aux";
+		reg		= <0xfee82a00 0x200>;
+		clock-names     = "vtac";
+		clocks          = <&clk_m_a2_div0 CLK_M_VTAC_AUX_PHY>;
+	};
+
+	sti-vtac-tx-main@fd349000 {
+		compatible	= "st,vtac-main";
+		reg		= <0xfd349000 0x200>, <0xfd320000 0x10000>;
+		clock-names     = "vtac";
+		clocks           = <&clk_s_a1_hs CLK_S_VTAC_TX_PHY>;
+	};
+
+	sti-vtac-tx-aux@fd349200 {
+		compatible	= "st,vtac-aux";
+		reg		= <0xfd349200 0x200>, <0xfd320000 0x10000>;
+		clock-names     = "vtac";
+		clocks          = <&clk_s_a1_hs CLK_S_VTAC_TX_PHY>;
+	};
+
+	sti-display-subsystem {
+		compatible = "st,sti-display-subsystem";
+		ranges;
+
+		sti-compositor@fd340000 {
+			compatible	= "st,stih416-compositor";
+			reg		= <0xfd340000 0x1000>;
+			clock-names	= "compo_main", "compo_aux",
+			                  "pix_main", "pix_aux";
+			clocks          = <&clk_m_a2_div1 CLK_M_COMPO_MAIN>, <&clk_m_a2_div1 CLK_M_COMPO_AUX>,
+					  <&clockgen_c_vcc CLK_S_PIX_MAIN>, <&clockgen_c_vcc CLK_S_PIX_AUX>;
+			reset-names     = "compo-main", "compo-aux";
+			resets          = <&softreset STIH416_COMPO_M_SOFTRESET>, <&softreset STIH416_COMPO_A_SOFTRESET>;
+			st,vtg		= <&vtg_main>, <&vtg_aux>;
+		};
+
+		sti-tvout@fe000000 {
+			compatible	= "st,stih416-tvout";
+			reg		= <0xfe000000 0x1000>, <0xfe85a000 0x400>, <0xfe830000 0x10000>;
+			reg-names	= "tvout-reg", "hda-reg", "syscfg";
+			reset-names     = "tvout";
+			resets          = <&softreset STIH416_HDTVOUT_SOFTRESET>;
+			ranges;
+
+			sti-hdmi@fe85c000 {
+				compatible	= "st,stih416-hdmi";
+				reg		= <0xfe85c000 0x1000>, <0xfe830000 0x10000>;
+				reg-names	= "hdmi-reg", "syscfg";
+				interrupts	= <GIC_SPI 173 IRQ_TYPE_NONE>;
+				interrupt-names	= "irq";
+				clock-names	= "pix", "tmds", "phy", "audio";
+				clocks          = <&clockgen_c_vcc CLK_S_PIX_HDMI>, <&clockgen_c_vcc CLK_S_TMDS_HDMI>, <&clockgen_c_vcc CLK_S_HDMI_REJECT_PLL>, <&clockgen_b1 CLK_S_PCM_0>;
+				hdmi,hpd-gpio	= <&PIO2 5>;
+			};
+
+			sti-hda@fe85a000 {
+				compatible	= "st,stih416-hda";
+				reg		= <0xfe85a000 0x400>, <0xfe83085c 0x4>;
+				reg-names	= "hda-reg", "video-dacs-ctrl";
+				clock-names	= "pix", "hddac";
+				clocks          = <&clockgen_c_vcc CLK_S_PIX_HD>, <&clockgen_c_vcc CLK_S_HDDAC>;
+			};
+		};
+	};
+	...
+};
diff --git a/drivers/gpu/drm/sti/NOTES b/drivers/gpu/drm/sti/NOTES
new file mode 100644
index 0000000..57e2579
--- /dev/null
+++ b/drivers/gpu/drm/sti/NOTES
@@ -0,0 +1,58 @@
+1. stiH display hardware IP
+---------------------------
+The STMicroelectronics stiH SoCs use a common chain of HW display IP blocks:
+- The High Quality Video Display Processor (HQVDP) gets video frames from a
+  video decoder and does high quality video processing, including scaling.
+
+- The Compositor is a multiplane, dual-mixer (Main & Aux) digital processor. It
+  has several inputs:
+  - The graphics planes are internally processed by the Generic Display
+    Pipeline (GDP).
+  - The video plug (VID) connects to the HQVDP output.
+  - The cursor handles ... a cursor.
+- The TV OUT pre-formats (convert, clip, round) the compositor output data
+- The HDMI / DVO / HD Analog / SD analog IP builds the video signals
+  - DVO (Digital Video Output) handles a 24bits parallel signal
+  - The HD analog signal is typically driven by a YCbCr cable, supporting up to
+    1080i mode.
+  - The SD analog signal is typically used for legacy TV
+- The VTG (Video Timing Generators) build Vsync signals used by the other HW IP
+Note that some stiH drivers support only a subset of thee HW IP.
+
+                  .-------------.   .-----------.   .-----------.
+GPU >-------------+GDP     Main |   |           +---+    HDMI   +--> HDMI
+GPU >-------------+GDP     mixer+---+           |   :===========:
+GPU >-------------+Cursor       |   |           +---+    DVO    +--> 24b//
+        -------   |  COMPOSITOR |   |  TV OUT   |   :===========:
+       |       |  |             |   |           +---+ HD analog +--> YCbCr
+Vid >--+ HQVDP +--+VID     Aux  +---+           |   :===========:
+dec    |       |  |        mixer|   |           +---+ SD analog +--> CVBS
+       '-------'  '-------------'   '-----------'   '-----------'
+                   .-----------.
+                   |       main+--> Vsync
+                   | VTG       |
+                   |        aux+--> Vsync
+                   '-----------'
+
+2. DRM / HW mapping
+-------------------
+These IP are mapped to the DRM objects as following:
+- The CRTCs are mapped to the Compositor Main and Aux Mixers
+- The Framebuffers and planes are mapped to the Compositor GDP (non video
+  buffers) and to HQVDP+VID (video buffers)
+- The Cursor is mapped to the Compositor Cursor
+- The Encoders are mapped to the TVOut
+- The Bridges/Connectors are mapped to the HDMI / DVO / HD Analog / SD analog
+
+FB & planes         Cursor      CRTC     Encoders    Bridges/Connectors
+   |                   |          |         |                       |
+   |                   |          |         |                       |
+   |              .-------------. | .-----------.   .-----------.   |
+   +------------> |GDP |   Main | | |       +-> |   |    HDMI   | <-+
+   +------------> |GDP v   mixer|<+ |       |   |   :===========:   |
+   |              |Cursor       | | |       +-> |   |    DVO    | <-+
+   |    -------   |  COMPOSITOR | | |TV OUT |   |   :===========:   |
+   |   |       |  |             | | |       +-> |   | HD analog | <-+
+   +-> | HQVDP |  |VID     Aux  |<+ |       |   |   :===========:   |
+       |       |  |        mixer|   |       +-> |   | SD analog | <-+
+       '-------'  '-------------'   '-----------'   '-----------'
-- 
1.9.1

