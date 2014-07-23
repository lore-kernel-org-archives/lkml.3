Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752AbaGWJMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:12:37 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:12103
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757527AbaGWJMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:12:05 -0400
From: Yuan Yao <yao.yuan@freescale.com>
To: <wsa@the-dreams.de>, <marex@denx.de>
CC: <mark.rutland@arm.com>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH v5 2/2] Documentation:add DMA support for freescale i2c driver
Date: Wed, 23 Jul 2014 16:24:43 +0800
Message-ID: <1406103883-3572-3-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1406103883-3572-1-git-send-email-yao.yuan@freescale.com>
References: <1406103883-3572-1-git-send-email-yao.yuan@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(77982001)(80022001)(86362001)(81542001)(47776003)(81156004)(92566001)(46102001)(95666004)(105606002)(85306003)(64706001)(106466001)(74502001)(229853001)(20776003)(74662001)(93916002)(31966008)(50226001)(76176999)(85852003)(48376002)(83072002)(33646002)(4396001)(79102001)(69596002)(36756003)(77156001)(107046002)(6806004)(19580395003)(83322001)(44976005)(19580405001)(102836001)(104166001)(84676001)(50986999)(88136002)(89996001)(99396002)(81342001)(92726001)(68736004)(76482001)(87936001)(104016003)(87286001)(50466002)(62966002)(97736001)(21056001)(26826002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB573;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yao.yuan@freescale.com; 
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

