Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbaKPMcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:32:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35511 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbaKPMck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:32:40 -0500
Date: Sun, 16 Nov 2014 04:31:57 -0800
From: tip-bot for Wolfram Sang <tipbot@zytor.com>
Message-ID: <tip-a1bd5373357d3edc4b97548747d583c3efa484b3@git.kernel.org>
Cc: gnomes@lxorguk.ukuu.org.uk, wsa@the-dreams.de, mingo@kernel.org,
        tglx@linutronix.de, hpa@zytor.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Reply-To: mingo@kernel.org, gnomes@lxorguk.ukuu.org.uk, wsa@the-dreams.de,
        hpa@zytor.com, peterz@infradead.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1415098901-2768-1-git-send-email-wsa@the-dreams.de>
References: <1415098901-2768-1-git-send-email-wsa@the-dreams.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/completion:
  Document when to use wait_for_completion_io_*()
Git-Commit-ID: a1bd5373357d3edc4b97548747d583c3efa484b3
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

Commit-ID:  a1bd5373357d3edc4b97548747d583c3efa484b3
Gitweb:     http://git.kernel.org/tip/a1bd5373357d3edc4b97548747d583c3efa484b3
Author:     Wolfram Sang <wsa@the-dreams.de>
AuthorDate: Tue, 4 Nov 2014 12:01:41 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 10:58:54 +0100

sched/completion: Document when to use wait_for_completion_io_*()

As discussed in [1], accounting IO is meant for blkio only. Document that
so driver authors won't use them for device io.

 [1] http://thread.gmane.org/gmane.linux.drivers.i2c/20470

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1415098901-2768-1-git-send-email-wsa@the-dreams.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/completion.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/completion.c b/kernel/sched/completion.c
index a63f4dc..607f852 100644
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
