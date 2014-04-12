Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbaDLBPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 21:15:14 -0400
Received: from mail.kernel.org ([198.145.19.201]:55204 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343AbaDLBPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 21:15:11 -0400
From: Steven Miao <realmz6@kernel.org>
To: torvalds@linux-foundation.org
Cc: adi-buildroot-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [uclinux-dist-devel] [GIT PULL] Blackfin updates for 3.15
Date: Sat, 12 Apr 2014 09:13:02 +0800
Message-Id: <1397265182-2830-1-git-send-email-realmz6@kernel.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please pull blackfin updates for Linux 3.15, code cleanup, some previously ignored patches,
and bug fixes.

The following changes since commit 455c6fdbd219161bd09b1165f11699d6d73de11c:

  Linux 3.14 (2014-03-30 20:40:15 -0700)

are available in the git repository at:

  http://git.kernel.org/pub/scm/linux/kernel/git/realmz6/blackfin-linux.git tags/blackfin-for-linus

for you to fetch changes up to c4a2c58d20953ff1080f50f705cdd952f6d301b2:

  blackfin: cleanup board files (2014-04-12 08:48:01 +0800)

----------------------------------------------------------------
blackfin updates for Linux 3.15

----------------------------------------------------------------
Paul Bolle (7):
      blackfin: bf60x: fix typo "CONFIG_PM_BFIN_WAKE_PA15_POL"
      blackfin: Remove GENERIC_GPIO config option again
      Blackfin: remove "config IP_CHECKSUM_L1"
      blackfin: bf537: fix typo "CONFIG_SND_SOC_ADV80X_MODULE"
      Blackfin: bf537: rename ad2s120x ->ad2s1200
      Blackfin: bf537: rename "CONFIG_AD7314"
      Blackfin: bf537: rename "CONFIG_ADT75"

Sonic Zhang (2):
      bfin_crc: Move architecture independant crc header file out of the blackfin folder.
      blackfin: dma: current count mmr is read only

Steven Miao (4):
      blackfin: portmux: cleanup head file
      bf54x: drop unuesd HOST status,control,timeout registers bit define macros
      bf609: clock: drop unused clock bit set/clear functions
      blackfin: cleanup board files

Thomas Gleixner (1):
      blackfin:Use generic /proc/interrupts implementation

 arch/blackfin/Kconfig                            |   12 +-
 arch/blackfin/include/asm/bfin_crc.h             |  125 -------
 arch/blackfin/include/asm/dma.h                  |    2 -
 arch/blackfin/include/asm/portmux.h              |   10 +-
 arch/blackfin/kernel/irqchip.c                   |   39 +-
 arch/blackfin/mach-bf518/boards/ezbrd.c          |   87 +++--
 arch/blackfin/mach-bf518/boards/tcm-bf518.c      |   64 ++--
 arch/blackfin/mach-bf527/boards/ad7160eval.c     |   71 ++--
 arch/blackfin/mach-bf527/boards/cm_bf527.c       |   91 +++--
 arch/blackfin/mach-bf527/boards/ezbrd.c          |   76 ++--
 arch/blackfin/mach-bf527/boards/ezkit.c          |  139 ++++---
 arch/blackfin/mach-bf527/boards/tll6527m.c       |   91 +++--
 arch/blackfin/mach-bf533/boards/H8606.c          |   46 +--
 arch/blackfin/mach-bf533/boards/blackstamp.c     |   44 +--
 arch/blackfin/mach-bf533/boards/cm_bf533.c       |   54 +--
 arch/blackfin/mach-bf533/boards/ezkit.c          |   56 +--
 arch/blackfin/mach-bf533/boards/ip0x.c           |   26 +-
 arch/blackfin/mach-bf533/boards/stamp.c          |  118 +++---
 arch/blackfin/mach-bf537/boards/cm_bf537e.c      |   82 ++---
 arch/blackfin/mach-bf537/boards/cm_bf537u.c      |   70 ++--
 arch/blackfin/mach-bf537/boards/dnp5370.c        |   32 +-
 arch/blackfin/mach-bf537/boards/minotaur.c       |   50 ++-
 arch/blackfin/mach-bf537/boards/pnav10.c         |   55 ++-
 arch/blackfin/mach-bf537/boards/stamp.c          |  425 ++++++++++------------
 arch/blackfin/mach-bf537/boards/tcm_bf537.c      |   70 ++--
 arch/blackfin/mach-bf538/boards/ezkit.c          |   62 ++--
 arch/blackfin/mach-bf548/boards/cm_bf548.c       |   78 ++--
 arch/blackfin/mach-bf548/boards/ezkit.c          |  136 ++++---
 arch/blackfin/mach-bf548/include/mach/defBF544.h |   30 --
 arch/blackfin/mach-bf548/include/mach/defBF547.h |   30 --
 arch/blackfin/mach-bf561/boards/acvilon.c        |   28 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c       |   56 +--
 arch/blackfin/mach-bf561/boards/ezkit.c          |   74 ++--
 arch/blackfin/mach-bf561/boards/tepla.c          |    8 +-
 arch/blackfin/mach-bf609/boards/ezkit.c          |  131 +++----
 arch/blackfin/mach-bf609/clock.c                 |   18 -
 arch/blackfin/mach-bf609/pm.c                    |    2 +-
 37 files changed, 1115 insertions(+), 1473 deletions(-)
 delete mode 100644 arch/blackfin/include/asm/bfin_crc.h
