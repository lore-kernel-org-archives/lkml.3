Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbaJNTkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 15:40:10 -0400
Received: from mail-bn1on0093.outbound.protection.outlook.com ([157.56.110.93]:39168
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754840AbaJNTkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 15:40:08 -0400
From: <atull@opensource.altera.com>
To: <dinguyen@opensource.altera.com>, <linux@arm.linux.org.uk>
CC: <pavel@denx.de>, <arnd@arndb.de>, <s.trumtrar@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v3 0/2] socfpga: fix hotplug/add suspend to ram
Date: Tue, 14 Oct 2014 14:33:37 -0500
Message-ID: <1413315219-28885-1-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CY1PR09CA0021.namprd09.prod.outlook.com (25.160.223.31) To
 BL2PR03MB307.namprd03.prod.outlook.com (10.141.68.21)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB307;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03648EFF89
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(46102003)(80022003)(42186005)(33646002)(87976001)(89996001)(81156004)(106356001)(48376002)(95666004)(122386002)(77096002)(50466002)(229853001)(77156001)(19580395003)(40100003)(97736003)(105586002)(107046002)(19580405001)(50986999)(99396003)(101416001)(85852003)(53416004)(20776003)(64706001)(47776003)(92726001)(86152002)(92566001)(86362001)(93916002)(31966008)(87286001)(62966002)(66066001)(85306004)(69596002)(104166001)(21056001)(76482002)(4396001)(50226001)(120916001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB307;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Patch 1: socfpga: hotplug: put cpu1 in wfi
  Use WFI when putting CPU1 to sleep.  Don't hold CPU1 in reset
  since that results in increased power consumption.  Only
  briefly reset CPU1.

Patch 2: socfpga: support suspend to ram
  * allocate space in ocram using sram driver
  * Add a function in ocram to do suspend to ram and
    place DDR in self-refresh

Alan Tull (2):
  socfpga: hotplug: put cpu1 in wfi
  socfpga: support suspend to ram

 arch/arm/mach-socfpga/Kconfig        |    1 +
 arch/arm/mach-socfpga/Makefile       |    1 +
 arch/arm/mach-socfpga/core.h         |    7 ++
 arch/arm/mach-socfpga/platsmp.c      |   19 ++--
 arch/arm/mach-socfpga/pm.c           |  150 ++++++++++++++++++++++++++++++++
 arch/arm/mach-socfpga/self-refresh.S |  157 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-socfpga/socfpga.c      |   10 +++
 7 files changed, 337 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm/mach-socfpga/pm.c
 create mode 100644 arch/arm/mach-socfpga/self-refresh.S

-- 
1.7.9.5

