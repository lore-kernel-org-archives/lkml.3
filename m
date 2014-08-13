Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaHMPBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:01:08 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:13608
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751963AbaHMPBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:01:04 -0400
X-WSS-ID: 0NA931F-07-2DM-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <jason@lakedaemon.net>
CC: <pawel.moll@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>,
        <tglx@linutronix.de>, <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 0/2 V4] irqchip: gic: Introduce ARM GICv2m MSI(-X) support
Date: Wed, 13 Aug 2014 10:00:39 -0500
Message-ID: <1407942041-3291-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019004)(6009001)(428002)(199003)(189002)(80022001)(86152002)(62966002)(92566001)(88136002)(85306004)(79102001)(33646002)(31966008)(106466001)(229853001)(19580405001)(53416004)(48376002)(2201001)(84676001)(20776003)(95666004)(89996001)(83072002)(93916002)(86362001)(50226001)(85852003)(105586002)(81342001)(92726001)(15975445006)(19580395003)(46102001)(4396001)(77096002)(87286001)(107046002)(101416001)(76482001)(47776003)(77982001)(81542001)(50986999)(99396002)(87936001)(97736001)(102836001)(104166001)(64706001)(36756003)(44976005)(50466002)(83322001)(77156001)(21056001)(74662001)(74502001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB044;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0302D4F392
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch set introduces support for MSI(-X) in GICv2m specification,
which is implemented in some variation of GIC400.

This depends on and has been tested with the V7 of"Add support for PCI in AArch64"
(https://lkml.org/lkml/2014/3/14/320).

Changes in V4:
    * Rebase to git://git.infradead.org/users/jcooper/linux.git irqchip/core
    * Remove patch 2 from previous version
    * Merge patch 1 and 3 from previous version
    * Reworks the GICv2m initialization based on Marc Zyngier review comments.
    * Introduce "v2m" subnode in GIC binding
    * Moves the "struct msi_chip" from "struct gic_chip_data" to "struct v2m_data".

Suravee Suthikulpanit (2):
  irqchip: gic: Add supports for ARM GICv2m MSI(-X)
  irqchip: gicv2m: Add support for multiple MSI for ARM64 GICv2m

 Documentation/devicetree/bindings/arm/gic.txt |  32 +++
 arch/arm64/include/asm/msi.h                  |  15 ++
 arch/arm64/kernel/Makefile                    |   1 +
 arch/arm64/kernel/msi.c                       |  57 +++++
 drivers/irqchip/Kconfig                       |   7 +
 drivers/irqchip/Makefile                      |   1 +
 drivers/irqchip/irq-gic-v2m.c                 | 294 ++++++++++++++++++++++++++
 drivers/irqchip/irq-gic.c                     |  75 ++++---
 drivers/irqchip/irq-gic.h                     |  48 +++++
 9 files changed, 500 insertions(+), 30 deletions(-)
 create mode 100644 arch/arm64/include/asm/msi.h
 create mode 100644 arch/arm64/kernel/msi.c
 create mode 100644 drivers/irqchip/irq-gic-v2m.c
 create mode 100644 drivers/irqchip/irq-gic.h

-- 
1.9.0

