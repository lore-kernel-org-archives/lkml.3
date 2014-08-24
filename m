Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaHXRPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 13:15:25 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:48556 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbaHXRPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 13:15:24 -0400
Date: Sun, 24 Aug 2014 17:12:27 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] wait: document timeout corner case
Message-ID: <alpine.LNX.2.11.1408241710070.6462@localhost.localdomain>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timeout may elapse without 0 being returned, such as when waiting
on an unused queue. Document this possibility.

Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
---
 include/linux/wait.h | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 6fb1ba5..034f6fc 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -280,9 +280,11 @@ do {									\
  * wake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
- * The function returns 0 if the @timeout elapsed, or the remaining
- * jiffies (at least 1) if the @condition evaluated to %true before
- * the @timeout elapsed.
+ * Returns:
+ * 0 if the @condition evaluated to %false after the @timeout elapsed,
+ * 1 if the @condition evaluated to %true after the @timeout elapsed,
+ * or the remaining jiffies (at least 1) if the @condition evaluated
+ * to %true before the @timeout elapsed.
  */
 #define wait_event_timeout(wq, condition, timeout)			\
 ({									\
@@ -363,9 +365,11 @@ do {									\
  * change the result of the wait condition.
  *
  * Returns:
- * 0 if the @timeout elapsed, -%ERESTARTSYS if it was interrupted by
- * a signal, or the remaining jiffies (at least 1) if the @condition
- * evaluated to %true before the @timeout elapsed.
+ * 0 if the @condition evaluated to %false after the @timeout elapsed,
+ * 1 if the @condition evaluated to %true after the @timeout elapsed,
+ * the remaining jiffies (at least 1) if the @condition evaluated
+ * to %true before the @timeout elapsed, or -%ERESTARTSYS if it was
+ * interrupted by a signal.
  */
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
 ({									\
-- 
2.0.4

