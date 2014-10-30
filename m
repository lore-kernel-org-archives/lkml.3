Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161149AbaJ3PcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:32:04 -0400
Received: from mail-bn1bon0068.outbound.protection.outlook.com ([157.56.111.68]:40667
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932947AbaJ3PcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:32:02 -0400
From: <tthayer@opensource.altera.com>
To: <bp@alien8.de>, <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <dinguyen@opensource.altera.com>,
        <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@opensource.altera.com>
Subject: [PATCHv3 0/5] Add Altera peripheral memories to EDAC framework
Date: Thu, 30 Oct 2014 10:32:06 -0500
Message-ID: <1414683131-20786-1-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR0201CA0002.namprd02.prod.outlook.com (25.160.191.140)
 To BY2PR03MB127.namprd03.prod.outlook.com (10.242.36.27)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB127;
X-Forefront-PRVS: 038002787A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(101416001)(87286001)(88136002)(50226001)(81156004)(50466002)(106356001)(85306004)(40100003)(33646002)(87976001)(95666004)(21056001)(122386002)(77156001)(76482002)(48376002)(4396001)(86362001)(31966008)(120916001)(93916002)(229853001)(107046002)(102836001)(53416004)(86152002)(47776003)(2201001)(92566001)(97736003)(50986999)(19580395003)(62966002)(19580405001)(64706001)(89996001)(85852003)(105586002)(69596002)(104166001)(92726001)(66066001)(77096002)(42186005)(46102003)(20776003)(80022003)(1121002)(921003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB127;H:dinh-ubuntu.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@opensource.altera.com>

This patch adds the L2 cache and OCRAM peripherals to the EDAC framework
using the EDAC device framework. The ECC is enabled early in the boot
process in the platform specific code.

v2 changes:
- Split On-Chip RAM ECC platform initialization into separate patch from
  L2 ECC platform initialization.
- Fix L2 cache dependency comments.
- Remove OCRAM node from dts and reference prior patch.

v3 changes:
- Move L2 cache & On-Chip RAM EDAC code into altera_edac.c
- Remove SDRAM module compile.


Thor Thayer (5):
  arm: socfpga: Enable L2 Cache ECC on startup.
  arm: socfpga: Enable OCRAM ECC on startup.
  edac: altera: Remove SDRAM module compile
  edac: altera: Add Altera L2 Cache and OCRAM EDAC Support
  arm: dts: Add Altera L2 Cache and OCRAM EDAC

 .../bindings/arm/altera/socfpga-l2-edac.txt        |   15 +
 .../bindings/arm/altera/socfpga-ocram-edac.txt     |   16 +
 MAINTAINERS                                        |    2 +
 arch/arm/boot/dts/socfpga.dtsi                     |   15 +-
 arch/arm/mach-socfpga/Makefile                     |    2 +
 arch/arm/mach-socfpga/l2_cache.c                   |   44 ++
 arch/arm/mach-socfpga/l2_cache.h                   |   28 ++
 arch/arm/mach-socfpga/ocram.c                      |   90 ++++
 arch/arm/mach-socfpga/ocram.h                      |   28 ++
 arch/arm/mach-socfpga/socfpga.c                    |   13 +-
 drivers/edac/Kconfig                               |   18 +-
 drivers/edac/Makefile                              |    5 +-
 drivers/edac/altera_edac.c                         |  475 +++++++++++++++++++-
 13 files changed, 745 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt
 create mode 100644 arch/arm/mach-socfpga/l2_cache.c
 create mode 100644 arch/arm/mach-socfpga/l2_cache.h
 create mode 100644 arch/arm/mach-socfpga/ocram.c
 create mode 100644 arch/arm/mach-socfpga/ocram.h

-- 
1.7.9.5

