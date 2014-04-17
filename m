Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbaDQAAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 20:00:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34987 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbaDQAAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 20:00:33 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Rajendra Nayak <rnayak@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/9] dmtimer code clean-up first pass
Date: Wed, 16 Apr 2014 19:00:00 -0500
Message-ID: <1397692800-7395-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some minor cleanups for dmtimer code in preparation for moving it out
to drivers.

There is OMAP1 specific dmtimer code earlier, that are handled in mach-omap1
directly now.   Other than this, few functions and code has been refactored to
reduce redundancy and some minor cleanups.

OMAP1 hasn't been tested so I welcome anyone with HW to test this.

Joel Fernandes (9):
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

 arch/arm/mach-omap1/include/mach/hardware.h |    2 +
 arch/arm/mach-omap1/timer.c                 |   34 ++++-
 arch/arm/mach-omap2/timer.c                 |    6 +-
 arch/arm/plat-omap/dmtimer.c                |  185 +++++++++++++--------------
 arch/arm/plat-omap/include/plat/dmtimer.h   |    4 +-
 include/linux/platform_data/dmtimer-omap.h  |    2 -
 6 files changed, 129 insertions(+), 104 deletions(-)

-- 
1.7.9.5

