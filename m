Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab3KWPh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 10:37:28 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:46758 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab3KWPhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 10:37:25 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] posix cpu timers cleanups for 3.14
Date: Sat, 23 Nov 2013 16:37:10 +0100
Message-Id: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Thomas,

Please pull the timers/posix-timers-for-tip branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/posix-timers-for-tip

HEAD: 239dd62b5c41bf606f3a3b3adb9e70341a62dbd3
It passed through 0-day testing.

This is another series of posix cpu timers cleanups. Note it's essentially the same
as: "posix-timers: Various cleanups" at http://lkml.org/lkml/2013/10/12/107 which
Peter Zijlstra had a look into. He told me that it looked ok. This version brings
almost no code change (just fix a NULL check ommitted somewhere), it's mostly a rebase
against 2.6.12 with refined changelogs.

It's a first pile but more is to come, as I have some more cleanups in mind. Plus
I plan to integrate more fixes from Kosaki Motohiro.

Changes:

* Remove a few irrelevant optimizations that were complicating the code a lot
* Consolidate local and remote clock read
* Remove dead leftovers
* Optimize the locking by removing unnecessary uses of tasklist lock
* Various other cleanups...

Thanks,
	Frederic
---

Frederic Weisbecker (10):
      posix-timers: Remove dead thread posix cpu timers caching
      posix-timers: Remove dead process posix cpu timers caching
      posix-timers: Cleanup reaped target handling
      posix-timers: Remove dead task special case
      posix-timers: Remove useless clock sample on timers cleanup
      posix-timers: Consolidate posix_cpu_clock_get()
      posix-timers: Use sighand lock instead of tasklist_lock for task clock sample
      posix-timers: Use sighand lock instead of tasklist_lock on timer deletion
      posix-timers: Remove remaining uses of tasklist_lock
      posix-timers: Convert abuses of BUG_ON to WARN_ON


 kernel/posix-cpu-timers.c | 309 +++++++++++++++++++---------------------------
 1 file changed, 129 insertions(+), 180 deletions(-)
