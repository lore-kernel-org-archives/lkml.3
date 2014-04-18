Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaDRNOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:14:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39254 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaDRNO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:14:27 -0400
Date: Fri, 18 Apr 2014 06:13:30 -0700
From: tip-bot for Sasha Levin <tipbot@zytor.com>
Message-ID: <tip-1413c03893332366e5b4d1e26f942ada25f3e82a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1389208906-24338-1-git-send-email-sasha.levin@oracle.com>
References: <1389208906-24338-1-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] lockdep: Increase static allocations
Git-Commit-ID: 1413c03893332366e5b4d1e26f942ada25f3e82a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1413c03893332366e5b4d1e26f942ada25f3e82a
Gitweb:     http://git.kernel.org/tip/1413c03893332366e5b4d1e26f942ada25f3e82a
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Wed, 8 Jan 2014 14:21:46 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:50 +0200

lockdep: Increase static allocations

Fuzzing a recent kernel with a large configuration hits the static
allocation limits and disables lockdep.

This patch doubles the limits.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389208906-24338-1-git-send-email-sasha.levin@oracle.com
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
