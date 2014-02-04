Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaBDARB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 19:17:01 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17074 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaBDAQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 19:16:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 03 Feb 2014 16:15:35 -0800
From: Andrew Chew <achew@nvidia.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>, <rob@landley.net>,
        <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <abrestic@chromium.org>, <dgreid@chromium.org>, <katierh@chromium.org>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-watchdog@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH v2 0/3] tegra30 watchdog support
Date: Mon, 3 Feb 2014 16:17:32 -0800
Message-ID: <1391473055-3158-1-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series ultimately adds watchdog support for tegra30 and later
chips.

The existing tegra clocksource driver (drivers/clocksource/tegra20_timer.c)
sadly does not distinguish between tegra20 and tegra30 (and later), which
it should have done since the contents of the timer register base have
changed significantly.  In particular, tegra30 (and later) has more timers,
and also hardware watchdog registers.

The first patch adds nvidia,tegra30-timer to the list of compatibilty
strings for the tegra timer device tree node, so that we can distinguish
between tegra20 and tegra30 (and later).

The second patch separates out some macros that are interesting to other
drivers (in particular, the tegra watchdog driver), and also adds the
the missing timers that are present in tegra30 and later.

The third patch adds the actual watchdog driver.  This driver configures
a single watchdog (watchdog 0), pairs it with timer 5
(defined as TEGRA30_TIMER_WDT_* in the shared header file from the previous
patch), and sets it up so that upon timer expiration, will cause the target
system to reset.

I've decided to encapsulate all related changes into one patch series, since
I did not modify any device tree bindings and therefore don't need to review
dt changes separately.  This way, everything can be seen within its complete
context.

Andrew Chew (3):
  clocksource: tegra: Add nvidia,tegra30-timer compat
  clocksource: tegra: Define timer bases in header file
  watchdog: Add tegra watchdog

 Documentation/watchdog/watchdog-parameters.txt |   5 +
 drivers/clocksource/tegra20_timer.c            |  16 +-
 drivers/watchdog/Kconfig                       |  11 +
 drivers/watchdog/Makefile                      |   1 +
 drivers/watchdog/tegra_wdt.c                   | 372 +++++++++++++++++++++++++
 include/clocksource/tegra_timer.h              |  43 +++
 6 files changed, 439 insertions(+), 9 deletions(-)
 create mode 100644 drivers/watchdog/tegra_wdt.c
 create mode 100644 include/clocksource/tegra_timer.h

-- 
1.8.1.5

