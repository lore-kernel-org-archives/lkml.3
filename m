Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab3LPUYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:24:49 -0500
Received: from 10.mo1.mail-out.ovh.net ([178.32.96.102]:53338 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751037Ab3LPUYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:24:48 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Landley <rob@landley.net>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 00/10] ARM: at91: move aic driver to drivers/irqchips
Date: Mon, 16 Dec 2013 21:24:11 +0100
Message-Id: <1387225461-6201-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 7035748519787264098
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series is a proposal to move AIC driver to the irqchip directory.

It also changes the implementation design of the interrupt controller in
several ways:
 - make use of the generic chip framework whenever possible
 - add support for irq muxing definition to prevent spurious interrupts
   during system startup (see https://lkml.org/lkml/2013/3/8/175)
 - only support dt enabled boards


Best Regards,

Boris

Boris BREZILLON (10):
  genirq: generic chip: export irq_map_generic_chip function
  irqchip: atmel-aic: add new atmel AIC driver
  ARM: at91: introduce OLD_IRQ_AT91 Kconfig option
  ARM: at91: enclose at91_aic_xx calls in
    IS_ENABLED(CONFIG_OLD_IRQ_AT91) blocks
  ARM: at91: make use of the new AIC driver for dt enabled boards
  irqchip: atmel-aic: move binding doc to interrupt-controller
    directory
  irqchip: atmel-aic: document new dt properties and children nodes
  ARM: at91: remove old irq material
  ARM: at91/dt: add new AIC irq mux definitions
  ARM: at91/dt: add new AIC irq mux definitions for sama5 SoCs

 .../devicetree/bindings/arm/atmel-aic.txt          |   41 -
 .../bindings/interrupt-controller/atmel,aic.txt    |   86 ++
 arch/arm/boot/dts/at91sam9x5.dtsi                  |  111 ++-
 arch/arm/boot/dts/sama5d3.dtsi                     |   40 +-
 arch/arm/boot/dts/sama5d3_tcb1.dtsi                |   22 +
 arch/arm/mach-at91/Kconfig                         |   11 +
 arch/arm/mach-at91/Kconfig.non_dt                  |    7 +
 arch/arm/mach-at91/Makefile                        |    3 +-
 arch/arm/mach-at91/board-dt-rm9200.c               |   13 -
 arch/arm/mach-at91/board-dt-sam9.c                 |   14 -
 arch/arm/mach-at91/board-dt-sama5.c                |   13 -
 arch/arm/mach-at91/irq.c                           |  270 +-----
 arch/arm/mach-at91/pm.c                            |   32 +-
 arch/arm/mach-at91/setup.c                         |    3 +-
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-atmel-aic.c                    |  879 ++++++++++++++++++++
 include/linux/irq.h                                |    2 +
 kernel/irq/generic-chip.c                          |    5 +-
 18 files changed, 1189 insertions(+), 364 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/atmel-aic.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/atmel,aic.txt
 create mode 100644 drivers/irqchip/irq-atmel-aic.c

-- 
1.7.9.5

