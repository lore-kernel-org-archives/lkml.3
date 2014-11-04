Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaKDLmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:42:03 -0500
Received: from mail-db3on0119.outbound.protection.outlook.com ([157.55.234.119]:8672
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753269AbaKDLl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:41:58 -0500
X-Greylist: delayed 1074 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2014 06:41:54 EST
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <shawn.guo@freescale.com>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH 1/2] ARM: dts: vf-colibri: Add I2C support
Date: Tue, 4 Nov 2014 16:52:09 +0530
Message-ID: <d5e07584708523262df69f5a4dec10609f77baa3.1415099486.git.bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1415099486.git.bhuvanchandra.dv@toradex.com>
References: <cover.1415099486.git.bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: DM2PR04CA052.namprd04.prod.outlook.com (10.141.154.170) To
 AM3PR05MB259.eurprd05.prod.outlook.com (10.242.249.26)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:AM3PR05MB259;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03853D523D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(102836001)(48376002)(42186005)(21056001)(104166001)(92726001)(118296001)(89996001)(33646002)(92566001)(87286001)(87976001)(101416001)(50466002)(97736003)(36756003)(19580395003)(19580405001)(4396001)(2371004)(50226001)(69596002)(93916002)(88136002)(31966008)(107046002)(106356001)(229853001)(66066001)(40100003)(53416004)(50986999)(122386002)(77096003)(76176999)(62966003)(110136001)(105586002)(120916001)(46102003)(47776003)(77156002)(575784001)(86362001)(64706001)(20776003)(2351001)(99396003)(95666004)(7059028);DIR:OUT;SFP:1102;SCL:1;SRVR:AM3PR05MB259;H:trdx.toradex.int;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: toradex.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
---
 arch/arm/boot/dts/vf-colibri-eval-v3.dtsi |    7 ++++++-
 arch/arm/boot/dts/vf-colibri.dtsi         |   13 +++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
index 80e8fbc..0251e6c 100644
--- a/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
+++ b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
@@ -33,6 +33,11 @@
 	status = "okay";
 };
 
+&i2c0 {
+	clock-frequency = <400000>;
+	status = "okay";
+};
+
 &pwm0 {
 	status = "okay";
 };
@@ -51,4 +56,4 @@
 
 &uart2 {
 	status = "okay";
-};
\ No newline at end of file
+};
diff --git a/arch/arm/boot/dts/vf-colibri.dtsi b/arch/arm/boot/dts/vf-colibri.dtsi
index ab40367..471eec0 100644
--- a/arch/arm/boot/dts/vf-colibri.dtsi
+++ b/arch/arm/boot/dts/vf-colibri.dtsi
@@ -39,6 +39,12 @@
 	pinctrl-0 = <&pinctrl_fec1>;
 };
 
+&i2c0 {
+	clock-frequency = <400000>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_i2c0>;
+};
+
 &pwm0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_pwm0>;
@@ -102,6 +108,13 @@
 			>;
 		};
 
+		pinctrl_i2c0: i2c0grp {
+			fsl,pins = <
+				VF610_PAD_PTB14__I2C0_SCL		0x37ff
+				VF610_PAD_PTB15__I2C0_SDA		0x37ff
+			>;
+		};
+
 		pinctrl_pwm0: pwm0grp {
 			fsl,pins = <
 				VF610_PAD_PTB0__FTM0_CH0		0x1182
-- 
1.7.9.5

