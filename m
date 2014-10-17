Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbaJQVGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 17:06:53 -0400
Received: from mail-bl2on0078.outbound.protection.outlook.com ([65.55.169.78]:44064
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751342AbaJQVGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 17:06:52 -0400
From: <tthayer@opensource.altera.com>
To: <bp@alien8.de>, <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <dinguyen@altera.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@opensource.altera.com>, <tthayer@altera.com>
Subject: [PATCHv2 0/4] Add Altera peripheral memories to EDAC framework
Date: Fri, 17 Oct 2014 15:33:44 -0500
Message-ID: <1413578029-13205-1-git-send-email-tthayer@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR00CA0029.namprd00.prod.outlook.com (25.160.243.39) To
 BN1PR03MB124.namprd03.prod.outlook.com (10.255.201.23)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB124;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(106356001)(81156004)(48376002)(87976001)(76482002)(77156001)(88136002)(62966002)(87286001)(66066001)(64706001)(95666004)(53416004)(229853001)(33646002)(47776003)(107046002)(85306004)(20776003)(31966008)(89996001)(85852003)(50466002)(105586002)(42186005)(102836001)(104166001)(46102003)(80022003)(40100003)(97736003)(19580405001)(122386002)(19580395003)(77096002)(93916002)(99396003)(86152002)(86362001)(92566001)(4396001)(50986999)(2201001)(69596002)(101416001)(21056001)(92726001)(50226001)(120916001)(921003)(1121002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB124;H:dinh-ubuntu.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@opensource.altera.com>

This patch adds the L2 cache and OCRAM peripherals to the EDAC framework
using the EDAC device framework. The ECC is enabled early in the boot
process in the platform specific code.

Thor Thayer (4):
  arm: socfpga: Enable L2 Cache ECC on startup.
  arm: socfpga: Enable OCRAM ECC on startup.
  edac: altera: Add Altera L2 Cache and OCRAM EDAC Support
  arm: dts: Add Altera L2 Cache and OCRAM EDAC

 .../bindings/arm/altera/socfpga-l2-edac.txt        |   15 ++
 .../bindings/arm/altera/socfpga-ocram-edac.txt     |   16 ++
 MAINTAINERS                                        |    4 +-
 arch/arm/boot/dts/socfpga.dtsi                     |   15 +-
 arch/arm/mach-socfpga/Makefile                     |    2 +
 arch/arm/mach-socfpga/l2_cache.c                   |   44 ++++
 arch/arm/mach-socfpga/l2_cache.h                   |   28 +++
 arch/arm/mach-socfpga/ocram.c                      |   90 +++++++
 arch/arm/mach-socfpga/ocram.h                      |   28 +++
 arch/arm/mach-socfpga/socfpga.c                    |   13 +-
 drivers/edac/Kconfig                               |   14 ++
 drivers/edac/Makefile                              |    3 +
 drivers/edac/altera_edac_mgr.c                     |  261 ++++++++++++++++++++
 drivers/edac/altera_edac_mgr.h                     |   56 +++++
 drivers/edac/altera_l2_edac.c                      |  130 ++++++++++
 drivers/edac/altera_ocram_edac.c                   |  107 ++++++++
 16 files changed, 823 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt
 create mode 100644 arch/arm/mach-socfpga/l2_cache.c
 create mode 100644 arch/arm/mach-socfpga/l2_cache.h
 create mode 100644 arch/arm/mach-socfpga/ocram.c
 create mode 100644 arch/arm/mach-socfpga/ocram.h
 create mode 100644 drivers/edac/altera_edac_mgr.c
 create mode 100644 drivers/edac/altera_edac_mgr.h
 create mode 100644 drivers/edac/altera_l2_edac.c
 create mode 100644 drivers/edac/altera_ocram_edac.c

-- 
1.7.9.5

