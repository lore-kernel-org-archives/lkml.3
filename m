Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaKZHVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 02:21:31 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:24212 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752108AbaKZHVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 02:21:30 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/qYu6JrqSYHP5uPSuJtTU9XjvbrLtffCE=
X-DKIM: OpenDKIM Filter v2.0.1 titan DA6F0624270
Date: Wed, 26 Nov 2014 02:21:27 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: Core changes for v3.19 (round 2)
Message-ID: <20141126072127.GA22670@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here's the second round of changes for v3.19.  These have been in -next
for a while.  I'm sending this as a separate pull request so that the
next one doesn't color the summary with the contents of mvebu/fixes.

This is an incremental pull request from tags/irqchip-core-3.19 up to
tags/irqchip-core-3.19-2 in the irqchip/core branch.

Please pull.

thx,

Jason.


The following changes since commit 1dacf194b1468546a5715db58cbb65d50b598482:

  irqchip: irq-armada-370-xp: Use proper return value for ->set_affinity() (2014-11-09 03:56:37 +0000)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-core-3.19-2

for you to fetch changes up to 1abbdbac362af44f337fdbae5dcbe8d9ced8d063:

  irqchip: brcmstb-l2: Convert driver to use irq_reg_{readl,writel} (2014-11-09 04:03:35 +0000)

----------------------------------------------------------------
irqchip core changes for v3.19 (round 2)

 - genirq
    - Modify irq_reg_{readl,writel} for big endian I/O accessors

 - bcm{stb,7120}-l2
    - Allow sharing of driver between mips and arm

----------------------------------------------------------------
Kevin Cernekee (13):
      genirq: Generic chip: Change irq_reg_{readl,writel} arguments
      genirq: Generic chip: Allow irqchip drivers to override irq_reg_{readl,writel}
      genirq: Generic chip: Add big endian I/O accessors
      irqchip: brcmstb-l2: Eliminate dependency on ARM code
      irqchip: bcm7120-l2: Eliminate bad IRQ check
      irqchip: bcm7120-l2, brcmstb-l2: Remove ARM Kconfig dependency
      irqchip: bcm7120-l2: Make sure all register accesses use base+offset
      irqchip: bcm7120-l2: Fix missing nibble in gc->unused mask
      irqchip: bcm7120-l2: Use gc->mask_cache to simplify suspend/resume functions
      irqchip: bcm7120-l2: Extend driver to support 64+ bit controllers
      irqchip: bcm7120-l2: Decouple driver from brcmstb-l2
      irqchip: bcm7120-l2: Convert driver to use irq_reg_{readl,writel}
      irqchip: brcmstb-l2: Convert driver to use irq_reg_{readl,writel}

 .../interrupt-controller/brcm,bcm7120-l2-intc.txt  |  26 ++-
 arch/arm/mach-bcm/Kconfig                          |   1 +
 drivers/irqchip/Kconfig                            |   6 +-
 drivers/irqchip/Makefile                           |   4 +-
 drivers/irqchip/irq-atmel-aic.c                    |  40 ++---
 drivers/irqchip/irq-atmel-aic5.c                   |  65 ++++----
 drivers/irqchip/irq-bcm7120-l2.c                   | 174 +++++++++++++--------
 drivers/irqchip/irq-brcmstb-l2.c                   |  41 +++--
 drivers/irqchip/irq-sunxi-nmi.c                    |   4 +-
 drivers/irqchip/irq-tb10x.c                        |   4 +-
 include/linux/irq.h                                |  32 +++-
 kernel/irq/generic-chip.c                          |  36 +++--
 12 files changed, 263 insertions(+), 170 deletions(-)
