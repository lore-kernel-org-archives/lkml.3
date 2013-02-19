Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab3BSRvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:51:16 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44356 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932746Ab3BSRvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:51:15 -0500
Date: Tue, 19 Feb 2013 09:51:10 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Dan Williams <dcbw@redhat.com>
Subject: [GIT PULL] workqueue [delayed_]work_pending() cleanups for 3.9-rc1
Message-ID: <20130219175110.GN17414@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This is part of on-going cleanups to remove / minimize usages of
workqueue interfaces which are deprecated and/or misleading.  This
round drops a number of usages of [delayed_]work_pending(), which are
dangerous as they lack any form of synchronization and thus often lead
to buggy / unnecessary code.  There are a couple legitimate use cases
in kernel.  Hopefully, they can be converted and
[delayed_]work_pending() can be removed completely.  Even if not,
removing most of misuses should make it more difficult to find
examples of misuses and thus slow down growth of them.

These changes are independent from other workqueue changes.

The changes are available in the following git branch

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.9-cleanups

for you to fetch changes up to 23663c873154f01220ef679558e1ca110c4c4ca4:

  wimax/i2400m: fix i2400m->wake_tx_skb handling (2013-02-09 11:34:19 -0800)

----------------------------------------------------------------
Tejun Heo (11):
      sja1000: don't use [delayed_]work_pending()
      mwifiex: don't use [delayed_]work_pending()
      thinkpad_acpi: don't use [delayed_]work_pending()
      wl1251: don't use [delayed_]work_pending()
      rfkill: don't use [delayed_]work_pending()
      x86/mce: don't use [delayed_]work_pending()
      tty/max3100: don't use [delayed_]work_pending()
      video/exynos: don't use [delayed_]work_pending()
      ipw2x00: simplify scan_event handling
      kprobes: fix wait_for_kprobe_optimizer()
      wimax/i2400m: fix i2400m->wake_tx_skb handling

 arch/x86/kernel/cpu/mcheck/mce.c       | 14 +++-----------
 drivers/net/can/sja1000/peak_pci.c     |  3 +--
 drivers/net/wimax/i2400m/netdev.c      | 31 +++++++++++++++++--------------
 drivers/net/wireless/ipw2x00/ipw2100.c | 31 ++++++++-----------------------
 drivers/net/wireless/ipw2x00/ipw2100.h |  3 +--
 drivers/net/wireless/ipw2x00/ipw2200.c | 13 +++----------
 drivers/net/wireless/mwifiex/sdio.c    |  9 ++++-----
 drivers/net/wireless/ti/wl1251/ps.c    |  3 +--
 drivers/platform/x86/thinkpad_acpi.c   |  3 +--
 drivers/tty/serial/max3100.c           |  3 +--
 drivers/video/exynos/exynos_dp_core.c  |  6 ++----
 kernel/kprobes.c                       | 23 +++++++++++++++--------
 net/rfkill/input.c                     |  8 +++-----
 13 files changed, 60 insertions(+), 90 deletions(-)

Thanks.

--
tejun
