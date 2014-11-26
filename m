Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaKZQgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:36:25 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:16813 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752624AbaKZQgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:36:24 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19PjGC6P8pxeeq6he3dyB0PUNRhDOv7g10=
X-DKIM: OpenDKIM Filter v2.0.1 titan 802A36248F8
Date: Wed, 26 Nov 2014 11:36:21 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: irqdomain-arm: Changes for v3.19
Message-ID: <20141126163621.GJ22670@titan.lakedaemon.net>
References: <20141126083928.GG22670@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126083928.GG22670@titan.lakedaemon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

As requested, here is a new pull request for a branch,
irqchip/irqdomain-arm which is based on v3.18-rc1, depends on
tip/irq/irqdomain, and contains the below summary of changes.

I build-tested this on aarch64 and it came through fine, but we probably
want this to stew in -next for a few days.  Since we have the
Thanksgiving holiday here in the states Thursday and Friday, and my work
schedule is chaotic atm, I'm sending this now so if everything goes
smoothly, you can just pull when you're ready.

Please pull at your convenience.

thx,

Jason.

The following changes since commit 020c312658d61297ffe43b412441c69b1c36fb1b:

  PCI/MSI: Allow an msi_controller to be associated to an irq domain (2014-11-23 17:14:43 +0100)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-irqdomain-arm-3.19

for you to fetch changes up to e684e258d831781fd89d2047a272fdb0b0ffe7f4:

  irqchip: gic-v2m: Add DT bindings for GICv2m (2014-11-26 15:55:19 +0000)

----------------------------------------------------------------
irqchip hierarchy irqdomain changes for arm for v3.19

 - GICv3 ITS
 - Mediatek sysirq
 - GICv2m

----------------------------------------------------------------
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
 drivers/irqchip/irq-gic-v2m.c                      |  333 +++++
 drivers/irqchip/irq-gic-v3-its.c                   | 1402 ++++++++++++++++++++
 drivers/irqchip/irq-gic-v3.c                       |  156 ++-
 drivers/irqchip/irq-gic.c                          |   81 +-
 drivers/irqchip/irq-mtk-sysirq.c                   |  163 +++
 include/linux/irqchip/arm-gic-v3.h                 |  128 ++
 include/linux/irqchip/arm-gic.h                    |    2 +
 14 files changed, 2339 insertions(+), 64 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
 create mode 100644 drivers/irqchip/irq-gic-v2m.c
 create mode 100644 drivers/irqchip/irq-gic-v3-its.c
 create mode 100644 drivers/irqchip/irq-mtk-sysirq.c
