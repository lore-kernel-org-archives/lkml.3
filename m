Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbaKDLAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:00:49 -0500
Received: from sauhun.de ([89.238.76.85]:53469 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaKDLAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:00:47 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH] sched: completion: document when to use wait_for_completion_io_*
Date: Tue,  4 Nov 2014 12:01:41 +0100
Message-Id: <1415098901-2768-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed [1], accounting IO is meant for blkio only. Document that
so driver authors won't use them for device io.

[1] http://thread.gmane.org/gmane.linux.drivers.i2c/20470

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 kernel/sched/completion.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/completion.c b/kernel/sched/completion.c
index a63f4dc27909..607f852b4d04 100644
--- a/kernel/sched/completion.c
+++ b/kernel/sched/completion.c
@@ -148,7 +148,7 @@ EXPORT_SYMBOL(wait_for_completion_timeout);
  *
  * This waits to be signaled for completion of a specific task. It is NOT
  * interruptible and there is no timeout. The caller is accounted as waiting
- * for IO.
+ * for IO (which traditionally means blkio only).
  */
 void __sched wait_for_completion_io(struct completion *x)
 {
@@ -163,7 +163,8 @@ EXPORT_SYMBOL(wait_for_completion_io);
  *
  * This waits for either a completion of a specific task to be signaled or for a
  * specified timeout to expire. The timeout is in jiffies. It is not
- * interruptible. The caller is accounted as waiting for IO.
+ * interruptible. The caller is accounted as waiting for IO (which traditionally
+ * means blkio only).
  *
  * Return: 0 if timed out, and positive (at least 1, or number of jiffies left
  * till timeout) if completed.
-- 
2.1.1

