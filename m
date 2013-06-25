Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab3FYUCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:02:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36317 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3FYUCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:02:13 -0400
Date: Tue, 25 Jun 2013 13:02:12 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>, Barry Song <baohua.song@csr.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Remove ARM local timer API
Message-ID: <20130625200211.GA11625@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof/Arnd,

These patches remove the ARM local timer API. The ARM architected
timers have already moved away from this API so this series
migrates the rest of the users allowing us to remove the API
entirely. Thomas has been kind enough to take the first two
patches into timers/core in the tip tree (thanks Thomas!) so I've
merged that into v3.10-rc1 and then applied the rest of the
patches on top. Let me know if this is acceptable.

These patches have been through multiple rounds and tested by
multiple people since before the 3.10 merge window closed. Only
Barry's ack is missing (Cced).

Since I don't have a tree on kernel.org, David Brown has been
kind enough to push my tag out to his repo. Please pull.

The following changes since commit 42cba6e27c4cddc4df701c597dbfa666e1c013c8:

  Merge branch 'timers/core' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into remove-local-timers (2013-06-24 17:45:02 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/remove-local-timers

for you to fetch changes up to 060fd3043e5e3488504b9e70182e188dd9113aea:

  ARM: smp: Remove local timer API (2013-06-24 17:47:34 -0700)

----------------------------------------------------------------
Now that we have a generic arch hook for broadcast we can remove the local
timer API entirely. Doing so will reduce code in ARM core, reduce the
architecture dependencies of our timer drivers, and simplify the code because
we no longer go through an architecture layer that is essentially a hotplug
notifier.

----------------------------------------------------------------
Stephen Boyd (9):
      ARM: smp: Remove duplicate dummy timer implementation
      ARM: smp_twd: Divorce smp_twd from local timer API
      ARM: OMAP2+: Divorce from local timer API
      ARM: EXYNOS4: Divorce mct from local timer API
      ARM: PRIMA2: Divorce timer-marco from local timer API
      ARM: msm: Divorce msm_timer from local timer API
      clocksource: time-armada-370-xp: Fix sparse warning
      clocksource: time-armada-370-xp: Divorce from local timer API
      ARM: smp: Remove local timer API

 arch/arm/Kconfig                         |  12 +--
 arch/arm/include/asm/localtimer.h        |  34 ---------
 arch/arm/kernel/smp.c                    |  87 ---------------------
 arch/arm/kernel/smp_twd.c                |  64 ++++++++++------
 arch/arm/mach-highbank/Kconfig           |   2 +-
 arch/arm/mach-imx/Kconfig                |   2 +-
 arch/arm/mach-msm/timer.c                | 126 +++++++++++++++++--------------
 arch/arm/mach-omap2/Kconfig              |   3 +-
 arch/arm/mach-omap2/timer.c              |   7 --
 arch/arm/mach-realview/Kconfig           |   8 +-
 arch/arm/mach-spear/Kconfig              |   2 +-
 arch/arm/mach-tegra/Kconfig              |   2 +-
 arch/arm/mach-ux500/Kconfig              |   2 +-
 arch/arm/mach-vexpress/Kconfig           |   2 +-
 arch/arm/mach-zynq/Kconfig               |   2 +-
 drivers/clocksource/exynos_mct.c         |  60 ++++++++++-----
 drivers/clocksource/time-armada-370-xp.c |  92 +++++++++++-----------
 drivers/clocksource/timer-marco.c        | 100 +++++++++++++-----------
 include/linux/time-armada-370-xp.h       |   4 +-
 19 files changed, 267 insertions(+), 344 deletions(-)
 delete mode 100644 arch/arm/include/asm/localtimer.h

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
