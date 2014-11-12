Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaKLH7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:59:13 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34197 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbaKLH7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:59:09 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        mikko.perttunen@kapsi.fi, acourbot@nvidia.com,
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
Subject: [PATCH v4 06/13] of: Add Tegra124 EMC bindings
Date: Wed, 12 Nov 2014 08:56:29 +0100
Message-Id: <1415779051-26410-7-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415779051-26410-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1415779051-26410-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

Add binding documentation for the nvidia,tegra124-emc device tree node.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

---

v4:	* Remove mandatory naming of the timings subnode
	* Remove constraint on the unit-address of the timings and timing subnodes
	* Add some more information about nvidia,emc-configuration
	* Make the example complete

v2:	* Specify the unit addresses for the timings and timing nodes
---
 .../bindings/memory-controllers/tegra-emc.txt      | 376 +++++++++++++++++++++
 1 file changed, 376 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt

diff --git a/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
new file mode 100644
index 0000000..306e5c6
--- /dev/null
+++ b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
@@ -0,0 +1,376 @@
+NVIDIA Tegra124 SoC EMC (external memory controller)
+====================================================
+
+Required properties :
+- compatible : Should be "nvidia,tegra124-emc".
+- reg : physical base address and length of the controller's registers.
+- nvidia,memory-controller : phandle of the MC driver.
+
+The node should contain a "emc-timings" subnode for each supported RAM type (see field RAM_CODE in
+register PMC_STRAPPING_OPT_A), with its unit address being its RAM_CODE.
+
+Required properties for "emc-timings" nodes :
+- nvidia,ram-code : Should contain the value of RAM_CODE this timing set is used for.
+
+Each "emc-timings" node should contain a "timing" subnode for every supported EMC clock rate. The
+"timing" subnodes should have the clock rate in Hz as their unit address.
+
+Required properties for "timing" nodes :
+- clock-frequency : Should contain the memory clock rate in Hz.
+- The following properties contain EMC timing characterization values (specified in the board
+documentation) :
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
+- nvidia,emc-configuration : EMC timing characterization data. These are the registers (see section
+"15.6.2 EMC Registers" in the TRM) whose values need to be specified, according to the board
+documentation:
+
+	EMC_RC
+	EMC_RFC
+	EMC_RFC_SLR
+	EMC_RAS
+	EMC_RP
+	EMC_R2W
+	EMC_W2R
+	EMC_R2P
+	EMC_W2P
+	EMC_RD_RCD
+	EMC_WR_RCD
+	EMC_RRD
+	EMC_REXT
+	EMC_WEXT
+	EMC_WDV
+	EMC_WDV_MASK
+	EMC_QUSE
+	EMC_QUSE_WIDTH
+	EMC_IBDLY
+	EMC_EINPUT
+	EMC_EINPUT_DURATION
+	EMC_PUTERM_EXTRA
+	EMC_PUTERM_WIDTH
+	EMC_PUTERM_ADJ
+	EMC_CDB_CNTL_1
+	EMC_CDB_CNTL_2
+	EMC_CDB_CNTL_3
+	EMC_QRST
+	EMC_QSAFE
+	EMC_RDV
+	EMC_RDV_MASK
+	EMC_REFRESH
+	EMC_BURST_REFRESH_NUM
+	EMC_PRE_REFRESH_REQ_CNT
+	EMC_PDEX2WR
+	EMC_PDEX2RD
+	EMC_PCHG2PDEN
+	EMC_ACT2PDEN
+	EMC_AR2PDEN
+	EMC_RW2PDEN
+	EMC_TXSR
+	EMC_TXSRDLL
+	EMC_TCKE
+	EMC_TCKESR
+	EMC_TPD
+	EMC_TFAW
+	EMC_TRPAB
+	EMC_TCLKSTABLE
+	EMC_TCLKSTOP
+	EMC_TREFBW
+	EMC_FBIO_CFG6
+	EMC_ODT_WRITE
+	EMC_ODT_READ
+	EMC_FBIO_CFG5
+	EMC_CFG_DIG_DLL
+	EMC_CFG_DIG_DLL_PERIOD
+	EMC_DLL_XFORM_DQS0
+	EMC_DLL_XFORM_DQS1
+	EMC_DLL_XFORM_DQS2
+	EMC_DLL_XFORM_DQS3
+	EMC_DLL_XFORM_DQS4
+	EMC_DLL_XFORM_DQS5
+	EMC_DLL_XFORM_DQS6
+	EMC_DLL_XFORM_DQS7
+	EMC_DLL_XFORM_DQS8
+	EMC_DLL_XFORM_DQS9
+	EMC_DLL_XFORM_DQS10
+	EMC_DLL_XFORM_DQS11
+	EMC_DLL_XFORM_DQS12
+	EMC_DLL_XFORM_DQS13
+	EMC_DLL_XFORM_DQS14
+	EMC_DLL_XFORM_DQS15
+	EMC_DLL_XFORM_QUSE0
+	EMC_DLL_XFORM_QUSE1
+	EMC_DLL_XFORM_QUSE2
+	EMC_DLL_XFORM_QUSE3
+	EMC_DLL_XFORM_QUSE4
+	EMC_DLL_XFORM_QUSE5
+	EMC_DLL_XFORM_QUSE6
+	EMC_DLL_XFORM_QUSE7
+	EMC_DLL_XFORM_ADDR0
+	EMC_DLL_XFORM_ADDR1
+	EMC_DLL_XFORM_ADDR2
+	EMC_DLL_XFORM_ADDR3
+	EMC_DLL_XFORM_ADDR4
+	EMC_DLL_XFORM_ADDR5
+	EMC_DLL_XFORM_QUSE8
+	EMC_DLL_XFORM_QUSE9
+	EMC_DLL_XFORM_QUSE10
+	EMC_DLL_XFORM_QUSE11
+	EMC_DLL_XFORM_QUSE12
+	EMC_DLL_XFORM_QUSE13
+	EMC_DLL_XFORM_QUSE14
+	EMC_DLL_XFORM_QUSE15
+	EMC_DLI_TRIM_TXDQS0
+	EMC_DLI_TRIM_TXDQS1
+	EMC_DLI_TRIM_TXDQS2
+	EMC_DLI_TRIM_TXDQS3
+	EMC_DLI_TRIM_TXDQS4
+	EMC_DLI_TRIM_TXDQS5
+	EMC_DLI_TRIM_TXDQS6
+	EMC_DLI_TRIM_TXDQS7
+	EMC_DLI_TRIM_TXDQS8
+	EMC_DLI_TRIM_TXDQS9
+	EMC_DLI_TRIM_TXDQS10
+	EMC_DLI_TRIM_TXDQS11
+	EMC_DLI_TRIM_TXDQS12
+	EMC_DLI_TRIM_TXDQS13
+	EMC_DLI_TRIM_TXDQS14
+	EMC_DLI_TRIM_TXDQS15
+	EMC_DLL_XFORM_DQ0
+	EMC_DLL_XFORM_DQ1
+	EMC_DLL_XFORM_DQ2
+	EMC_DLL_XFORM_DQ3
+	EMC_DLL_XFORM_DQ4
+	EMC_DLL_XFORM_DQ5
+	EMC_DLL_XFORM_DQ6
+	EMC_DLL_XFORM_DQ7
+	EMC_XM2CMDPADCTRL
+	EMC_XM2CMDPADCTRL4
+	EMC_XM2CMDPADCTRL5
+	EMC_XM2DQSPADCTRL2
+	EMC_XM2DQPADCTRL2
+	EMC_XM2DQPADCTRL3
+	EMC_XM2CLKPADCTRL
+	EMC_XM2CLKPADCTRL2
+	EMC_XM2COMPPADCTRL
+	EMC_XM2VTTGENPADCTRL
+	EMC_XM2VTTGENPADCTRL2
+	EMC_XM2VTTGENPADCTRL3
+	EMC_XM2DQSPADCTRL3
+	EMC_XM2DQSPADCTRL4
+	EMC_XM2DQSPADCTRL5
+	EMC_XM2DQSPADCTRL6
+	EMC_DSR_VTTGEN_DRV
+	EMC_TXDSRVTTGEN
+	EMC_FBIO_SPARE
+	EMC_ZCAL_INTERVAL
+	EMC_ZCAL_WAIT_CNT
+	EMC_MRS_WAIT_CNT
+	EMC_MRS_WAIT_CNT2
+	EMC_CTT
+	EMC_CTT_DURATION
+	EMC_CFG_PIPE
+	EMC_DYN_SELF_REF_CONTROL
+	EMC_QPOP
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
+		emc-timings-3 {
+			nvidia,ram-code = <3>;
+
+			timing-12750000 {
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
+					0x00000004 /* EMC_R2W */
+					0x0000000a /* EMC_W2R */
+					0x00000003 /* EMC_R2P */
+					0x0000000b /* EMC_W2P */
+					0x00000000 /* EMC_RD_RCD */
+					0x00000000 /* EMC_WR_RCD */
+					0x00000003 /* EMC_RRD */
+					0x00000003 /* EMC_REXT */
+					0x00000000 /* EMC_WEXT */
+					0x00000006 /* EMC_WDV */
+					0x00000006 /* EMC_WDV_MASK */
+					0x00000006 /* EMC_QUSE */
+					0x00000002 /* EMC_QUSE_WIDTH */
+					0x00000000 /* EMC_IBDLY */
+					0x00000005 /* EMC_EINPUT */
+					0x00000005 /* EMC_EINPUT_DURATION */
+					0x00010000 /* EMC_PUTERM_EXTRA */
+					0x00000003 /* EMC_PUTERM_WIDTH */
+					0x00000000 /* EMC_PUTERM_ADJ */
+					0x00000000 /* EMC_CDB_CNTL_1 */
+					0x00000000 /* EMC_CDB_CNTL_2 */
+					0x00000000 /* EMC_CDB_CNTL_3 */
+					0x00000004 /* EMC_QRST */
+					0x0000000c /* EMC_QSAFE */
+					0x0000000d /* EMC_RDV */
+					0x0000000f /* EMC_RDV_MASK */
+					0x00000060 /* EMC_REFRESH */
+					0x00000000 /* EMC_BURST_REFRESH_NUM */
+					0x00000018 /* EMC_PRE_REFRESH_REQ_CNT */
+					0x00000002 /* EMC_PDEX2WR */
+					0x00000002 /* EMC_PDEX2RD */
+					0x00000001 /* EMC_PCHG2PDEN */
+					0x00000000 /* EMC_ACT2PDEN */
+					0x00000007 /* EMC_AR2PDEN */
+					0x0000000f /* EMC_RW2PDEN */
+					0x00000005 /* EMC_TXSR */
+					0x00000005 /* EMC_TXSRDLL */
+					0x00000004 /* EMC_TCKE */
+					0x00000005 /* EMC_TCKESR */
+					0x00000004 /* EMC_TPD */
+					0x00000000 /* EMC_TFAW */
+					0x00000000 /* EMC_TRPAB */
+					0x00000005 /* EMC_TCLKSTABLE */
+					0x00000005 /* EMC_TCLKSTOP */
+					0x00000064 /* EMC_TREFBW */
+					0x00000000 /* EMC_FBIO_CFG6 */
+					0x00000000 /* EMC_ODT_WRITE */
+					0x00000000 /* EMC_ODT_READ */
+					0x106aa298 /* EMC_FBIO_CFG5 */
+					0x002c00a0 /* EMC_CFG_DIG_DLL */
+					0x00008000 /* EMC_CFG_DIG_DLL_PERIOD */
+					0x00064000 /* EMC_DLL_XFORM_DQS0 */
+					0x00064000 /* EMC_DLL_XFORM_DQS1 */
+					0x00064000 /* EMC_DLL_XFORM_DQS2 */
+					0x00064000 /* EMC_DLL_XFORM_DQS3 */
+					0x00064000 /* EMC_DLL_XFORM_DQS4 */
+					0x00064000 /* EMC_DLL_XFORM_DQS5 */
+					0x00064000 /* EMC_DLL_XFORM_DQS6 */
+					0x00064000 /* EMC_DLL_XFORM_DQS7 */
+					0x00064000 /* EMC_DLL_XFORM_DQS8 */
+					0x00064000 /* EMC_DLL_XFORM_DQS9 */
+					0x00064000 /* EMC_DLL_XFORM_DQS10 */
+					0x00064000 /* EMC_DLL_XFORM_DQS11 */
+					0x00064000 /* EMC_DLL_XFORM_DQS12 */
+					0x00064000 /* EMC_DLL_XFORM_DQS13 */
+					0x00064000 /* EMC_DLL_XFORM_DQS14 */
+					0x00064000 /* EMC_DLL_XFORM_DQS15 */
+					0x00000000 /* EMC_DLL_XFORM_QUSE0 */
+					0x00000000 /* EMC_DLL_XFORM_QUSE1 */
+					0x00000000 /* EMC_DLL_XFORM_QUSE2 */
+					0x00000000 /* EMC_DLL_XFORM_QUSE3 */
+					0x00000000 /* EMC_DLL_XFORM_QUSE4 */
+					0x00000000 /* EMC_DLL_XFORM_QUSE5 */
+					0x00000000 /* EMC_DLL_XFORM_QUSE6 */
+					0x00000000 /* EMC_DLL_XFORM_QUSE7 */
+					0x00000000 /* EMC_DLL_XFORM_ADDR0 */
+					0x00000000 /* EMC_DLL_XFORM_ADDR1 */
+					0x00000000 /* EMC_DLL_XFORM_ADDR2 */
+					0x00000000 /* EMC_DLL_XFORM_ADDR3 */
+					0x00000000 /* EMC_DLL_XFORM_ADDR4 */
+					0x00000000 /* EMC_DLL_XFORM_ADDR5 */
+					0x00000000 /* EMC_DLL_XFORM_QUSE8 */
+					0x00000000 /* EMC_DLL_XFORM_QUSE9 */
+					0x00000000 /* EMC_DLL_XFORM_QUSE10 */
+					0x00000000 /* EMC_DLL_XFORM_QUSE11 */
+					0x00000000 /* EMC_DLL_XFORM_QUSE12 */
+					0x00000000 /* EMC_DLL_XFORM_QUSE13 */
+					0x00000000 /* EMC_DLL_XFORM_QUSE14 */
+					0x00000000 /* EMC_DLL_XFORM_QUSE15 */
+					0x00000000 /* EMC_DLI_TRIM_TXDQS0 */
+					0x00000000 /* EMC_DLI_TRIM_TXDQS1 */
+					0x00000000 /* EMC_DLI_TRIM_TXDQS2 */
+					0x00000000 /* EMC_DLI_TRIM_TXDQS3 */
+					0x00000000 /* EMC_DLI_TRIM_TXDQS4 */
+					0x00000000 /* EMC_DLI_TRIM_TXDQS5 */
+					0x00000000 /* EMC_DLI_TRIM_TXDQS6 */
+					0x00000000 /* EMC_DLI_TRIM_TXDQS7 */
+					0x00000000 /* EMC_DLI_TRIM_TXDQS8 */
+					0x00000000 /* EMC_DLI_TRIM_TXDQS9 */
+					0x00000000 /* EMC_DLI_TRIM_TXDQS10 */
+					0x00000000 /* EMC_DLI_TRIM_TXDQS11 */
+					0x00000000 /* EMC_DLI_TRIM_TXDQS12 */
+					0x00000000 /* EMC_DLI_TRIM_TXDQS13 */
+					0x00000000 /* EMC_DLI_TRIM_TXDQS14 */
+					0x00000000 /* EMC_DLI_TRIM_TXDQS15 */
+					0x000fc000 /* EMC_DLL_XFORM_DQ0 */
+					0x000fc000 /* EMC_DLL_XFORM_DQ1 */
+					0x000fc000 /* EMC_DLL_XFORM_DQ2 */
+					0x000fc000 /* EMC_DLL_XFORM_DQ3 */
+					0x0000fc00 /* EMC_DLL_XFORM_DQ4 */
+					0x0000fc00 /* EMC_DLL_XFORM_DQ5 */
+					0x0000fc00 /* EMC_DLL_XFORM_DQ6 */
+					0x0000fc00 /* EMC_DLL_XFORM_DQ7 */
+					0x10000280 /* EMC_XM2CMDPADCTRL */
+					0x00000000 /* EMC_XM2CMDPADCTRL4 */
+					0x00111111 /* EMC_XM2CMDPADCTRL5 */
+					0x0130b118 /* EMC_XM2DQSPADCTRL2 */
+					0x00000000 /* EMC_XM2DQPADCTRL2 */
+					0x00000000 /* EMC_XM2DQPADCTRL3 */
+					0x77ffc081 /* EMC_XM2CLKPADCTRL */
+					0x00000e0e /* EMC_XM2CLKPADCTRL2 */
+					0x81f1f108 /* EMC_XM2COMPPADCTRL */
+					0x07070004 /* EMC_XM2VTTGENPADCTRL */
+					0x0000003f /* EMC_XM2VTTGENPADCTRL2 */
+					0x016eeeee /* EMC_XM2VTTGENPADCTRL3 */
+					0x51451400 /* EMC_XM2DQSPADCTRL3 */
+					0x00514514 /* EMC_XM2DQSPADCTRL4 */
+					0x00514514 /* EMC_XM2DQSPADCTRL5 */
+					0x51451400 /* EMC_XM2DQSPADCTRL6 */
+					0x0000003f /* EMC_DSR_VTTGEN_DRV */
+					0x00000007 /* EMC_TXDSRVTTGEN */
+					0x00000000 /* EMC_FBIO_SPARE */
+					0x00000000 /* EMC_ZCAL_INTERVAL */
+					0x00000042 /* EMC_ZCAL_WAIT_CNT */
+					0x000e000e /* EMC_MRS_WAIT_CNT */
+					0x000e000e /* EMC_MRS_WAIT_CNT2 */
+					0x00000000 /* EMC_CTT */
+					0x00000003 /* EMC_CTT_DURATION */
+					0x0000f2f3 /* EMC_CFG_PIPE */
+					0x800001c5 /* EMC_DYN_SELF_REF_CONTROL */
+					0x0000000a /* EMC_QPOP */
+				>;
+			};
+		};
+	};
+};
-- 
1.9.3

