Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaIAFVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 01:21:36 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:23048
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752433AbaIAFVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 01:21:33 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <kuninori.morimoto.gx@renesas.com>, <moinejf@free.fr>,
        <andrew@lunn.ch>, <jsarha@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-sh@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <shawn.guo@freescale.com>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv1 7/7] ASoC: dts: kirkwood-openrd-client: To support simple card newest style.
Date: Mon, 1 Sep 2014 12:29:41 +0800
Message-ID: <1409545781-20530-8-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(81342001)(86362001)(77982001)(20776003)(229853001)(105606002)(102836001)(69596002)(19580405001)(83322001)(19580395003)(44976005)(6806004)(87286001)(81542001)(107046002)(230783001)(80022001)(47776003)(68736004)(26826002)(90102001)(84676001)(106466001)(62966002)(79102001)(64706001)(95666004)(21056001)(92726001)(81156004)(97736001)(76482001)(46102001)(31966008)(77156001)(36756003)(74662001)(89996001)(50226001)(48376002)(104016003)(99396002)(50466002)(93916002)(88136002)(2201001)(85306004)(104166001)(92566001)(85852003)(4396001)(50986999)(74502001)(83072002)(76176999)(87936001)(1121002)(921003)(83996005)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB344;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
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
 arch/arm/boot/dts/kirkwood-openrd-client.dts | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-openrd-client.dts b/arch/arm/boot/dts/kirkwood-openrd-client.dts
index 887b9c1..3b6f169 100644
--- a/arch/arm/boot/dts/kirkwood-openrd-client.dts
+++ b/arch/arm/boot/dts/kirkwood-openrd-client.dts
@@ -33,15 +33,16 @@
 
 	sound {
 		compatible = "simple-audio-card";
-		simple-audio-card,format = "i2s";
 		simple-audio-card,mclk-fs = <256>;
 
-		simple-audio-card,cpu {
-			sound-dai = <&audio0>;
-		};
-
-		simple-audio-card,codec {
-			sound-dai = <&cs42l51>;
+		simple-audio-card,dai-link {
+			format = "i2s";
+			cpu {
+				sound-dai = <&audio0>;
+			};
+			codec {
+				sound-dai = <&cs42l51>;
+			};
 		};
 	};
 };
-- 
1.8.4

