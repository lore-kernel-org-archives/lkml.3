Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554AbbAFUPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:15:41 -0500
Received: from mail-bn1on0092.outbound.protection.outlook.com ([157.56.110.92]:37750
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756093AbbAFUOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:14:21 -0500
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
Subject: [PATCH v8 2/4] fpga manager: add sysfs interface document
Date: Tue, 6 Jan 2015 14:13:37 -0600
Message-ID: <1420575219-27061-3-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR00CA0017.namprd00.prod.outlook.com (25.160.102.27) To
 BY1PR0301MB1238.namprd03.prod.outlook.com (25.161.203.22)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atull@opensource.altera.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY1PR0301MB1238;
X-Forefront-PRVS: 0448A97BF2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(50944004)(53416004)(87976001)(2950100001)(42186005)(62966003)(77156002)(81156004)(105586002)(106356001)(107046002)(69596002)(19580395003)(97736003)(122386002)(229853001)(21056001)(19580405001)(31966008)(48376002)(66066001)(4396001)(50466002)(76176999)(50226001)(46102003)(50986999)(86152002)(92566001)(2201001)(120916001)(47776003)(64706001)(20776003)(99396003)(89996001)(33646002)(86362001)(68736005)(40100003)(101416001)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1238;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2015 20:14:10.5290 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0301MB1238
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Add documentation under drivers/staging for new fpga manager's
sysfs interface.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
v5  : (actually second version, but keeping version numbers
      aligned with rest of patch series)
      Move document to drivers/staging/fpga/Documentation/ABI

v6  : No change in this patch for v6 of the patch set

v7  : No change in this patch for v7 of the patch set

v8  : No change in this patch for v8 of the patch set
---
 .../Documentation/ABI/sysfs-class-fpga-manager     |   38 ++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 drivers/staging/fpga/Documentation/ABI/sysfs-class-fpga-manager

diff --git a/drivers/staging/fpga/Documentation/ABI/sysfs-class-fpga-manager b/drivers/staging/fpga/Documentation/ABI/sysfs-class-fpga-manager
new file mode 100644
index 0000000..eb600f2
--- /dev/null
+++ b/drivers/staging/fpga/Documentation/ABI/sysfs-class-fpga-manager
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

