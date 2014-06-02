Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaFBMDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:03:30 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:34611 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbaFBMD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:03:28 -0400
MIME-Version: 1.0
Date: Mon, 2 Jun 2014 14:03:27 +0200
Message-ID: <CAPDyKFpkKNx17ha=WWAp4-6w3k4pRYSHUhOWHv1G+1_wAEBceA@mail.gmail.com>
Subject: [GIT PULL] MMC for v.3.16
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Chris Ball <chris@printf.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the first PR I send to you as I am co-maintaining the MMC
subsystem with Chris Ball. You will receive a separate PR for MMC from
him as well, as usual.

These patches are mainly updates for the mmci driver and have been
tested in linux-next.

Some ARM SoC related patches are also included and those have been
acked from the corresponding maintainers to go through my mmc tree.

Some more details in the signed tag.

Kind regards
Ulf Hansson


The following changes since commit 89ca3b881987f5a4be4c5dbaa7f0df12bbdde2fd:

  Linux 3.15-rc4 (2014-05-04 18:14:42 -0700)

are available in the git repository at:

  git://git.linaro.org/people/ulf.hansson/mmc.git tags/mmc-v3.16-1

for you to fetch changes up to 8c3a05b489ef097f86bf87c64192456553f57781:

  mmc: mmci: Enforce DMA configuration through DT (2014-06-02 11:20:25 +0200)

----------------------------------------------------------------
Updates for mmci driver:
 - Put the device into low power state at system suspend.
 - Convert to the common mmc DT parser.
 - Add missing DT bindings needed for ux500.

Updates for ARM ux500|u300:
 - Convert to the common mmc DT bindings.
 - Remove redundant board file for mmci platform data.

----------------------------------------------------------------
Ulf Hansson (22):
      mmc: mmci: Mask IRQs for all variants during runtime suspend
      mmc: mmci: Let runtime PM callbacks be available for CONFIG_PM
      mmc: mmci: Put the device into low power state at system suspend
      mmc: mmci: Convert to the mmc gpio API
      mmc: mmci: Convert to devm functions
      mmc: mmci: Update DT documentation
      mmc: mmci: Add DT bindings for signal direction
      mmc: mmci: Add DT bindings for feedback clock pin
      mmc: mmci: Use the common mmc DT parser
      ARM: ux500: Add mmci signal directions and feeback clock in DT for href
      ARM: ux500: Convert to the common mmc DT bindings for highspeed mode
      ARM: nomadik: Convert to the common mmc DT bindings for highspeed mode
      ARM: u300: Convert to the common mmc DT bindings for highspeed mode
      mmc: mmci: Mark the DT bindings for highspeed mode as deprecated
      mmc: mmci: Enable MMC_CAP_CMD23
      ARM: ux500: Add the mmc capabilities flags to DT
      ARM: ux500: Add a vmmc regulator through DT for the poped eMMC for href
      ARM: ux500: Remove redundant board file for mmci platform data
      mmc: mmci: Enforce DT for signal direction and feedback clock
      mmc: mmci: Enforce mmc capabilities through DT
      mmc: mmci: Enforce max frequency configuration through DT
      mmc: mmci: Enforce DMA configuration through DT

 Documentation/devicetree/bindings/mmc/mmci.txt |   54 +++-
 arch/arm/boot/dts/ste-ccu9540.dts              |    6 +-
 arch/arm/boot/dts/ste-href.dtsi                |   19 +-
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi     |    4 +-
 arch/arm/boot/dts/ste-snowball.dts             |    4 +-
 arch/arm/boot/dts/ste-u300.dts                 |    4 +-
 arch/arm/mach-lpc32xx/phy3250.c                |    3 -
 arch/arm/mach-ux500/Makefile                   |    3 +-
 arch/arm/mach-ux500/board-mop500-sdi.c         |  166 ------------
 arch/arm/mach-ux500/board-mop500.h             |    5 -
 arch/arm/mach-ux500/cpu-db8500.c               |    4 -
 drivers/mmc/host/mmci.c                        |  324 ++++++------------------
 drivers/mmc/host/mmci.h                        |   14 +-
 include/linux/amba/mmci.h                      |   42 ---
 14 files changed, 169 insertions(+), 483 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/board-mop500-sdi.c
