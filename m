Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaKMEgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 23:36:16 -0500
Received: from mail-db3on0114.outbound.protection.outlook.com ([157.55.234.114]:6667
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753123AbaKMEgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 23:36:14 -0500
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <shawn.guo@linaro.org>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [RESEND PATCH V2 1/2] ARM: dts: vf-colibri: Add I2C support
Date: Thu, 13 Nov 2014 10:05:31 +0530
Message-ID: <cd1efeb312d35f45fee426ab3783beff7af4d327.1415852425.git.bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1415852424.git.bhuvanchandra.dv@toradex.com>
References: <cover.1415852424.git.bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: SINPR01CA0015.apcprd01.prod.exchangelabs.com
 (10.141.109.15) To DB3PR05MB266.eurprd05.prod.outlook.com (10.141.4.23)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DB3PR05MB266;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB3PR05MB266;
X-Forefront-PRVS: 0394259C80
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(979002)(6009001)(199003)(189002)(105586002)(106356001)(46102003)(107046002)(66066001)(229853001)(118296001)(87286001)(47776003)(20776003)(64706001)(2351001)(110136001)(77096003)(33646002)(102836001)(40100003)(31966008)(104166001)(62966003)(77156002)(36756003)(81156004)(122386002)(101416001)(42186005)(99396003)(89996001)(21056001)(93916002)(92726001)(86362001)(92566001)(87976001)(575784001)(95666004)(76176999)(69596002)(19580395003)(48376002)(19580405001)(50986999)(97736003)(120916001)(50466002)(4396001)(88136002)(53416004)(50226001)(217873001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR05MB266;H:trdx.toradex.int;FPR:;MLV:ovrnspm;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=bhuvanchandra.dv@toradex.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB3PR05MB266;
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

