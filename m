Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab3CEOBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:01:31 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:44618 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab3CEOBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:01:30 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [RFC PATCH 0/3] posix_cpu_timers: Some code consolidation
Date: Tue,  5 Mar 2013 15:01:19 +0100
Message-Id: <1362492082-23019-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some interesting consolidation comes when we unify the expiry
time type.

I'm also wondering: can't we implement CPUCLOCK_PROF using CPUCLOCK_SCHED?
One is using the tick, the other is using the sched. But they both seem
to account the same thing: utime + stime.

Thanks.

Frederic Weisbecker (3):
  posix_cpu_timers: Consolidate expiry time type
  posix_cpu_timers: Consolidate timer list cleanups
  posix_cpu_timers: Consolidate expired timers check

 include/linux/posix-timers.h |   16 ++-
 kernel/posix-cpu-timers.c    |  387 +++++++++++++++---------------------------
 2 files changed, 146 insertions(+), 257 deletions(-)

-- 
1.7.5.4

