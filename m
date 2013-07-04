Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab3GDQqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 12:46:33 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:57747 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab3GDQqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 12:46:32 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Olivier Langlois <olivier@trillion01.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chen Gang <gang.chen@asianux.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] posix cpu timers updates
Date: Thu,  4 Jul 2013 18:46:18 +0200
Message-Id: <1372956385-25396-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Please pull the timers/posix-cpu-timers-for-tglx branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/posix-cpu-timers-for-tglx

Most of these patches have been hanging around for several month now, in -mmotm
for a significant chunk. They already missed a few releases.

This pile includes quite a part of these. Kosaki also has some pending patches
that we are still discussing a bit. But I'll try to take care of these as well.

Thanks,
	Frederic
---

Frederic Weisbecker (6):
      posix_cpu_timer: consolidate expiry time type
      posix_cpu_timers: consolidate timer list cleanups
      posix_cpu_timers: consolidate expired timers check
      selftests: add basic posix timers selftests
      posix-timers: correctly get dying task time sample in posix_cpu_timer_schedule()
      posix_timers: fix racy timer delta caching on task exit

KOSAKI Motohiro (1):
      posix-cpu-timers: don't account cpu timer after stopped thread runtime accounting


 include/linux/posix-timers.h                  |   16 +-
 kernel/posix-cpu-timers.c                     |  395 +++++++++----------------
 kernel/sched/stats.h                          |   39 +++-
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/timers/Makefile       |    8 +
 tools/testing/selftests/timers/posix_timers.c |  221 ++++++++++++++
 6 files changed, 417 insertions(+), 263 deletions(-)
