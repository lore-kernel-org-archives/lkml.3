Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3CNWMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:12:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52420 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3CNWML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:12:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@vger.kernel.org
Cc: patches@linaro.org, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/6] ARM platform spring cleaning
Date: Thu, 14 Mar 2013 23:12:02 +0100
Message-Id: <1363299128-8192-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:1lGU09/i+lR2dktZnDS+tZgSBWHGBdBP031DJUSDQaE
 bVAty7Z31ojcJlmfC/ym+j8sPDTcWRFqxJ6TxfvV8fJEoO3wav
 yz3h2bD6ZmB4IMxnoW4SXoqr0WO4eQt8fqIIIKsN72S5pwAfkY
 SobHHEUURki74H5wTbyPLjuURinODNHqyPIUE/lFs/SFGC4z0f
 Gx6hYAFho8XIaxO/hO1Ieh0cU2PYP+m5TvoL1auDklX/pwToCt
 cmgnzEHzJ3Wl160/HsvhJjrG5cgCb/W8ocDq24FTspq6jVxsBL
 tK9pk0qL+4LzJe8XDESho1sMfszmLVYNbdaQLiTPoDnJe1UwMK
 /VvBIUdYf/7EB+PGs6SaBY+I0NRtX7hhsGlwSE4++
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have discussed cleaning these up before, but we never actually
removed them. For all I can tell, none of these have any users
in the upstream kernel, so they can be removed. If you know of
anyone using them, please yell now, or send a revert patch
later if you really want them back.

