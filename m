Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbaJWX6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 19:58:06 -0400
Received: from mail-bn1bon0089.outbound.protection.outlook.com ([157.56.111.89]:56211
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753533AbaJWX6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 19:58:04 -0400
From: <atull@opensource.altera.com>
To: <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>, <monstr@monstr.eu>,
        <michal.simek@xilinx.com>, <rdunlap@infradead.org>,
        <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <mgerlach@opensource.altera.com>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v2 0/3] fpga bridge framework
Date: Thu, 23 Oct 2014 18:51:04 -0500
Message-ID: <1414108267-22058-1-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DB4PR04CA0024.eurprd04.prod.outlook.com (25.160.41.34) To
 BL2PR03MB306.namprd03.prod.outlook.com (10.141.68.14)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB306;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(479174003)(199003)(189002)(64706001)(66066001)(86152002)(92566001)(92726001)(2201001)(33646002)(48376002)(21056001)(50986999)(86362001)(50466002)(93916002)(47776003)(20776003)(105586002)(95666004)(50226001)(4396001)(85306004)(42186005)(53416004)(106356001)(80022003)(229853001)(77096002)(46102003)(81156004)(107046002)(69596002)(85852003)(122386002)(19580405001)(19580395003)(40100003)(89996001)(87976001)(88136002)(87286001)(76482002)(104166001)(99396003)(120916001)(101416001)(102836001)(31966008)(77156001)(62966002)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB306;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Followup to bridge framework that was posted on 2013/10/3

This is a driver for enabling/disabling the fpga bridges under control
of a sys entry.  It has a common framework and individual drivers for
the various bridges.

This framework uses the reset driver where appropriate.

Alan


Alan Tull (3):
  add sysfs document for fpga bridges
  ARM: dts: socfpga: fpga bridges bindings docs
  fpga bridge driver

 Documentation/ABI/testing/sysfs-class-fpga-bridge  |    5 +
 .../bindings/fpga/altera-fpga2sdram-bridge.txt     |   57 +++++
 .../bindings/fpga/altera-hps2fpga-bridge.txt       |   53 +++++
 drivers/misc/Kconfig                               |    3 +-
 drivers/misc/Makefile                              |    1 +
 drivers/misc/fpga-bridge/Kconfig                   |   20 ++
 drivers/misc/fpga-bridge/Makefile                  |    6 +
 drivers/misc/fpga-bridge/altera-fpga2sdram.c       |  236 ++++++++++++++++++++
 drivers/misc/fpga-bridge/altera-hps2fpga.c         |  220 ++++++++++++++++++
 drivers/misc/fpga-bridge/fpga-bridge.c             |  230 +++++++++++++++++++
 drivers/misc/fpga-bridge/fpga-bridge.h             |   51 +++++
 11 files changed, 881 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-bridge
 create mode 100644 Documentation/devicetree/bindings/fpga/altera-fpga2sdram-bridge.txt
 create mode 100644 Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt
 create mode 100644 drivers/misc/fpga-bridge/Kconfig
 create mode 100644 drivers/misc/fpga-bridge/Makefile
 create mode 100644 drivers/misc/fpga-bridge/altera-fpga2sdram.c
 create mode 100644 drivers/misc/fpga-bridge/altera-hps2fpga.c
 create mode 100644 drivers/misc/fpga-bridge/fpga-bridge.c
 create mode 100644 drivers/misc/fpga-bridge/fpga-bridge.h

-- 
1.7.9.5

