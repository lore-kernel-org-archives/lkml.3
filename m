Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab3ETGdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:33:17 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53872 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3ETGdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:33:16 -0400
From: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Sanjay Singh Rawat <sanjay.rawat@linaro.org>
Subject: [RFC PATCH 0/6] ARM: cpuhotplug: move common functions to core
Date: Mon, 20 May 2013 12:03:22 +0530
Message-Id: <1369031608-27347-1-git-send-email-sanjay.rawat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various SoCs with arm processors define their own platform hotplug related
functions. These functions can be defined as part of the core cpu hotplug
functions, this will avoid the duplication. This patchset is intended to
address this issue.

This patchset covers arm-Cortex-A9 of exynos, imx, realview, spear and
vexpress SoCs. Not having h/w, the patch is not tested.

Sanjay Singh Rawat (6):
  ARM: cpuhotplug: move common hotplug related functions to core
  ARM: imx: use the core cpu hotplug functions
  ARM: RealView: use the core cpu hotplug functions
  ARM: spear: use the core cpu hotplug functions
  ARM: vexpress: use the core cpu hotplug functions
  ARM: EXYNOS: use the core cpu hotplug functions

 arch/arm/include/asm/hotplug.h   |   24 ++++++++++++++
 arch/arm/kernel/Makefile         |    1 +
 arch/arm/kernel/cpuhotplug.c     |   64 ++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/hotplug.c   |   40 ++----------------------
 arch/arm/mach-imx/hotplug.c      |   22 +------------
 arch/arm/mach-realview/hotplug.c |   37 +---------------------
 arch/arm/mach-spear/hotplug.c    |   37 +---------------------
 arch/arm/mach-vexpress/hotplug.c |   38 +---------------------
 8 files changed, 95 insertions(+), 168 deletions(-)
 create mode 100644 arch/arm/include/asm/hotplug.h
 create mode 100644 arch/arm/kernel/cpuhotplug.c

-- 
1.7.9.5

