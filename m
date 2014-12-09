Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbaLIQ17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:27:59 -0500
Received: from mail-bn1bon0074.outbound.protection.outlook.com ([157.56.111.74]:40582
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753775AbaLIQ15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:27:57 -0500
X-Greylist: delayed 1216 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2014 11:27:57 EST
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
Subject: [PATCH v3 0/3] FPGA Manager Framework
Date: Tue, 9 Dec 2014 10:27:58 -0600
Message-ID: <1418142481-6167-1-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
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
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(229853001)(107046002)(33646002)(122386002)(99396003)(62966003)(77156002)(46102003)(68736005)(105586002)(81156004)(106356001)(4396001)(50226001)(101416001)(40100003)(120916001)(31966008)(97736003)(19580395003)(87976001)(19580405001)(50466002)(48376002)(66066001)(86362001)(21056001)(92566001)(2201001)(20776003)(86152002)(47776003)(64706001)(50986999)(89996001)(69596002)(53416004)(7059030)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1248;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1248;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Improvements in this version:

Fixed things in the framework that were left over from my original
version that was a character driver.  In particular, make the
struct device be present in the fpga_manager struct, not as a
pointer, so container_of will work.

Also rewrote the part that handles DT notifications.  Now this
section takes notifications instead of being another device to
load/unload.

Still want to integrate bridge enable/disable with this, but
that's not done yet.

Alan Tull (3):
  fpga manager: add sysfs interface document
  fpga manager: framework core
  fpga manager: device tree overlay support

 Documentation/ABI/testing/sysfs-class-fpga-manager |   38 ++
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/fpga/Kconfig                               |   28 +
 drivers/fpga/Makefile                              |   10 +
 drivers/fpga/fpga-mgr.c                            |  587 ++++++++++++++++++++
 include/linux/fpga-mgr.h                           |  107 ++++
 7 files changed, 773 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-manager
 create mode 100644 drivers/fpga/Kconfig
 create mode 100644 drivers/fpga/Makefile
 create mode 100644 drivers/fpga/fpga-mgr.c
 create mode 100644 include/linux/fpga-mgr.h

-- 
1.7.9.5

