Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbaAHTXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:23:02 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26254 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaAHTXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:23:00 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] lockdep: increase static allocations
Date: Wed,  8 Jan 2014 14:21:46 -0500
Message-Id: <1389208906-24338-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fuzzing a recent kernel with a large configuration hits the static
allocation limits and disables lockdep.

This patch doubles the limits.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/locking/lockdep_internals.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/locking/lockdep_internals.h b/kernel/locking/lockdep_internals.h
index 4f560cf..51c4b24 100644
--- a/kernel/locking/lockdep_internals.h
+++ b/kernel/locking/lockdep_internals.h
@@ -54,9 +54,9 @@ enum {
  * table (if it's not there yet), and we check it for lock order
  * conflicts and deadlocks.
  */
-#define MAX_LOCKDEP_ENTRIES	16384UL
+#define MAX_LOCKDEP_ENTRIES	32768UL
 
-#define MAX_LOCKDEP_CHAINS_BITS	15
+#define MAX_LOCKDEP_CHAINS_BITS	16
 #define MAX_LOCKDEP_CHAINS	(1UL << MAX_LOCKDEP_CHAINS_BITS)
 
 #define MAX_LOCKDEP_CHAIN_HLOCKS (MAX_LOCKDEP_CHAINS*5)
@@ -65,7 +65,7 @@ enum {
  * Stack-trace: tightly packed array of stack backtrace
  * addresses. Protected by the hash_lock.
  */
-#define MAX_STACK_TRACE_ENTRIES	262144UL
+#define MAX_STACK_TRACE_ENTRIES	524288UL
 
 extern struct list_head all_lock_classes;
 extern struct lock_chain lock_chains[];
-- 
1.8.3.2

