Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaCaIJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 04:09:32 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:55756
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753221AbaCaIJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 04:09:27 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 1/2] regmap: Add the DT binding documentation for endianness
Date: Mon, 31 Mar 2014 15:26:36 +0800
Message-ID: <1396250797-17758-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1396250797-17758-1-git-send-email-Li.Xiubo@freescale.com>
References: <1396250797-17758-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 .../bindings/regmap/regmap-endianness.txt          | 49 ++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regmap/regmap-endianness.txt

diff --git a/Documentation/devicetree/bindings/regmap/regmap-endianness.txt b/Documentation/devicetree/bindings/regmap/regmap-endianness.txt
new file mode 100644
index 0000000..045d347
--- /dev/null
+++ b/Documentation/devicetree/bindings/regmap/regmap-endianness.txt
@@ -0,0 +1,49 @@
+Device-Tree bindings for regmap endianness
+
+Required properties:
+- reg-endian: Register endianness, this string property could be absent
+  as default endianness, or must be one of 'BE', 'LE' and 'NT'.
+- val-endian: Value endianness, this string property could be absent as
+  default endianness, or must be one of 'BE', 'LE' and 'NT'.
+
+The Endianness flags supported by regmap:
+
+DT properties           Macros
+----------------------------------------
+    'LE'          REGMAP_ENDIAN_LITTLE
+    'BE'          REGMAP_ENDIAN_BIG
+    'NT'          REGMAP_ENDIAN_NATIVE
+    Absent        REGMAP_ENDIAN_DEFAULT
+
+Examples:
+Case 1 : CPU in LE mode & SAI device in BE mode, using mmio.
+sai2: sai@40031000 {
+	      compatible = "fsl,vf610-sai";
+	      reg = <0x40031000 0x1000>;
+	      ...
+	      val-endian = 'BE';
+};
+
+Case 2 : CPU in BE mode & SAI device in LE mode, using mmio.
+sai2: sai@40031000 {
+	      compatible = "fsl,vf610-sai";
+	      reg = <0x40031000 0x1000>;
+	      ...
+	      val-endian = 'LE';
+};
+
+Case 3 : CPU in LE mode & SAI device in LE mode, using mmio.
+sai2: sai@40031000 {
+	      compatible = "fsl,vf610-sai";
+	      reg = <0x40031000 0x1000>;
+	      ...
+	      val-endian = 'NT'; or just absent.
+};
+
+Case 4 : CPU in BE mode & SAI device in BE mode, using mmio.
+sai2: sai@40031000 {
+	      compatible = "fsl,vf610-sai";
+	      reg = <0x40031000 0x1000>;
+	      ...
+	      val-endian = 'NT'; or just absent.
+};
-- 
1.8.4


