Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaCPQGC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 12:06:02 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:35742 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbaCPQFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 12:05:34 -0400
From: Palmer Dabbelt <palmer@dabbelt.com>
To: linux-kernel@vger.kernel.org
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH] mcs_spin_lock() is inline, but comment says it isn't
Date: Sun, 16 Mar 2014 09:05:29 -0700
Message-Id: <1394985929-24969-1-git-send-email-palmer@dabbelt.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was reading the mcs_spinlock code today and I noticed a comment that
didn't appear to match the code.  This appears to have just been an
oversight during some restructuring of the mcs_spinlock code where
this function was made inline but the comment wasn't updated.

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
---
 kernel/locking/mcs_spinlock.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
index a2dbac4..f4e94af 100644
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -56,9 +56,6 @@ do {									\
  * If the lock has already been acquired, then this will proceed to spin
  * on this node->locked until the previous lock holder sets the node->locked
  * in mcs_spin_unlock().
- *
- * We don't inline mcs_spin_lock() so that perf can correctly account for the
- * time spent in this lock function.
  */
 static inline
 void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
-- 
1.8.3.2

