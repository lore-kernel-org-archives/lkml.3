Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaLNWKU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:10:20 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:50184 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaLNWKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:10:09 -0500
From: Stefan Agner <stefan@agner.ch>
To: tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com
Cc: u.kleine-koenig@pengutronix.de, shawn.guo@linaro.org,
        kernel@pengutronix.de, arnd@arndb.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH v2 0/3] irqchip: vf610-mscm: add support for MSCM interrupt router
Date: Sun, 14 Dec 2014 23:09:55 +0100
Message-Id: <1418594998-2361-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Splitted out version of the MSCM driver. My first driver based on the
routeable domain support and was part of the Vybrid Cortex-M4 support
patchset.

So far the MSCM interrupt router was initialized by the boot loader
and configured all interrupts for the Cortex-A5 CPU. There are two
use cases where a proper driver is necessary:
- To run Linux on the Cortex-M4. When the kernel is running on the
  non-preconfigured CPU, the interrupt router need to be configured
  properly.
- To support deeper sleep modes: LPSTOP clears the interrupt router
  configuration, hence a driver needs to restore the configuration
  on resume.
I created a seperate patchset for that driver which hopefully makes
it easier to get it into mergeable state.

The patchset is based on the master branch of Linus with the branch
irq-irqdomain-arm-for-linus from tip merged. I guess this will apply
flawless on 3.19-rc1 once it's out.

Changes since v1 (part of Vybrid Cortex-M4 support)
- Rewrite with irqdomain hierarchy
- Implemented as proper irqchip and move to driver/irqchip/
- Doesn't work on Cortex-M4 anymore (NVIC as parent is not yet
  implemented)

Stefan Agner (3):
  irqchip: vf610-mscm: add support for MSCM interrupt router
  irqchip: vf610-mscm: dt-bindings: add MSCM bindings
  ARM: dts: vf610: add Miscellaneous System Control Module (MSCM)

Stefan Agner (3):
  irqchip: vf610-mscm: add support for MSCM interrupt router
  irqchip: vf610-mscm: dt-bindings: add MSCM bindings
  ARM: dts: vf610: add Miscellaneous System Control Module (MSCM)

 .../bindings/arm/freescale/fsl,vf610-mscm.txt      |  21 +++
 arch/arm/boot/dts/vf500.dtsi                       |   9 +-
 arch/arm/boot/dts/vfxxx.dtsi                       |   7 +
 arch/arm/mach-imx/Kconfig                          |   1 +
 drivers/irqchip/Kconfig                            |  11 ++
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-vf610-mscm.c                   | 198 +++++++++++++++++++++
 7 files changed, 246 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/freescale/fsl,vf610-mscm.txt
 create mode 100644 drivers/irqchip/irq-vf610-mscm.c

-- 
2.1.3

