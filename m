Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab3COQxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:53:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8628 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab3COQxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:53:17 -0400
X-IronPort-AV: E=Sophos;i="4.84,852,1355068800"; 
   d="scan'208";a="6880056"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Eric Paris <eparis@parisplace.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sasha.levin@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Adam Buchbinder <adam.buchbinder@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Eric Paris <eparis@redhat.com>
Subject: [PATCH 9/9] fsnotify: remove fsnotify_init()
Date: Sat, 16 Mar 2013 00:50:57 +0800
Message-Id: <1363366257-4886-10-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 00:51:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 00:51:58,
	Serialize complete at 2013/03/16 00:51:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since fsnotify_init() is empty in runtime, remove it.
The build time test is moved to notification.c

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Eric Paris <eparis@parisplace.org>
---
 fs/notify/fsnotify.c     |    8 --------
 fs/notify/notification.c |    2 ++
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index eaa0e9e..2ea0c1a 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -295,11 +295,3 @@ out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(fsnotify);
-
-static __init int fsnotify_init(void)
-{
-	BUILD_BUG_ON(HWEIGHT32(ALL_FSNOTIFY_EVENTS) != 23);
-
-	return 0;
-}
-core_initcall(fsnotify_init);
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 7b51b05..80fc0b5 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -453,6 +453,8 @@ static __init int fsnotify_notification_init(void)
 	fsnotify_event_cachep = KMEM_CACHE(fsnotify_event, SLAB_PANIC);
 	fsnotify_event_holder_cachep = KMEM_CACHE(fsnotify_event_holder, SLAB_PANIC);
 
+	BUILD_BUG_ON(HWEIGHT32(ALL_FSNOTIFY_EVENTS) != 23);
+
 	q_overflow_event = fsnotify_create_event(NULL, FS_Q_OVERFLOW, NULL,
 						 FSNOTIFY_EVENT_NONE, NULL, 0,
 						 GFP_KERNEL);
-- 
1.7.4.4

