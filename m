Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbaCKMlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:41:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35766 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbaCKMlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:41:16 -0400
Date: Tue, 11 Mar 2014 05:40:48 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-byirmpamgr7h25m5kyavwpzx@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking: Move mcs_spinlock.h into kernel/
 locking/
Git-Commit-ID: c9122da1e2d29bd6a1475a0d1ce2aa6ac6ea25fa
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

Commit-ID:  c9122da1e2d29bd6a1475a0d1ce2aa6ac6ea25fa
Gitweb:     http://git.kernel.org/tip/c9122da1e2d29bd6a1475a0d1ce2aa6ac6ea25fa
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 3 Feb 2014 13:32:16 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 12:14:52 +0100

locking: Move mcs_spinlock.h into kernel/locking/

The mcs_spinlock code is not meant (or suitable) as a generic locking
primitive, therefore take it away from the normal includes and place
it in kernel/locking/.

This way the locking primitives implemented there can use it as part
of their implementation but we do not risk it getting used
inapropriately.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-byirmpamgr7h25m5kyavwpzx@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 {include/linux => kernel/locking}/mcs_spinlock.h | 0
 kernel/locking/mutex.c                           | 2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
similarity index 100%
rename from include/linux/mcs_spinlock.h
rename to kernel/locking/mcs_spinlock.h
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 45fe1b5..4f408be 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -25,7 +25,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/debug_locks.h>
-#include <linux/mcs_spinlock.h>
+#include "mcs_spinlock.h"
 
 /*
  * In the DEBUG case we are using the "NULL fastpath" for mutexes,
