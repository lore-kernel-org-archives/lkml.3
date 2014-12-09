Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbaLIQmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:42:32 -0500
Received: from mail-bl2on0088.outbound.protection.outlook.com ([65.55.169.88]:17408
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754278AbaLIQma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:42:30 -0500
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
        <linus.walleij@linaro.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v3 1/3] fpga manager: add sysfs interface document
Date: Tue, 9 Dec 2014 10:27:59 -0600
Message-ID: <1418142481-6167-2-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418142481-6167-1-git-send-email-atull@opensource.altera.com>
References: <1418142481-6167-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR00CA0015.namprd00.prod.outlook.com (25.160.102.25) To
 DM2PR0301MB1248.namprd03.prod.outlook.com (25.160.219.25)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1248;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:DM2PR0301MB1248;
X-Forefront-PRVS: 0420213CCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(50944004)(189002)(199003)(229853001)(107046002)(33646002)(122386002)(99396003)(62966003)(77156002)(46102003)(68736005)(105586002)(81156004)(106356001)(4396001)(50226001)(101416001)(40100003)(120916001)(31966008)(97736003)(19580395003)(87976001)(19580405001)(50466002)(48376002)(66066001)(86362001)(21056001)(92566001)(2201001)(20776003)(86152002)(47776003)(64706001)(50986999)(89996001)(69596002)(76176999)(53416004)(7059030)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1248;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1248;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Add documentation for new fpga manager sysfs interface.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
 Documentation/ABI/testing/sysfs-class-fpga-manager |   38 ++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-manager

diff --git a/Documentation/ABI/testing/sysfs-class-fpga-manager b/Documentation/ABI/testing/sysfs-class-fpga-manager
new file mode 100644
index 0000000..eb600f2
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-fpga-manager
@@ -0,0 +1,38 @@
+What:		/sys/class/fpga_manager/<fpga>/name
+Date:		October 2014
+KernelVersion:	3.18
+Contact:	Alan Tull <atull@opensource.altera.com>
+Description:	Name of low level driver.
+
+What:		/sys/class/fpga_manager/<fpga>/firmware
+Date:		October 2014
+KernelVersion:	3.18
+Contact:	Alan Tull <atull@opensource.altera.com>
+Description:	Name of the FPGA image file to load using firmware class.
+
+What:		/sys/class/fpga_manager/<fpga>/reset
+Date:		October 2014
+KernelVersion:	3.18
+Contact:	Alan Tull <atull@opensource.altera.com>
+Description:	Write 1 to reset the FPGA
+
+What:		/sys/class/fpga_manager/<fpga>/state
+Date:		October 2014
+KernelVersion:	3.18
+Contact:	Alan Tull <atull@opensource.altera.com>
+Description:	Read state of fpga framework state machine as a string.
+		Valid states may vary by manufacturer; superset is:
+		* unknown		= can't determine state
+		* power_off		= FPGA power is off
+		* power_up		= FPGA reports power is up
+		* reset			= FPGA held in reset state
+		* firmware_request	= firmware class request in progress
+		* firmware_request_err	= firmware request failed
+		* write_init		= FPGA being prepared for programming
+		* write_init_err	= Error while preparing FPGA for
+					  programming
+		* write			= FPGA ready to receive image data
+		* write_err		= Error while programming
+		* write_complete	= Doing post programming steps
+		* write_complete_err	= Error while doing post programming
+		* operating		= FPGA is programmed and operating
-- 
1.7.9.5

