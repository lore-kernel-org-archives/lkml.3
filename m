Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbaJUOrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:47:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40132 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315AbaJUOrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:47:49 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/12] of: Add Tegra124 EMC bindings
Date: Tue, 21 Oct 2014 16:45:38 +0200
Message-Id: <1413902788-7727-7-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413902788-7727-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1413902788-7727-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

Add binding documentation for the nvidia,tegra124-emc device tree node.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

---

v2:	* Specify the unit addresses for the timings and timing nodes
---
 .../bindings/memory-controllers/tegra-emc.txt      | 118 +++++++++++++++++++++
 1 file changed, 118 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt

diff --git a/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
new file mode 100644
index 0000000..fe64d57
--- /dev/null
+++ b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
@@ -0,0 +1,118 @@
+NVIDIA Tegra124 SoC EMC (external memory controller)
+====================================================
+
+Required properties :
+- compatible : Should be "nvidia,tegra124-emc".
+- reg : physical base address and length of the controller's registers.
+- nvidia,memory-controller : phandle of the MC driver.
+
+The node should contain a "timings" subnode for each supported RAM type (see
+field RAM_CODE in register PMC_STRAPPING_OPT_A), with its unit address being its
+RAM_CODE.
+
+Required properties for "timings" nodes :
+- nvidia,ram-code : Should contain the value of RAM_CODE this timing set is used
+for.
+
+Each "timings" node should contain a "timing" subnode for every supported EMC
+clock rate. The "timing" subnodes should have the clock rate in Hz as their unit
+address.
+
+Required properties for "timing" nodes :
+- clock-frequency : Should contain the memory clock rate in Hz.
+- The following properties contain EMC timing characterization values (specified
+in the board documentation) :
+  - nvidia,emc-zcal-cnt-long
+  - nvidia,emc-auto-cal-interval
+  - nvidia,emc-ctt-term-ctrl
+  - nvidia,emc-cfg
+  - nvidia,emc-cfg-2
+  - nvidia,emc-sel-dpd-ctrl
+  - nvidia,emc-cfg-dig-dll
+  - nvidia,emc-bgbias-ctl0
+  - nvidia,emc-auto-cal-config
+  - nvidia,emc-auto-cal-config2
+  - nvidia,emc-auto-cal-config3
+  - nvidia,emc-mode-reset
+  - nvidia,emc-mode-1
+  - nvidia,emc-mode-2
+  - nvidia,emc-mode-4
+- nvidia,emc-configuration : EMC timing characterization data to be written to
+the EMC registers, as specified by the board documentation.
+
+Example SoC include file:
+
+/ {
+	emc@0,7001b000 {
+		compatible = "nvidia,tegra124-emc";
+		reg = <0x0 0x7001b000 0x0 0x1000>;
+
+		nvidia,memory-controller = <&mc>;
+	};
+};
+
+Example board file:
+
+/ {
+	emc@0,7001b000 {
+		timings@3 {
+			nvidia,ram-code = <3>;
+
+			timing@12750000 {
+				clock-frequency = <12750000>;
+
+				nvidia,emc-zcal-cnt-long = <0x00000042>;
+				nvidia,emc-auto-cal-interval = <0x001fffff>;
+				nvidia,emc-ctt-term-ctrl = <0x00000802>;
+				nvidia,emc-cfg = <0x73240000>;
+				nvidia,emc-cfg-2 = <0x000008c5>;
+				nvidia,emc-sel-dpd-ctrl = <0x00040128>;
+				nvidia,emc-cfg-dig-dll = <0x002c0068>;
+				nvidia,emc-bgbias-ctl0 = <0x00000008>;
+				nvidia,emc-auto-cal-config = <0xa1430000>;
+				nvidia,emc-auto-cal-config2 = <0x00000000>;
+				nvidia,emc-auto-cal-config3 = <0x00000000>;
+				nvidia,emc-mode-reset = <0x80001221>;
+				nvidia,emc-mode-1 = <0x80100003>;
+				nvidia,emc-mode-2 = <0x80200008>;
+				nvidia,emc-mode-4 = <0x00000000>;
+
+				nvidia,emc-configuration = <
+					0x00000000 /* EMC_RC */
+					0x00000003 /* EMC_RFC */
+					0x00000000 /* EMC_RFC_SLR */
+					0x00000000 /* EMC_RAS */
+					0x00000000 /* EMC_RP */
+				>;
+			};
+
+			timing@20400000 {
+				clock-frequency = <20400000>;
+
+				nvidia,emc-zcal-cnt-long = <0x00000042>;
+				nvidia,emc-auto-cal-interval = <0x001fffff>;
+				nvidia,emc-ctt-term-ctrl = <0x00000802>;
+				nvidia,emc-cfg = <0x73240000>;
+				nvidia,emc-cfg-2 = <0x000008c5>;
+				nvidia,emc-sel-dpd-ctrl = <0x00040128>;
+				nvidia,emc-cfg-dig-dll = <0x002c0068>;
+				nvidia,emc-bgbias-ctl0 = <0x00000008>;
+				nvidia,emc-auto-cal-config = <0x00000000>;
+				nvidia,emc-auto-cal-config2 = <0x00000000>;
+				nvidia,emc-auto-cal-config3 = <0xa1430000>;
+				nvidia,emc-mode-reset = <0x80001221>;
+				nvidia,emc-mode-1 = <0x80100003>;
+				nvidia,emc-mode-2 = <0x80200008>;
+				nvidia,emc-mode-4 = <0x00000000>;
+
+				nvidia,emc-configuration = <
+					0x00000000
+					0x00000005
+					0x00000000
+					0x00000000
+					0x00000000
+				>;
+			};
+		};
+	};
+};
-- 
1.9.3

