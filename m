Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbbAID0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:26:23 -0500
Received: from mail-bl2on0054.outbound.protection.outlook.com ([65.55.169.54]:27697
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752952AbbAID0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:26:21 -0500
X-Greylist: delayed 1866 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2015 22:26:20 EST
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
Subject: [PATCHv6 0/5] Add Altera peripheral memories to EDAC framework
Date: Thu, 8 Jan 2015 20:53:51 -0600
Message-ID: <1420772036-3112-1-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0058.namprd05.prod.outlook.com (10.141.20.28) To
 BY2PR0301MB0629.namprd03.prod.outlook.com (25.160.125.27)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=tthayer@opensource.altera.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR0301MB0629;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0629;
X-Forefront-PRVS: 04519BA941
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(86362001)(48376002)(40100003)(106356001)(50466002)(50986999)(101416001)(97736003)(42186005)(50226001)(4396001)(19580395003)(120916001)(19580405001)(105586002)(122386002)(99396003)(33646002)(229853001)(68736005)(31966008)(107046002)(20776003)(64706001)(66066001)(46102003)(77156002)(2201001)(92566001)(89996001)(21056001)(86152002)(62966003)(47776003)(87976001)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR0301MB0629;H:localhost.localdomain;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2015 02:54:30.7073 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0629
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

v6 changes:
- Simplify OCRAM initialization. Remove be32_to_cpup() calls.
- Remove syscon from L2 Cache. Force L2 Cache on if ECC enabled.
- Convert to nested ECC in device tree. 
- Additional comments to clarify debug error injection.

Thor Thayer (5):
  arm: socfpga: Enable L2 Cache ECC on startup.
  arm: socfpga: Enable OCRAM ECC on startup.
  edac: altera: Remove SDRAM module compile
  edac: altera: Add Altera L2 Cache and OCRAM EDAC Support
  arm: dts: Add Altera L2 Cache and OCRAM EDAC entries

 .../bindings/arm/altera/socfpga-edac.txt           |   46 ++
 arch/arm/boot/dts/socfpga.dtsi                     |   20 +
 arch/arm/mach-socfpga/Makefile                     |    2 +
 arch/arm/mach-socfpga/core.h                       |    2 +
 arch/arm/mach-socfpga/l2_cache.c                   |   39 ++
 arch/arm/mach-socfpga/ocram.c                      |   97 ++++
 arch/arm/mach-socfpga/socfpga.c                    |    4 +-
 drivers/edac/Kconfig                               |   20 +-
 drivers/edac/Makefile                              |    5 +-
 drivers/edac/altera_edac.c                         |  506 +++++++++++++++++++-
 10 files changed, 735 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-edac.txt
 create mode 100644 arch/arm/mach-socfpga/l2_cache.c
 create mode 100644 arch/arm/mach-socfpga/ocram.c

-- 
1.7.9.5

