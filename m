Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbbA1AYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 19:24:20 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:40064 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbbA1AYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 19:24:19 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/4] sched: schedule/preempt optimizations and cleanups
Date: Wed, 28 Jan 2015 01:24:08 +0100
Message-Id: <1422404652-29067-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

This series is based on suggestions from Linus. I posted a previous
version one month ago then Linus suggested more improvements. Here
is the following iteration.

The last patch suggests to (ab)use PREEMPT_ACTIVE to disable preemption
on schedule(). It's optional as it's a possibily controversial cleanup.

Thanks.

Frederic Weisbecker (4):
  sched: Pull resched loop to __schedule() callers
  sched: Use traced preempt count operations to toggle PREEMPT_ACTIVE
  sched: Pull preemption disablement to __schedule() caller
  sched: Account PREEMPT_ACTIVE context as atomic

 include/linux/preempt_mask.h |  4 ++--
 kernel/sched/core.c          | 29 +++++++++++++++--------------
 2 files changed, 17 insertions(+), 16 deletions(-)

-- 
2.1.4

