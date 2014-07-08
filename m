Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaGHNsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:48:18 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:16426 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaGHNsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:48:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+IJIyURVf789RTRwIgey9RwC0njjdcwI4=
X-DKIM: OpenDKIM Filter v2.0.1 titan 7DFB25A5465
Date: Tue, 8 Jul 2014 09:48:14 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: core: Changes for v3.17 (round #2)
Message-ID: <20140708134814.GA13433@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here's a round of changes for irq/core.  These changes have been in -next
for at least a week, and this is an incremental pull request from
tags/irqchip-core-3.17 up to tags/irqchip-core-3.17-2 on the
irqchip/core branch.

The only thing unusual here is that I set up a topic branch for crossbar
since the omap guys have other changes depending on this series.

Please pull.

thx,

Jason.

The following changes since commit 1b0a76c146adce782ddb8e71f01729f5f3671c66:

  irqchip: spear_shirq: Simplify register access code (2014-06-24 12:38:45 +0000)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-core-3.17-2

for you to fetch changes up to 885d078bfe92abfd5965a4f8846a3e72648ac9a6:

  Merge branch 'irqchip/crossbar' into irqchip/core (2014-07-01 12:16:10 +0000)

----------------------------------------------------------------

irqchip core changes for v3.17 (incremental #2)

 - or1k-pic
    - Migrate driver from arch/openrisc

 - crossbar
    - cleanup series

----------------------------------------------------------------
Jason Cooper (1):
      Merge branch 'irqchip/crossbar' into irqchip/core

Nishanth Menon (14):
      irqchip: crossbar: Dont use '0' to mark reserved interrupts
      irqchip: crossbar: Check for premapped crossbar before allocating
      irqchip: crossbar: Introduce ti, irqs-skip to skip irqs that bypass crossbar
      irqchip: crossbar: Initialise the crossbar with a safe value
      irqchip: crossbar: Change allocation logic by reversing search for free irqs
      irqchip: crossbar: Remove IS_ERR_VALUE check
      irqchip: crossbar: Fix sparse and checkpatch warnings
      irqchip: crossbar: Fix kerneldoc warning
      irqchip: crossbar: Return proper error value
      irqchip: crossbar: Change the goto naming
      irqchip: crossbar: Introduce ti, max-crossbar-sources to identify valid crossbar mapping
      irqchip: crossbar: Introduce centralized check for crossbar write
      documentation: dt: omap: crossbar: Add description for interrupt consumer
      irqchip: crossbar: Allow for quirky hardware with direct hardwiring of GIC

Sricharan R (2):
      irqchip: crossbar: Set cb pointer to null in case of error
      irqchip: crossbar: Add kerneldoc for crossbar_domain_unmap callback

Stefan Kristiansson (1):
      irqchip: or1k-pic: Migrate from arch/openrisc/

 .../devicetree/bindings/arm/omap/crossbar.txt      |  36 ++++
 .../interrupt-controller/opencores,or1k-pic.txt    |  23 +++
 arch/openrisc/Kconfig                              |   1 +
 arch/openrisc/include/asm/irq.h                    |   3 +
 arch/openrisc/kernel/irq.c                         | 146 ++---------------
 drivers/irqchip/Kconfig                            |   4 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-crossbar.c                     | 168 ++++++++++++++++---
 drivers/irqchip/irq-or1k-pic.c                     | 182 +++++++++++++++++++++
 9 files changed, 406 insertions(+), 158 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/opencores,or1k-pic.txt
 create mode 100644 drivers/irqchip/irq-or1k-pic.c
