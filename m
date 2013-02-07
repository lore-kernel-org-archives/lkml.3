Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab3BGMNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:13:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44683 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3BGMND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:13:03 -0500
Date: Thu, 7 Feb 2013 04:12:34 -0800
From: tip-bot for Ben Greear <greearb@candelatech.com>
Message-ID: <tip-7a508076d4efdfd4fcb6fbd50a32d2c1a6e98791@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, greearb@candelatech.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, greearb@candelatech.com
In-Reply-To: <1360176979-4421-1-git-send-email-greearb@candelatech.com>
References: <1360176979-4421-1-git-send-email-greearb@candelatech.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep:
  Print more info when MAX_LOCK_DEPTH is exceeded
Git-Commit-ID: 7a508076d4efdfd4fcb6fbd50a32d2c1a6e98791
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 07 Feb 2013 04:12:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a508076d4efdfd4fcb6fbd50a32d2c1a6e98791
Gitweb:     http://git.kernel.org/tip/7a508076d4efdfd4fcb6fbd50a32d2c1a6e98791
Author:     Ben Greear <greearb@candelatech.com>
AuthorDate: Wed, 6 Feb 2013 10:56:19 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 7 Feb 2013 12:17:43 +0100

lockdep: Print more info when MAX_LOCK_DEPTH is exceeded

This helps debug cases where a lock is acquired over and
over without being released.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ben Greear <greearb@candelatech.com>
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1360176979-4421-1-git-send-email-greearb@candelatech.com
[ Changed the printout ordering. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/lockdep.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index c783e80..1966746 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3192,9 +3192,14 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 #endif
 	if (unlikely(curr->lockdep_depth >= MAX_LOCK_DEPTH)) {
 		debug_locks_off();
-		printk("BUG: MAX_LOCK_DEPTH too low!\n");
+		printk("BUG: MAX_LOCK_DEPTH too low, depth: %i  max: %lu!\n",
+		       curr->lockdep_depth, MAX_LOCK_DEPTH);
 		printk("turning off the locking correctness validator.\n");
+
+		lockdep_print_held_locks(current);
+		debug_show_all_locks();
 		dump_stack();
+
 		return 0;
 	}
 
