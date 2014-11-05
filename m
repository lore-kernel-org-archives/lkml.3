Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaKEKV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:21:26 -0500
Received: from mail-am1on0134.outbound.protection.outlook.com ([157.56.112.134]:43904
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751396AbaKEKVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:21:23 -0500
X-Greylist: delayed 851 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Nov 2014 05:21:22 EST
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <shawn.guo@freescale.com>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH V2 1/2] ARM: dts: vf-colibri: Add I2C support
Date: Wed, 5 Nov 2014 15:35:07 +0530
Message-ID: <cd1efeb312d35f45fee426ab3783beff7af4d327.1415181422.git.bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1415181422.git.bhuvanchandra.dv@toradex.com>
References: <cover.1415181422.git.bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: HKXPR03CA0022.apcprd03.prod.outlook.com (10.141.129.12) To
 DB3PR05MB266.eurprd05.prod.outlook.com (10.141.4.23)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DB3PR05MB266;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(88136002)(2371004)(93916002)(86362001)(575784001)(118296001)(97736003)(19580405001)(69596002)(19580395003)(50226001)(4396001)(31966008)(122386002)(50466002)(48376002)(21056001)(92566001)(46102003)(36756003)(107046002)(40100003)(62966003)(77096003)(77156002)(42186005)(102836001)(105586002)(104166001)(95666004)(81156004)(229853001)(53416004)(106356001)(101416001)(92726001)(89996001)(87286001)(2351001)(50986999)(87976001)(64706001)(47776003)(66066001)(120916001)(110136001)(99396003)(20776003)(76176999)(33646002)(7059028);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR05MB266;H:trdx.toradex.int;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: toradex.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
---
 arch/arm/boot/dts/vf-colibri-eval-v3.dtsi |    6 +++++-
 arch/arm/boot/dts/vf-colibri.dtsi         |   13 +++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
index 80e8fbc..7324bdc 100644
--- a/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
+++ b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
@@ -33,6 +33,10 @@
 	status = "okay";
 };
 
+&i2c0 {
+	status = "okay";
+};
+
 &pwm0 {
 	status = "okay";
 };
@@ -51,4 +55,4 @@
 
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

