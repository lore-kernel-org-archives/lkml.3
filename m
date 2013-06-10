Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab3FJRRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:17:19 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:63654 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab3FJRRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:17:17 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 0/6] ipc/sem.c: performance improvements, FIFO
Date: Mon, 10 Jun 2013 19:16:45 +0200
Message-Id: <1370884611-3861-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I have cleaned up/improved my updates to sysv sem.
Could you replace my patches in -akpm with this series?

- 1: cacheline align output from ipc_rcu_alloc
- 2: cacheline align semaphore structures
- 3: seperate-wait-for-zero-and-alter-tasks
- 4: Always-use-only-one-queue-for-alter-operations
- 5: Replace the global sem_otime with a distributed otime
- 6: Rename-try_atomic_semop-to-perform_atomic

The first 2 patches result up to a ~30% performance improvement on a 2-core i3.

3,4 remove unnecessary loops in do_smart_update() and restore FIFO behavior.

I would expect that the 5th one will cause an improvement for multi-socket
systems, but I don't have a test setup.

6 is just a cleanup/function rename.

--
	Manfred
