Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaGOE0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 00:26:55 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:17848
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750971AbaGOE0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 00:26:51 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <mark.rutland@arm.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv6 2/2] dt/bindings: Add the DT binding documentation for endianness
Date: Tue, 15 Jul 2014 12:23:03 +0800
Message-ID: <1405398183-31345-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1405398183-31345-1-git-send-email-Li.Xiubo@freescale.com>
References: <1405398183-31345-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(97736001)(87936001)(74662001)(4396001)(31966008)(76176999)(81542001)(107046002)(79102001)(81342001)(77156001)(104166001)(36756003)(95666004)(81156004)(74502001)(50466002)(77982001)(6806004)(106466001)(85852003)(99396002)(50986999)(104016003)(21056001)(48376002)(84676001)(19580395003)(88136002)(83072002)(92726001)(229853001)(62966002)(93916002)(87286001)(102836001)(89996001)(44976005)(20776003)(105606002)(26826002)(83322001)(80022001)(86362001)(92566001)(46102001)(69596002)(19580405001)(50226001)(85306003)(47776003)(68736004)(64706001)(76482001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0613;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
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
 .../devicetree/bindings/regmap/regmap.txt          | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regmap/regmap.txt

diff --git a/Documentation/devicetree/bindings/regmap/regmap.txt b/Documentation/devicetree/bindings/regmap/regmap.txt
new file mode 100644
index 0000000..b494f8b
--- /dev/null
+++ b/Documentation/devicetree/bindings/regmap/regmap.txt
@@ -0,0 +1,47 @@
+Device-Tree binding for regmap
+
+The endianness mode of CPU & Device scenarios:
+Index     Device     Endianness properties
+---------------------------------------------------
+1         BE         'big-endian'
+2         LE         'little-endian'
+
+For one device driver, which will run in different scenarios above
+on different SoCs using the devicetree, we need one way to simplify
+this.
+
+Required properties:
+- {big,little}-endian: these are boolean properties, if absent
+  meaning that the CPU and the Device are in the same endianness mode,
+  these properties are for register values and all the buffers only.
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
+	      big-endian;
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
+	      little-endian;
+};
-- 
1.8.5

