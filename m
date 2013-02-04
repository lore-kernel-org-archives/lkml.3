Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab3BDNzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:55:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60941 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3BDNzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:55:20 -0500
Date: Mon, 4 Feb 2013 05:55:06 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-8baa277b1b862ced9fce64d5ee5386676a723025@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1359942644-26371-5-git-send-email-sasha.levin@oracle.com>
References: <1359942644-26371-5-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep: Add pthread_rwlock_t test suite
Git-Commit-ID: 8baa277b1b862ced9fce64d5ee5386676a723025
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 04 Feb 2013 05:55:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8baa277b1b862ced9fce64d5ee5386676a723025
Gitweb:     http://git.kernel.org/tip/8baa277b1b862ced9fce64d5ee5386676a723025
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Sun, 3 Feb 2013 20:50:42 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 4 Feb 2013 11:39:06 +0100

liblockdep: Add pthread_rwlock_t test suite

A simple test to make sure we handle rwlocks correctly.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: paulus@samba.org
Cc: acme@ghostprotocols.net
Cc: penberg@kernel.org
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1359942644-26371-5-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/lib/lockdep/tests/WW.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/lib/lockdep/tests/WW.c b/tools/lib/lockdep/tests/WW.c
new file mode 100644
index 0000000..4b1be0f
--- /dev/null
+++ b/tools/lib/lockdep/tests/WW.c
@@ -0,0 +1,16 @@
+#include <liblockdep/rwlock.h>
+
+void main(void)
+{
+	pthread_rwlock_t a, b;
+
+	liblockdep_init();
+	liblockdep_set_thread();
+
+	pthread_rwlock_init(&a, NULL);
+	pthread_rwlock_init(&b, NULL);
+
+	pthread_rwlock_wrlock(&a);
+	pthread_rwlock_rdlock(&b);
+	pthread_rwlock_wrlock(&a);
+}
