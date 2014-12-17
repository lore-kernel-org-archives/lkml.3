Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaLQQzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 11:55:09 -0500
Received: from mail-bn1on0077.outbound.protection.outlook.com ([157.56.110.77]:20339
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751451AbaLQQzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 11:55:05 -0500
From: <atull@opensource.altera.com>
To: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <rdunlap@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devel@driverdev.osuosl.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v5 1/6] doc: add bindings document for altera fpga manager
Date: Wed, 17 Dec 2014 10:54:44 -0600
Message-ID: <1418835289-15752-2-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418835289-15752-1-git-send-email-atull@opensource.altera.com>
References: <1418835289-15752-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR00CA0007.namprd00.prod.outlook.com (25.160.102.17) To
 BN3PR0301MB1236.namprd03.prod.outlook.com (25.161.207.24)
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1236;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN3PR0301MB1236;
X-Forefront-PRVS: 042857DBB5
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(122386002)(99396003)(19580395003)(19580405001)(69596002)(120916001)(40100003)(81156004)(106356001)(105586002)(66066001)(50986999)(76176999)(64706001)(42186005)(47776003)(20776003)(87976001)(46102003)(101416001)(86362001)(92566001)(2201001)(86152002)(89996001)(31966008)(4396001)(2950100001)(50466002)(33646002)(50226001)(21056001)(97736003)(68736005)(48376002)(53416004)(229853001)(62966003)(77156002)(107046002)(7059030)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1236;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1236;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2014 16:54:58.0238 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB1236
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

New bindings document for Altera fpga manager.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
v5 : Move bindings to drivers/staging/fpga/Documentation/bindings
---
 .../Documentation/bindings/altera-fpga-mgr.txt     |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 drivers/staging/fpga/Documentation/bindings/altera-fpga-mgr.txt

diff --git a/drivers/staging/fpga/Documentation/bindings/altera-fpga-mgr.txt b/drivers/staging/fpga/Documentation/bindings/altera-fpga-mgr.txt
new file mode 100644
index 0000000..373af7b
--- /dev/null
+++ b/drivers/staging/fpga/Documentation/bindings/altera-fpga-mgr.txt
@@ -0,0 +1,17 @@
+Altera FPGA Manager
+
+Required properties:
+- compatible : should contain "altr,fpga-mgr"
+- reg        : base address and size for memory mapped io.
+               - The first index is for FPGA manager register access.
+               - The second index is for writing FPGA configuration data.
+- interrupts : interrupt for the FPGA Manager device.
+
+Example:
+
+	hps_0_fpgamgr: fpgamgr@0xff706000 {
+		compatible = "altr,fpga-mgr";
+		reg = <0xFF706000 0x1000
+		       0xFFB90000 0x1000>;
+		interrupts = <0 175 4>;
+	};
-- 
1.7.9.5

