Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3LQDJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 22:09:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:16971 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab3LQDJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 22:09:50 -0500
X-IronPort-AV: E=Sophos;i="4.95,498,1384272000"; 
   d="scan'208";a="9273020"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-audit@redhat.com
Cc: linux-kernel@vger.kernel.org, rgb@redhat.com, eparis@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 1/2] audit: print error message when fail to create audit socket
Date: Tue, 17 Dec 2013 11:10:41 +0800
Message-Id: <1387249842-27793-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/17 11:09:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/17 11:09:21,
	Serialize complete at 2013/12/17 11:09:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

print the error message and then return -ENOMEM.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 2a0ed0b..041b951 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1083,12 +1083,11 @@ static int __net_init audit_net_init(struct net *net)
 	pr_info("audit: initializing netlink socket in namespace\n");
 
 	aunet->nlsk = netlink_kernel_create(net, NETLINK_AUDIT, &cfg);
-	if (aunet->nlsk == NULL)
-		return -ENOMEM;
-	if (!aunet->nlsk)
+	if (aunet->nlsk == NULL) {
 		audit_panic("cannot initialize netlink socket in namespace");
-	else
-		aunet->nlsk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
+		return -ENOMEM;
+	}
+	aunet->nlsk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
 	return 0;
 }
 
-- 
1.8.3.1

