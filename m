Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaIJJPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 05:15:23 -0400
Received: from mail-bl2on0123.outbound.protection.outlook.com ([65.55.169.123]:57622
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751231AbaIJJPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 05:15:19 -0400
X-Greylist: delayed 121750 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 05:15:18 EDT
X-WSS-ID: 0NBOHPC-07-X00-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <jason@lakedaemon.net>
CC: <pawel.moll@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>,
        <tglx@linutronix.de>, <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 0/2 V5] irqchip: gic: Introduce ARM GICv2m MSI(-X) support
Date: Wed, 10 Sep 2014 04:14:59 -0500
Message-ID: <1410340501-30752-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(428002)(199003)(189002)(20776003)(92726001)(85306004)(47776003)(2201001)(86152002)(83072002)(92566001)(81342001)(90102001)(84676001)(50226001)(21056001)(106466001)(4396001)(64706001)(50466002)(81542001)(95666004)(46102001)(97736003)(48376002)(77982001)(36756003)(80022001)(50986999)(76482001)(88136002)(105586002)(89996001)(86362001)(77096002)(101416001)(19580405001)(19580395003)(83322001)(44976005)(68736004)(93916002)(87286001)(74502001)(102836001)(49486002)(62966002)(104166001)(31966008)(229853001)(74662001)(85852003)(107046002)(77156001)(99396002)(33646002)(87936001)(79102001)(15975445006);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB038;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
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
 drivers/irqchip/irq-gic-v2m.c                 | 326 ++++++++++++++++++++++++++
 drivers/irqchip/irq-gic.c                     |  88 ++++---
 drivers/irqchip/irq-gic.h                     |  51 ++++
 8 files changed, 526 insertions(+), 28 deletions(-)
 create mode 100644 arch/arm64/kernel/msi.c
 create mode 100644 drivers/irqchip/irq-gic-v2m.c
 create mode 100644 drivers/irqchip/irq-gic.h

-- 
1.9.3

