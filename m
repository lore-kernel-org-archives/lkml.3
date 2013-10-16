Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761928Ab3JPURJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:17:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41811 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761651Ab3JPURH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:17:07 -0400
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: [GIT PULL] msm cleanups for v3.13
Date: Wed, 16 Oct 2013 13:16:57 -0700
Message-Id: <1381954617-2431-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-cleanup-for-3.13

for you to fetch changes up to 81cf1e061d001fab44dbaa85fc4fbfb6da6713a1:

  ARM: msm: Rename msm devicetrees to have standard 'qcom' prefix (2013-09-25 13:02:56 -0700)

----------------------------------------------------------------
General cleanups for MSM for 3.13

Some small cleanups for MSM.  Removes extraneous irq definitions that
aren't used on DT targets, moves the single existing board file to
board-dt.c in antipication of additional targets, and renames the
existing DT files to have a common 'qcom' prefix.

----------------------------------------------------------------
Kumar Gala (1):
      ARM: msm: Rename msm devicetrees to have standard 'qcom' prefix

Rohit Vaswani (1):
      ARM: msm: Create a common board-dt and config ARCH_MSM_DT

Stephen Boyd (1):
      ARM: msm: Remove irqs-*.h files for DT based targets

 arch/arm/boot/dts/Makefile                         |   4 +-
 .../{msm8660-surf.dts => qcom-msm8660-surf.dts}    |   0
 .../dts/{msm8960-cdp.dts => qcom-msm8960-cdp.dts}  |   0
 arch/arm/mach-msm/Kconfig                          |  13 +-
 arch/arm/mach-msm/Makefile                         |   3 +-
 arch/arm/mach-msm/board-dt-8660.c                  |  48 ----
 arch/arm/mach-msm/{board-dt-8960.c => board-dt.c}  |  17 +-
 arch/arm/mach-msm/include/mach/irqs-8960.h         | 277 ---------------------
 arch/arm/mach-msm/include/mach/irqs-8x60.h         | 258 -------------------
 arch/arm/mach-msm/include/mach/irqs.h              |   5 -
 10 files changed, 20 insertions(+), 605 deletions(-)
 rename arch/arm/boot/dts/{msm8660-surf.dts => qcom-msm8660-surf.dts} (100%)
 rename arch/arm/boot/dts/{msm8960-cdp.dts => qcom-msm8960-cdp.dts} (100%)
 delete mode 100644 arch/arm/mach-msm/board-dt-8660.c
 rename arch/arm/mach-msm/{board-dt-8960.c => board-dt.c} (64%)
 delete mode 100644 arch/arm/mach-msm/include/mach/irqs-8960.h
 delete mode 100644 arch/arm/mach-msm/include/mach/irqs-8x60.h
