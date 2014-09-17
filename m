Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbaIQIdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:33:21 -0400
Received: from mail-am1on0132.outbound.protection.outlook.com ([157.56.112.132]:23584
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754119AbaIQIdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:33:20 -0400
X-Greylist: delayed 851 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Sep 2014 04:33:19 EDT
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <shawn.guo@freescale.com>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH 1/3] ARM: dts: vf610: Add PWM second instance
Date: Wed, 17 Sep 2014 13:46:28 +0530
Message-ID: <8adbc5d8df9f559c434a486fd9e8143e1d537aaf.1410930820.git.bhuvanchandra.dv@toradex.com>
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
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(48376002)(93916002)(50986999)(19580405001)(50466002)(64706001)(76176999)(89996001)(66066001)(83322001)(20776003)(31966008)(62966002)(95666004)(90102001)(92566001)(110136001)(86362001)(47776003)(105586002)(118296001)(85306004)(83072002)(2351001)(77096002)(81156004)(36756003)(97736003)(87286001)(79102003)(19580395003)(77982003)(106356001)(69596002)(21056001)(33646002)(53416004)(74662003)(107046002)(102836001)(101416001)(4396001)(77156001)(88136002)(87976001)(50226001)(229853001)(81342003)(42186005)(85852003)(99396002)(92726001)(76482002)(2371004)(74502003)(46102003)(81542003)(104166001)(80022003)(7059017);DIR:OUT;SFP:1102;SCL:1;SRVR:AMSPR05MB261;H:trdx.toradex.int;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: toradex.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
---
 arch/arm/boot/dts/vf610.dtsi |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 4d2ec32..fb00f13 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -210,6 +210,19 @@
 				status = "disabled";
 			};
 
+			pwm1: pwm@40039000 {
+				compatible = "fsl,vf610-ftm-pwm";
+				#pwm-cells = <3>;
+				reg = <0x40039000 0x1000>;
+				clock-names = "ftm_sys", "ftm_ext",
+					      "ftm_fix", "ftm_cnt_clk_en";
+				clocks = <&clks VF610_CLK_FTM1>,
+					<&clks VF610_CLK_FTM1_EXT_SEL>,
+					<&clks VF610_CLK_FTM1_FIX_SEL>,
+					<&clks VF610_CLK_FTM1_EXT_FIX_EN>;
+				status = "disabled";
+			};
+
 			adc0: adc@4003b000 {
 				compatible = "fsl,vf610-adc";
 				reg = <0x4003b000 0x1000>;
-- 
1.7.9.5

