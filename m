Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935208AbaGRVRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:17:18 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:39815 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932143AbaGRVRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:17:17 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18xcFYNZSbytx6HMgsTXPMjPyYHfhuR4Z4=
X-DKIM: OpenDKIM Filter v2.0.1 titan 8A3C75AFC6C
Date: Fri, 18 Jul 2014 17:17:14 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: Core changes for v3.17 (round 3)
Message-ID: <20140718211714.GK24496@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here are the core changes I've gathered so far for v3.17.  irq-gic.c has
been a little adventuresome this cycle.  There's still the possibility
of some more code making it in for gic (assuming we don't run out of
time), which is why I merged a tag into core instead of the branch.

As usual, this is an incremental pull from tags/irqchip-core-3.17-2 up
to tags/irqchip-core-3.17-3 of the irqchip/core branch.

Please pull.

thx,

Jason.

The following changes since commit 885d078bfe92abfd5965a4f8846a3e72648ac9a6:

  Merge branch 'irqchip/crossbar' into irqchip/core (2014-07-01 12:16:10 +0000)

are available in the git repository at:


  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-core-3.17-3

for you to fetch changes up to f0cf9d2facbe3aa93b302058c013729cbc1bca22:

  Merge branch 'irqchip/atmel-aic' into irqchip/core (2014-07-18 20:58:34 +0000)

----------------------------------------------------------------

irqchip core changes for v3.17 (round #3)

 - gic
   - Add GICv3 driver

 - atmel
   - Move atmel aic driver from arch code to irqchip/

----------------------------------------------------------------
Boris BREZILLON (6):
      genirq: generic chip: Export irq_map_generic_chip function
      irqchip: atmel-aic: Move binding doc to interrupt-controller directory
      irqchip: atmel-aic: Add atmel AIC/AIC5 drivers
      irqchip: atmel-aic: Add irq fixup infrastructure
      irqchip: atmel-aic: Implement RTC irq fixup
      irqchip: atmel-aic: Define irq fixups for atmel SoCs

Jason Cooper (2):
      Merge tag 'tags/deps-irqchip-gic-3.17' into irqchip/core
      Merge branch 'irqchip/atmel-aic' into irqchip/core

Marc Zyngier (2):
      irqchip: gic: Move some bits of GICv2 to a library-type file
      irqchip: gic-v3: Initial support for GICv3

 .../atmel,aic.txt}                                 |   0
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/kernel/head.S                           |  18 +
 arch/arm64/kernel/hyp-stub.S                       |   1 +
 drivers/irqchip/Kconfig                            |  19 +
 drivers/irqchip/Makefile                           |   5 +-
 drivers/irqchip/irq-atmel-aic-common.c             | 254 ++++++++
 drivers/irqchip/irq-atmel-aic-common.h             |  39 ++
 drivers/irqchip/irq-atmel-aic.c                    | 262 ++++++++
 drivers/irqchip/irq-atmel-aic5.c                   | 353 +++++++++++
 drivers/irqchip/irq-gic-common.c                   | 115 ++++
 drivers/irqchip/irq-gic-common.h                   |  29 +
 drivers/irqchip/irq-gic-v3.c                       | 692 +++++++++++++++++++++
 drivers/irqchip/irq-gic.c                          |  59 +-
 include/linux/irq.h                                |   2 +
 include/linux/irqchip/arm-gic-v3.h                 | 198 ++++++
 kernel/irq/generic-chip.c                          |   5 +-
 17 files changed, 1994 insertions(+), 58 deletions(-)
 rename Documentation/devicetree/bindings/{arm/atmel-aic.txt => interrupt-controller/atmel,aic.txt} (100%)
 create mode 100644 drivers/irqchip/irq-atmel-aic-common.c
 create mode 100644 drivers/irqchip/irq-atmel-aic-common.h
 create mode 100644 drivers/irqchip/irq-atmel-aic.c
 create mode 100644 drivers/irqchip/irq-atmel-aic5.c
 create mode 100644 drivers/irqchip/irq-gic-common.c
 create mode 100644 drivers/irqchip/irq-gic-common.h
 create mode 100644 drivers/irqchip/irq-gic-v3.c
 create mode 100644 include/linux/irqchip/arm-gic-v3.h
