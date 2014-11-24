Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbaKXKW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:22:26 -0500
Received: from mail-bn1on0148.outbound.protection.outlook.com ([157.56.110.148]:63744
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753275AbaKXKWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:22:23 -0500
X-Greylist: delayed 3812 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2014 05:22:23 EST
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>
CC: <shawn.guo@linaro.org>, <linux-fbdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Xiubo Li" <Li.Xiubo@freescale.com>
Subject: [PATCH 2/4] video: fsl-dcfb: Add devicetree binding support
Date: Mon, 24 Nov 2014 18:20:52 +0800
Message-ID: <1416824454-28156-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1416824454-28156-1-git-send-email-Li.Xiubo@freescale.com>
References: <1416824454-28156-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(21056001)(104166001)(104016003)(6806004)(102836001)(50986999)(76176999)(31966008)(92726001)(92566001)(86362001)(84676001)(93916002)(68736004)(19580395003)(44976005)(19580405001)(97736003)(47776003)(20776003)(64706001)(87936001)(87286001)(88136002)(89996001)(105606002)(120916001)(99396003)(48376002)(36756003)(106466001)(229853001)(46102003)(107046002)(62966003)(95666004)(77156002)(4396001)(50226001)(50466002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0611;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0611;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0611;
X-Forefront-PRVS: 040513D301
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0611;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree binding support for fsl-dcfb framebuffer driver. It
uses the generic display bindings and helper functions.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 .../devicetree/bindings/video/fsl,dcfb.txt         | 52 ++++++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/fsl,dcfb.txt

diff --git a/Documentation/devicetree/bindings/video/fsl,dcfb.txt b/Documentation/devicetree/bindings/video/fsl,dcfb.txt
new file mode 100644
index 0000000..2f3d02b
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/fsl,dcfb.txt
@@ -0,0 +1,52 @@
+* Freescale Simple Display Controller FB Driver
+
+=== For dcfb node ===
+Required properties:
+- compatible:		Should be one of "fsl,ls1021a-dcfb".
+- reg:			Address and length of the register set for dcfb.
+- clocks:		From common clock binding: handle to dcfb clock.
+- clock-names:		From common clock binding: Shall be "dcfb".
+- display:		The phandle to display node.
+
+Optional properties:
+- scfg-controller:	The phandle of scfg node.
+
+=== For display sub-node ===
+Required properties:
+- bits-per-pixel:	<16> for RGB565,
+			<24> for RGB888,
+			<32> for RGB8888.
+
+Required timing node for dispplay sub-node:
+- display-timings:	Refer to binding doc display-timing.txt for details.
+
+Examples:
+dcfb: dcfb@2ce0000 {
+	compatible = "fsl,ls1021a-dcfb";
+	reg = <0x0 0x2ce0000 0x0 0x10000>;
+	clocks = <&platform_clk 0>;
+	clock-names = "dcfb";
+	scfg-controller = <&scfg>;
+	display = <&display>;
+
+	display: display@0 {
+		bits-per-pixel = <24>;
+
+		display-timings {
+			native-mode = <&timing0>;
+			timing0: nl4827hc19 {
+				clock-frequency = <10870000>;
+				hactive = <480>;
+				vactive = <272>;
+				hback-porch = <2>;
+				hfront-porch = <2>;
+				vback-porch = <1>;
+				vfront-porch = <1>;
+				hsync-len = <41>;
+				vsync-len = <2>;
+				hsync-active = <1>;
+				vsync-active = <1>;
+			};
+		};
+	};
+};
-- 
2.1.0.27.g96db324

