Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab3ILGv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:51:59 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:64917 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab3ILGv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:51:57 -0400
From: Fan Rong <cinifr@gmail.com>
To: coosty@163.com, maxime.ripard@free-electrons.com,
        daniel.lezcano@linaro.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.co, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Cc: Fan Rong <cinifr@gmail.com>
Subject: [PATCH 0/4] Add smp support for Allwinner A20 and phy arch count timer
Date: Thu, 12 Sep 2013 14:51:23 +0800
Message-Id: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patchs add smp support for Allwinner A20. It add cpuregister node in dts forsmp configure. The patchs also add a options for phy count timer to replace vir count timer as ARM arch timer clocksource. About ARM arch timer: 1. Current kernel use vir count timer, vir count timer can be accessed in any cpu mode for kernel, but it need bootloader set vir count offset rigister zero at first. 2. Phy count timer can be accessed in most cpu mode for kernel except NS-PL1 mode when register CNTHCTL.PL1PCTEN is set to zero. To ensure to use phy count timer, bootloader should set register CNTHCTL.PL1PCTEN is 1 at first. At all, to ensure kernel can use arch timer, bootload should set some generic timer register(cntvoff or cnthctl) at first. the kernel should select  which count timer by reading current kernel running mode. 

Fan Rong (4):
  Add smp support for Allwinner A20(sunxi 7i).
  Add cpuconfig nodes in dts for smp configure.
  Add physical count arch timer support for clocksource in ARMv7.
  Add arch count timer node in dts for Allwinner A20(sunxi 7i).

 arch/arm/boot/dts/sun7i-a20.dtsi     |   18 +-
 arch/arm/include/asm/arch_timer.h    |   11 ++
 arch/arm/mach-sunxi/Makefile         |    2 +
 arch/arm/mach-sunxi/headsmp.S        |   12 ++
 arch/arm/mach-sunxi/platform.h       |  346 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-sunxi/platsmp.c        |  166 ++++++++++++++++
 arch/arm/mach-sunxi/sunxi.c          |    4 +
 drivers/clocksource/Kconfig          |    8 +
 drivers/clocksource/arm_arch_timer.c |   10 +-
 9 files changed, 574 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mach-sunxi/headsmp.S
 create mode 100644 arch/arm/mach-sunxi/platform.h
 create mode 100644 arch/arm/mach-sunxi/platsmp.c

-- 
1.7.9.5

