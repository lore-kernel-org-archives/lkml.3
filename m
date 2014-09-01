Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbaIAFVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 01:21:23 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:7158
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752341AbaIAFVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 01:21:21 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <kuninori.morimoto.gx@renesas.com>, <moinejf@free.fr>,
        <andrew@lunn.ch>, <jsarha@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-sh@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <shawn.guo@freescale.com>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv1 4/7] ASoC: dts: kirkwood-t5325: To support simple card newest style.
Date: Mon, 1 Sep 2014 12:29:38 +0800
Message-ID: <1409545781-20530-5-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(80022001)(575784001)(92566001)(86362001)(47776003)(20776003)(84676001)(87286001)(64706001)(88136002)(89996001)(85306004)(97736001)(90102001)(87936001)(2201001)(21056001)(62966002)(77156001)(85852003)(83072002)(36756003)(26826002)(93916002)(92726001)(104016003)(102836001)(79102001)(104166001)(50986999)(81342001)(46102001)(76176999)(99396002)(50466002)(48376002)(6806004)(44976005)(4396001)(50226001)(83322001)(19580405001)(19580395003)(68736004)(69596002)(107046002)(106466001)(77982001)(74502001)(76482001)(81542001)(31966008)(74662001)(229853001)(81156004)(95666004)(105606002)(1121002)(921003)(2101003)(83996005);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0623;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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
 arch/arm/boot/dts/kirkwood-t5325.dts | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-t5325.dts b/arch/arm/boot/dts/kirkwood-t5325.dts
index 610ec0f..25d1223 100644
--- a/arch/arm/boot/dts/kirkwood-t5325.dts
+++ b/arch/arm/boot/dts/kirkwood-t5325.dts
@@ -189,7 +189,6 @@
 
 	sound {
 		compatible = "simple-audio-card";
-		simple-audio-card,format = "i2s";
 		simple-audio-card,routing =
 			"Headphone Jack", "HPL",
 			"Headphone Jack", "HPR",
@@ -204,12 +203,14 @@
 
 		simple-audio-card,mclk-fs = <256>;
 
-		simple-audio-card,cpu {
-			sound-dai = <&audio>;
-		};
-
-		simple-audio-card,codec {
-			sound-dai = <&alc5621>;
+		simple-audio-card,dai-link {
+			format = "i2s";
+			cpu {
+				sound-dai = <&audio>;
+			};
+			codec {
+				sound-dai = <&alc5621>;
+			};
 		};
 	};
 };
-- 
1.8.4

