Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaKXKiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:38:18 -0500
Received: from mail-bn1bn0108.outbound.protection.outlook.com ([157.56.110.108]:10064
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751179AbaKXKiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:38:16 -0500
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>
CC: <shawn.guo@linaro.org>, <linux-fbdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Xiubo Li" <Li.Xiubo@freescale.com>
Subject: [PATCH 3/4] ARM: ls1021a: dtsi: Add dt node support for dcfb.
Date: Mon, 24 Nov 2014 18:20:53 +0800
Message-ID: <1416824454-28156-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1416824454-28156-1-git-send-email-Li.Xiubo@freescale.com>
References: <1416824454-28156-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(85426001)(88136002)(87936001)(20776003)(84676001)(68736004)(46102003)(4396001)(19580405001)(19580395003)(44976005)(76176999)(50226001)(6806004)(92726001)(92566001)(97736003)(99396003)(120916001)(104166001)(48376002)(64706001)(102836001)(104016003)(87286001)(31966008)(50466002)(47776003)(89996001)(95666004)(62966003)(77156002)(105606002)(50986999)(21056001)(106466001)(36756003)(86362001)(93916002)(229853001)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
X-Forefront-PRVS: 040513D301
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
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

