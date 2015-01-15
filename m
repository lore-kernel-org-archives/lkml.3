Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbbAOO7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:59:37 -0500
Received: from down.free-electrons.com ([37.187.137.238]:54336 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751993AbbAOO7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:59:35 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 0/8] AT91 cleanup for 3.20 #2
Date: Thu, 15 Jan 2015 15:59:23 +0100
Message-Id: <1421333971-7581-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets is based on AT91 cleanup for 3.20 #1
and depends on AT91 DT for 3.20 #1 because it uses the added SRAM nodes.

The first two patches rework the pm code to get rid of cpu_is_xxx (they will be
dropped soon) and use the SRAM from the genpool instead of relying on the remap
done by at91_init_sram.

The 3rd and 4th patches a reworking the pm code further to move at91_pm_init in
the .init_machine of the SoCs instead of arch_initcall, to get ready for
multiplatform.

Then the following patches get rid of at91_init_sram, taking .map_io for almost
all SoCs but the sama5d4 (more cleanups coming soon for that part).

The final patch moves at91rm9200_idle to clk/at91/pmc.c and allows to almost
empty arch/arm/mach-at91/at91rm9200.c (It is actually empty once "Atmel System
Timer cleanups" is applied).

Changes in v2:
 - added patch 3 and 4 to remove the calls to of_machine_is_compatible()

Alexandre Belloni (8):
  ARM: at91: pm: rework cpu detection
  ARM: at91: pm: use the mmio-sram pool to access SRAM
  ARM: at91: pm: add UDP and UHP checks to newer SoCs
  ARM: at91: pm: prepare for multiplatform
  ARM: at91: remove useless map_io
  ARM: at91: sama5d4: remove useless call to at91_init_sram
  ARM: at91: remove unused at91_init_sram
  ARM: at91: move at91rm9200_idle() to clk/at91/pmc.c

 arch/arm/mach-at91/Kconfig           |   1 +
 arch/arm/mach-at91/at91rm9200.c      |  15 -----
 arch/arm/mach-at91/at91sam9260.c     |  27 ---------
 arch/arm/mach-at91/at91sam9261.c     |   9 ---
 arch/arm/mach-at91/at91sam9263.c     |   7 ---
 arch/arm/mach-at91/at91sam9g45.c     |   7 ---
 arch/arm/mach-at91/at91sam9n12.c     |   6 --
 arch/arm/mach-at91/at91sam9rl.c      |  18 ------
 arch/arm/mach-at91/at91sam9x5.c      |   6 --
 arch/arm/mach-at91/board-dt-rm9200.c |  11 ++++
 arch/arm/mach-at91/board-dt-sam9.c   |  27 +++++++++
 arch/arm/mach-at91/board-dt-sama5.c  |   1 +
 arch/arm/mach-at91/generic.h         |  15 ++++-
 arch/arm/mach-at91/pm.c              | 110 ++++++++++++++++++++++++++---------
 arch/arm/mach-at91/sama5d3.c         |   6 --
 arch/arm/mach-at91/sama5d4.c         |   1 -
 arch/arm/mach-at91/setup.c           |  20 -------
 drivers/clk/at91/pmc.c               |   9 +++
 18 files changed, 146 insertions(+), 150 deletions(-)

-- 
2.1.0

