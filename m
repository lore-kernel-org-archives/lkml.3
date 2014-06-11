Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbaFKX7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:59:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:35988 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaFKX7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:59:15 -0400
Message-Id: <20140611234024.103571777@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 23:59:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [patch 00/13] time: Tree wide cleanup of interfaces and crap
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part 1 of a larger cleanup series I have on store. This just
deals with simple independent cleanups, except for the removal of
do_posix_clock_monotonic_gettime() which depends on all the related
cleanup patches being applied. I'm happy to take the whole series
trough my tree if nobody objects.

1) Finally get rid of do_posix_clock_monotonic_gettime() which is just
   a wrapper around ktime_get_ts()

2) Kill a few braindamaged time conversion sites

Thanks,

	tglx
----
 drivers/firewire/core-cdev.c            |    2 +-
 drivers/net/wireless/mwifiex/cfg80211.c |    4 +---
 drivers/net/wireless/mwifiex/main.c     |    4 +---
 drivers/net/wireless/mwifiex/tdls.c     |    6 ++----
 drivers/net/wireless/mwifiex/uap_txrx.c |    4 +---
 drivers/net/wireless/mwifiex/wmm.c      |    9 +--------
 include/linux/time.h                    |    1 -
 include/sound/pcm.h                     |    2 +-
 kernel/acct.c                           |    2 +-
 kernel/debug/kdb/kdb_main.c             |    2 +-
 kernel/delayacct.c                      |   16 +++-------------
 kernel/fork.c                           |    2 +-
 kernel/tsacct.c                         |    2 +-
 net/mac80211/cfg.c                      |    2 +-
 net/mac80211/debugfs_sta.c              |    2 +-
 net/mac80211/sta_info.c                 |    2 +-
 net/mac80211/status.c                   |    7 ++-----
 net/mac80211/tx.c                       |    5 +----
 security/tomoyo/audit.c                 |    8 +++-----
 security/tomoyo/common.c                |    4 +---
 sound/core/timer.c                      |    4 ++--
 sound/pci/intel8x0.c                    |   10 ++++------
 22 files changed, 31 insertions(+), 69 deletions(-)

