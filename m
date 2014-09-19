Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbaISNje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:39:34 -0400
Received: from mail-db3on0147.outbound.protection.outlook.com ([157.55.234.147]:63581
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755848AbaISNjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:39:32 -0400
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <shawn.guo@freescale.com>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH v2 2/2] ARM: dts: vf610-colibri: Add backlight support
Date: Fri, 19 Sep 2014 19:08:52 +0530
Message-ID: <bae435d33cac93fd5f0c763fbe7bb302b52a6f0f.1411130205.git.bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1411130205.git.bhuvanchandra.dv@toradex.com>
References: <cover.1411130205.git.bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: DM2PR10CA0043.namprd10.prod.outlook.com (10.141.241.11) To
 AM3PR05MB257.eurprd05.prod.outlook.com (10.242.249.14)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(76176999)(66066001)(83072002)(50986999)(48376002)(93916002)(69596002)(81342003)(77096002)(77156001)(62966002)(101416001)(88136002)(102836001)(99396002)(36756003)(104166001)(31966008)(19580395003)(50226001)(97736003)(89996001)(46102003)(106356001)(86362001)(2371004)(92566001)(85306004)(74662003)(42186005)(33646002)(87976001)(19580405001)(53416004)(83322001)(21056001)(107046002)(105586002)(85852003)(90102001)(77982003)(118296001)(2351001)(76482002)(4396001)(229853001)(79102003)(80022003)(47776003)(110136001)(95666004)(87286001)(81156004)(81542003)(92726001)(50466002)(74502003)(20776003)(7059019);DIR:OUT;SFP:1102;SCL:1;SRVR:AM3PR05MB257;H:trdx.toradex.int;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: toradex.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
---
 arch/arm/boot/dts/vf610-colibri-eval-v3.dts |    6 ++++++
 arch/arm/boot/dts/vf610-colibri.dtsi        |    6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
index 00f63d9..711cf82 100644
--- a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
+++ b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
@@ -19,6 +19,12 @@
 	};
 };
 
+&bl {
+	brightness-levels = <0 4 8 16 32 64 128 255>;
+	default-brightness-level = <6>;
+	status  = "okay";
+};
+
 &esdhc1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_esdhc1>;
diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
index 560cd69..20b1c15 100644
--- a/arch/arm/boot/dts/vf610-colibri.dtsi
+++ b/arch/arm/boot/dts/vf610-colibri.dtsi
@@ -13,6 +13,12 @@
 	model = "Toradex Colibri VF61 COM";
 	compatible = "toradex,vf610-colibri_vf61", "fsl,vf610";
 
+	bl: backlight {
+		compitable = "pwm-backlight";
+		pwms = <&pwm0 0 5000000 0>;
+		status = "disabled";
+	};
+
 	clocks {
 		enet_ext {
 			compatible = "fixed-clock";
-- 
1.7.9.5

