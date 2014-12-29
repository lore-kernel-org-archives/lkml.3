Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaL2Ggi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 01:36:38 -0500
Received: from mail-bn1bbn0104.outbound.protection.outlook.com ([157.56.111.104]:14880
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752044AbaL2Ggd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 01:36:33 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v6 13/21] Documentation: dt-bindings: Add bindings for i.MX specific Synopsys DW MIPI DSI driver
Date: Mon, 29 Dec 2014 14:39:20 +0800
Message-ID: <1419835168-9034-14-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419835168-9034-1-git-send-email-Ying.Liu@freescale.com>
References: <1419835168-9034-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(99396003)(229853001)(47776003)(107046002)(2950100001)(62966003)(77156002)(84676001)(110136001)(104016003)(6806004)(50226001)(64706001)(19580405001)(20776003)(2351001)(19580395003)(105606002)(36756003)(4396001)(106466001)(77096005)(89996001)(48376002)(87936001)(50466002)(97736003)(76176999)(50986999)(21056001)(120916001)(85426001)(68736005)(46102003)(86362001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0640;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0640;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB0640;
X-Forefront-PRVS: 0440AC9990
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0640;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2014 06:36:29.8866
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB0640
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree bindings for i.MX specific Synopsys DW MIPI DSI driver.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v5->v6:
 * Add the #address-cells and #size-cells properties in the example 'ports'
   node.
 * Remove the useless pllref_gate clock from the required clocks, clock-names
   property.

v4->v5:
 * None.

v3->v4:
 * Newly introduced in v4.  This is separated from the relevant driver patch
   in v3 to address Stefan Wahren's comment.

 .../devicetree/bindings/drm/imx/mipi_dsi.txt       | 78 ++++++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt

diff --git a/Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt b/Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt
new file mode 100644
index 0000000..75a7766
--- /dev/null
+++ b/Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt
@@ -0,0 +1,78 @@
+i.MX specific Device-Tree bindings for Synopsys DesignWare MIPI DSI host controller
+
+MIPI DSI host controller
+========================
+
+The MIPI DSI host controller is a Synopsys DesignWare IP.
+The common device tree documentation for this controller can be found
+at [1].
+
+Required properties:
+ - #address-cells: Should be <1>.
+ - #size-cells: Should be <0>.
+ - compatible: The compatible string should be "fsl,imx6q-mipi-dsi"
+   for i.MX6q/sdl SoCs.
+ - reg: Physical base address of the controller and length of memory
+   mapped region.
+ - interrupts: The controller's interrupt number to the CPU(s).
+ - gpr: Should be <&gpr>.
+   The phandle points to the iomuxc-gpr region containing the
+   multiplexer control register for the controller.
+ - clocks, clock-names: Phandles to the controller pllref and core_cfg clocks,
+   as described in [2] and [3].
+
+Required sub-nodes:
+ - ports: This node may contain up to four port nodes with endpoint
+   definitions as defined in [4], corresponding to the four inputs to
+   the controller multiplexer.
+ - A node to represent a DSI peripheral as described in [5].
+
+[1] Documentation/devicetree/bindings/drm/bridge/dw_mipi_dsi.txt.
+[2] Documentation/devicetree/bindings/clock/clock-bindings.txt
+[3] Documentation/devicetree/bindings/clock/imx6q-clock.txt
+[4] Documentation/devicetree/bindings/media/video-interfaces.txt
+[5] Documentation/devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt
+
+example:
+	gpr: iomuxc-gpr@020e0000 {
+		/* ... */
+	};
+
+	mipi_dsi: mipi@021e0000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,imx6q-mipi-dsi";
+		reg = <0x021e0000 0x4000>;
+		interrupts = <0 102 IRQ_TYPE_LEVEL_HIGH>;
+		gpr = <&gpr>;
+		clocks = <&clks IMX6QDL_CLK_MIPI_CORE_CFG>,
+			 <&clks IMX6QDL_CLK_MIPI_CORE_CFG>;
+		clock-names = "pllref", "core_cfg";
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				reg = <0>;
+
+				mipi_mux_0: endpoint {
+					remote-endpoint = <&ipu1_di0_mipi>;
+				};
+			};
+
+			port@1 {
+				reg = <1>;
+
+				mipi_mux_1: endpoint {
+					remote-endpoint = <&ipu1_di1_mipi>;
+				};
+			};
+		};
+
+		panel {
+			compatible = "truly,tft480800-16-e-dsi";
+			reg = <0>;
+			/* ... */
+		};
+	};
-- 
2.1.0

