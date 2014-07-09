Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbaGIXFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:05:14 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:35685
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756571AbaGIXFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:05:12 -0400
X-WSS-ID: 0N8GW4J-07-8ML-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <jason@lakedaemon.net>
CC: <pawel.moll@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>,
        <tglx@linutronix.de>, <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 0/4 V3] irqchip: gic: Introduce ARM GICv2m MSI(-X) support
Date: Wed, 9 Jul 2014 18:05:00 -0500
Message-ID: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(77982001)(77156001)(79102001)(20776003)(95666004)(85306003)(53416004)(77096002)(64706001)(76482001)(105586002)(47776003)(33646001)(107046002)(229853001)(48376002)(74502001)(106466001)(50466002)(46102001)(4396001)(19580405001)(97736001)(80022001)(44976005)(83322001)(19580395003)(31966008)(2201001)(102836001)(81342001)(74662001)(86152002)(92566001)(50986999)(21056001)(86362001)(101416001)(93916002)(92726001)(89996001)(36756003)(84676001)(88136002)(62966002)(99396002)(68736004)(50226001)(87286001)(83072002)(15975445006)(85852003)(81542001)(87936001);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB048;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0267E514F9
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

Changes in V3:
    * Rebase to git://git.infradead.org/users/jcooper/linux.git irqchip/gic
      (per Jason Cooper request)
    * Misc fix/clean up per Mark Rutland comments
    * Minor Clean up in the driver/irqchip/irq-gic-v2m.c: alloc_msi_irqs()
    * Patch 4 is new to the series:
        * Add ARM64-specific version arch_setup_msi_irqs() to allow support
          for Multiple MSI.
        * Add support for Multiple MSI for GICv2m.

Suravee Suthikulpanit (4):
  irqchip: gic: Add binding probe for ARM GIC400
  irqchip: gic: Restructuring ARM GIC code
  irqchip: gic: Add supports for ARM GICv2m MSI(-X)
  irqchip: gicv2m: Add support for multiple MSI for ARM64 GICv2m

 Documentation/devicetree/bindings/arm/gic.txt |  20 +-
 arch/arm64/Kconfig                            |   1 +
 arch/arm64/include/asm/msi.h                  |  15 ++
 arch/arm64/kernel/Makefile                    |   1 +
 arch/arm64/kernel/msi.c                       |  57 +++++
 drivers/irqchip/Kconfig                       |   7 +
 drivers/irqchip/Makefile                      |   1 +
 drivers/irqchip/irq-gic-v2m.c                 | 331 ++++++++++++++++++++++++++
 drivers/irqchip/irq-gic-v2m.h                 |  13 +
 drivers/irqchip/irq-gic.c                     |  90 ++++---
 drivers/irqchip/irq-gic.h                     |  67 ++++++
 11 files changed, 562 insertions(+), 41 deletions(-)
 create mode 100644 arch/arm64/include/asm/msi.h
 create mode 100644 arch/arm64/kernel/msi.c
 create mode 100644 drivers/irqchip/irq-gic-v2m.c
 create mode 100644 drivers/irqchip/irq-gic-v2m.h
 create mode 100644 drivers/irqchip/irq-gic.h

-- 
1.9.0

