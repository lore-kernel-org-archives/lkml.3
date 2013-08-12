Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab3HLPKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:10:01 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:42188 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab3HLPJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:09:56 -0400
From: Sasikantha Babu <sasikanth.v19@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-kernel@vger.kernel.org, Sasikantha Babu <sasikanth.v19@gmail.com>
Subject: [PATCH 2/2] ipc/mq: Removed unused def_attr local variable and its initialization in do_create
Date: Mon, 12 Aug 2013 20:39:42 +0530
Message-Id: <1376320182-2118-2-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1376320182-2118-1-git-send-email-sasikanth.v19@gmail.com>
References: <1376320182-2118-1-git-send-email-sasikanth.v19@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the first patch since we removed calling mq_attr_ok to validate
mqueue attributes default/ceil values, So removing the unused def_attr

Signed-off-by: Sasikantha Babu <sasikanth.v19@gmail.com>
---
 ipc/mqueue.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 04ece80..0bcf69c 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -741,13 +741,6 @@ static struct file *do_create(struct ipc_namespace *ipc_ns, struct inode *dir,
 			return ERR_PTR(ret);
 		/* store for use during create */
 		path->dentry->d_fsdata = attr;
-	} else {
-		struct mq_attr def_attr;
-
-		def_attr.mq_maxmsg = min(ipc_ns->mq_msg_max,
-					 ipc_ns->mq_msg_default);
-		def_attr.mq_msgsize = min(ipc_ns->mq_msgsize_max,
-					  ipc_ns->mq_msgsize_default);
 	}
 
 	mode &= ~current_umask();
-- 
1.7.3.4

