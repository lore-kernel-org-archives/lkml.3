Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaJAToh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:44:37 -0400
Received: from mail-bl2on0073.outbound.protection.outlook.com ([65.55.169.73]:47760
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751176AbaJATof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:44:35 -0400
From: <atull@opensource.altera.com>
To: <dinguyen@opensource.altera.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v2 0/2] socfpga: fix hotplug/add suspend to ram
Date: Wed, 1 Oct 2014 14:38:22 -0500
Message-ID: <1412192304-1209-1-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0053.namprd05.prod.outlook.com (10.141.20.23) To
 BY2PR03MB314.namprd03.prod.outlook.com (10.141.139.19)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB314;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(77096002)(105586002)(81156004)(85306004)(106356001)(102836001)(33646002)(229853001)(107046002)(48376002)(99396003)(50466002)(77156001)(53416004)(10300001)(42186005)(95666004)(97736003)(20776003)(50226001)(47776003)(64706001)(50986999)(4396001)(86152002)(92566001)(92726001)(21056001)(62966002)(120916001)(93916002)(86362001)(31966008)(88136002)(19580405001)(87286001)(85852003)(89996001)(19580395003)(76482002)(66066001)(69596002)(101416001)(87976001)(80022003)(104166001)(46102003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB314;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Patch 1: socfpga: hotplug: put cpu1 in wfi
  Fix how cpu1 is hotplugged to prevent increased power
  consumption.

v2: no need to flush the caches
    clean up spacing in comments
    replace a register offset with a macro

Patch 2: socfpga: support suspend to ram
  * allocate space in ocram
  * Add a function to do suspend to ram and
    place DDR in self-refresh
  * This function lives in ocram

v2: use Generic on-chip SRAM driver to allocate ocram
    rm fncpy_align since generic allocator handles alignment
    check __arm_ioremap_exec return code
    check for NULL pointers
    add a comment regarding sdram controller configuration

Alan Tull (2):
  socfpga: hotplug: put cpu1 in wfi
  socfpga: support suspend to ram

 arch/arm/mach-socfpga/Kconfig        |    1 +
 arch/arm/mach-socfpga/Makefile       |    1 +
 arch/arm/mach-socfpga/core.h         |    7 ++
 arch/arm/mach-socfpga/platsmp.c      |   16 ++--
 arch/arm/mach-socfpga/pm.c           |  147 +++++++++++++++++++++++++++++++
 arch/arm/mach-socfpga/self-refresh.S |  157 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-socfpga/socfpga.c      |   10 +++
 7 files changed, 333 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm/mach-socfpga/pm.c
 create mode 100644 arch/arm/mach-socfpga/self-refresh.S

-- 
1.7.9.5

