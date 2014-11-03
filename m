Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbaKCVQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:16:31 -0500
Received: from mail-bn1bn0103.outbound.protection.outlook.com ([157.56.110.103]:55604
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752538AbaKCVQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:16:29 -0500
X-WSS-ID: 0NEHF39-07-TZ3-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <jason@lakedaemon.net>,
        <tglx@linutronix.de>
CC: <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>, <liviu.dudau@arm.com>,
        <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>
Subject: [V10 PATCH 0/2] irqchip: gic: Introduce ARM GICv2m MSI(-X) support
Date: Mon, 3 Nov 2014 16:16:15 -0600
Message-ID: <1415052977-26036-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(105586002)(106466001)(92726001)(15975445006)(21056001)(102836001)(99396003)(120916001)(107046002)(229853001)(104166001)(62966003)(20776003)(47776003)(64706001)(46102003)(101416001)(95666004)(86152002)(2201001)(92566001)(33646002)(50986999)(87286001)(87936001)(19580395003)(93916002)(19580405001)(48376002)(36756003)(44976005)(53416004)(97736003)(86362001)(68736004)(88136002)(4396001)(31966008)(50226001)(89996001)(77096003)(77156002)(50466002)(84676001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0384275935
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch set introduces support for MSI(-X) in GICv2m specification,
which is implemented in some variation of GIC400.

This patch adopt the new hierarchy irq domain, and is rebased from: 
    Git tree   : git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git
    Git branch : domain_hierarchy
    Last commit: 97d4ea1f0922fb47dd1b09cd2694b7fa5b519db9

Changes in V10 includes:
  * Remove the alloc_msi_irq and integrate into gicv2m_setup_msi_irq
  * Clean up the error_out logic in gicv2m_init_one
  * Add comments in gic_irq_domain_alloc()
  * Removed v2m_list since no longer needed with the irqdomain hierachy framework
  * Rename variable in gicv2m_taredown_msi_irq to be consistent with other functions

History:
    V9: https://lkml.org/lkml/2014/10/31/111
    V8: https://lkml.org/lkml/2014/9/20/111
    V7: https://lkml.org/lkml/2014/9/17/751


Suravee Suthikulpanit (2):
  genirq: Add irq_chip_set_type_parent function
  irqchip: gicv2m: Add supports for ARM GICv2m MSI(-X)

 Documentation/devicetree/bindings/arm/gic.txt |  53 ++++
 arch/arm64/Kconfig                            |   1 +
 drivers/irqchip/Kconfig                       |   5 +
 drivers/irqchip/Makefile                      |   1 +
 drivers/irqchip/irq-gic-v2m.c                 | 340 ++++++++++++++++++++++++++
 drivers/irqchip/irq-gic-v2m.h                 |   6 +
 drivers/irqchip/irq-gic.c                     |  23 +-
 include/linux/irq.h                           |   1 +
 kernel/irq/chip.c                             |  10 +
 9 files changed, 436 insertions(+), 4 deletions(-)
 create mode 100644 drivers/irqchip/irq-gic-v2m.c
 create mode 100644 drivers/irqchip/irq-gic-v2m.h

-- 
1.9.3

