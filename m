Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbaLDRwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:52:04 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:27960 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655AbaLDRwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:52:01 -0500
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
Subject: [GIT PULL] at91: cleanup for 3.19 #5
Date: Thu, 4 Dec 2014 18:52:00 +0100
Message-ID: <1417715520-30412-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is the last "cleanup" pull-request for 3.19 on my side. Most of the work
was done by Arnd actually ;-)
This simplifies even more the mach-at91 directory and remove a bunch of dead
code. Arnd also wrote some more cleanup patches that I will keep for 3.20 as
they modify files in a larger extent.

Thanks, best regards,

The following changes since commit 4a109c50d1958a2783df01980b55508fe47bb79c:

  ARM: at91: remove unused IRQ function declarations (2014-11-27 16:33:06 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-cleanup5

for you to fetch changes up to ba62a8593d15f3f353acdc8ab32c18dd40a275bb:

  ARM: at91: remove unused board.h file (2014-12-03 14:16:07 +0100)

----------------------------------------------------------------
Fifth batch of cleanup/SoC for 3.19:
- removal of now dead code and AT91-specific driver
- removal of !DT initialization in some core AT91 drivers
- simplification of Kconfig DT board file selection: now automatic

----------------------------------------------------------------
Arnd Bergmann (6):
      ARM: at91/Kconfig: select board files automatically
      ARM: at91: cleanup initilisation code by removing dead code
      ARM: at91: remove old AT91-specific drivers
      ARM: at91: at91rm9200 ST initialization is now DT only
      ARM: at91/clocksource: remove !DT PIT initializations
      ARM: at91: remove unused board.h file

Nicolas Ferre (1):
      ARM: at91: remove unneeded header files

 arch/arm/mach-at91/Kconfig                 |  14 +-
 arch/arm/mach-at91/Makefile                |   5 +-
 arch/arm/mach-at91/at91_tc.h               | 146 -----
 arch/arm/mach-at91/at91rm9200_time.c       |  23 -
 arch/arm/mach-at91/board-dt-rm9200.c       |   2 -
 arch/arm/mach-at91/board-dt-sam9.c         |   1 -
 arch/arm/mach-at91/board.h                 | 123 ----
 arch/arm/mach-at91/generic.h               |  33 -
 arch/arm/mach-at91/gpio.c                  | 982 -----------------------------
 arch/arm/mach-at91/gpio.h                  | 214 -------
 arch/arm/mach-at91/gsia18s.h               |  33 -
 arch/arm/mach-at91/include/mach/hardware.h |   5 -
 arch/arm/mach-at91/leds.c                  |  56 --
 arch/arm/mach-at91/pm.c                    |  11 +-
 arch/arm/mach-at91/setup.c                 |  54 --
 arch/arm/mach-at91/soc.h                   |   6 -
 drivers/clocksource/timer-atmel-pit.c      |  32 -
 17 files changed, 5 insertions(+), 1735 deletions(-)
 delete mode 100644 arch/arm/mach-at91/at91_tc.h
 delete mode 100644 arch/arm/mach-at91/board.h
 delete mode 100644 arch/arm/mach-at91/gpio.c
 delete mode 100644 arch/arm/mach-at91/gpio.h
 delete mode 100644 arch/arm/mach-at91/gsia18s.h
 delete mode 100644 arch/arm/mach-at91/leds.c

-- 
Nicolas Ferre
