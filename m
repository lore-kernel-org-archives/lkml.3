Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaINGae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 02:30:34 -0400
Received: from mail-bn1on0133.outbound.protection.outlook.com ([157.56.110.133]:5152
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752368AbaINGac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 02:30:32 -0400
X-WSS-ID: 0NBVOQP-08-F1Z-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <jason@lakedaemon.net>
CC: <pawel.moll@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>,
        <tglx@linutronix.de>, <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 0/2 V6] irqchip: gic: Introduce ARM GICv2m MSI(-X) support
Date: Sun, 14 Sep 2014 01:30:14 -0500
Message-ID: <1410676216-27953-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(48376002)(80022001)(81342001)(85306004)(101416001)(15975445006)(86152002)(105586002)(92566001)(2201001)(92726001)(106466001)(86362001)(50986999)(44976005)(76482001)(79102001)(77156001)(64706001)(68736004)(19580405001)(81542001)(47776003)(20776003)(46102001)(99396002)(90102001)(77982001)(19580395003)(50466002)(83322001)(104166001)(4396001)(50226001)(77096002)(31966008)(53416004)(74502001)(74662001)(36756003)(102836001)(33646002)(95666004)(89996001)(87286001)(97736003)(87936001)(62966002)(84676001)(229853001)(85852003)(21056001)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0201MB0921;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0334223192
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch set introduces support for MSI(-X) in GICv2m specification,
which is implemented in some variation of GIC400.

This depends on and has been tested with the following patch set which
implements PCI supports for ARM64:
 
    * https://lkml.org/lkml/2014/8/12/394
    * https://lkml.org/lkml/2014/8/12/361

Changes in V6:
    * Fix the logic in patch 1 in drivers/irqchip/irq-gic.c: gic_of_init()
      to print warning message when gicv2m_of_init fails instead of
      returning error since v2m is optional.

    * Minor clean up

Changes in V5:
    * Rebase to git://git.infradead.org/users/jcooper/linux.git irqchip/core

  Marc Zyngier suggestions:
    * Only use GICv2m irq_chip for MSI interrupts.
    * Simplify logic to support multi-MSI in arch/arm64/kernel/msi.c.
    * Modify gicv2m_setup_msi_irq() to also handle multi-MSI.

  Mark Rutlan suggestions: 
    * V4 patch set did not support multiple MSI register frame within a GIC.
      Although, the proposed GICv2m device tree binding should be able to
      handle the case.  Mark was questioning on how we can properly handle
      this in the code. Therefore, I try to implement this by iterating through
      the subnodes and look for msi-controller property. Once found, the code
      parses v2m register frame information and store it in the v2m_list of
      each gic_chip_data.

  Jingoo han suggestions:
    * Misc clean up.

Suravee Suthikulpanit (2):
  irqchip: gic: Add supports for ARM GICv2m MSI(-X)
  irqchip: gicv2m: Add support for multiple MSI for ARM64 GICv2m

 Documentation/devicetree/bindings/arm/gic.txt |  39 +++
 arch/arm64/kernel/Makefile                    |   1 +
 arch/arm64/kernel/msi.c                       |  41 ++++
 drivers/irqchip/Kconfig                       |   7 +
 drivers/irqchip/Makefile                      |   1 +
 drivers/irqchip/irq-gic-v2m.c                 | 328 ++++++++++++++++++++++++++
 drivers/irqchip/irq-gic.c                     |  88 ++++---
 drivers/irqchip/irq-gic.h                     |  51 ++++
 8 files changed, 528 insertions(+), 28 deletions(-)
 create mode 100644 arch/arm64/kernel/msi.c
 create mode 100644 drivers/irqchip/irq-gic-v2m.c
 create mode 100644 drivers/irqchip/irq-gic.h

-- 
1.9.3

