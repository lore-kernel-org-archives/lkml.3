Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaKLAOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 19:14:16 -0500
Received: from mail-bn1bon0082.outbound.protection.outlook.com ([157.56.111.82]:52224
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751712AbaKLAOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 19:14:10 -0500
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
Subject: [PATCHv5 0/5] Add Altera peripheral memories to EDAC framework
Date: Tue, 11 Nov 2014 18:14:18 -0600
Message-ID: <1415751263-1830-1-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR06CA049.namprd06.prod.outlook.com (10.141.250.167) To
 BLUPR03MB118.namprd03.prod.outlook.com (10.255.212.19)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB118;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB118;
X-Forefront-PRVS: 03932714EB
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(87286001)(48376002)(101416001)(104166001)(66066001)(87976001)(46102003)(50466002)(64706001)(19580395003)(33646002)(21056001)(19580405001)(69596002)(86362001)(92566001)(89996001)(86152002)(92726001)(2201001)(95666004)(99396003)(81156004)(42186005)(106356001)(97736003)(120916001)(105586002)(31966008)(4396001)(62966003)(77096003)(77156002)(50226001)(50986999)(122386002)(107046002)(47776003)(20776003)(102836001)(40100003)(53416004)(229853001)(921003)(1121002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB118;H:dinh-ubuntu.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB118;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB165;
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

v5 changes:
- Remove l2cache.h by using if (IS_ENABLED(CONFIG_EDAC_ALTERA_L2C))
- Remove ocram.h by using if (IS_ENABLED(CONFIG_EDAC_ALTERA_OCRAM))
- Check prop variable before using. Include io.h.
- Add defines for better readability. Remove MAINTAINERS changes.

Thor Thayer (5):
  arm: socfpga: Enable L2 Cache ECC on startup.
  arm: socfpga: Enable OCRAM ECC on startup.
  edac: altera: Remove SDRAM module compile
  edac: altera: Add Altera L2 Cache and OCRAM EDAC Support
  arm: dts: Add Altera L2 Cache and OCRAM EDAC

 .../bindings/arm/altera/socfpga-l2-edac.txt        |   15 +
 .../bindings/arm/altera/socfpga-ocram-edac.txt     |   16 +
 arch/arm/boot/dts/socfpga.dtsi                     |   15 +-
 arch/arm/mach-socfpga/Makefile                     |    2 +
 arch/arm/mach-socfpga/core.h                       |    3 +
 arch/arm/mach-socfpga/l2_cache.c                   |   41 ++
 arch/arm/mach-socfpga/ocram.c                      |   90 ++++
 arch/arm/mach-socfpga/socfpga.c                    |   13 +-
 drivers/edac/Kconfig                               |   18 +-
 drivers/edac/Makefile                              |    5 +-
 drivers/edac/altera_edac.c                         |  481 +++++++++++++++++++-
 11 files changed, 693 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt
 create mode 100644 arch/arm/mach-socfpga/l2_cache.c
 create mode 100644 arch/arm/mach-socfpga/ocram.c

-- 
1.7.9.5

