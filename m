Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3FZMFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:05:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55804 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab3FZMFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:05:12 -0400
Date: Wed, 26 Jun 2013 05:04:56 -0700
From: tip-bot for Maarten Lankhorst <tipbot@zytor.com>
Message-ID: <tip-166989e366ffa66108b2f37b870e66b85b2185ad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, tglx@linutronix.de,
        maarten.lankhorst@canonical.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de,
        maarten.lankhorst@canonical.com
In-Reply-To: <20130620113151.4001.77963.stgit@patser>
References: <20130620113151.4001.77963.stgit@patser>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/mutexes] locking-selftests:
  Handle unexpected failures more strictly
Git-Commit-ID: 166989e366ffa66108b2f37b870e66b85b2185ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 26 Jun 2013 05:05:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  166989e366ffa66108b2f37b870e66b85b2185ad
Gitweb:     http://git.kernel.org/tip/166989e366ffa66108b2f37b870e66b85b2185ad
Author:     Maarten Lankhorst <maarten.lankhorst@canonical.com>
AuthorDate: Thu, 20 Jun 2013 13:31:51 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Jun 2013 12:10:59 +0200

locking-selftests: Handle unexpected failures more strictly

When CONFIG_PROVE_LOCKING is not enabled, more tests are
expected to pass unexpectedly, but there no tests that should
start to fail that pass with CONFIG_PROVE_LOCKING enabled.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: rostedt@goodmis.org
Cc: daniel@ffwll.ch
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20130620113151.4001.77963.stgit@patser
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 lib/locking-selftest.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index d554f3f..aad024d 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -976,16 +976,18 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 	/*
 	 * Filter out expected failures:
 	 */
-	if (debug_locks != expected) {
 #ifndef CONFIG_PROVE_LOCKING
+	if (expected == FAILURE && debug_locks) {
 		expected_testcase_failures++;
 		printk("failed|");
-#else
+	}
+	else
+#endif
+	if (debug_locks != expected) {
 		unexpected_testcase_failures++;
 		printk("FAILED|");
 
 		dump_stack();
-#endif
 	} else {
 		testcase_successes++;
 		printk("  ok  |");
