Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbaIRCPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 22:15:00 -0400
Received: from mail-bn1bon0114.outbound.protection.outlook.com ([157.56.111.114]:31936
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757365AbaIRCO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 22:14:56 -0400
X-WSS-ID: 0NC2RKQ-07-G1E-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <jason@lakedaemon.net>
CC: <pawel.moll@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>,
        <liviu.dudau@arm.com>, <tglx@linutronix.de>,
        <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 0/2 V7] irqchip: gic: Introduce ARM GICv2m MSI(-X) support
Date: Wed, 17 Sep 2014 19:14:44 -0700
Message-ID: <1411006486-17513-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(66654002)(189002)(199003)(33646002)(81342003)(79102003)(107046002)(77156001)(84676001)(81542003)(74662003)(77982003)(46102003)(97736003)(77096002)(106466001)(62966002)(31966008)(74502003)(229853001)(95666004)(83322001)(80022003)(48376002)(105586002)(20776003)(21056001)(50466002)(104166001)(99396002)(44976005)(89996001)(87286001)(36756003)(101416001)(86152002)(92726001)(2201001)(64706001)(92566001)(93916002)(68736004)(19580395003)(50226001)(87936001)(90102001)(4396001)(15975445006)(86362001)(88136002)(19580405001)(85306004)(53416004)(83072002)(85852003)(47776003)(50986999);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB198;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

NOTE: Resend w/ proper subject for the 2/2 patch.

This patch set introduces support for MSI(-X) in GICv2m specification,
which is implemented in some variation of GIC400.

This depends on and has been tested with the following patch set which
implements PCI supports for ARM64:

    [PATCH v10 00/10] Support for creating generic PCI host bridges from DT
    https://lkml.org/lkml/2014/9/8/333

    [PATCH v10] Add support for PCI in AArch64
    https://lkml.org/lkml/2014/9/8/325
 
Changes in V7:
    * Fix error handling logic in gicv2m_of_init() and gicv2m_init_one().
      per Marc suggestions.
    * Restructure the patch to integrate the multi-MSI support for V2m
      into the patch 2/2.
    * Introduce "arm,gic-v2m-frame" compatible ID for the v2m DT binding.
    * Introduce "arm,msi-base-spi" and "arm,msi-num-spi" property in the
      v2m DT binding for overwriting value in MSI_TYPER register.
    * Add irq-gic-v2m.c: is_msi_spi_valid() to validate the SPI base and
      number of SPIs.
    * Fix various comments from Marc (Many thanks).
    * Add the missing CONFIG_ARM_GICV2M (per Marcin Juszkiewicz comment)

Suravee Suthikulpanit (2):
  irqchip: gic: Add support for multiple MSI for ARM64
  irqchip: gicv2m: Add supports for ARM GICv2m MSI(-X)

 Documentation/devicetree/bindings/arm/gic.txt |  55 ++++
 arch/arm64/Kconfig                            |   1 +
 arch/arm64/kernel/Makefile                    |   1 +
 arch/arm64/kernel/msi.c                       |  41 +++
 drivers/irqchip/Kconfig                       |   7 +
 drivers/irqchip/Makefile                      |   1 +
 drivers/irqchip/irq-gic-common.c              |  12 +
 drivers/irqchip/irq-gic-common.h              |   4 +
 drivers/irqchip/irq-gic-v2m.c                 | 356 ++++++++++++++++++++++++++
 drivers/irqchip/irq-gic.c                     |  82 +++---
 drivers/irqchip/irq-gic.h                     |  54 ++++
 11 files changed, 584 insertions(+), 30 deletions(-)
 create mode 100644 arch/arm64/kernel/msi.c
 create mode 100644 drivers/irqchip/irq-gic-v2m.c
 create mode 100644 drivers/irqchip/irq-gic.h

-- 
1.9.3

