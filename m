Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965432Ab3FTLdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:33:08 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35034 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965378Ab3FTLdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:33:02 -0400
Subject: [PATCH v5 7/7] locking-selftests: handle unexpected failures more
 strictly
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, peterz@infradead.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, daniel@ffwll.ch,
        tglx@linutronix.de, mingo@kernel.org, linux-media@vger.kernel.org
Date: Thu, 20 Jun 2013 13:31:51 +0200
Message-ID: <20130620113151.4001.77963.stgit@patser>
In-Reply-To: <20130620112811.4001.86934.stgit@patser>
References: <20130620112811.4001.86934.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_PROVE_LOCKING is not enabled, more tests are expected to
pass unexpectedly, but there no tests that should start to fail that
pass with CONFIG_PROVE_LOCKING enabled.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 lib/locking-selftest.c |    8 +++++---
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

