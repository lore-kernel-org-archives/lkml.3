Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3COQwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:52:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33465 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab3COQwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:52:21 -0400
X-IronPort-AV: E=Sophos;i="4.84,852,1355068800"; 
   d="scan'208";a="6880051"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Eric Paris <eparis@parisplace.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sasha.levin@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 6/9] fsnotify: use DEFINE_SRCU() for srcu_struct
Date: Sat, 16 Mar 2013 00:50:54 +0800
Message-Id: <1363366257-4886-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 00:51:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 00:51:01,
	Serialize complete at 2013/03/16 00:51:01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEFINE_STATIC_SRCU() defines srcu struct and do init at build time.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Eric Paris <eparis@parisplace.org>
---
 fs/notify/fsnotify.c |    6 ------
 fs/notify/mark.c     |    2 +-
 2 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 4bb21d6..aba962a 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -298,14 +298,8 @@ EXPORT_SYMBOL_GPL(fsnotify);
 
 static __init int fsnotify_init(void)
 {
-	int ret;
-
 	BUG_ON(hweight32(ALL_FSNOTIFY_EVENTS) != 23);
 
-	ret = init_srcu_struct(&fsnotify_mark_srcu);
-	if (ret)
-		panic("initializing fsnotify_mark_srcu");
-
 	return 0;
 }
 core_initcall(fsnotify_init);
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index fc6b49b..aeededc 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -97,7 +97,7 @@
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
 
-struct srcu_struct fsnotify_mark_srcu;
+DEFINE_SRCU(fsnotify_mark_srcu);
 static DEFINE_SPINLOCK(destroy_lock);
 static LIST_HEAD(destroy_list);
 static DECLARE_WAIT_QUEUE_HEAD(destroy_waitq);
-- 
1.7.4.4

