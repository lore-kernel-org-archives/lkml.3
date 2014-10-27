Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbaJ0XO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:14:29 -0400
Received: from down.free-electrons.com ([37.187.137.238]:55565 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752521AbaJ0XJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:09:49 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Sebastian Reichel <sre@kernel.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 0/8] ARM: at91: Remove mach/ includes from the reset driver
Date: Tue, 28 Oct 2014 00:09:29 +0100
Message-Id: <1414451377-11053-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series removes the mach/ headers dependency from the reset driver. It is
also laying some groundwork for the necessary power management support rework.

The first patch adds and export a function to shutdown the sdram from the sdramc
driver. That function also take the RSTC CR register and a value as parameters
to be able to reset the chip. This is a hackish way of doing it but it ensures
that all the code fits in one cache line. We already have plan to start using
the sram to have a cleaner way to execute that code safely as soon as that
series goes in:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-September/198778.html

The second patch makes the sdramc driver usable from the board files.

The third patch actually registers the sdramc driver from the boards files.
The fourth patch does the same, only for sam9g45 and sam9rl to simplify future
merging as the board files have been removed. Simply drop that patch.

The fifth patch makes the at91-reset driver use the newly created
at91_ramc_shutdown() function and removes the mach/ headers inclusion.

Then the sixth and seven patch do some cleanup. Again, you can simply drop patch
7 when merging.

The last patch adds myself a the maintainer for those drivers.

Changes in v2:
 - corrected a typo in MAINTAINERS
 - pass the RSTC CR register address and its value to reset the SoC to ensure
   everything fits in one cache line.

Alexandre Belloni (8):
  memory: atmel-sdramc: export a shutdown function
  memory: atmel-sdramc: allow probing from pdata
  ARM: at91: sam9: probe the RAMC driver from pdata
  ARM: at91: sam9g45/sam9rl: probe the ramc driver
  power: reset: at91-reset: use at91_ramc_shutdown
  ARM: at91: sam9: remove useless resource for rstc
  ARM: at91: sam9g45/sam9rl: remove useless resources for rstc
  MAINTAINERS: add at91 power and memory entries

 MAINTAINERS                      |  19 +++++
 arch/arm/mach-at91/Kconfig       |   2 +-
 arch/arm/mach-at91/at91sam9260.c |  20 ++++--
 arch/arm/mach-at91/at91sam9261.c |  20 ++++--
 arch/arm/mach-at91/at91sam9263.c |  20 ++++--
 arch/arm/mach-at91/at91sam9g45.c |  20 ++++--
 arch/arm/mach-at91/at91sam9rl.c  |  20 ++++--
 drivers/memory/atmel-sdramc.c    | 148 ++++++++++++++++++++++++++++++++++++++-
 drivers/power/reset/at91-reset.c | 122 ++++----------------------------
 include/soc/atmel/memory.h       |   6 ++
 10 files changed, 262 insertions(+), 135 deletions(-)
 create mode 100644 include/soc/atmel/memory.h

-- 
1.9.1

