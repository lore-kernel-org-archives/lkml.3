Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaI1Uyf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 16:54:35 -0400
Received: from mail-bn1on0111.outbound.protection.outlook.com ([157.56.110.111]:31808
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753470AbaI1Uya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 16:54:30 -0400
X-WSS-ID: 0NCMQ2J-07-OVX-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <will.deacon@arm.com>, <liviu.dudau@arm.com>, <marc.zyngier@arm.com>,
        <mark.rutland@arm.com>, <catalin.marinas@arm.com>,
        <jason@lakedaemon.net>, <tglx@linutronix.de>, <robh+dt@kernel.org>,
        <bhelgaas@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [RFC 0/4] Add PCI/MSI(x) support for AMD Seattle Platform
Date: Sun, 28 Sep 2014 15:53:26 -0500
Message-ID: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(77156001)(50226001)(76482002)(104166001)(229853001)(21056001)(50986999)(20776003)(47776003)(120916001)(4396001)(102836001)(90102001)(84676001)(48376002)(101416001)(50466002)(97736003)(107046002)(89996001)(95666004)(85306004)(87936001)(15975445006)(99396003)(83322001)(19580405001)(64706001)(19580395003)(33646002)(88136002)(105586002)(77096002)(31966008)(62966002)(81542003)(77982003)(74502003)(74662003)(93916002)(92726001)(81342003)(79102003)(80022003)(46102003)(87286001)(86362001)(44976005)(106466001)(53416004)(83072002)(85852003)(36756003)(86152002)(92566001)(2201001)(68736004)(10300001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Forefront-PRVS: 03484C0ABF
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This is an RFC to introduce support for AMD Seattle ARM64 platform.

It is also intended to provide support for validating Liviu's PCI patch series:
    [PATCH v12 00/12] Support for creating generic PCI host bridges from DT
    https://lkml.org/lkml/2014/9/23/852

It is also intended to provide support for validating GICv2m patch series
(w/o multi-MSI).

Overview:

 * Patch 1 adds AMD Seattle device tree (w/ PCI and MSI support)

 * Patch 2-3) adds ARM64 and MSI support to the existing Generic PCI
   host controller.

 * Patch 4 comes from the GICv2m patch series: 
      [V8 2/2] irqchip: gicv2m: Add supports for ARM GICv2m MSI(-X)
      (https://lkml.org/lkml/2014/9/20/113)

   It has been slightly modified to remove the multi-MSI supports for now
   (awaiting discussion with other maintainers), and will be submitted
   separately.

Suravee Suthikulpanit (4):
  arm64: amd-seattle: Adding device tree for AMD Seattle platform
  PCI: generic: Add support for ARM64 and MSI(x)
  arm64: Do not call enable PCI resources when specify PCI_PROBE_ONLY
  irqchip: gicv2m: Add supports for ARM GICv2m MSI(-X)

 Documentation/devicetree/bindings/arm/gic.txt      |  53 ++++
 .../devicetree/bindings/pci/host-generic-pci.txt   |   3 +
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/boot/dts/Makefile                       |   1 +
 arch/arm64/boot/dts/amd-seattle-periph.dtsi        | 175 ++++++++++++
 arch/arm64/boot/dts/amd-seattle.dts                | 245 +++++++++++++++++
 arch/arm64/kernel/pci.c                            |   8 +
 drivers/irqchip/Kconfig                            |   5 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-gic-v2m.c                      | 301 +++++++++++++++++++++
 drivers/irqchip/irq-gic.c                          |  82 ++++--
 drivers/irqchip/irq-gic.h                          |  54 ++++
 drivers/pci/host/Kconfig                           |   2 +-
 drivers/pci/host/pci-host-generic.c                |  95 ++++++-
 14 files changed, 986 insertions(+), 40 deletions(-)
 create mode 100644 arch/arm64/boot/dts/amd-seattle-periph.dtsi
 create mode 100644 arch/arm64/boot/dts/amd-seattle.dts
 create mode 100644 drivers/irqchip/irq-gic-v2m.c
 create mode 100644 drivers/irqchip/irq-gic.h

-- 
1.9.3

