Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab3I0CZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 22:25:31 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:46648 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3I0CZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 22:25:28 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v4 0/6] PSCI support for highbank
Date: Thu, 26 Sep 2013 21:24:48 -0500
Message-Id: <1380248694-13388-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This series converts highbank to use PSCI calls for smp_ops, suspend and
cpuidle. I've dropped system reset and poweroff until we can finalize
PSCI 0.2 bindings. Otherwise, this is mostly unchanged from the previous
posting.

New in this posting is enabling cpuidle on ecx-2000.

Rob Herring (6):
  cpuidle: calxeda: add support to use PSCI calls
  cpuidle: calxeda: add cpu_pm_enter/exit calls
  cpuidle: calxeda: add ecx-2000 support
  ARM: PSCI: remove unnecessary include of arm-gic.h
  ARM: highbank: adapt to use ARM PSCI calls
  dts: calxeda: add ARM PSCI binding

 arch/arm/boot/dts/ecx-common.dtsi |  8 +++++
 arch/arm/kernel/psci_smp.c        |  1 -
 arch/arm/mach-highbank/Kconfig    |  1 +
 arch/arm/mach-highbank/Makefile   |  2 --
 arch/arm/mach-highbank/core.h     |  4 ---
 arch/arm/mach-highbank/highbank.c | 16 +--------
 arch/arm/mach-highbank/hotplug.c  | 37 ---------------------
 arch/arm/mach-highbank/platsmp.c  | 68 ---------------------------------------
 arch/arm/mach-highbank/pm.c       | 27 ++++++----------
 drivers/cpuidle/Kconfig.arm       |  2 +-
 drivers/cpuidle/cpuidle-calxeda.c | 46 +++++++-------------------
 11 files changed, 32 insertions(+), 180 deletions(-)
 delete mode 100644 arch/arm/mach-highbank/hotplug.c
 delete mode 100644 arch/arm/mach-highbank/platsmp.c

-- 
1.8.1.2

