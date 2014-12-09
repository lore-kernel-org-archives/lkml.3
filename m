Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaLIUOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:14:51 -0500
Received: from mail-bl2on0067.outbound.protection.outlook.com ([65.55.169.67]:3697
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752323AbaLIUOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:14:49 -0500
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
        <galak@codeaurora.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v4 0/6] FPGA Manager Framework
Date: Tue, 9 Dec 2014 14:14:44 -0600
Message-ID: <1418156090-23578-1-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0079.namprd05.prod.outlook.com (10.141.20.49) To
 DM2PR0301MB1245.namprd03.prod.outlook.com (25.160.219.22)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1245;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:DM2PR0301MB1245;
X-Forefront-PRVS: 0420213CCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(50466002)(86152002)(31966008)(19580395003)(101416001)(64706001)(47776003)(20776003)(92566001)(2201001)(50226001)(86362001)(4396001)(21056001)(66066001)(50986999)(69596002)(19580405001)(42186005)(68736005)(48376002)(53416004)(87976001)(97736003)(62966003)(81156004)(106356001)(89996001)(122386002)(40100003)(107046002)(229853001)(120916001)(46102003)(99396003)(105586002)(33646002)(77156002)(7059030)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1245;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1245;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Improvements in this v3 and v4:

I've moved the driver to drivers/staging.

I'm including the altera low level driver, defconfig changes, and
DTS changes - everything to make it work on socfpga platform.

Fixed things in the framework that were left over from my original
version (that Michal started with) that was a character driver.
In particular, make the device be present in the fpga_manager struct,
not as a pointer, so container_of will work.

Since not enough of the Device Tree Overlays code is in the main
kernel yet, I'm leaving out the (small) changes to make this accept
notifications when a device tree overlay is accepted.  That can
wait a little until enough of is in that it can build and work.
That is a little disappointing to leave it out for now because
it was very cool and, I think, more Linux-like than this is by
itself.

Alan Tull (6):
  doc: add bindings document for altera fpga manager
  arm: dts: socfpga: add altera fpga manager
  ARM: socfpga: defconfig: enable fpga manager
  fpga manager: add sysfs interface document
  staging: fpga manager: framework core
  staging: fpga manager: add driver for altera socfpga manager

 Documentation/ABI/testing/sysfs-class-fpga-manager |   38 +
 .../devicetree/bindings/fpga/altera-fpga-mgr.txt   |   17 +
 arch/arm/boot/dts/socfpga.dtsi                     |   10 +
 arch/arm/configs/socfpga_defconfig                 |    4 +
 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/fpga/Kconfig                       |   27 +
 drivers/staging/fpga/Makefile                      |   11 +
 drivers/staging/fpga/altera.c                      |  789 ++++++++++++++++++++
 drivers/staging/fpga/fpga-mgr.c                    |  485 ++++++++++++
 include/linux/fpga-mgr.h                           |  104 +++
 11 files changed, 1488 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-manager
 create mode 100644 Documentation/devicetree/bindings/fpga/altera-fpga-mgr.txt
 create mode 100644 drivers/staging/fpga/Kconfig
 create mode 100644 drivers/staging/fpga/Makefile
 create mode 100644 drivers/staging/fpga/altera.c
 create mode 100644 drivers/staging/fpga/fpga-mgr.c
 create mode 100644 include/linux/fpga-mgr.h

-- 
1.7.9.5

