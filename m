Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab3EZJJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 05:09:22 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:43255 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3EZJJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 05:09:17 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 0/4] ipc/sem.c: Bug fixes, regression fixes, v3
Date: Sun, 26 May 2013 11:08:51 +0200
Message-Id: <1369559335-13491-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've split my patch into 4 parts:
- 1: Fix-missing-wakeups-in-do_smart_update
- 2: seperate-wait-for-zero-and-alter-tasks
- 3: Always-use-only-one-queue-for-alter-operations
- 4: Rename-try_atomic_semop-to-perform_atomic

Linus:
- Patch 1 should be merged immediately: It fixes bugs,
  the current code misses wakeups.

- Patch 2 and 3 restore the behavior of linux <=3.0.9.
  I would propose that they are merged, too: I can't rule out that
  changing the priority of the wakeups breaks user space apps.

- Patch 4 is trivial, no code changes at all.
  If 2+3 are merged, then 4 should be merged, too.

I have tested patch 1 seperately and 1+2+3+4:
With patch 1 applied, there are no more missed wakeups.

With all 4 applied, linux-3.0.10-rc1 behaves as linux <=3.0.9.

With regards to the scalability, I do not expect any degradation:
Operations on seperate semaphores in an array remain parallelized.

Apps that use lots of wait-for-zero semop are probably even faster,
because the wait-for-zero ops are now only scanned if a semval is 0.

--
	Manfred
