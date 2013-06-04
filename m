Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab3FDOIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:08:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46733 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab3FDOIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:08:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 24/70] sunrpc: clarify comments on rpc_make_runnable
Date: Tue,  4 Jun 2013 15:06:40 +0100
Message-Id: <1370354846-14213-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 506026c3ec270e18402f0c9d33fee37482c23861 upstream.

rpc_make_runnable is not generally called with the queue lock held, unless
it's waking up a task that has been sitting on a waitqueue. This is safe
when the task has not entered the FSM yet, but the comments don't really
spell this out.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sunrpc/sched.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 72d89e1..38cca32 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -302,8 +302,9 @@ EXPORT_SYMBOL_GPL(__rpc_wait_for_completion_task);
 /*
  * Make an RPC task runnable.
  *
- * Note: If the task is ASYNC, this must be called with
- * the spinlock held to protect the wait queue operation.
+ * Note: If the task is ASYNC, and is being made runnable after sitting on an
+ * rpc_wait_queue, this must be called with the queue spinlock held to protect
+ * the wait queue operation.
  */
 static void rpc_make_runnable(struct rpc_task *task)
 {
-- 
1.8.1.2

