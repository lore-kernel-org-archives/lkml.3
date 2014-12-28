Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaL1JMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 04:12:19 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:43206 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaL1JMQ (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Sun, 28 Dec 2014 04:12:16 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] locking: Various updates
Date: Sun, 28 Dec 2014 01:11:15 -0800
Message-Id: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

A little bit of everything really, with the last two patches being
the most interesting ones.

Patch 1 fixes a silly typo.
Patches 2-5 cleanup a bit of ww mutex code.
Patch 6 isolates osq code.
Patch 7 uses the brand new READ/ASSIGN_ONCE primitives.
Patch 8 is a performance patch and gets rid of barrier calls when
        polling for the (osq) lock.

More details obviously in the individual patches. Applies on today's -tip.

Please consider for 3.20, thanks!

Davidlohr Bueso (8):
  Documentation/memory-barriers.txt: Fix smp typo
  locking/mutex: Get rid of use_ww_cxt param in common paths
  locking/mutex: Checking the stamp is ww only
  locking/mutex: Delete useless comment
  locking/mutex: Introduce ww_mutex_set_context_slowpath
  locking/mcs: Better differentiate between mcs variants
  locking: Use [READ,ASSIGN]_ONCE() for non-scalar types
  locking/osq: No need for load/acquire when acquire-polling

 Documentation/memory-barriers.txt |   2 +-
 include/linux/osq_lock.h          |  12 ++-
 kernel/Kconfig.locks              |   4 +
 kernel/locking/Makefile           |   3 +-
 kernel/locking/mcs_spinlock.c     | 208 --------------------------------------
 kernel/locking/mcs_spinlock.h     |  22 +---
 kernel/locking/mutex.c            |  99 +++++++++---------
 kernel/locking/osq_lock.c         | 203 +++++++++++++++++++++++++++++++++++++
 kernel/locking/rwsem-xadd.c       |   4 +-
 9 files changed, 276 insertions(+), 281 deletions(-)
 delete mode 100644 kernel/locking/mcs_spinlock.c
 create mode 100644 kernel/locking/osq_lock.c

-- 
2.1.2

