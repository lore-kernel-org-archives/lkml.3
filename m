Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111AbaKZIjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 03:39:32 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:26403 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaKZIjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 03:39:31 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18AYl48SxtDCCP5oZCm2mTKk3F0UFi99A8=
X-DKIM: OpenDKIM Filter v2.0.1 titan AFE9E624419
Date: Wed, 26 Nov 2014 03:39:28 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: Core changes for v3.19 (round 4)
Message-ID: <20141126083928.GG22670@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Well, here it is. :)  I can't build-test most of it because I haven't
rebuilt my aarch64 toolchain yet.  I'm sending this now so you can pull
at your leisure (Maybe let it cook in Weds' and Thurs' -next?).  I have
nothing else pending for this window unless an urgent bugfix pops up.

This is an incremental pull request from tags/irqchip-core-3.19-3 up to
tags/irqchip-core-3.19-4 on the irqchip/core branch.

This branch has a previous dependency on mvebu/fixes (already in
mainline as of v3.18-rc5) and a new dependency on tip/irq/irqdomain.

Please pull.

thx,

Jason.


The following changes since commit 7a0b25d6d64e0b9009d8048b6f75fbba004e79f3:

  Merge remote-tracking branch 'tip/irq/irqdomain' into irqchip/core (2014-11-26 07:43:07 +0000)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-core-3.19-4

for you to fetch changes up to 1ddfd8ce2147d6d337738e2c4062eccc5448bbe2:

  irqchip: dw-apb-ictl: add PM support (2014-11-26 08:18:40 +0000)

----------------------------------------------------------------
irqchip core changes for v3.19 (round 4)

 - Hierarchy domains
    - GICv3 ITS
    - Mediatek sysirq
    - GICv2m

 - dw-apb-ictl
     - Small changes and PM support

----------------------------------------------------------------
Jisheng Zhang (3):
      irqchip: dw-apb-ictl: always use use {readl|writel}_relaxed
      irqchip: dw-apb-ictl: enable IRQ_GC_MASK_CACHE_PER_TYPE
      irqchip: dw-apb-ictl: add PM support

Marc Zyngier (13):
      arm64: PCI/MSI: Use asm-generic/msi.h
      irqchip: GICv3: Convert to domain hierarchy
      irqchip: GICv3: rework redistributor structure
      irqchip: GICv3: ITS command queue
      irqchip: GICv3: ITS: irqchip implementation
      irqchip: GICv3: ITS: LPI allocator
      irqchip: GICv3: ITS: tables allocators
      irqchip: GICv3: ITS: device allocation and configuration
      irqchip: GICv3: ITS: MSI support
      irqchip: GICv3: ITS: DT probing and initialization
      irqchip: GICv3: ITS: plug ITS init into main GICv3 code
      irqchip: GICv3: ITS: enable compilation of the ITS driver
      irqchip: GICv3: Binding updates for ITS

Suravee Suthikulpanit (2):
      irqchip: gic-v2m: Add support for ARM GICv2m MSI(-X) doorbell
      irqchip: gic-v2m: Add DT bindings for GICv2m

Yingjoe Chen (3):
      irqchip: gic: Support hierarchy irq domain.
      irqchip: mtk-sysirq: Add sysirq interrupt polarity support
      irqchip: mtk-sysirq: dt-bindings: Add bindings for mediatek sysirq

 Documentation/devicetree/bindings/arm/gic-v3.txt   |   39 +
 Documentation/devicetree/bindings/arm/gic.txt      |   53 +
 .../bindings/arm/mediatek/mediatek,sysirq.txt      |   28 +
 arch/arm64/Kconfig                                 |    2 +
 arch/arm64/include/asm/Kbuild                      |    1 +
 drivers/irqchip/Kconfig                            |   12 +
 drivers/irqchip/Makefile                           |    3 +
 drivers/irqchip/irq-dw-apb-ictl.c                  |   32 +-
 drivers/irqchip/irq-gic-v2m.c                      |  333 +++++
 drivers/irqchip/irq-gic-v3-its.c                   | 1402 ++++++++++++++++++++
 drivers/irqchip/irq-gic-v3.c                       |  156 ++-
 drivers/irqchip/irq-gic.c                          |   81 +-
 drivers/irqchip/irq-mtk-sysirq.c                   |  163 +++
 include/linux/irqchip/arm-gic-v3.h                 |  128 ++
 include/linux/irqchip/arm-gic.h                    |    2 +
 15 files changed, 2365 insertions(+), 70 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
 create mode 100644 drivers/irqchip/irq-gic-v2m.c
 create mode 100644 drivers/irqchip/irq-gic-v3-its.c
 create mode 100644 drivers/irqchip/irq-mtk-sysirq.c
