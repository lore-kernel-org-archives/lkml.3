Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab3JLTGc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 15:06:32 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:56597 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab3JLTGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 15:06:31 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: posix-timers: Various cleanups 
Date: Sat, 12 Oct 2013 21:06:16 +0200
Message-Id: <1381604786-21293-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this is a first take to cleanup the posix cpu timers code. It removes
some optimizations that don't seem very worth the code complications to me,
and also bring some locking cleanup (remove use of tasklist_lock), etc..

It has been only lightly tested for now (just ran though the posix timers
selftests in tools/testing/selftests).

And there is still some work to do, I need to integrate the fixes proposed
by Kosaki: https://lkml.kernel.org/r/1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com
and there is some more chunks to sanitize.

But anyway that's a first step. And I would like to also make sure
that people are fine with the optimizations I'm removing. So here is it.

Thanks.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/posix-timers-rfc

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


 kernel/posix-cpu-timers.c | 307 +++++++++++++++++++---------------------------
 1 file changed, 127 insertions(+), 180 deletions(-)
