Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbaLWDpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:45:35 -0500
Received: from mail-by2on0129.outbound.protection.outlook.com ([207.46.100.129]:46208
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754790AbaLWDnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:43:23 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v3 09/18] ARM: dts: imx6qdl: Move existing MIPI DSI ports into a new 'ports' node
Date: Tue, 23 Dec 2014 11:46:30 +0800
Message-ID: <1419306399-9387-10-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419306399-9387-1-git-send-email-Ying.Liu@freescale.com>
References: <1419306399-9387-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(84676001)(31966008)(105606002)(6806004)(110136001)(50226001)(68736005)(4396001)(77096005)(86362001)(106466001)(19580405001)(107046002)(36756003)(92566001)(104016003)(97736003)(76176999)(2351001)(229853001)(20776003)(89996001)(50986999)(99396003)(50466002)(120916001)(2950100001)(21056001)(19580395003)(47776003)(64706001)(46102003)(85426001)(62966003)(77156002)(48376002)(87936001)(32563001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0638;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:ErrorRetry;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0638;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB0638;
X-Forefront-PRVS: 04347F8039
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0638;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2014 03:43:17.7082
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB0638
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MIPI DSI node contains some ports which represent possible DRM CRTCs
it can connect with.  Each port has a 'reg' property embedded.  This
property will be wrongly interpretted by the MIPI DSI bus driver, because
the driver will take each subnode which contains a 'reg' property as a
DSI peripheral device.  This patch moves the existing MIPI DSI ports into
a new 'ports' node so that the MIPI DSI bus driver may distinguish its
DSI peripheral device(s) from the existing ports.

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v2->v3:
 * Add Philipp's Ack.

v1->v2:
 * Newly added, as suggested by Thierry Reding.

 arch/arm/boot/dts/imx6q.dtsi   | 20 +++++++++++---------
 arch/arm/boot/dts/imx6qdl.dtsi | 23 ++++++++++++++---------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index e9f3646..9c0990b 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -292,19 +292,21 @@
 };
 
 &mipi_dsi {
-	port@2 {
-		reg = <2>;
+	ports {
+		port@2 {
+			reg = <2>;
 
-		mipi_mux_2: endpoint {
-			remote-endpoint = <&ipu2_di0_mipi>;
+			mipi_mux_2: endpoint {
+				remote-endpoint = <&ipu2_di0_mipi>;
+			};
 		};
-	};
 
-	port@3 {
-		reg = <3>;
+		port@3 {
+			reg = <3>;
 
-		mipi_mux_3: endpoint {
-			remote-endpoint = <&ipu2_di1_mipi>;
+			mipi_mux_3: endpoint {
+				remote-endpoint = <&ipu2_di1_mipi>;
+			};
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 9596ed5..96bf2a0 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1009,19 +1009,24 @@
 				reg = <0x021e0000 0x4000>;
 				status = "disabled";
 
-				port@0 {
-					reg = <0>;
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
 
-					mipi_mux_0: endpoint {
-						remote-endpoint = <&ipu1_di0_mipi>;
+						mipi_mux_0: endpoint {
+							remote-endpoint = <&ipu1_di0_mipi>;
+						};
 					};
-				};
 
-				port@1 {
-					reg = <1>;
+					port@1 {
+						reg = <1>;
 
-					mipi_mux_1: endpoint {
-						remote-endpoint = <&ipu1_di1_mipi>;
+						mipi_mux_1: endpoint {
+							remote-endpoint = <&ipu1_di1_mipi>;
+						};
 					};
 				};
 			};
-- 
2.1.0

