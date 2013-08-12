Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab3HLPJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:09:52 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:42566 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab3HLPJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:09:51 -0400
From: Sasikantha Babu <sasikanth.v19@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-kernel@vger.kernel.org, Sasikantha Babu <sasikanth.v19@gmail.com>
Subject: [PATCH 1/2] ipc/mq: Do not vaild queue attributes default/ceiling value If the user pass attr as NULL
Date: Mon, 12 Aug 2013 20:39:41 +0530
Message-Id: <1376320182-2118-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel should not validate queue attributes default/ceiling value while
creating a mqueue, if user pass attr as NULL. Otherwise In worst case
If the validation fails then sys_mq_open returns -EINVAL/-EOVERFLOW
which will make user clueless about reason for the failure.

Signed-off-by: Sasikantha Babu <sasikanth.v19@gmail.com>
---
 ipc/mqueue.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index ae1996d..04ece80 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -748,9 +748,6 @@ static struct file *do_create(struct ipc_namespace *ipc_ns, struct inode *dir,
 					 ipc_ns->mq_msg_default);
 		def_attr.mq_msgsize = min(ipc_ns->mq_msgsize_max,
 					  ipc_ns->mq_msgsize_default);
-		ret = mq_attr_ok(ipc_ns, &def_attr);
-		if (ret)
-			return ERR_PTR(ret);
 	}
 
 	mode &= ~current_umask();
-- 
1.7.3.4

