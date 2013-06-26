Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab3FZBGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:06:52 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:47499 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3FZBGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:06:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130625200211.GA11625@codeaurora.org>
References: <20130625200211.GA11625@codeaurora.org>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 26 Jun 2013 09:06:29 +0800
Message-ID: <CAGsJ_4zQEAHQM1C5_PDhMtUsrM1za6Fg-XS3jBNYTnm9H30qaQ@mail.gmail.com>
Subject: Re: [GIT PULL] Remove ARM local timer API
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Barry Song <baohua.song@csr.com>, Olof Johansson <olof@lixom.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/26 Stephen Boyd <sboyd@codeaurora.org>:
> Olof/Arnd,
>
> These patches remove the ARM local timer API. The ARM architected
> timers have already moved away from this API so this series
> migrates the rest of the users allowing us to remove the API
> entirely. Thomas has been kind enough to take the first two
> patches into timers/core in the tip tree (thanks Thomas!) so I've
> merged that into v3.10-rc1 and then applied the rest of the
> patches on top. Let me know if this is acceptable.
>
> These patches have been through multiple rounds and tested by
> multiple people since before the 3.10 merge window closed. Only
> Barry's ack is missing (Cced).

sorry for delayed reply. pls don't wait for my ack. as we are dropping
the marco SoC project this driver supports and moving to a new SoC.
that is why i didn't verify and ack this.
whether this driver is still usable will depend on whether the timer
IP will be re-used in the new chip. so maybe i will delete this driver
once timer IP is decided in the new SoC, or i will repeat to maintain
and verify it if the new SoC uses the same IP.

>
> Since I don't have a tree on kernel.org, David Brown has been
> kind enough to push my tag out to his repo. Please pull.
>
> The following changes since commit 42cba6e27c4cddc4df701c597dbfa666e1c013c8:
>
>   Merge branch 'timers/core' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into remove-local-timers (2013-06-24 17:45:02 -0700)
>
> are available in the git repository at:
>
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/remove-local-timers
>
> for you to fetch changes up to 060fd3043e5e3488504b9e70182e188dd9113aea:
>
>   ARM: smp: Remove local timer API (2013-06-24 17:47:34 -0700)
>
> ----------------------------------------------------------------
> Now that we have a generic arch hook for broadcast we can remove the local
> timer API entirely. Doing so will reduce code in ARM core, reduce the
> architecture dependencies of our timer drivers, and simplify the code because
> we no longer go through an architecture layer that is essentially a hotplug
> notifier.
>
> ----------------------------------------------------------------
> Stephen Boyd (9):
>       ARM: smp: Remove duplicate dummy timer implementation
>       ARM: smp_twd: Divorce smp_twd from local timer API
>       ARM: OMAP2+: Divorce from local timer API
>       ARM: EXYNOS4: Divorce mct from local timer API
>       ARM: PRIMA2: Divorce timer-marco from local timer API
>       ARM: msm: Divorce msm_timer from local timer API
>       clocksource: time-armada-370-xp: Fix sparse warning
>       clocksource: time-armada-370-xp: Divorce from local timer API
>       ARM: smp: Remove local timer API
>
>  arch/arm/Kconfig                         |  12 +--
>  arch/arm/include/asm/localtimer.h        |  34 ---------
>  arch/arm/kernel/smp.c                    |  87 ---------------------
>  arch/arm/kernel/smp_twd.c                |  64 ++++++++++------
>  arch/arm/mach-highbank/Kconfig           |   2 +-
>  arch/arm/mach-imx/Kconfig                |   2 +-
>  arch/arm/mach-msm/timer.c                | 126 +++++++++++++++++--------------
>  arch/arm/mach-omap2/Kconfig              |   3 +-
>  arch/arm/mach-omap2/timer.c              |   7 --
>  arch/arm/mach-realview/Kconfig           |   8 +-
>  arch/arm/mach-spear/Kconfig              |   2 +-
>  arch/arm/mach-tegra/Kconfig              |   2 +-
>  arch/arm/mach-ux500/Kconfig              |   2 +-
>  arch/arm/mach-vexpress/Kconfig           |   2 +-
>  arch/arm/mach-zynq/Kconfig               |   2 +-
>  drivers/clocksource/exynos_mct.c         |  60 ++++++++++-----
>  drivers/clocksource/time-armada-370-xp.c |  92 +++++++++++-----------
>  drivers/clocksource/timer-marco.c        | 100 +++++++++++++-----------
>  include/linux/time-armada-370-xp.h       |   4 +-
>  19 files changed, 267 insertions(+), 344 deletions(-)
>  delete mode 100644 arch/arm/include/asm/localtimer.h
>
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation

-barry
