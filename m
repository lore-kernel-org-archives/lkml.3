Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbaJ0TM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:12:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52801 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbaJ0TDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:03:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabian Frederick <fabf@skynet.be>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 045/105] nfs: fix duplicate proc entries
Date: Mon, 27 Oct 2014 11:56:20 -0700
Message-Id: <1414436240-13879-46-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabian Frederick <fabf@skynet.be>

commit 2f3169fb18f4643ac9a6a097a6a6c71f0b2cef75 upstream.

Commit 65b38851a174
("NFS: Fix /proc/fs/nfsfs/servers and /proc/fs/nfsfs/volumes")

updated the following function:
static int nfs_volume_list_open(struct inode *inode, struct file *file)

it used &nfs_server_list_ops instead of &nfs_volume_list_ops
which means cat /proc/fs/nfsfs/volumes = /proc/fs/nfsfs/servers

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Fixes: 65b38851a174 (NFS: Fix /proc/fs/nfsfs/servers and...)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 6e37cd0..a6bb348 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1310,7 +1310,7 @@ static int nfs_server_list_show(struct seq_file *m, void *v)
  */
 static int nfs_volume_list_open(struct inode *inode, struct file *file)
 {
-	return seq_open_net(inode, file, &nfs_server_list_ops,
+	return seq_open_net(inode, file, &nfs_volume_list_ops,
 			   sizeof(struct seq_net_private));
 }
 
-- 
1.9.1

