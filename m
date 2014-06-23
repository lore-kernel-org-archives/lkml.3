Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaFWSZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:25:18 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:6128 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaFWSZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:25:16 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v4 0/1] lockdep: add support for queued rwlock
Date: Mon, 23 Jun 2014 14:24:59 -0400
Message-Id: <1403547900-40658-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3->v4:
 - Document the new read state and move the conditional compilation code
   to lockdep.h.

v2->v3:
 - Add a new read mode (3) for rwlock (used in
   lock_acquire_shared_cond_recursive()) to avoid conflict with other
   use cases of lock_acquire_shared_recursive().

v1->v2:
 - Use less conditional & make it easier to read

With the merging of qrwlock into 3.16, it was found that the btrfs
filesystem hanged readily. A fix was devised and merged into rc2 and
the use of recursive read_lock call was part of the problem.

This patch addes code to the lockdep subsystem to catch this kind of
recursive read_lock calls in kernel code.

Waiman Long (1):
  lockdep: restrict the use of recursive read_lock with qrwlock

 include/linux/lockdep.h  |   12 ++++++++++++
 kernel/locking/lockdep.c |    6 ++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

