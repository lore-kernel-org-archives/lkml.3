Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaIYJTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:19:32 -0400
Received: from mail-by2on0107.outbound.protection.outlook.com ([207.46.100.107]:38911
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751122AbaIYJTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:19:30 -0400
X-Greylist: delayed 861 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2014 05:19:30 EDT
From: Yuan Yao <yao.yuan@freescale.com>
To: <wsa@the-dreams.de>, <marex@denx.de>
CC: <LW@KARO-electronics.de>, <mark.rutland@arm.com>,
        <fugang.duan@freescale.com>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH v8 2/2] Documentation:add DMA support for freescale i2c driver
Date: Thu, 25 Sep 2014 16:11:29 +0800
Message-ID: <1411632689-31531-3-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1411632689-31531-1-git-send-email-yao.yuan@freescale.com>
References: <1411632689-31531-1-git-send-email-yao.yuan@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(74502003)(81542003)(105606002)(44976005)(83072002)(6806004)(93916002)(229853001)(46102003)(87936001)(107046002)(87286001)(104016003)(79102003)(106466001)(64706001)(19580405001)(85306004)(81342003)(95666004)(68736004)(97736003)(36756003)(31966008)(104166001)(76482002)(92726001)(80022003)(19580395003)(4396001)(20776003)(21056001)(50226001)(90102001)(77156001)(74662003)(89996001)(86362001)(76176999)(84676001)(85852003)(50466002)(10300001)(120916001)(99396003)(62966002)(92566001)(102836001)(77982003)(48376002)(33646002)(50986999)(83322001)(47776003)(88136002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB377;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB377;
X-Forefront-PRVS: 0345CFD558
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yao.yuan@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add i2c dts node properties for eDMA support, them depend on the eDMA driver.

Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
---
 Documentation/devicetree/bindings/i2c/i2c-imx.txt | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-imx.txt b/Documentation/devicetree/bindings/i2c/i2c-imx.txt
index 4a8513e..52d37fd 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-imx.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-imx.txt
@@ -11,6 +11,8 @@ Required properties:
 Optional properties:
 - clock-frequency : Constains desired I2C/HS-I2C bus clock frequency in Hz.
   The absence of the propoerty indicates the default frequency 100 kHz.
+- dmas: A list of two dma specifiers, one for each entry in dma-names.
+- dma-names: should contain "tx" and "rx".
 
 Examples:
 
@@ -26,3 +28,12 @@ i2c@70038000 { /* HS-I2C on i.MX51 */
 	interrupts = <64>;
 	clock-frequency = <400000>;
 };
+
+i2c0: i2c@40066000 { /* i2c0 on vf610 */
+	compatible = "fsl,vf610-i2c";
+	reg = <0x40066000 0x1000>;
+	interrupts =<0 71 0x04>;
+	dmas = <&edma0 0 50>,
+		<&edma0 0 51>;
+	dma-names = "rx","tx";
+};
-- 
1.8.4

