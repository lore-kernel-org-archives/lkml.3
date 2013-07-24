Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3GXUyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:54:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52732 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3GXUyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:54:37 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH v2 0/9] Move MSM closer to multi-platform
Date: Wed, 24 Jul 2013 13:54:25 -0700
Message-Id: <1374699274-18388-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.4.840.g6a90778
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are a set of patches that move MSM closer to multi-platform
but still keep everything compiling. We still have to tackle
reset and dma, but these patches shouldn't be controversial.

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

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

