Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaIXUdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:33:50 -0400
Received: from mail-by2on0079.outbound.protection.outlook.com ([207.46.100.79]:38191
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751284AbaIXUdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:33:49 -0400
From: <atull@opensource.altera.com>
To: <dinguyen@opensource.altera.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH 0/2] socfpga: fix hotplug/add suspend to ram
Date: Wed, 24 Sep 2014 15:27:27 -0500
Message-ID: <1411590449-9794-1-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR06CA036.namprd06.prod.outlook.com (10.141.250.154) To
 DM2PR03MB318.namprd03.prod.outlook.com (10.141.54.17)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB318;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(74662003)(107046002)(53416004)(106356001)(46102003)(50466002)(4396001)(50226001)(92726001)(93916002)(79102003)(90102001)(92566001)(64706001)(42186005)(229853001)(86152002)(87286001)(10300001)(105586002)(88136002)(66066001)(50986999)(62966002)(33646002)(86362001)(104166001)(89996001)(85852003)(19580405001)(83322001)(21056001)(69596002)(80022003)(20776003)(81542003)(77156001)(120916001)(19580395003)(101416001)(74502003)(83072002)(77982003)(81156004)(81342003)(48376002)(76482002)(95666004)(87976001)(85306004)(47776003)(77096002)(99396003)(102836001)(31966008)(97736003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB318;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

patch 1: socfpga: hotplug: put cpu1 in wfi
  Fix how cpu1 is hotplugged to prevent increaced power
  consumption.

patch 2: socfpga: support suspend to ram
  * Initialize ocram
  * Add a function to do suspend to ram and
    place DDR in self-refresh
  * This function lives in ocram

Alan Tull (2):
  socfpga: hotplug: put cpu1 in wfi
  socfpga: support suspend to ram

 arch/arm/mach-socfpga/Makefile       |    1 +
 arch/arm/mach-socfpga/core.h         |    6 ++
 arch/arm/mach-socfpga/platsmp.c      |   12 ++-
 arch/arm/mach-socfpga/pm.c           |  141 ++++++++++++++++++++++++++++++++
 arch/arm/mach-socfpga/self-refresh.S |  148 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-socfpga/socfpga.c      |   10 +++
 6 files changed, 315 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mach-socfpga/pm.c
 create mode 100644 arch/arm/mach-socfpga/self-refresh.S

-- 
1.7.9.5

