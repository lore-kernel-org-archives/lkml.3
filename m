Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab3FNTxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:53:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48724 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab3FNTw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:52:58 -0400
Date: Fri, 14 Jun 2013 12:52:55 -0700
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL 3/3] msm clock for 3.11
Message-ID: <20130614195238.GA2381@codeaurora.org>
References: <1371232615-30731-1-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1371232615-30731-1-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-clock-for-3.11

for you to fetch changes up to f54c1c11053d8aaf318a096b8b332fd41a394a66:

  ARM: msm: Migrate to common clock framework (2013-06-12 14:43:31 -0700)

----------------------------------------------------------------
MSM clock updates for 3.11.

Per Stephen Boyd's coverletter:

This patchset moves the existing MSM clock code and affected drivers
to the common clock framework. A prerequisite of moving to the common
clock framework is to use clk_prepare() and clk_enable() so the first
few patches migrate drivers to that call (clk_prepare() is a no-op on
MSM right now). It also removes some custom clock APIs that MSM
provides and finally moves the proc_comm clock code to the common
struct clk.

This patch series will be used as the foundation of the MSM 8660/8960
clock code that I plan to send out after this series.

----------------------------------------------------------------
Stephen Boyd (12):
      msm_serial: Convert to clk_prepare/unprepare
      msm_serial: Use devm_clk_get() and properly return errors
      usb: otg: msm: Convert to clk_prepare/unprepare
      msm_sdcc: Convert to clk_prepare/unprepare
      msm: iommu: Convert to clk_prepare/unprepare
      msm: iommu: Use clk_set_rate() instead of clk_set_min_rate()
      ARM: msm: Remove custom clk_set_flags() API
      ARM: msm: Remove custom clk_set_{max,min}_rate() API
      ARM: msm: Remove clock-7x30.h include file
      ARM: msm: Prepare clk_get() users in mach-msm for clock-pcom driver
      ARM: msm: Make proc_comm clock control into a platform driver
      ARM: msm: Migrate to common clock framework

 arch/arm/Kconfig                       |   2 +-
 arch/arm/mach-msm/Makefile             |  10 +-
 arch/arm/mach-msm/board-halibut.c      |   2 +-
 arch/arm/mach-msm/board-msm7x30.c      |   2 +-
 arch/arm/mach-msm/board-qsd8x50.c      |   2 +-
 arch/arm/mach-msm/board-trout-panel.c  |  19 ++--
 arch/arm/mach-msm/board-trout.c        |   3 +-
 arch/arm/mach-msm/clock-7x30.h         | 155 ------------------------------
 arch/arm/mach-msm/clock-debug.c        | 130 --------------------------
 arch/arm/mach-msm/clock-pcom.c         | 149 ++++++++++++++++++-----------
 arch/arm/mach-msm/clock-pcom.h         |  31 +++---
 arch/arm/mach-msm/clock.c              | 166 +--------------------------------
 arch/arm/mach-msm/clock.h              |  51 +++-------
 arch/arm/mach-msm/devices-msm7x00.c    |  12 ++-
 arch/arm/mach-msm/devices-msm7x30.c    |  14 ++-
 arch/arm/mach-msm/devices-qsd8x50.c    |  11 ++-
 arch/arm/mach-msm/devices.h            |  15 +--
 arch/arm/mach-msm/dma.c                |   5 +-
 arch/arm/mach-msm/include/mach/board.h |   5 -
 arch/arm/mach-msm/include/mach/clk.h   |   9 --
 drivers/iommu/msm_iommu_dev.c          |  20 ++--
 drivers/mmc/host/msm_sdcc.c            |  14 ++-
 drivers/tty/serial/msm_serial.c        |  35 +++----
 drivers/usb/phy/phy-msm-usb.c          |  38 ++++----
 24 files changed, 241 insertions(+), 659 deletions(-)
 delete mode 100644 arch/arm/mach-msm/clock-7x30.h
 delete mode 100644 arch/arm/mach-msm/clock-debug.c

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
