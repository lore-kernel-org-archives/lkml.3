Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaKGQyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:54:38 -0500
Received: from mail-bn1on0071.outbound.protection.outlook.com ([157.56.110.71]:12352
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751569AbaKGQyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:54:36 -0500
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
Subject: [PATCHv4 0/5] Add Altera peripheral memories to EDAC framework
Date: Fri, 7 Nov 2014 10:54:17 -0600
Message-ID: <1415379263-12391-1-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: GRUPR80CA004.lamprd80.prod.outlook.com (10.242.28.14) To
 BN1PR03MB121.namprd03.prod.outlook.com (10.255.201.16)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB121;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(95666004)(19580405001)(19580395003)(102836001)(40100003)(105586002)(106356001)(21056001)(107046002)(81156004)(77096003)(97736003)(101416001)(33646002)(62966003)(50226001)(4396001)(69596002)(48376002)(86152002)(93916002)(92566001)(77156002)(92726001)(86362001)(104166001)(2201001)(31966008)(20776003)(99396003)(64706001)(53416004)(120916001)(89996001)(42186005)(47776003)(50986999)(229853001)(66066001)(50466002)(88136002)(122386002)(46102003)(87286001)(87976001)(1121002)(921003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB121;H:dinh-ubuntu.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
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

v4 changes:
- Change mask defines to use BIT().
- Fix comment style to agree with kernel coding style.
- Better printk description for read != write in trigger.
- Remove SysFS debugging message.
- Better dci->mod_name
- Move gen_pool pointer assignment to end of function.
- Invert logic to reduce indent in ocram depenency check.
- Change from dev_err() to edac_printk()
- Replace magic numbers with defines & comments.
- Improve error injection test.
- Change Makefile intermediary name to altr (from alt)

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
 drivers/edac/altera_edac.c                         |  481 +++++++++++++++++++-
 13 files changed, 751 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt
 create mode 100644 arch/arm/mach-socfpga/l2_cache.c
 create mode 100644 arch/arm/mach-socfpga/l2_cache.h
 create mode 100644 arch/arm/mach-socfpga/ocram.c
 create mode 100644 arch/arm/mach-socfpga/ocram.h

-- 
1.7.9.5

