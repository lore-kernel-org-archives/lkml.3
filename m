Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaBMMfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 07:35:41 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:47466 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbaBMMfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 07:35:39 -0500
MIME-Version: 1.0
Date: Thu, 13 Feb 2014 13:35:38 +0100
Message-ID: <CACRpkdYeaMqTNUTqBSg6vNa9=VucjpFFkx3diHJJNgZTg+iq1w@mail.gmail.com>
Subject: [GIT PULL] integrator base patches for v3.15
From: Linus Walleij <linus.walleij@linaro.org>
To: "arm@kernel.org" <arm@kernel.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ARM SoC folks,

this is a set of patches I have sent for review and failed to get
ACKs from the proper subsystem maintainers after repeated
pings. However I now need to have this rotated in linux-next
as a base for multiplatform, so please pull it in, it is all ARM
drivers anyway. Russell pointed out some things and these
have been fixed and iterated in this series.

Yours,
Linus Walleij

The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-integrator.git
tags/integrator-for-v3.15-1

for you to fetch changes up to 29525484cd2524a31ee0924831ab43b46ea6ebe1:

  ARM: integrator: select GPIO block (2014-02-13 11:21:37 +0100)

----------------------------------------------------------------
Integrator/Versatile base patch stack for the v3.15 series:

- Move integrator clock definitions to the device tree, alter
  clock and timer drivers accordingly.

- Alter the VIC irqchip driver to support cascaded VICs off
  a parent IRQ controller.

- Update the IM-PD1 plugin code to use managed resources.

- Register the VIC on the IM-PD1.

- Select the PL061 GPIO block for the IM-PD1 on the
  Integrator/AP.

----------------------------------------------------------------
Linus Walleij (10):
      ARM: integrator: define clocks in the device trees
      ARM: SP804: make Integrator/CP timer pick clock from DT
      ARM: integrator: switch to fetch clocks from device tree
      clk: versatile: pass a parent to the ICST clock
      clk: versatile: respect parent rate in ICST clock
      irqchip: vic: update the base IRQ member correctly
      irqchip: support cascaded VICs
      ARM: integrator: use managed resources for the IM-PD1
      ARM: integrator: register the IM-PD1 VIC
      ARM: integrator: select GPIO block

 .../devicetree/bindings/clock/arm-integrator.txt   |  34 +++++++
 arch/arm/boot/dts/integratorap.dts                 |  35 +++++++
 arch/arm/boot/dts/integratorcp.dts                 | 102 ++++++++++++++++++++-
 arch/arm/common/timer-sp.c                         |   8 +-
 arch/arm/mach-integrator/Kconfig                   |   3 +
 arch/arm/mach-integrator/impd1.c                   |  81 +++++++++-------
 arch/arm/mach-integrator/integrator_ap.c           |  19 +++-
 arch/arm/mach-integrator/integrator_cp.c           |   6 --
 arch/arm/mach-versatile/core.c                     |   2 +-
 drivers/clk/versatile/clk-icst.c                   |  21 ++++-
 drivers/clk/versatile/clk-icst.h                   |   1 +
 drivers/clk/versatile/clk-impd1.c                  |   6 +-
 drivers/clk/versatile/clk-integrator.c             |  83 +++++++----------
 drivers/clk/versatile/clk-realview.c               |   4 +-
 drivers/irqchip/irq-vic.c                          |  59 ++++++++++--
 include/linux/irqchip/arm-vic.h                    |   6 +-
 include/linux/platform_data/clk-integrator.h       |   1 -
 17 files changed, 353 insertions(+), 118 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/arm-integrator.txt
