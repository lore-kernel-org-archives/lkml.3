Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936066AbaBDWhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:37:11 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58093 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933521AbaBDWhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 17:37:07 -0500
From: Kumar Gala <galak@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: Kumar Gala <galak@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] Split mach-msm into legacy and mach-qcom (multiplatform)
Date: Tue,  4 Feb 2014 16:36:56 -0600
Message-Id: <1391553421-26914-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the splits the Qualcomm MSM platform into legacy support that we will
not try and convert to multiplatform and multiplatform support.

- k

Changes from v1:
* Added patch to remove hotplug.c
* Added patch to rename msm_ to qcom_
* Changes the Kconfig to drop CPU_V7
* used wfi() in cpu_die function
* Added git tree to MAINTAINERS file

Kumar Gala (5):
      ARM: msm: kill off hotplug.c
      clocksource: qcom: Move clocksource code out of mach-msm
      arm: qcom: Split Qualcomm support into legacy and multiplatform
      clocksource: qcom: split building of legacy vs multiplatform support
      ARM: qcom: Rename various msm prefixed functions to qcom

 arch/arm/mach-msm/board-dt.c       |   41 ----
 arch/arm/mach-msm/hotplug.c        |   51 -----
 arch/arm/mach-msm/platsmp.c        |  130 --------------
 arch/arm/mach-msm/scm-boot.c       |   39 ----
 arch/arm/mach-msm/scm-boot.h       |   22 --
 arch/arm/mach-msm/scm.c            |  299 ---------------------------------
 arch/arm/mach-msm/scm.h            |   25 --
 arch/arm/mach-msm/timer.c          |  333 -------------------------------------
 b/MAINTAINERS                      |    8 
 b/arch/arm/Kconfig                 |    7 
 b/arch/arm/Kconfig.debug           |    2 
 b/arch/arm/Makefile                |    1 
 b/arch/arm/boot/dts/Makefile       |    6 
 b/arch/arm/mach-msm/Kconfig        |   54 ------
 b/arch/arm/mach-msm/Makefile       |    8 
 b/arch/arm/mach-msm/common.h       |    1 
 b/arch/arm/mach-qcom/Kconfig       |   33 +++
 b/arch/arm/mach-qcom/Makefile      |    5 
 b/arch/arm/mach-qcom/board.c       |   40 ++++
 b/arch/arm/mach-qcom/scm-boot.c    |   39 ++++
 b/arch/arm/mach-qcom/scm-boot.h    |   22 ++
 b/arch/arm/mach-qcom/scm.c         |  299 +++++++++++++++++++++++++++++++++
 b/arch/arm/mach-qcom/scm.h         |   25 ++
 b/arch/arm/mach-qcom/smp.c         |  137 +++++++++++++++
 b/drivers/clocksource/Kconfig      |    4 
 b/drivers/clocksource/Makefile     |    1 
 b/drivers/clocksource/qcom-timer.c |  330 ++++++++++++++++++++++++++++++++++++
 27 files changed, 957 insertions(+), 1005 deletions(-)
