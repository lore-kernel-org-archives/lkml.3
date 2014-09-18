Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbaIRH1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 03:27:51 -0400
Received: from mail-bl2on0147.outbound.protection.outlook.com ([65.55.169.147]:56715
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751149AbaIRH1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 03:27:50 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <B29396@freescale.com>, <pankaj.dubey@samsung.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <devicetree@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] mfd: syscon: binding: Add syscon endianness support.
Date: Thu, 18 Sep 2014 15:27:29 +0800
Message-ID: <1411025249-34333-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(47776003)(64706001)(19580395003)(83322001)(19580405001)(44976005)(6806004)(20776003)(97736003)(26826002)(68736004)(21056001)(87286001)(84676001)(104016003)(104166001)(79102003)(81542003)(74662003)(85306004)(102836001)(90102001)(229853001)(76482002)(107046002)(74502003)(46102003)(81342003)(80022003)(77982003)(95666004)(106466001)(105606002)(99396002)(4396001)(50226001)(48376002)(62966002)(50466002)(92726001)(92566001)(2201001)(86362001)(50986999)(87936001)(85852003)(89996001)(93916002)(83072002)(88136002)(36756003)(31966008)(77156001)(1121002)(921003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB323;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For many drivers which will support rich endianness of Devices
need define DT properties by itself with the binding support.

The regmap core has already support endianness of the following
case:
Index      Device     DT properties needed
------------------------------------------
1          BE         'big-endian'
2          LE         'little-endian'

Please see the regmap binding for more detail information of
the endianness support.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---


This patch hasn't any dependency with Pankaj Dubey's:
    mfd: syscon: Decouple syscon interface from platform devices



 Documentation/devicetree/bindings/mfd/syscon.txt | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/syscon.txt b/Documentation/devicetree/bindings/mfd/syscon.txt
index fe8150b..7c33178 100644
--- a/Documentation/devicetree/bindings/mfd/syscon.txt
+++ b/Documentation/devicetree/bindings/mfd/syscon.txt
@@ -10,11 +10,22 @@ OS driver) to determine the location of the registers, and access the
 registers directly.
 
 Required properties:
-- compatible: Should contain "syscon".
-- reg: the register region can be accessed from syscon
+- compatible:		Should contain "syscon".
+- reg:			The register region can be accessed from syscon
 
-Examples:
+Optional property:
+- {big,little}-endian:	Boolean property. Please see ../regmap/regmap.txt
+			for more information.
+
+Example 1:
 gpr: iomuxc-gpr@020e0000 {
 	compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
 	reg = <0x020e0000 0x38>;
 };
+
+Example 2:
+dcfg: dcfg@1ee0000 {
+	compatible = "fsl,ls1021a-dcfg", "syscon";
+	reg = <0x0 0x1ee0000 0x0 0x10000>;
+	big-endian;
+};
-- 
2.1.0.27.g96db324

