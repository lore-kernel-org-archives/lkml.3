Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbaFZRje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:39:34 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:3973 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684AbaFZRjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:39:33 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v5 0/2] lockdep: add support for queued rwlock
Date: Thu, 26 Jun 2014 13:39:09 -0400
Message-Id: <1403804351-405-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v4->v5:
 - Add patch 2 to update the locking selftest code to handle recursive
   read_lock correctly. Patch 1 has no change.

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

This patch series addes code to the lockdep subsystem to catch this
kind of recursive read_lock calls in kernel code. It also updates
the locking selftest to handle recursive read_lock correctly so that
it won't complain about test failures whether or not queue rwlock
is configured.

Waiman Long (2):
  lockdep: restrict the use of recursive read_lock with qrwlock
  locking-selftest: Support queue rwlock

 include/linux/lockdep.h  |   12 ++++++++++++
 kernel/locking/lockdep.c |    6 ++++++
 lib/locking-selftest.c   |   16 +++++++++++++---
 3 files changed, 31 insertions(+), 3 deletions(-)

