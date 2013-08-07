Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894Ab3HGXGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 19:06:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39920 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933540Ab3HGXGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 19:06:46 -0400
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Subject: [GIT PULL v2] msm cleanups for v3.12
Date: Wed,  7 Aug 2013 16:06:32 -0700
Message-Id: <1375916792-24408-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375909096-22088-1-git-send-email-davidb@codeaurora.org>
References: <1375909096-22088-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-cleanup3-for-3.12

for you to fetch changes up to 3294a7e7c3a55bb4eb9d98b0af5643a7ea44afe1:

  ARM: msm: Only compile io.c on platforms that use it (2013-08-06 11:18:04 -0700)

----------------------------------------------------------------
General cleanups for MSM for 3.12

This is a series of cleanups to the MSM code.  These are a healthy
start to bringing the MSM code closer to the state of current ARM code
and getting more of it ready for conversion to devicetree.

----------------------------------------------------------------

Otherwise, same as last pull with head commit dropped.

Rohit Vaswani (1):
      ARM: msm: Remove unused and unmapped MSM_TLMM_BASE for 8x60

Stephen Boyd (8):
      ARM: msm: Don't compile __msm_ioremap_caller() unless used
      ARM: msm: Move debug-macro.S to include/debug
      ARM: msm: Remove TMR and TMR0 static mappings
      ARM: msm: Migrate msm_timer to CLOCKSOURCE_OF_DECLARE
      ARM: msm: Move mach/board.h contents to common.h
      ARM: msm: Remove devices-iommu.c
      iommu/msm: Move mach includes to iommu directory
      ARM: msm: Only compile io.c on platforms that use it

 arch/arm/Kconfig                                   |   1 +
 arch/arm/Kconfig.debug                             |   9 +-
 .../mach/debug-macro.S => include/debug/msm.S}     |  32 +-
 arch/arm/mach-msm/Makefile                         |   9 +-
 arch/arm/mach-msm/board-dt-8660.c                  |   4 +-
 arch/arm/mach-msm/board-dt-8960.c                  |   3 +-
 arch/arm/mach-msm/board-halibut.c                  |   1 -
 arch/arm/mach-msm/board-mahimahi.c                 |   2 +-
 arch/arm/mach-msm/board-msm7x30.c                  |   1 -
 arch/arm/mach-msm/board-qsd8x50.c                  |   1 -
 arch/arm/mach-msm/board-sapphire.c                 |   2 +-
 arch/arm/mach-msm/board-trout.c                    |   1 -
 arch/arm/mach-msm/board-trout.h                    |   2 +-
 arch/arm/mach-msm/common.h                         |  18 +-
 arch/arm/mach-msm/devices-iommu.c                  | 912 ---------------------
 arch/arm/mach-msm/devices-msm7x30.c                |   2 +-
 arch/arm/mach-msm/devices-qsd8x50.c                |   2 +-
 arch/arm/mach-msm/include/mach/board.h             |  38 -
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h    |  46 --
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h    |  53 --
 arch/arm/mach-msm/include/mach/msm_iomap.h         |  17 -
 arch/arm/mach-msm/include/mach/uncompress.h        |  63 --
 arch/arm/mach-msm/io.c                             |  67 +-
 arch/arm/mach-msm/timer.c                          |  17 +-
 drivers/iommu/msm_iommu.c                          |   4 +-
 .../mach/iommu.h => drivers/iommu/msm_iommu.h      |   0
 drivers/iommu/msm_iommu_dev.c                      |   4 +-
 .../iommu/msm_iommu_hw-8xxx.h                      |   0
 drivers/video/msm/msm_fb.c                         |   1 -
 29 files changed, 93 insertions(+), 1219 deletions(-)
 rename arch/arm/{mach-msm/include/mach/debug-macro.S => include/debug/msm.S} (61%)
 delete mode 100644 arch/arm/mach-msm/devices-iommu.c
 delete mode 100644 arch/arm/mach-msm/include/mach/board.h
 delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8960.h
 delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
 delete mode 100644 arch/arm/mach-msm/include/mach/uncompress.h
 rename arch/arm/mach-msm/include/mach/iommu.h => drivers/iommu/msm_iommu.h (100%)
 rename arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h => drivers/iommu/msm_iommu_hw-8xxx.h (100%)
