Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab3COQw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:52:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42940 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab3COQwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:52:55 -0400
X-IronPort-AV: E=Sophos;i="4.84,852,1355068800"; 
   d="scan'208";a="6880054"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Eric Paris <eparis@parisplace.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sasha.levin@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 8/9] fsnotify: use BUILD_BUG_ON() to test the weight of ALL_FSNOTIFY_EVENTS
Date: Sat, 16 Mar 2013 00:50:56 +0800
Message-Id: <1363366257-4886-9-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 00:51:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 00:51:36,
	Serialize complete at 2013/03/16 00:51:36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUILD_BUG_ON() is build-time-test for constant. avoid runtime test.
also use HWEIGHT32() for build-time.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Eric Paris <eparis@parisplace.org>
---
 fs/notify/fsnotify.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index aba962a..eaa0e9e 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -298,7 +298,7 @@ EXPORT_SYMBOL_GPL(fsnotify);
 
 static __init int fsnotify_init(void)
 {
-	BUG_ON(hweight32(ALL_FSNOTIFY_EVENTS) != 23);
+	BUILD_BUG_ON(HWEIGHT32(ALL_FSNOTIFY_EVENTS) != 23);
 
 	return 0;
 }
-- 
1.7.4.4

