Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaLCJRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:17:51 -0500
Received: from mail-bn1bn0103.outbound.protection.outlook.com ([157.56.110.103]:52608
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751285AbaLCJRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:17:45 -0500
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>
CC: <alexander.stein@systec-electronic.com>, <shawn.guo@linaro.org>,
        <linux-fbdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 3/4] ARM: ls1021a: dtsi: Add dt node support for dcfb.
Date: Wed, 3 Dec 2014 17:16:01 +0800
Message-ID: <1417598162-40433-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1417598162-40433-1-git-send-email-Li.Xiubo@freescale.com>
References: <1417598162-40433-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(199003)(189002)(64706001)(104166001)(47776003)(48376002)(50466002)(20776003)(95666004)(31966008)(229853001)(76176999)(50986999)(104016003)(107046002)(105606002)(106466001)(102836001)(77156002)(62966003)(86362001)(93916002)(92566001)(92726001)(84676001)(97736003)(6806004)(44976005)(19580395003)(19580405001)(50226001)(4396001)(21056001)(77096005)(68736005)(87936001)(88136002)(89996001)(120916001)(99396003)(46102003)(87286001)(36756003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0618;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0618;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0618;
X-Forefront-PRVS: 0414DF926F
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0618;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On LS1021A SoC, the dcfb device is in BE mode.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 arch/arm/boot/dts/ls1021a.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/ls1021a.dtsi b/arch/arm/boot/dts/ls1021a.dtsi
index c70bb27..740a04e 100644
--- a/arch/arm/boot/dts/ls1021a.dtsi
+++ b/arch/arm/boot/dts/ls1021a.dtsi
@@ -383,6 +383,16 @@
 				 <&platform_clk 1>;
 		};
 
+		dcfb: dcfb@2ce0000 {
+			compatible = "fsl,ls1021a-dcfb";
+			reg = <0x0 0x2ce0000 0x0 0x10000>;
+			clocks = <&platform_clk 0>;
+			clock-names = "dcfb";
+			scfg-controller = <&scfg>;
+			big-endian;
+			status = "disabled";
+		};
+
 		mdio0: mdio@2d24000 {
 			compatible = "gianfar";
 			device_type = "mdio";
-- 
2.1.0.27.g96db324

