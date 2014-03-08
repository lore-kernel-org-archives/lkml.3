Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbaCHBSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:18:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbaCHBHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 77/99] sunrpc: clarify comments on rpc_make_runnable
Date: Fri,  7 Mar 2014 17:08:13 -0800
Message-Id: <20140308010614.065965285@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/sched.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -302,8 +302,9 @@ EXPORT_SYMBOL_GPL(__rpc_wait_for_complet
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


