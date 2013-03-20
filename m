Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab3CTWya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:54:30 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:42902 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3CTWy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:54:29 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Arnd Bergmann <arnd@arndb.de>, linus.walleij@linaro.org,
        Russell King <linux@arm.linux.org.uk>, haojian.zhuang@linaro.org,
        pawel.moll@arm.com, john.stultz@linaro.org, tglx@linutronix.de,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 00/11] sp804 and integrator timer CLKSRC_OF support
Date: Wed, 20 Mar 2013 17:54:00 -0500
Message-Id: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This series add device-tree support using CLKSRC_OF for initialization
of integrator ap and cp timers and sp804 timers. The timer code for all
of these is moved to drivers/clocksource. The common DT based
initialization of sp804 is supported on highbank, versatile-ab and
vexpress. The DT init support is newly added for versatile-ab.

This series is dependent on my CLKSRC_OF clean-up in arm-soc, my
sched_clock selection series[1], and Arnd's default machine descriptor
patch (for default clocksource_of_init call). The full series is
available here:

git://sources.calxeda.com/kernel/linux.git arm-timers

http://sources.calxeda.com/gitweb/?p=kernel/linux.git;a=shortlog;h=refs/heads/arm-timers

I've tested integrator and versatile on qemu and on highbank h/w.

Rob

[1] http://comments.gmane.org/gmane.linux.ports.arm.kernel/222282

Haojian Zhuang (1):
  devtree: add binding documentation for sp804

Rob Herring (10):
  OF: add empty of_device_is_available for !OF
  ARM: remove extra timer-sp control register clearing
  ARM: timer-sp: convert to use CLKSRC_OF init
  ARM: highbank: use OF init for sp804 timer
  ARM: vexpress: remove sp804 OF init
  ARM: dts: vexpress: disable CA9 core tile sp804 timer
  ARM: versatile: add versatile dtbs to dtbs target
  ARM: versatile: use OF init for sp804 timer
  ARM: integrator-cp: convert use CLKSRC_OF for timer init
  ARM: move sp804 and integrator timers to drivers/clocksource

 .../devicetree/bindings/timer/arm,sp804.txt        |   29 +++
 arch/arm/Kconfig                                   |    5 -
 arch/arm/boot/dts/Makefile                         |    2 +
 arch/arm/boot/dts/integratorcp.dts                 |    6 +-
 arch/arm/boot/dts/versatile-ab.dts                 |   12 ++
 arch/arm/boot/dts/vexpress-v2p-ca9.dts             |    1 +
 arch/arm/common/Makefile                           |    1 -
 arch/arm/include/asm/hardware/timer-sp.h           |   15 --
 arch/arm/mach-highbank/highbank.c                  |   19 --
 arch/arm/mach-integrator/Kconfig                   |    1 +
 arch/arm/mach-integrator/integrator_ap.c           |  173 +-----------------
 arch/arm/mach-integrator/integrator_cp.c           |   42 +----
 arch/arm/mach-realview/core.c                      |   12 +-
 arch/arm/mach-versatile/core.c                     |   37 ++--
 arch/arm/mach-versatile/versatile_dt.c             |    1 -
 arch/arm/mach-vexpress/ct-ca9x4.c                  |    4 +-
 arch/arm/mach-vexpress/v2m.c                       |   17 +-
 drivers/clocksource/Kconfig                        |   12 ++
 drivers/clocksource/Makefile                       |    2 +
 .../hardware => drivers/clocksource}/arm_timer.h   |    6 +-
 drivers/clocksource/integrator_ap_timer.c          |  190 ++++++++++++++++++++
 .../arm/common => drivers/clocksource}/timer-sp.c  |  132 ++++++++++++--
 include/clocksource/integrator_ap_timer.h          |    7 +
 include/clocksource/timer-sp.h                     |   31 ++++
 include/linux/of.h                                 |    5 +
 25 files changed, 429 insertions(+), 333 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/timer/arm,sp804.txt
 delete mode 100644 arch/arm/include/asm/hardware/timer-sp.h
 rename {arch/arm/include/asm/hardware => drivers/clocksource}/arm_timer.h (89%)
 create mode 100644 drivers/clocksource/integrator_ap_timer.c
 rename {arch/arm/common => drivers/clocksource}/timer-sp.c (60%)
 create mode 100644 include/clocksource/integrator_ap_timer.h
 create mode 100644 include/clocksource/timer-sp.h

-- 
1.7.10.4

