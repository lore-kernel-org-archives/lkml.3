Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbaHAWdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 18:33:44 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:29277
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754620AbaHAWdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 18:33:42 -0400
From: <atull@opensource.altera.com>
To: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH 0/3] Yet another stab at a fpga framework
Date: Fri, 1 Aug 2014 17:28:35 -0500
Message-ID: <1406932118-13885-1-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0025.namprd02.prod.outlook.com (10.141.56.25) To
 DM2PR03MB317.namprd03.prod.outlook.com (10.141.54.15)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029097202E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(189002)(199002)(93916002)(77982001)(66066001)(50986999)(62966002)(87976001)(87286001)(92566001)(69596002)(102836001)(48376002)(50466002)(85852003)(80022001)(86362001)(20776003)(101416001)(76482001)(81542001)(21056001)(53416004)(81156004)(4396001)(99396002)(50226001)(77096002)(229853001)(74502001)(19580395003)(19580405001)(42186005)(77156001)(88136002)(89996001)(86152002)(107046002)(81342001)(33646002)(106356001)(2201001)(92726001)(64706001)(95666004)(79102001)(104166001)(74662001)(47776003)(31966008)(83322001)(46102001)(105586002)(83072002)(85306004)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB317;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

[resend with fixed email settings]

The idea of the framework is to provide consistent ways of
programming raw images into FPGA's.

Programming from device tree overlays is supported.

The core (fpga-mgr.c) does not include a userspace interface
and just exports kernel functions.

This approach separates the core from the interfaces.

Each interface can be enabled or disabled in the defconfig.
In some production contexts, interfaces that might be used
during development can be disabled.

The core exports kernel functions to:
  * write the fpga from a buffer or using the firmware layer
  * get fpga status
  * find a particular fpga manager from a device tree phandle
  * register/unregister lower level fpga drivers.

The bus allows us to:
  * program fpga from a device tree overlay using firmware.
  * automatically reload firmware and reprogram fpga during resume.

The sysfs interface:
  * read only, get the name and status of fpga manager.

I have a configfs interface patch which I haven't included,
adds configfs as a separate file.

TODO:
  * Enable bridges after fpga programming, disable during suspend

Alan Tull (3):
  fpga manager framework core
  fpga bus driver
  fpga sysfs interface

 drivers/Kconfig          |    2 +
 drivers/Makefile         |    1 +
 drivers/fpga/Kconfig     |   27 +++
 drivers/fpga/Makefile    |   12 ++
 drivers/fpga/bus.c       |  145 ++++++++++++++++
 drivers/fpga/fpga-mgr.c  |  431 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/fpga/sysfs.c     |   69 ++++++++
 include/linux/fpga-mgr.h |  137 +++++++++++++++
 8 files changed, 824 insertions(+)
 create mode 100644 drivers/fpga/Kconfig
 create mode 100644 drivers/fpga/Makefile
 create mode 100644 drivers/fpga/bus.c
 create mode 100644 drivers/fpga/fpga-mgr.c
 create mode 100644 drivers/fpga/sysfs.c
 create mode 100644 include/linux/fpga-mgr.h

-- 
1.7.9.5

