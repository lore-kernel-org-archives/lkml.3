Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933956AbaDIQLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:11:34 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:46896 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100AbaDIQL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:11:29 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/5] core: Convert thread iteration to use for_each[_process]_thread APIs, 1st pile
Date: Wed,  9 Apr 2014 18:11:17 +0200
Message-Id: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the first pile of a longer series that convert deprecated and
RCU-unsafe thread group iterators (do_each_thread, while_each_thread)
to use for_each_thread/for_each_process_thread RCU-safe iterators that
have been introduced by Oleg.

for_each[_process]_thread() is already upstream so these patches don't
depend on any pending preparatory work.

So ideally it would be nice if maintainers cherry-pick the patches
corresponding to their own subsystem.

Thanks,
	Frederic
---

Frederic Weisbecker (5):
      sched: Convert thread_group_cputime() to use for_each_thread()
      tracepoint: Convert process iteration to use for_each_process_thread()
      hung_task: Convert process iteration to use for_each_process_thread()
      procfs: Convert process iteration to use for_each_thread()
      sched: Convert tasks iteration to use for_each_process_thread()


 fs/proc/array.c        |  7 ++++---
 fs/proc/base.c         |  4 ++--
 kernel/hung_task.c     |  8 ++++----
 kernel/sched/core.c    | 13 ++++++-------
 kernel/sched/cputime.c | 13 ++++++-------
 kernel/tracepoint.c    | 12 ++++++------
 6 files changed, 28 insertions(+), 29 deletions(-)
