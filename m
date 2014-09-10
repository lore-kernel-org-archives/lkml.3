Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaIJCh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 22:37:28 -0400
Received: from mail-bl2on0109.outbound.protection.outlook.com ([65.55.169.109]:64544
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751432AbaIJCh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 22:37:26 -0400
X-Greylist: delayed 85692 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 22:37:26 EDT
From: Robin Gong <b38343@freescale.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Frank.Li@freescale.com>
Subject: [PATCH v1] ARM: dts: imx6dl: disable dma support for spi on i.mx6dl
Date: Wed, 10 Sep 2014 09:33:36 +0800
Message-ID: <1410312816-32171-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(189002)(199003)(107046002)(229853001)(47776003)(64706001)(46102001)(4396001)(50226001)(80022001)(76482001)(20776003)(74502001)(83322001)(21056001)(6806004)(74662001)(19580405001)(31966008)(19580395003)(87286001)(68736004)(44976005)(50986999)(79102001)(95666004)(105606002)(81342001)(81542001)(62966002)(99396002)(84676001)(104016003)(77982001)(77156001)(106466001)(85306004)(87936001)(48376002)(88136002)(89996001)(97736003)(575784001)(93916002)(50466002)(90102001)(92726001)(104166001)(85852003)(26826002)(102836001)(36756003)(92566001)(33646002)(83072002)(32563001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB343;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is one weird data in rxfifo after one full rx/tx transfer
done sometimes. It looks a design issue and hard to workaround
totally, so disable dma functhion here. And will re-enable it
once the root cause found.

Signed-off-by: Robin Gong <b38343@freescale.com>
---
 arch/arm/boot/dts/imx6dl.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/imx6dl.dtsi b/arch/arm/boot/dts/imx6dl.dtsi
index b453e0e..e84a1ff 100644
--- a/arch/arm/boot/dts/imx6dl.dtsi
+++ b/arch/arm/boot/dts/imx6dl.dtsi
@@ -102,6 +102,22 @@
 	};
 };
 
+&ecspi1 {
+	dma-names = "", "";
+};
+
+&ecspi2 {
+	dma-names = "", "";
+};
+
+&ecspi3 {
+	dma-names = "", "";
+};
+
+&ecspi4 {
+	dma-names = "", "";
+};
+
 &hdmi {
 	compatible = "fsl,imx6dl-hdmi";
 };
-- 
1.9.1

