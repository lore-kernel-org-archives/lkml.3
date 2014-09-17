Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaIQIgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:36:06 -0400
Received: from mail-am1on0130.outbound.protection.outlook.com ([157.56.112.130]:48748
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751852AbaIQIgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:36:05 -0400
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <shawn.guo@freescale.com>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH 2/3] ARM: dts: vf610-colibri: Add PWM support
Date: Wed, 17 Sep 2014 13:46:29 +0530
Message-ID: <819bd3bc9541ca53f005b7cf95bc890f1a9215e5.1410930820.git.bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1410930820.git.bhuvanchandra.dv@toradex.com>
References: <cover.1410930820.git.bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: BY2PR04CA059.namprd04.prod.outlook.com (10.141.249.177) To
 AMSPR05MB261.eurprd05.prod.outlook.com (10.242.95.18)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0337AFFE9A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(48376002)(93916002)(50986999)(19580405001)(50466002)(64706001)(76176999)(89996001)(66066001)(83322001)(20776003)(31966008)(62966002)(95666004)(90102001)(92566001)(110136001)(86362001)(47776003)(105586002)(118296001)(85306004)(83072002)(2351001)(77096002)(81156004)(36756003)(97736003)(87286001)(79102003)(19580395003)(77982003)(106356001)(69596002)(21056001)(33646002)(53416004)(74662003)(107046002)(102836001)(101416001)(4396001)(77156001)(88136002)(87976001)(50226001)(229853001)(81342003)(575784001)(42186005)(85852003)(99396002)(92726001)(76482002)(2371004)(74502003)(46102003)(81542003)(104166001)(80022003)(7059017)(473944003)(414714003);DIR:OUT;SFP:1102;SCL:1;SRVR:AMSPR05MB261;H:trdx.toradex.int;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
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
 arch/arm/boot/dts/vf610-colibri.dtsi        |   25 +++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
index 7fb3066..ba98039 100644
--- a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
+++ b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
@@ -44,3 +44,11 @@
 &uart2 {
 	status = "okay";
 };
+
+&pwm0 {
+	status = "okay";
+};
+
+&pwm1 {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
index 0cd8343..9bd1415 100644
--- a/arch/arm/boot/dts/vf610-colibri.dtsi
+++ b/arch/arm/boot/dts/vf610-colibri.dtsi
@@ -69,6 +69,16 @@
 	status = "okay";
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
 &iomuxc {
 	vf610-colibri {
 		pinctrl_esdhc1: esdhc1grp {
@@ -119,5 +129,20 @@
 				VF610_PAD_PTD3__UART2_CTS		0x21a1
 			>;
 		};
+
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
 	};
 };
-- 
1.7.9.5

