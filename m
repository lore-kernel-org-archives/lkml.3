Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaCMUgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 16:36:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57858 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259AbaCMUgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 16:36:17 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Rob Herring <robh@kernel.org>,
        Tero Kristo <t-kristo@ti.com>, Nishanth Menon <nm@ti.com>,
        Suman Anna <s-anna@ti.com>, Felipe Balbi <balbi@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC 0/5] Clocksource driver for OMAP SoCs
Date: Thu, 13 Mar 2014 15:35:14 -0500
Message-ID: <1394742919-32163-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's an RFC series for clocksource migration of OMAP timers.
This attempt is going to step-by-step attempt to migrate platforms
such that everything is kept working smoothly during migration. Currently
the series introduces a clocksource driver and migrates AM335x platform
to discuss the general idea.

The plan is to move dmtimer to clocksource (infact make a copy for now
so that platforms not migrated still work). Then we add a per-SoC clocksource
registration and select a timer as each of them are initialized by clocksource
(suggested in [1]).

We also add support for a generic timer init function which is called for
every SoC for which support in clocksource driver is available. And, we
call a generic OMAP power up function which is introduced in the mach-omap
layer in this series.

Lastly, we add clock nodes for the system timers, and setup a default-parent
so that the parent clocks are setup correctly. Due to this, the series depends
on Tero's series [2].

Please note- this effort is for system timer support. This is the first basic
step. Converting dmtimer to use any other generic framework is a completely
different topic and should not be discussed in this thread. It is something
that can be done only _after_ the work done in this series is completed, thanks.

[1] https://lkml.org/lkml/2013/11/23/88
[2] http://www.spinics.net/lists/linux-omap/msg103069.html

Joel Fernandes (5):
  ARM: dts: am33xx: Add clock nodes for timer1 and timer2
  ARM: dts: am33xx: Set parent clock for timer through DT
  ARM: OMAP2+: timer: Add clocksource initialization and powerup
    support
  clocksource: omap-timer: Introduce clocksource driver for OMAP SoCs
  ARM: AM33xx: Move to using omap_generic_timer_init for init_time

 arch/arm/boot/dts/am33xx.dtsi       |    4 +
 arch/arm/mach-omap2/board-generic.c |    2 +-
 arch/arm/mach-omap2/common.h        |    1 +
 arch/arm/mach-omap2/timer.c         |   28 +
 drivers/clocksource/Makefile        |    1 +
 drivers/clocksource/omap-timer.c    | 1157 +++++++++++++++++++++++++++++++++++
 drivers/clocksource/omap-timer.h    |  422 +++++++++++++
 7 files changed, 1614 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clocksource/omap-timer.c
 create mode 100644 drivers/clocksource/omap-timer.h

-- 
1.7.9.5

