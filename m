Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab3E1Dyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:54:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52559 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758822Ab3E1DyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:11 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jeff Layton" <jlayton@redhat.com>,
        "Trond Myklebust" <Trond.Myklebust@netapp.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.690390643@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [54/94] sunrpc: clarify comments on rpc_make_runnable
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 506026c3ec270e18402f0c9d33fee37482c23861 upstream.

rpc_make_runnable is not generally called with the queue lock held, unless
it's waking up a task that has been sitting on a waitqueue. This is safe
when the task has not entered the FSM yet, but the comments don't really
spell this out.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/sched.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -296,8 +296,9 @@ EXPORT_SYMBOL_GPL(__rpc_wait_for_complet
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

