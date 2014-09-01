Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaIAFVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 01:21:20 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:28113
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752297AbaIAFVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 01:21:16 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <kuninori.morimoto.gx@renesas.com>, <moinejf@free.fr>,
        <andrew@lunn.ch>, <jsarha@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-sh@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <shawn.guo@freescale.com>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv1 3/7] ASoC: dts: vf610-twr: To support simple card newest style.
Date: Mon, 1 Sep 2014 12:29:37 +0800
Message-ID: <1409545781-20530-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(77982001)(77156001)(79102001)(76482001)(2201001)(80022001)(64706001)(20776003)(26826002)(4396001)(90102001)(95666004)(50226001)(83072002)(87936001)(81342001)(97736001)(102836001)(85306004)(89996001)(21056001)(92566001)(36756003)(104166001)(47776003)(93916002)(46102001)(88136002)(85852003)(229853001)(87286001)(50466002)(19580395003)(31966008)(19580405001)(69596002)(105606002)(83322001)(50986999)(104016003)(84676001)(81542001)(107046002)(92726001)(76176999)(106466001)(86362001)(74662001)(68736004)(48376002)(99396002)(6806004)(44976005)(74502001)(62966002)(81156004)(921003)(1121002)(83996005)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0301MB0618;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
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
 arch/arm/boot/dts/vf610-twr.dts | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-twr.dts
index b8a5e8c..841a45a 100644
--- a/arch/arm/boot/dts/vf610-twr.dts
+++ b/arch/arm/boot/dts/vf610-twr.dts
@@ -61,7 +61,6 @@
 
 	sound {
 		compatible = "simple-audio-card";
-		simple-audio-card,format = "i2s";
 		simple-audio-card,widgets =
 			"Microphone", "Microphone Jack",
 			"Headphone", "Headphone Jack",
@@ -74,17 +73,17 @@
 			"Headphone Jack", "HP_OUT",
 			"Speaker Ext", "LINE_OUT";
 
-		simple-audio-card,cpu {
-			sound-dai = <&sai2>;
-			master-clkdir-out;
+		simple-audio-card,dai-link {
+			format = "i2s";
 			frame-master;
 			bitclock-master;
-		};
 
-		simple-audio-card,codec {
-			sound-dai = <&codec>;
-			frame-master;
-			bitclock-master;
+			cpu {
+				sound-dai = <&sai2>;
+			};
+			codec {
+				sound-dai = <&codec>;
+			};
 		};
 	};
 };
-- 
1.8.4

