Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbaJATMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:12:07 -0400
Received: from mail-bn1bon0075.outbound.protection.outlook.com ([157.56.111.75]:38314
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751283AbaJATME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:12:04 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v4 1/4] hwmon: ltc2978: device tree bindings documentation
Date: Wed, 1 Oct 2014 14:05:47 -0500
Message-ID: <1412190349-16343-2-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412190349-16343-1-git-send-email-atull@opensource.altera.com>
References: <1412190349-16343-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0022.namprd02.prod.outlook.com (10.141.56.22) To
 DM2PR03MB318.namprd03.prod.outlook.com (10.141.54.17)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB318;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(4396001)(20776003)(64706001)(47776003)(88136002)(80022003)(85852003)(50466002)(50226001)(48376002)(77156001)(33646002)(229853001)(107046002)(66066001)(87976001)(87286001)(76482002)(89996001)(42186005)(105586002)(81156004)(69596002)(106356001)(102836001)(53416004)(99396003)(86362001)(120916001)(85306004)(86152002)(62966002)(92726001)(92566001)(10300001)(21056001)(93916002)(101416001)(97736003)(77096002)(50986999)(46102003)(19580405001)(95666004)(31966008)(76176999)(104166001)(19580395003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB318;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Add device tree bindings documentation for ltc2978.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
 .../devicetree/bindings/hwmon/ltc2978.txt          |   42 ++++++++++++++++++++
 1 file changed, 42 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwmon/ltc2978.txt

diff --git a/Documentation/devicetree/bindings/hwmon/ltc2978.txt b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
new file mode 100644
index 0000000..60fadc2
--- /dev/null
+++ b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
@@ -0,0 +1,42 @@
+ltc2978
+
+Required properties:
+ - compatible: one of: ltc2974, ltc2977, ltc2978, ltc3880, ltc3883, ltm4676
+ - reg: I2C address
+
+Optional properties:
+ Name of the optional regulator subnode must be "regulators".
+  - #address-cells must be 1.
+  - #size-cells must be 0.
+
+ For each regulator:
+  - reg: regulator number
+  - regulator-compatible: must be vout_en<regulator number> such as vout_en3
+    valid range is:
+      ltc2977, ltc2978 : vout_en0 - vout_en7
+      ltc2974          : vout_en0 - vout_en3
+      ltc3880, ltm4676 : vout_en0 - vout_en1
+      ltc3883          : vout_en0 only
+  - regulator-name: arbitrary name for regulator
+
+Example:
+ltc2978@5e {
+	compatible = "ltc2978";
+	reg = <0x5e>;
+	regulators {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vdacp0_reg: regulator@0 {
+			reg = <0>;
+			regulator-compatible = "vout_en0";
+			regulator-name = "FPGA-2.5V";
+		};
+		vdacp2_reg: regulator@2 {
+			reg = <2>;
+			regulator-compatible = "vout_en2";
+			regulator-name = "FPGA-1.5V";
+		};
+	};
+};
+
-- 
1.7.9.5

