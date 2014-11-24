Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaKXKWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:22:32 -0500
Received: from mail-by2on0140.outbound.protection.outlook.com ([207.46.100.140]:52354
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753245AbaKXKW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:22:29 -0500
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>
CC: <shawn.guo@linaro.org>, <linux-fbdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Xiubo Li" <Li.Xiubo@freescale.com>
Subject: [PATCH 4/4] ARM: ls1021a: dts: Add and enable dt node for dcfb.
Date: Mon, 24 Nov 2014 18:20:54 +0800
Message-ID: <1416824454-28156-5-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1416824454-28156-1-git-send-email-Li.Xiubo@freescale.com>
References: <1416824454-28156-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(92566001)(92726001)(120916001)(20776003)(50986999)(47776003)(64706001)(87286001)(46102003)(86362001)(76176999)(87936001)(84676001)(68736004)(50466002)(48376002)(104166001)(36756003)(44976005)(19580395003)(19580405001)(89996001)(6806004)(102836001)(88136002)(106466001)(105606002)(97736003)(31966008)(95666004)(104016003)(4396001)(50226001)(21056001)(93916002)(99396003)(229853001)(62966003)(107046002)(77156002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0623;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0623;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0623;
X-Forefront-PRVS: 040513D301
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0623;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On LS1021A TWR board, the TFT LCD panel is WQVGA "480x272", and
the bpp is 24.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 arch/arm/boot/dts/ls1021a-twr.dts | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/ls1021a-twr.dts b/arch/arm/boot/dts/ls1021a-twr.dts
index a2c591e..3602286 100644
--- a/arch/arm/boot/dts/ls1021a-twr.dts
+++ b/arch/arm/boot/dts/ls1021a-twr.dts
@@ -58,6 +58,32 @@
 	};
 };
 
+&dcfb {
+	display = <&display>;
+	status = "okay";
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
+				vback-porch = <2>;
+				vfront-porch = <2>;
+				hsync-len = <41>;
+				vsync-len = <4>;
+				hsync-active = <1>;
+				vsync-active = <1>;
+			};
+		};
+	};
+};
+
 &dspi1 {
 	bus-num = <0>;
 	status = "okay";
-- 
2.1.0.27.g96db324

