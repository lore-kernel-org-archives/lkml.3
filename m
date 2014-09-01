Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaIAFVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 01:21:49 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:20266
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752187AbaIAFVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 01:21:46 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <kuninori.morimoto.gx@renesas.com>, <moinejf@free.fr>,
        <andrew@lunn.ch>, <jsarha@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-sh@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <shawn.guo@freescale.com>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv1 6/7] ASoC: dts: sh73a0-kzm9g-reference: To support simple card newest style.
Date: Mon, 1 Sep 2014 12:29:40 +0800
Message-ID: <1409545781-20530-7-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(90102001)(81542001)(97736001)(81342001)(229853001)(80022001)(86362001)(64706001)(62966002)(36756003)(77156001)(106466001)(104166001)(81156004)(105606002)(77982001)(47776003)(107046002)(95666004)(46102001)(19580395003)(93916002)(87936001)(74662001)(230783001)(20776003)(102836001)(83072002)(85852003)(92566001)(92726001)(2201001)(83322001)(48376002)(50466002)(99396002)(50986999)(4396001)(76176999)(31966008)(26826002)(88136002)(85306004)(89996001)(74502001)(104016003)(50226001)(6806004)(19580405001)(76482001)(79102001)(44976005)(84676001)(87286001)(21056001)(68736004)(69596002)(1121002)(921003)(83996005)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB337;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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
 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts b/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts
index 18662ae..e689ae3 100644
--- a/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts
+++ b/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts
@@ -160,15 +160,19 @@
 
 	sound {
 		compatible = "simple-audio-card";
-		simple-audio-card,format = "left_j";
-		simple-audio-card,cpu {
-			sound-dai = <&sh_fsi2 0>;
-		};
-		simple-audio-card,codec {
-			sound-dai = <&ak4648>;
+
+		simple-audio-card,dai-link {
+			format = "left_j";
 			bitclock-master;
 			frame-master;
-			system-clock-frequency = <11289600>;
+
+			cpu {
+				sound-dai = <&sh_fsi2 0>;
+			};
+			codec {
+				sound-dai = <&ak4648>;
+				system-clock-frequency = <11289600>;
+			};
 		};
 	};
 };
-- 
1.8.4

