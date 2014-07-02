Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaGBPV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:21:29 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:19399
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754564AbaGBPV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:21:26 -0400
X-WSS-ID: 0N83BZG-08-3J6-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <jason@lakedaemon.net>
CC: <pawel.moll@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>,
        <tglx@linutronix.de>, <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 0/3 V2] irqchip: gic: Introduce ARM GICv2m MSI(-X) support
Date: Wed, 2 Jul 2014 10:21:05 -0500
Message-ID: <1404314468-7674-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(80022001)(74502001)(93916002)(81342001)(4396001)(47776003)(50226001)(79102001)(85852003)(44976005)(19580395003)(19580405001)(83322001)(46102001)(86152002)(76482001)(50986999)(68736004)(77156001)(97736001)(99396002)(64706001)(20776003)(62966002)(36756003)(74662001)(87286001)(86362001)(31966008)(104166001)(77982001)(53416004)(85306003)(95666004)(101416001)(50466002)(81542001)(107046002)(48376002)(21056001)(87936001)(102836001)(2201001)(92566001)(15975445006)(33646001)(83072002)(92726001)(229853001)(106466001)(105586002)(77096002)(84676001)(88136002)(89996001);DIR:OUT;SFP:;SCL:1;SRVR:BY1PR0201MB0918;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0260457E99
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch set introduces support for MSI(-X) in GICv2m specification,
which is implemented in some variation of GIC400 (e.g. gic-400+).

This depends on and has been tested with the V7 of "Add support for PCI in AArch64"
(https://lkml.org/lkml/2014/3/14/320).

Changes in V2:
Re-architect the code to:
    * Use irq_chip for gicv2m instead of using the gic_chip (per Marc suggestion).
    * Remove the overwriting of arch_setup_msi_irq and arch_setup_msi_irqs
      (per Marc suggestion).
    * Add devicetree matching for gic-400-plus for v2m stuff instread of
      re-using gic-400 just to be clear.
    * Misc fix/clean up per Mark Rutland and Marc Zyngier comments

Suravee Suthikulpanit (3):
  irqchip: gic: Add binding probe for ARM GIC400
  irqchip: gic: Restructuring ARM GIC code
  irqchip: gic: Add supports for ARM GICv2m MSI(-X)

 Documentation/devicetree/bindings/arm/gic.txt |  19 +-
 drivers/irqchip/Kconfig                       |   6 +
 drivers/irqchip/Makefile                      |   1 +
 drivers/irqchip/irq-gic-v2m.c                 | 248 ++++++++++++++++++++++++++
 drivers/irqchip/irq-gic-v2m.h                 |  13 ++
 drivers/irqchip/irq-gic.c                     |  88 +++++----
 drivers/irqchip/irq-gic.h                     |  60 +++++++
 7 files changed, 395 insertions(+), 40 deletions(-)
 create mode 100644 drivers/irqchip/irq-gic-v2m.c
 create mode 100644 drivers/irqchip/irq-gic-v2m.h
 create mode 100644 drivers/irqchip/irq-gic.h

-- 
1.9.0

