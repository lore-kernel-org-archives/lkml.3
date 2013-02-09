Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578Ab3BICpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 21:45:44 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37375 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682Ab3BICpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 21:45:42 -0500
From: Michel Lespinasse <walken@google.com>
To: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@kernel.org, arjan@linux.intel.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, alex.shi@intel.com,
        yuanhan.liu@linux.intel.com, dhowells@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Subject: [PATCH 0/4] rwsem: Implement writer lock-stealing
Date: Fri,  8 Feb 2013 18:45:33 -0800
Message-Id: <1360377937-16297-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This proposal implements writer lock stealing in lib/rwsem.c, just as
Alex Shi's earlier proposal did for the simpler lib/rwsem-spinlock.c

Patches 1 and 2 are small cleanups that I thought I should separate
from the bulk of the changes; Patch 3 is the generic support for write
lock stealing; Patch 4 is the x86 support (optional, only required for
higher performance).

I am not in an ideal position to push this as I will be out of town
starting from the middle of next week. However, I hope that this
proposal will at least get the ball rolling. I did run some basic
testing including David Howell's synchro-test module (as found in
Andrew's -mm tree).

Michel Lespinasse (4):
  rwsem: make the waiter type an enumeration rather than a bitmask
  rwsem: shorter spinlocked section in rwsem_down_failed_common()
  rwsem: implement write lock stealing
  x86 rwsem: avoid taking slow path when stealing write lock

 arch/x86/include/asm/rwsem.h |  28 +++--
 include/linux/rwsem.h        |   2 +
 lib/rwsem.c                  | 252 ++++++++++++++++++++-----------------------
 3 files changed, 139 insertions(+), 143 deletions(-)

-- 
1.8.1
