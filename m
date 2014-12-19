Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaLSQqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 11:46:08 -0500
Received: from mail-bl2on0078.outbound.protection.outlook.com ([65.55.169.78]:44774
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750953AbaLSQqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 11:46:05 -0500
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
Subject: [PATCH v7 1/4] doc: add bindings document for altera fpga manager
Date: Fri, 19 Dec 2014 10:45:48 -0600
Message-ID: <1419007551-10040-2-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419007551-10040-1-git-send-email-atull@opensource.altera.com>
References: <1419007551-10040-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR06CA030.namprd06.prod.outlook.com (10.141.250.148) To
 DM2PR0301MB1247.namprd03.prod.outlook.com (25.160.219.24)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atull@opensource.altera.com; 
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1247;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB1247;
X-Forefront-PRVS: 0430FA5CB7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(69596002)(122386002)(19580405001)(47776003)(19580395003)(76176999)(86152002)(50466002)(53416004)(42186005)(120916001)(2201001)(20776003)(64706001)(107046002)(81156004)(31966008)(66066001)(48376002)(33646002)(50226001)(105586002)(87976001)(4396001)(97736003)(21056001)(229853001)(86362001)(50986999)(62966003)(46102003)(77156002)(92566001)(99396003)(101416001)(68736005)(40100003)(2950100001)(106356001)(89996001)(7059030)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1247;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1247;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0847;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

New bindings document for Altera fpga manager.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
v5 : Move bindings to drivers/staging/fpga/Documentation/bindings

v6 : No change in this patch for v6 of the patch set

v7 : No change in this patch for v7 of the patch set
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

