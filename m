Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677AbaDXWzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:55:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38813 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708AbaDXVot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:44:49 -0400
From: Joel Fernandes <joelf@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 00/26] OMAP dmtimer prep series
Date: Thu, 24 Apr 2014 16:43:43 -0500
Message-ID: <1398375849-6017-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a couple of patches moving things around in dmtimer and system timer
code simplying, rewriting many parts of it, inorder to prep them for moving out
of plat-omap and mach-omap2 to a generic clocksource driver. These patches are
required before the clocksource migration can be done.

Many of these patches have been out for a while now, I'd like to get any
final feedback and have them merged for v3.16.

The series includes all earlier series posted for OMAP1 timers, OMAP2+ timers,
and common platform dmtimer code [1] [2].

Tests have been performed with system timers on AM335x, DRA7 and OMAP4 Panda.

The code delta is slightly more because a bit of redundancy introduced for fall
back cases in mach-omap2/timer.c and a few more checks etc to simply things in
plat-omap/dmtimer.c. Finally once we move things out to drivers/, there will be
a lot of negative delta so this is a small cost for migration.

[1] https://lkml.org/lkml/2014/4/16/737
[2] http://www.kernelhub.org/?msg=453407&p=2

Joel Fernandes (26):
  ARM: OMAP: dmtimer: Remove setting of clk parent indirectly through
    platform hook
  ARM: OMAP: dmtimer: Add comments on OMAP1 clock framework
  ARM: OMAP: dmtimer: Add note to set parent from DT
  ARM: OMAP: dmtimer: Add function to check if timer is running
  ARM: OMAP1: dmtimer: Rewrite modify of IDLECT mask to use new
    is_running function
  ARM: OMAP: dmtimer: Add a write_ctrl function to simplify bit setting
  ARM: OMAP: dmtimer: Have __omap_dm_timer_load_start set ST bit in
    CTRL instead of caller
  ARM: OMAP: dmtimer: Add function to check for timer availability
  ARM: OMAP: dmtimer: Get rid of check for mem resource error
  ARM: OMAP: dmtimer: Check return of pm_runtime_get_sync
  ARM: OMAP2+: timer: Add a powerup function
  ARM: OMAP2+: timer: Simplify clock event/source name setting
  ARM: OMAP2+: timer: Add comment on timer clk parenting
  ARM: OMAP2+: timer: Remove hwmod look-up dependency for DT-boot
  ARM: OMAP2+: timer: Use of_clk_get for DT platforms
  ARM: OMAP2+: timer: Fix error message to not use hwmod structure
  ARM: OMAP2+: timer: Add fallback for of_clk_get
  ARM: OMAP2+: timer: Add legacy code for old way of getting fclk
  ARM: OMAP: dmtimer: Remove API __omap_dm_timer_load_start
  ARM: OMAP: dmtimer: Fold back private stop function
  ARM: OMAP: dmtimer: Add systimer flag to dmtimer structure
  ARM: OMAP: dmtimer: Eliminate __omap_dm_timer_write_status function
  ARM: OMAP: dmtimer: Eliminate __omap_dm_timer_read_counter function
  ARM: OMAP: dmtimer: Move private functions into dmtimer core and
    export others
  ARM: OMAP: dmtimer: Eliminate omap_dm_timer_int_enable function
  ARM: OMAP: dmtimer: Use is_timer_available function in
    omap_dm_timer_trigger

 arch/arm/mach-omap1/include/mach/hardware.h  |    2 +
 arch/arm/mach-omap1/timer.c                  |   34 +-
 arch/arm/mach-omap2/timer.c                  |  151 ++++++---
 arch/arm/plat-omap/dmtimer.c                 |  449 +++++++++++++++++---------
 arch/arm/plat-omap/include/plat/dmtimer.h    |  153 +--------
 drivers/staging/tidspbridge/core/dsp-clock.c |    2 +-
 include/linux/platform_data/dmtimer-omap.h   |    2 -
 7 files changed, 451 insertions(+), 342 deletions(-)

-- 
1.7.9.5

