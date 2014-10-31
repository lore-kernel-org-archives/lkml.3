Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbaJaI1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:27:09 -0400
Received: from [157.56.110.110] ([157.56.110.110]:53211 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751187AbaJaI1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:27:00 -0400
X-WSS-ID: 0NEAVGH-07-1V9-02
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
Subject: [V9 PATCH 0/2] irqchip: gic: Introduce ARM GICv2m MSI(-X) support
Date: Fri, 31 Oct 2014 03:26:28 -0500
Message-ID: <1414743990-28421-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(64706001)(93916002)(46102003)(80022003)(31966008)(84676001)(86362001)(104166001)(92566001)(2201001)(92726001)(86152002)(36756003)(77156001)(85852003)(50466002)(48376002)(88136002)(89996001)(76482002)(85306004)(87286001)(87936001)(105586002)(33646002)(99396003)(95666004)(77096002)(106466001)(120916001)(62966002)(101416001)(47776003)(20776003)(44976005)(68736004)(50986999)(19580405001)(19580395003)(107046002)(4396001)(229853001)(15975445006)(53416004)(102836001)(21056001)(50226001)(97736003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03818C953D
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch set introduces support for MSI(-X) in GICv2m specification,
which is implemented in some variation of GIC400.

This patch set is rebased from: 
    Git tree   : git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git
    Git branch : domain_hierarchy
    Last commit: 97d4ea1f0922fb47dd1b09cd2694b7fa5b519db9

Changes in V9 includes:
  * GICv2m is now adopting the new domain hierarchy, which requires
    GICv2m to implements its own irq_chip and irq_domain, as a child of GIC. 
    GICv2m domain is intialized using the SPI base and the number of SPIs from
    V2M_MSI_TYPER registers (or the override value from DT).

  * Simplified GIC logic that was used to handle MSI stuff. Now the v2m
    stuff is cleanly separated.

History:
    V8: https://lkml.org/lkml/2014/9/20/111
    V7: https://lkml.org/lkml/2014/9/17/751

Suravee Suthikulpanit (2):
  genirq: Add irq_chip_set_type_parent function
  irqchip: gicv2m: Add supports for ARM GICv2m MSI(-X)

 Documentation/devicetree/bindings/arm/gic.txt |  53 ++++
 arch/arm64/Kconfig                            |   1 +
 drivers/irqchip/Kconfig                       |   5 +
 drivers/irqchip/Makefile                      |   1 +
 drivers/irqchip/irq-gic-v2m.c                 | 395 ++++++++++++++++++++++++++
 drivers/irqchip/irq-gic-v2m.h                 |   7 +
 drivers/irqchip/irq-gic.c                     |  21 +-
 include/linux/irq.h                           |   1 +
 kernel/irq/chip.c                             |  10 +
 9 files changed, 490 insertions(+), 4 deletions(-)
 create mode 100644 drivers/irqchip/irq-gic-v2m.c
 create mode 100644 drivers/irqchip/irq-gic-v2m.h

-- 
1.9.3

