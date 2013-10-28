Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab3J1Une (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 16:43:34 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51827 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3J1Unc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 16:43:32 -0400
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/4] Remove older ARM msm SoC support
Date: Mon, 28 Oct 2013 13:43:22 -0700
Message-Id: <1382993006-27359-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Over the past few years, the ARM msm SoC tree has picked up support
for a handfull of SoCs.  Each of these targets had a brief period of
activity, and has since only received trivial fixes.  Support has only
been minimal, generally serial console, and possibly storage.  None of
these saw conversion to device tree, and they contain a lot of headers
and other aspects that prevent use in the ARM multi-platform kernel.

Current activity on MSM seems to be focused on newer SoCs.  These
devices have the advantage of having dev-boards available, so
hopefully there will be more community activity.  There also seems to
be effort into better DT and multi-platform support on these targets,
but not the older ones.

This patch series removes support for the three older Qualcomm SoC
families: 7x00, 7x30, and 8x50.

If there is a serious desire to support any of these SoCs, patches
that make them properly support DT, and multi-platform can begin by
adding the necessary files back.

Note that because these patches remove a lot of lines of code, and the
lengths exceed the size typically allowed on the mailing lists, I've
generated the patches with the '-D' option to format-patch.  I can
send full patches on request, and I've also made the patches available
at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git for-3.14/big-cleanup

