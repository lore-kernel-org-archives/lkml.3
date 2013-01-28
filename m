Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3A1DIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 22:08:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49525 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab3A1DIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 22:08:31 -0500
X-IronPort-AV: E=Sophos;i="4.84,549,1355068800"; 
   d="scan'208";a="6651809"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: ebiederm@xmission.com
Cc: serge.hallyn@canonical.com, akpm@linux-foundation.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH] userns: Allow the unprivileged users to mount mqueue fs
Date: Mon, 28 Jan 2013 11:09:01 +0800
Message-Id: <1359342541-383-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/28 11:07:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/28 11:07:24,
	Serialize complete at 2013/01/28 11:07:24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allow the unprivileged user to mount mqueuefs in
user ns.

If two userns share the same ipcns,the files in mqueue fs
should be seen in both these two userns.

If the userns has its own ipcns,it has its own mqueue fs too.
ipcns has already done this job well.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 ipc/mqueue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 71a3ca1..023c986 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1383,6 +1383,7 @@ static struct file_system_type mqueue_fs_type = {
 	.name = "mqueue",
 	.mount = mqueue_mount,
 	.kill_sb = kill_litter_super,
+	.fs_flags = FS_USERNS_MOUNT,
 };
 
 int mq_init_ns(struct ipc_namespace *ns)
-- 
1.7.11.7

