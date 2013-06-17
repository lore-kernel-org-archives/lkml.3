Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab3FQRpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:45:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41477 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3FQRnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:43:21 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>, Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH/RESEND 00/12] Convert MSM to common clock framework
Date: Mon, 17 Jun 2013 10:43:07 -0700
Message-Id: <1371490999-15501-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.378.g9926f66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending to collect higher level maintainer acks per Olof's request. 
The plan is to push this patchset through MSM to the arm-soc tree.

This patchset moves the existing MSM clock code and affected drivers to the
common clock framework. A prerequisite of moving to the common clock
framework is to use clk_prepare() and clk_enable() so the first
few patches migrate drivers to that call (clk_prepare() is a no-op on MSM
right now). It also removes some custom clock APIs that MSM provides
and finally moves the proc_comm clock code to the common struct clk.

This patch series will be used as the foundation of the MSM 8660/8960
clock code that I plan to send out after this series.

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
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

