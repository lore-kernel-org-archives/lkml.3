Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbbAPRZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 12:25:34 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:44223 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbbAPRZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 12:25:32 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: cleanup for 3.20 #2
Date: Fri, 16 Jan 2015 18:25:41 +0100
Message-ID: <1421429141-5405-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is another cleanup pull-request for AT91. This one depends on the Device
Tree material that I posted yesterday, so I merged the at91-dt tag just before
stacking up Alexandre's patches. This dependency is needed to make sure that
SRAM gets initialized before using it.
More cleanup will come soon to reach multi-platform.

Thanks, best regards,

The following changes since commit eca6f17253f33313eeb3020d0634a60d10f650c4:

  Merge tag 'at91-dt' into at91-3.20-cleanup (2015-01-16 17:18:34 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-cleanup2

for you to fetch changes up to 29ee506d0d56f6d39cc237de2512f9cb5629cbf7:

  ARM: at91: move at91rm9200_idle() to clk/at91/pmc.c (2015-01-16 18:08:42 +0100)

----------------------------------------------------------------
Second batch of cleanup for 3.20:
- By reworking the PM code, we can remove the AT91 more specific initialization
- We are using DT for SRAM initialization now, so we can remove its explicit
  mapping
- The PMC clock driver now hosts IDLE function for at91rm9200 with other
  SoCs ones.

----------------------------------------------------------------
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
 arch/arm/mach-at91/pm.c              | 109 ++++++++++++++++++++++++++---------
 arch/arm/mach-at91/sama5d3.c         |   6 --
 arch/arm/mach-at91/sama5d4.c         |   1 -
 arch/arm/mach-at91/setup.c           |  20 -------
 drivers/clk/at91/pmc.c               |   9 +++
 18 files changed, 145 insertions(+), 150 deletions(-)

-- 
Nicolas Ferre
