Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab3JQQiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:38:24 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62361 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab3JQQh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:37:59 -0400
From: Fan Rong <cinifr@gmail.com>
To: coosty@163.com, maxime.ripard@free-electrons.com,
        daniel.lezcano@linaro.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Cc: Fan Rong <cinifr@gmail.com>
Subject: [Add SMP support for Allwinner A20: PATCH V5 0/3] 
Date: Fri, 18 Oct 2013 00:37:04 +0800
Message-Id: <1382027827-10080-1-git-send-email-cinifr@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V1 V2:
The patchs add smp support for Allwinner A20. It add cpuregister node in dts for smp configure. The patchs also add a options for phy count timer to replace vir count timer as ARM arch timer clocksource.
V3 Changes since V2:
It delete platform.h and delete some code in platsmp.c that's not necessary. It delete phy count timer support because most linux kernel platform want to use vir count timer especially for kvm. SMP need arch timer as clocksource, It does use virtual counter timer and  no longer use physical counter timer, so bootloader ***must*** set CNTVOFF register for a20 before kernel booting. I have add support set CNTVOFF register for uboot, if you want to test it in a20 board, you need update your sunxi uboot from: https://groups.google.com/forum/#!topic/linux-sunxi/O0Za7H5_jQI
V4 Changes since V3:
It use smp_prepare_cpus replacing early_init as cpuconfigure map init funcation caller and use sun7i replacing sunxi7i as funcation name and variable name.
V5 Changes since V4:
Move smp from struct DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tree)") to struct DT_MACHINE_START(SUN7I_DT, "Allwinner sun7i (A20) Family") in file sunxi.c

*** BLURB HERE ***

Fan Rong (3):
  Add smp support for Allwinner A20(sunxi 7i).
  Add cpuconfig nodes in dts for smp configure.
  Add arch count timer node in dts for Allwinner A20(sunxi 7i).

 arch/arm/boot/dts/sun7i-a20.dtsi |  15 ++++++
 arch/arm/mach-sunxi/Makefile     |   2 +
 arch/arm/mach-sunxi/headsmp.S    |  18 +++++++
 arch/arm/mach-sunxi/platsmp.c    | 114 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-sunxi/sunxi.c      |   3 ++
 5 files changed, 152 insertions(+)
 create mode 100644 arch/arm/mach-sunxi/headsmp.S
 create mode 100644 arch/arm/mach-sunxi/platsmp.c
 mode change 100644 => 100755 arch/arm/mach-sunxi/sunxi.c

-- 
1.8.1.2

