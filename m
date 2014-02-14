Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaBNA7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:59:08 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37455 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBNA7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:59:06 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 00/27] Renesas CMT (Compare Match Timer) DT bindings
Date: Fri, 14 Feb 2014 01:59:38 +0100
Message-Id: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch set adds DT support to the Renesas CMT driver.

The first 14 patches are a bunch of necessary cleanups that reorganize the
driver, its platform data, and the memory, interrupt and clock resources it
expects. As a result the driver accepts a new platform data model close to the
hardware with supports for all the timer channels using a single device.

The next 7 patches (15 to 21) move all platforms from the old to the new
platform data model. Patch 22 then drops support for the old model, and patch
23 finally adds DT support.

Patches 24 to 27 then add the CMT devices to the r8a7790 and r8a7791 device
trees, and enable them for the lager-reference and koelsch-reference boards.

The patches are based on top of Simon's latest devel branch with the
"[PATCH v4 0/2] [RESEND] Lager and Koelsch reference serial port support"
series applied.

Laurent Pinchart (27):
  clocksource: sh_cmt: Split channel fields from sh_cmt_priv
  clocksource: sh_cmt: Rename struct sh_cmt_priv to sh_cmt_device
  clocksource: sh_cmt: Split channel setup to separate function
  clocksource: sh_cmt: Rename mapbase/mapbase_str to mapbase_ch/mapbase
  clocksource: sh_cmt: Add memory base to sh_cmt_channel structure
  clocksource: sh_cmt: Add index to struct sh_cmt_channel
  clocksource: sh_cmt: Replace kmalloc + memset with kzalloc
  clocksource: sh_cmt: Allocate channels dynamically
  clocksource: sh_cmt: Split static information from sh_cmt_device
  clocksource: sh_cmt: Replace hardcoded register values with macros
  clocksource: sh_cmt: Add support for multiple channels per device
  clocksource: sh_cmt: Acquire default clock in the non-legacy case
  clocksource: sh_cmt: Remove FSF mail address from GPL notice
  clocksource: sh_cmt: Sort headers alphabetically
  sh: Switch to new style CMT device
  ARM: shmobile: sh7372: Switch to new style CMT device
  ARM: shmobile: sh73a0: Switch to new style CMT device
  ARM: shmobile: r8a73a4: Switch to new style CMT device
  ARM: shmobile: r8a7740: Switch to new style CMT device
  ARM: shmobile: r8a7790: Switch to new style CMT device
  ARM: shmobile: r8a7791: Switch to new style CMT device
  clocksource: sh_cmt: Drop support for legacy platform data
  clocksource: sh_cmt: Add DT support
  ARM: shmobile: r8a7790: Add CMT devices to DT
  ARM: shmobile: r8a7791: Add CMT devices to DT
  ARM: shmobile: lager-reference: Enable CMT0 in device tree
  ARM: shmobile: koelsch-reference: Enable CMT0 in device tree

 .../devicetree/bindings/timer/renesas,cmt.txt      |  75 ++
 arch/arm/boot/dts/r8a7790-lager.dts                |   9 +
 arch/arm/boot/dts/r8a7790.dtsi                     |  38 +
 arch/arm/boot/dts/r8a7791-koelsch.dts              |   9 +
 arch/arm/boot/dts/r8a7791.dtsi                     |  38 +
 arch/arm/mach-shmobile/board-koelsch-reference.c   |  15 +-
 arch/arm/mach-shmobile/board-lager-reference.c     |  15 +-
 arch/arm/mach-shmobile/clock-r8a73a4.c             |   2 +-
 arch/arm/mach-shmobile/clock-r8a7740.c             |   2 +-
 arch/arm/mach-shmobile/clock-r8a7790.c             |   2 +-
 arch/arm/mach-shmobile/clock-r8a7791.c             |   2 +-
 arch/arm/mach-shmobile/clock-sh7372.c              |   6 +-
 arch/arm/mach-shmobile/clock-sh73a0.c              |   2 +-
 arch/arm/mach-shmobile/include/mach/r8a7790.h      |   1 -
 arch/arm/mach-shmobile/include/mach/r8a7791.h      |   1 -
 arch/arm/mach-shmobile/setup-r8a73a4.c             |  25 +-
 arch/arm/mach-shmobile/setup-r8a7740.c             |  45 +-
 arch/arm/mach-shmobile/setup-r8a7790.c             |  31 +-
 arch/arm/mach-shmobile/setup-r8a7791.c             |  31 +-
 arch/arm/mach-shmobile/setup-sh7372.c              |  30 +-
 arch/arm/mach-shmobile/setup-sh73a0.c              |  45 +-
 arch/sh/kernel/cpu/clock-cpg.c                     |   3 +-
 arch/sh/kernel/cpu/sh2/setup-sh7619.c              |  73 +-
 arch/sh/kernel/cpu/sh2a/clock-sh7264.c             |   2 +-
 arch/sh/kernel/cpu/sh2a/clock-sh7269.c             |   2 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7203.c             |  73 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c             |  73 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7264.c             |  76 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7269.c             |  73 +-
 arch/sh/kernel/cpu/sh3/setup-sh7720.c              | 155 +---
 arch/sh/kernel/cpu/sh4a/clock-sh7343.c             |   2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7366.c             |   2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c             |   2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7723.c             |   2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c             |   2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7343.c             |  28 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c             |  27 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c             |  28 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c             |  28 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c             |  28 +-
 drivers/clocksource/sh_cmt.c                       | 903 +++++++++++++--------
 include/linux/sh_timer.h                           |   9 +
 42 files changed, 1078 insertions(+), 937 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/timer/renesas,cmt.txt

-- 
Regards,

Laurent Pinchart

