Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734AbaJVT5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:57:50 -0400
Received: from mail-by2on0061.outbound.protection.outlook.com ([207.46.100.61]:31031
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754296AbaJVT45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:56:57 -0400
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
Subject: [PATCH v2 1/3] fpga manager: add sysfs interface document
Date: Wed, 22 Oct 2014 14:50:03 -0500
Message-ID: <1414007405-32186-2-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414007405-32186-1-git-send-email-atull@opensource.altera.com>
References: <1414007405-32186-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR11CA0002.namprd11.prod.outlook.com (25.160.91.12) To
 BL2PR03MB307.namprd03.prod.outlook.com (10.141.68.21)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB307;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 037291602B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(50944004)(199003)(189002)(62966002)(31966008)(50986999)(76176999)(106356001)(48376002)(77096002)(76482002)(99396003)(120916001)(50466002)(77156001)(97736003)(81156004)(107046002)(229853001)(105586002)(95666004)(19580395003)(122386002)(85306004)(19580405001)(46102003)(80022003)(102836001)(87286001)(69596002)(93916002)(101416001)(40100003)(86362001)(104166001)(88136002)(89996001)(33646002)(66066001)(21056001)(47776003)(53416004)(20776003)(42186005)(50226001)(87976001)(4396001)(92566001)(85852003)(92726001)(64706001)(86152002)(2201001)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB307;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
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

