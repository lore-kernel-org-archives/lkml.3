Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaIAFV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 01:21:27 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:40022
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752388AbaIAFVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 01:21:24 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <kuninori.morimoto.gx@renesas.com>, <moinejf@free.fr>,
        <andrew@lunn.ch>, <jsarha@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-sh@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <shawn.guo@freescale.com>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv1 5/7] ASoC: dts: r8a7740-armadillo800eva-reference: To support simple card newest style.
Date: Mon, 1 Sep 2014 12:29:39 +0800
Message-ID: <1409545781-20530-6-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(85306004)(50466002)(107046002)(102836001)(81342001)(50226001)(93916002)(26826002)(48376002)(46102001)(80022001)(2201001)(83072002)(92726001)(4396001)(85852003)(81156004)(229853001)(90102001)(104166001)(92566001)(86362001)(89996001)(106466001)(88136002)(74662001)(105606002)(21056001)(104016003)(99396002)(84676001)(79102001)(76482001)(77982001)(76176999)(62966002)(47776003)(83322001)(44976005)(19580395003)(19580405001)(87936001)(64706001)(20776003)(31966008)(74502001)(77156001)(87286001)(50986999)(81542001)(68736004)(97736001)(69596002)(230783001)(6806004)(95666004)(36756003)(1121002)(921003)(2101003)(83996005);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB352;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03218BFD9F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch depends on the following simple card patch:
===
ASoC: simple-card: Merge single and muti DAI link code.

This patch merge single DAI link and muti-DAI links code together,
and simply the simple-card driver code.

And also do some other improvement:

Since from the DAI format micro SND_SOC_DAIFMT_CBx_CFx, the 'CBx'
mean Codec's bit clock is as master/slave and the 'CFx' mean Codec's
frame clock is as master/slave.

So these same DAI formats should be informed to CPU and CODE DAIs at
the same time. For the Codec driver will set the bit clock and frame
clock as the DAI formats said, but for the CPU driver, if the the
bit clock or frame clock is as Codec master, so it should be set CPU
DAI device as bit clock or frame clock as slave, and vice versa.

The old code will cause confusion, and we should be clear that the
letter 'C' here mean to Codec.
===

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 .../boot/dts/r8a7740-armadillo800eva-reference.dts  | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7740-armadillo800eva-reference.dts b/arch/arm/boot/dts/r8a7740-armadillo800eva-reference.dts
index ee9e7d5..b83d95a 100644
--- a/arch/arm/boot/dts/r8a7740-armadillo800eva-reference.dts
+++ b/arch/arm/boot/dts/r8a7740-armadillo800eva-reference.dts
@@ -150,18 +150,19 @@
 	sound {
 		compatible = "simple-audio-card";
 
-		simple-audio-card,format = "i2s";
-
-		simple-audio-card,cpu {
-			sound-dai = <&sh_fsi2 0>;
-			bitclock-inversion;
-		};
-
-		simple-audio-card,codec {
-			sound-dai = <&wm8978>;
+		simple-audio-card,dai-link {
+			format = "i2s";
 			bitclock-master;
 			frame-master;
-			system-clock-frequency = <12288000>;
+
+			cpu {
+				sound-dai = <&sh_fsi2 0>;
+				bitclock-inversion;
+			};
+			codec {
+				sound-dai = <&wm8978>;
+				system-clock-frequency = <12288000>;
+			};
 		};
 	};
 };
-- 
1.8.4

