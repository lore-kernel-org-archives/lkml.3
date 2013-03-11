Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab3CKQ2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:28:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6269 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab3CKQ2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:28:10 -0400
X-IronPort-AV: E=Sophos;i="4.84,824,1355068800"; 
   d="scan'208";a="6852602"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/3] async: remove unused @node from struct async_domain
Date: Tue, 12 Mar 2013 00:30:03 +0800
Message-Id: <1363019405-4331-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1363019405-4331-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363019405-4331-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 00:26:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 00:26:57,
	Serialize complete at 2013/03/12 00:26:57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The @node in struct async_domain is unused after we introduce
async_global_pending, remove it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/async.h |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/include/linux/async.h b/include/linux/async.h
index a2e3f18..8e53494 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -18,7 +18,6 @@
 typedef u64 async_cookie_t;
 typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
 struct async_domain {
-	struct list_head node;
 	struct list_head pending;
 	unsigned registered:1;
 };
@@ -26,19 +25,15 @@ struct async_domain {
 /*
  * domain participates in global async_synchronize_full
  */
-#define ASYNC_DOMAIN(_name) \
-	struct async_domain _name = { .node = LIST_HEAD_INIT(_name.node), \
-				      .pending = LIST_HEAD_INIT(_name.pending), \
-				      .registered = 1 }
+#define ASYNC_DOMAIN(_name) struct async_domain _name =			\
+	{ .pending = LIST_HEAD_INIT(_name.pending), .registered = 1 }
 
 /*
  * domain is free to go out of scope as soon as all pending work is
  * complete, this domain does not participate in async_synchronize_full
  */
-#define ASYNC_DOMAIN_EXCLUSIVE(_name) \
-	struct async_domain _name = { .node = LIST_HEAD_INIT(_name.node), \
-				      .pending = LIST_HEAD_INIT(_name.pending), \
-				      .registered = 0 }
+#define ASYNC_DOMAIN_EXCLUSIVE(_name) struct async_domain _name =	\
+	{ .pending = LIST_HEAD_INIT(_name.pending), .registered = 0 }
 
 extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
 extern async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
-- 
1.7.4.4