David Brown (4):
  ARM: msm: Remove unused board files
  ARM: msm: Remove 7x00 support
  ARM: msm: Remove 7x30 support
  ARM: msm: Remove 8x50 support

 arch/arm/mach-msm/Kconfig                       |  104 ---
 arch/arm/mach-msm/Makefile                      |   20 -
 arch/arm/mach-msm/board-halibut.c               |  110 ---
 arch/arm/mach-msm/board-mahimahi.c              |   88 --
 arch/arm/mach-msm/board-msm7x30.c               |  157 ----
 arch/arm/mach-msm/board-qsd8x50.c               |  213 -----
 arch/arm/mach-msm/board-sapphire.c              |  117 ---
 arch/arm/mach-msm/board-trout-gpio.c            |  233 -----
 arch/arm/mach-msm/board-trout-mmc.c             |  185 ----
 arch/arm/mach-msm/board-trout-panel.c           |  292 -------
 arch/arm/mach-msm/board-trout.c                 |  113 ---
 arch/arm/mach-msm/board-trout.h                 |  162 ----
 arch/arm/mach-msm/clock-pcom.c                  |  177 ----
 arch/arm/mach-msm/clock-pcom.h                  |  145 ----
 arch/arm/mach-msm/devices-msm7x00.c             |  480 -----------
 arch/arm/mach-msm/devices-msm7x30.c             |  246 ------
 arch/arm/mach-msm/devices-qsd8x50.c             |  388 ---------
 arch/arm/mach-msm/devices.h                     |   53 --
 arch/arm/mach-msm/dma.c                         |  295 -------
 arch/arm/mach-msm/gpiomux-8x50.c                |   51 --
 arch/arm/mach-msm/gpiomux-v1.h                  |   67 --
 arch/arm/mach-msm/gpiomux.c                     |  111 ---
 arch/arm/mach-msm/gpiomux.h                     |   84 --
 arch/arm/mach-msm/include/mach/entry-macro.S    |   36 -
 arch/arm/mach-msm/include/mach/hardware.h       |   18 -
 arch/arm/mach-msm/include/mach/irqs-7x00.h      |   75 --
 arch/arm/mach-msm/include/mach/irqs-7x30.h      |  153 ----
 arch/arm/mach-msm/include/mach/irqs-8x50.h      |   88 --
 arch/arm/mach-msm/include/mach/irqs.h           |   37 -
 arch/arm/mach-msm/include/mach/msm_gpiomux.h    |   38 -
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h |  108 ---
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h |  103 ---
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h |  125 ---
 arch/arm/mach-msm/include/mach/msm_iomap.h      |   53 --
 arch/arm/mach-msm/include/mach/msm_smd.h        |  109 ---
 arch/arm/mach-msm/include/mach/sirc.h           |   98 ---
 arch/arm/mach-msm/include/mach/vreg.h           |   29 -
 arch/arm/mach-msm/io.c                          |  161 ----
 arch/arm/mach-msm/irq-vic.c                     |  363 --------
 arch/arm/mach-msm/irq.c                         |  151 ----
 arch/arm/mach-msm/last_radio_log.c              |   71 --
 arch/arm/mach-msm/proc_comm.c                   |  129 ---
 arch/arm/mach-msm/proc_comm.h                   |  258 ------
 arch/arm/mach-msm/sirc.c                        |  172 ----
 arch/arm/mach-msm/smd.c                         | 1035 -----------------------
 arch/arm/mach-msm/smd_debug.c                   |  311 -------
 arch/arm/mach-msm/smd_private.h                 |  403 ---------
 arch/arm/mach-msm/vreg.c                        |  220 -----
 48 files changed, 8235 deletions(-)
 delete mode 100644 arch/arm/mach-msm/board-halibut.c
 delete mode 100644 arch/arm/mach-msm/board-mahimahi.c
 delete mode 100644 arch/arm/mach-msm/board-msm7x30.c
 delete mode 100644 arch/arm/mach-msm/board-qsd8x50.c
 delete mode 100644 arch/arm/mach-msm/board-sapphire.c
 delete mode 100644 arch/arm/mach-msm/board-trout-gpio.c
 delete mode 100644 arch/arm/mach-msm/board-trout-mmc.c
 delete mode 100644 arch/arm/mach-msm/board-trout-panel.c
 delete mode 100644 arch/arm/mach-msm/board-trout.c
 delete mode 100644 arch/arm/mach-msm/board-trout.h
 delete mode 100644 arch/arm/mach-msm/clock-pcom.c
 delete mode 100644 arch/arm/mach-msm/clock-pcom.h
 delete mode 100644 arch/arm/mach-msm/devices-msm7x00.c
 delete mode 100644 arch/arm/mach-msm/devices-msm7x30.c
 delete mode 100644 arch/arm/mach-msm/devices-qsd8x50.c
 delete mode 100644 arch/arm/mach-msm/devices.h
 delete mode 100644 arch/arm/mach-msm/dma.c
 delete mode 100644 arch/arm/mach-msm/gpiomux-8x50.c
 delete mode 100644 arch/arm/mach-msm/gpiomux-v1.h
 delete mode 100644 arch/arm/mach-msm/gpiomux.c
 delete mode 100644 arch/arm/mach-msm/gpiomux.h
 delete mode 100644 arch/arm/mach-msm/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-msm/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-msm/include/mach/irqs-7x00.h
 delete mode 100644 arch/arm/mach-msm/include/mach/irqs-7x30.h
 delete mode 100644 arch/arm/mach-msm/include/mach/irqs-8x50.h
 delete mode 100644 arch/arm/mach-msm/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-msm/include/mach/msm_gpiomux.h
 delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
 delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
 delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
 delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap.h
 delete mode 100644 arch/arm/mach-msm/include/mach/msm_smd.h
 delete mode 100644 arch/arm/mach-msm/include/mach/sirc.h
 delete mode 100644 arch/arm/mach-msm/include/mach/vreg.h
 delete mode 100644 arch/arm/mach-msm/io.c
 delete mode 100644 arch/arm/mach-msm/irq-vic.c
 delete mode 100644 arch/arm/mach-msm/irq.c
 delete mode 100644 arch/arm/mach-msm/last_radio_log.c
 delete mode 100644 arch/arm/mach-msm/proc_comm.c
 delete mode 100644 arch/arm/mach-msm/proc_comm.h
 delete mode 100644 arch/arm/mach-msm/sirc.c
 delete mode 100644 arch/arm/mach-msm/smd.c
 delete mode 100644 arch/arm/mach-msm/smd_debug.c
 delete mode 100644 arch/arm/mach-msm/smd_private.h
 delete mode 100644 arch/arm/mach-msm/vreg.c

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

