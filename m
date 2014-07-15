Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaGOEgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 00:36:50 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:22869
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750972AbaGOEgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 00:36:47 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <mark.rutland@arm.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv5 2/2] dt/bindings: Add the DT binding documentation for endianness
Date: Tue, 15 Jul 2014 12:18:24 +0800
Message-ID: <1405397904-31202-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1405397904-31202-1-git-send-email-Li.Xiubo@freescale.com>
References: <1405397904-31202-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(6806004)(69596002)(87286001)(88136002)(87936001)(21056001)(107046002)(36756003)(86362001)(76482001)(83072002)(85852003)(89996001)(77156001)(50466002)(81342001)(48376002)(74502001)(19580395003)(20776003)(26826002)(74662001)(47776003)(79102001)(81542001)(44976005)(68736004)(64706001)(19580405001)(83322001)(76176999)(102836001)(84676001)(80022001)(104016003)(229853001)(4396001)(105606002)(97736001)(85306003)(46102001)(106466001)(81156004)(50226001)(62966002)(93916002)(77982001)(104166001)(92566001)(99396002)(31966008)(92726001)(50986999)(95666004);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0612;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027367F73D
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device-Tree binding for device endianness
Index     Device     Endianness properties
---------------------------------------------------
1         BE         'big-endian'
2         LE         'little-endian'

For one device driver, which will run in different scenarios above
on different SoCs using the devicetree, we need one way to simplify
this.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 .../devicetree/bindings/regmap/regmap.txt          | 48 ++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regmap/regmap.txt

diff --git a/Documentation/devicetree/bindings/regmap/regmap.txt b/Documentation/devicetree/bindings/regmap/regmap.txt
new file mode 100644
index 0000000..cc5f7f8
--- /dev/null
+++ b/Documentation/devicetree/bindings/regmap/regmap.txt
@@ -0,0 +1,48 @@
+Device-Tree binding for device endianness
+
+The endianness mode of CPU & Device scenarios:
+Index    CPU       Device     Endianness properties
+------------------------------------------------------------
+1        LE        LE         -
+2        LE        BE         'big-endian{,-*}'
+3        BE        BE         -
+4        BE        LE         'little-endian{,-*}'
+
+For one device driver, which will run in different scenarios above
+on different SoCs using the devicetree, we need one way to simplify
+this.
+
+Required properties:
+- {big,little}-endian{,-*}: these are boolean properties, if absent
+  meaning that the CPU and the Device are in the same endianness mode.
+
+Examples:
+Scenario 1 : CPU in LE mode & device in LE mode.
+dev: dev@40031000 {
+	      compatible = "name";
+	      reg = <0x40031000 0x1000>;
+	      ...
+};
+
+Scenario 2 : CPU in LE mode & device in BE mode.
+dev: dev@40031000 {
+	      compatible = "name";
+	      reg = <0x40031000 0x1000>;
+	      ...
+	      big-endian{,-*};
+};
+
+Scenario 3 : CPU in BE mode & device in BE mode.
+dev: dev@40031000 {
+	      compatible = "name";
+	      reg = <0x40031000 0x1000>;
+	      ...
+};
+
+Scenario 4 : CPU in BE mode & device in LE mode.
+dev: dev@40031000 {
+	      compatible = "name";
+	      reg = <0x40031000 0x1000>;
+	      ...
+	      little-endian{,-*};
+};
-- 
1.8.5

