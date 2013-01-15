Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab3AOMft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:35:49 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42217 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505Ab3AOMe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:34:27 -0500
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: [PATCH 3/7] sched: allow try_to_wake_up to be used internally outside of core.c
Date: Tue, 15 Jan 2013 13:34:00 +0100
Message-Id: <1358253244-11453-4-git-send-email-maarten.lankhorst@canonical.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not exported, since only used by the fence implementation.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 include/linux/wait.h | 1 +
 kernel/sched/core.c  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 7cb64d4..7aaba95 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -11,6 +11,7 @@
 typedef struct __wait_queue wait_queue_t;
 typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int flags, void *key);
 int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *key);
+int try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags);
 
 struct __wait_queue {
 	unsigned int flags;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 257002c..5f23fe3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1425,7 +1425,7 @@ static void ttwu_queue(struct task_struct *p, int cpu)
  * Returns %true if @p was woken up, %false if it was already running
  * or @state didn't match @p's state.
  */
-static int
+int
 try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 {
 	unsigned long flags;
-- 
1.8.0.3

