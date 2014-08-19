Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbaHSSkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:40:10 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:7078
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753239AbaHSSkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:40:07 -0400
From: <atull@opensource.altera.com>
To: <wsa@the-dreams.de>, <baruch@tkos.co.il>,
        <mika.westerberg@linux.intel.com>
CC: <grant.likely@linaro.org>, <robh+dt@kernel.org>, <skuribay@pobox.com>,
        <Romain.Baeriswyl@abilis.com>, <rafael.j.wysocki@intel.com>,
        <alan@linux.intel.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH 1/2] i2c: designware: device tree bindings for i2c speed mode
Date: Tue, 19 Aug 2014 13:34:35 -0500
Message-ID: <1408473276-10847-1-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0050.namprd02.prod.outlook.com (10.141.56.50) To
 DM2PR03MB319.namprd03.prod.outlook.com (10.141.54.18)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0308EE423E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009006)(6009001)(189002)(199003)(101416001)(50986999)(33646002)(106356001)(105586002)(74662001)(53416004)(77096002)(50466002)(575784001)(93916002)(77156001)(86362001)(229853001)(81542001)(81156004)(85306004)(81342001)(20776003)(107046002)(95666004)(80022001)(66066001)(31966008)(89996001)(64706001)(74502001)(104166001)(2201001)(102836001)(47776003)(88136002)(21056001)(99396002)(79102001)(48376002)(69596002)(87286001)(19580405001)(19580395003)(87976001)(83322001)(50226001)(4396001)(83072002)(85852003)(86152002)(77982001)(62966002)(92726001)(42186005)(92566001)(46102001)(76482001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB319;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Add "speed-mode" Device Tree property to select between
standard and fast i2c mode.  Previously, driver was hardwired
as fast mode.  Default to fast mode if property is not
present.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
 .../devicetree/bindings/i2c/i2c-designware.txt     |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-designware.txt b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
index 5199b0c..0e4cd21 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-designware.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
@@ -9,6 +9,8 @@ Required properties :
 Recommended properties :
 
  - clock-frequency : desired I2C bus clock frequency in Hz.
+ - speed-mode      : 0 = standard (0 - 100Kb/s)
+                   : 1 = fast (<= 400Kb/s) <== default
 
 Optional properties :
  - i2c-sda-hold-time-ns : should contain the SDA hold time in nanoseconds.
@@ -29,6 +31,7 @@ Example :
 		reg = <0xf0000 0x1000>;
 		interrupts = <11>;
 		clock-frequency = <400000>;
+		speed-mode = <0>;
 	};
 
 	i2c@1120000 {
-- 
1.7.9.5

