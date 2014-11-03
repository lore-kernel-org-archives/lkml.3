Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaKCRy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:54:58 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:22044 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbaKCRyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:54:54 -0500
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
Subject: [GIT PULL] at91: cleanup for 3.19 #1
Date: Mon, 3 Nov 2014 18:54:47 +0100
Message-ID: <1415037288-4332-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

The pull-request that was sent late for 3.18. It was removing the old
!MMU at91x40 and 2 board files plus the whole code in at91sam9g45 & at91sam9rl
files for implementing this deprecated method. For these particular ones, the
EK were the only one to use this code.
We can use these boards with DT right now.

More code removal like that is shedulle for 3.19, so this is just a first set.

Thanks, best regards,

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-cleanup

for you to fetch changes up to bcf8c7e7703bb2bbde66bec26a81fed4be9cd1d4:

  ARM: at91: remove at91sam9rl legacy board support (2014-11-03 18:48:02 +0100)

----------------------------------------------------------------
First batch of cleanup/SoC for 3.19:
- removal of old at91x40 !MMU ARM7TDMI support which was kind of rusty
- removal of board-sam9m10g45ek.c and board-sam9rlek.c from mach-at91
  and the code related to these board C files + defconfigs. Use DT for them
  now!

----------------------------------------------------------------
Nicolas Ferre (3):
      ARM: at91: remove no-MMU at91x40 support
      ARM: at91: remove at91sam9g45/9m10 legacy board support
      ARM: at91: remove at91sam9rl legacy board support

 arch/arm/configs/at91sam9g45_defconfig       |  175 ---
 arch/arm/configs/at91sam9rl_defconfig        |   92 --
 arch/arm/configs/at91x40_defconfig           |   48 -
 arch/arm/mach-at91/Kconfig                   |   20 +-
 arch/arm/mach-at91/Kconfig.non_dt            |   58 -
 arch/arm/mach-at91/Makefile                  |   12 -
 arch/arm/mach-at91/at91sam9g45.c             |  448 ------
 arch/arm/mach-at91/at91sam9g45_devices.c     | 1915 --------------------------
 arch/arm/mach-at91/at91sam9rl.c              |  371 -----
 arch/arm/mach-at91/at91sam9rl_devices.c      | 1260 -----------------
 arch/arm/mach-at91/at91x40.c                 |   93 --
 arch/arm/mach-at91/at91x40_time.c            |   85 --
 arch/arm/mach-at91/board-eb01.c              |   52 -
 arch/arm/mach-at91/board-sam9m10g45ek.c      |  527 -------
 arch/arm/mach-at91/board-sam9rlek.c          |  333 -----
 arch/arm/mach-at91/generic.h                 |    3 -
 arch/arm/mach-at91/include/mach/at91_dbgu.h  |    3 -
 arch/arm/mach-at91/include/mach/at91x40.h    |   60 -
 arch/arm/mach-at91/include/mach/cpu.h        |    1 -
 arch/arm/mach-at91/include/mach/hardware.h   |    5 -
 arch/arm/mach-at91/include/mach/uncompress.h |    7 -
 arch/arm/mach-at91/setup.c                   |    2 +-
 drivers/rtc/Kconfig                          |    2 +-
 23 files changed, 5 insertions(+), 5567 deletions(-)
 delete mode 100644 arch/arm/configs/at91sam9g45_defconfig
 delete mode 100644 arch/arm/configs/at91sam9rl_defconfig
 delete mode 100644 arch/arm/configs/at91x40_defconfig
 delete mode 100644 arch/arm/mach-at91/at91sam9g45_devices.c
 delete mode 100644 arch/arm/mach-at91/at91sam9rl_devices.c
 delete mode 100644 arch/arm/mach-at91/at91x40.c
 delete mode 100644 arch/arm/mach-at91/at91x40_time.c
 delete mode 100644 arch/arm/mach-at91/board-eb01.c
 delete mode 100644 arch/arm/mach-at91/board-sam9m10g45ek.c
 delete mode 100644 arch/arm/mach-at91/board-sam9rlek.c
 delete mode 100644 arch/arm/mach-at91/include/mach/at91x40.h

-- 
Nicolas Ferre
