Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaIVKIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:08:49 -0400
Received: from mail-db3on0117.outbound.protection.outlook.com ([157.55.234.117]:62193
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753705AbaIVKIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:08:47 -0400
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <shawn.guo@freescale.com>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH v3 1/2] ARM: dts: vf610-colibri: Add PWM support
Date: Mon, 22 Sep 2014 15:38:11 +0530
Message-ID: <d508a6ad39e07d5489c4b5110784902ab0241c44.1411378369.git.bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1411378369.git.bhuvanchandra.dv@toradex.com>
References: <cover.1411378369.git.bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: DM2PR10CA0060.namprd10.prod.outlook.com (10.141.241.28) To
 AMSPR05MB262.eurprd05.prod.outlook.com (10.242.95.19)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:AMSPR05MB262;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(102836001)(229853001)(118296001)(2351001)(89996001)(95666004)(42186005)(90102001)(33646002)(101416001)(20776003)(92726001)(92566001)(107046002)(105586002)(76176999)(21056001)(81156004)(97736003)(104166001)(62966002)(120916001)(76482002)(50226001)(4396001)(106356001)(575784001)(53416004)(36756003)(64706001)(88136002)(80022003)(79102003)(77096002)(74502003)(74662003)(46102003)(99396002)(50986999)(83072002)(50466002)(81542003)(81342003)(110136001)(77982003)(77156001)(19580405001)(48376002)(66066001)(86362001)(2371004)(87976001)(85852003)(31966008)(47776003)(93916002)(19580395003)(87286001)(85306004)(83322001)(69596002)(7059019)(473944003)(414714003);DIR:OUT;SFP:1102;SCL:1;SRVR:AMSPR05MB262;H:trdx.toradex.int;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: toradex.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Colibri standard defines four pins as PWM outputs, two of them (PWM
A and C) are routed to FTM instance 0 and the other two (PWM B and D)
are routed to FTM instance 1. Hence enable both FTM instances for the
Colibri module and mux the four pins accordingly.

Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
---
 arch/arm/boot/dts/vf610-colibri-eval-v3.dts |    8 ++++++++
 arch/arm/boot/dts/vf610-colibri.dtsi        |   24 ++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
index 7fb3066..00f63d9 100644
--- a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
+++ b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
@@ -33,6 +33,14 @@
 	status = "okay";
 };
 
+&pwm0 {
+	status = "okay";
+};
+
+&pwm1 {
+	status = "okay";
+};
+
 &uart0 {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
index 0cd8343..1f73c1c 100644
--- a/arch/arm/boot/dts/vf610-colibri.dtsi
+++ b/arch/arm/boot/dts/vf610-colibri.dtsi
@@ -44,6 +44,16 @@
 	arm,tag-latency = <3 2 3>;
 };
 
+&pwm0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_pwm0>;
+};
+
+&pwm1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_pwm1>;
+};
+
 &uart0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart0>;
@@ -97,6 +107,20 @@
 			>;
 		};
 
+		pinctrl_pwm0: pwm0grp {
+			fsl,pins = <
+				VF610_PAD_PTB0__FTM0_CH0		0x1182
+				VF610_PAD_PTB1__FTM0_CH1		0x1182
+			>;
+		};
+
+		pinctrl_pwm1: pwm1grp {
+			fsl,pins = <
+				VF610_PAD_PTB8__FTM1_CH0		0x1182
+				VF610_PAD_PTB9__FTM1_CH1		0x1182
+			>;
+		};
+
 		pinctrl_uart0: uart0grp {
 			fsl,pins = <
 				VF610_PAD_PTB10__UART0_TX		0x21a2
-- 
1.7.9.5