Arnd Bergmann (6):
  ARM: gemini: get platform to build again
  ARM: gemini: remove platform support
  ARM: remove fa526 CPU support
  ARM: l7200: remove zombie file
  ARM: kill Hynix h720x platform
  mtd: remove h720x flash support

 MAINTAINERS                                     |  14 --
 arch/arm/Kconfig                                |  22 +-
 arch/arm/Makefile                               |   3 -
 arch/arm/boot/compressed/head.S                 |  28 ---
 arch/arm/configs/h7201_defconfig                |  27 ---
 arch/arm/configs/h7202_defconfig                |  47 ----
 arch/arm/include/asm/barrier.h                  |   6 -
 arch/arm/include/asm/glue-cache.h               |   8 -
 arch/arm/include/asm/glue-proc.h                |   9 -
 arch/arm/include/asm/page.h                     |   8 -
 arch/arm/include/asm/tlbflush.h                 |  19 --
 arch/arm/mach-gemini/Kconfig                    |  40 ----
 arch/arm/mach-gemini/Makefile                   |  13 --
 arch/arm/mach-gemini/Makefile.boot              |   9 -
 arch/arm/mach-gemini/board-nas4220b.c           | 106 ---------
 arch/arm/mach-gemini/board-rut1xx.c             |  90 --------
 arch/arm/mach-gemini/board-wbd111.c             | 133 ------------
 arch/arm/mach-gemini/board-wbd222.c             | 133 ------------
 arch/arm/mach-gemini/common.h                   |  29 ---
 arch/arm/mach-gemini/devices.c                  | 118 ----------
 arch/arm/mach-gemini/gpio.c                     | 230 --------------------
 arch/arm/mach-gemini/idle.c                     |  29 ---
 arch/arm/mach-gemini/include/mach/debug-macro.S |  21 --
 arch/arm/mach-gemini/include/mach/entry-macro.S |  33 ---
 arch/arm/mach-gemini/include/mach/global_reg.h  | 278 ------------------------
 arch/arm/mach-gemini/include/mach/gpio.h        |  20 --
 arch/arm/mach-gemini/include/mach/hardware.h    |  74 -------
 arch/arm/mach-gemini/include/mach/irqs.h        |  53 -----
 arch/arm/mach-gemini/include/mach/system.h      |  23 --
 arch/arm/mach-gemini/include/mach/timex.h       |  13 --
 arch/arm/mach-gemini/include/mach/uncompress.h  |  42 ----
 arch/arm/mach-gemini/irq.c                      | 103 ---------
 arch/arm/mach-gemini/mm.c                       |  82 -------
 arch/arm/mach-gemini/time.c                     |  89 --------
 arch/arm/mach-h720x/Kconfig                     |  40 ----
 arch/arm/mach-h720x/Makefile                    |  16 --
 arch/arm/mach-h720x/Makefile.boot               |   2 -
 arch/arm/mach-h720x/common.c                    | 268 -----------------------
 arch/arm/mach-h720x/common.h                    |  30 ---
 arch/arm/mach-h720x/cpu-h7201.c                 |  57 -----
 arch/arm/mach-h720x/cpu-h7202.c                 | 225 -------------------
 arch/arm/mach-h720x/h7201-eval.c                |  38 ----
 arch/arm/mach-h720x/h7202-eval.c                |  81 -------
 arch/arm/mach-h720x/include/mach/boards.h       |  53 -----
 arch/arm/mach-h720x/include/mach/debug-macro.S  |  40 ----
 arch/arm/mach-h720x/include/mach/entry-macro.S  |  57 -----
 arch/arm/mach-h720x/include/mach/h7201-regs.h   |  67 ------
 arch/arm/mach-h720x/include/mach/h7202-regs.h   | 155 -------------
 arch/arm/mach-h720x/include/mach/hardware.h     | 190 ----------------
 arch/arm/mach-h720x/include/mach/irqs.h         | 116 ----------
 arch/arm/mach-h720x/include/mach/isa-dma.h      |  19 --
 arch/arm/mach-h720x/include/mach/timex.h        |  15 --
 arch/arm/mach-h720x/include/mach/uncompress.h   |  36 ---
 arch/arm/mach-l7200/include/mach/debug-macro.S  |  38 ----
 arch/arm/mm/Kconfig                             |  32 +--
 arch/arm/mm/Makefile                            |   4 -
 arch/arm/mm/cache-fa.S                          | 249 ---------------------
 arch/arm/mm/copypage-fa.c                       |  86 --------
 arch/arm/mm/proc-fa526.S                        | 221 -------------------
 arch/arm/mm/tlb-fa.S                            |  69 ------
 drivers/mtd/maps/Kconfig                        |   7 -
 drivers/mtd/maps/Makefile                       |   1 -
 drivers/mtd/maps/h720x-flash.c                  | 120 ----------
 63 files changed, 3 insertions(+), 4281 deletions(-)
 delete mode 100644 arch/arm/configs/h7201_defconfig
 delete mode 100644 arch/arm/configs/h7202_defconfig
 delete mode 100644 arch/arm/mach-gemini/Kconfig
 delete mode 100644 arch/arm/mach-gemini/Makefile
 delete mode 100644 arch/arm/mach-gemini/Makefile.boot
 delete mode 100644 arch/arm/mach-gemini/board-nas4220b.c
 delete mode 100644 arch/arm/mach-gemini/board-rut1xx.c
 delete mode 100644 arch/arm/mach-gemini/board-wbd111.c
 delete mode 100644 arch/arm/mach-gemini/board-wbd222.c
 delete mode 100644 arch/arm/mach-gemini/common.h
 delete mode 100644 arch/arm/mach-gemini/devices.c
 delete mode 100644 arch/arm/mach-gemini/gpio.c
 delete mode 100644 arch/arm/mach-gemini/idle.c
 delete mode 100644 arch/arm/mach-gemini/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-gemini/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-gemini/include/mach/global_reg.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/system.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/timex.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-gemini/irq.c
 delete mode 100644 arch/arm/mach-gemini/mm.c
 delete mode 100644 arch/arm/mach-gemini/time.c
 delete mode 100644 arch/arm/mach-h720x/Kconfig
 delete mode 100644 arch/arm/mach-h720x/Makefile
 delete mode 100644 arch/arm/mach-h720x/Makefile.boot
 delete mode 100644 arch/arm/mach-h720x/common.c
 delete mode 100644 arch/arm/mach-h720x/common.h
 delete mode 100644 arch/arm/mach-h720x/cpu-h7201.c
 delete mode 100644 arch/arm/mach-h720x/cpu-h7202.c
 delete mode 100644 arch/arm/mach-h720x/h7201-eval.c
 delete mode 100644 arch/arm/mach-h720x/h7202-eval.c
 delete mode 100644 arch/arm/mach-h720x/include/mach/boards.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-h720x/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-h720x/include/mach/h7201-regs.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/h7202-regs.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/isa-dma.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/timex.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-l7200/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mm/cache-fa.S
 delete mode 100644 arch/arm/mm/copypage-fa.c
 delete mode 100644 arch/arm/mm/proc-fa526.S
 delete mode 100644 arch/arm/mm/tlb-fa.S
 delete mode 100644 drivers/mtd/maps/h720x-flash.c

-- 
1.8.1.2

