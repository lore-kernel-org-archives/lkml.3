Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaDDDYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:24:38 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:42749 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbaDDDYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:24:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: Yuan Yao <yao.yuan@freescale.com>
To: <wsa@the-dreams.de>, <marex@denx.de>
CC: <mark.rutland@arm.com>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH v4 2/2] Documentation:add DMA support for freescale i2c driver
Date: Fri, 4 Apr 2014 10:41:12 +0800
Message-ID: <1396579272-19542-3-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1396579272-19542-1-git-send-email-yao.yuan@freescale.com>
References: <1396579272-19542-1-git-send-email-yao.yuan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
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


