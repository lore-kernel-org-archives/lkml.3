Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaKKLJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:09:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57116 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbaKKLJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabian Frederick <fabf@skynet.be>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 010/170] nfs: fix duplicate proc entries
Date: Tue, 11 Nov 2014 11:06:09 +0000
Message-Id: <1415704129-12709-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 180d1ec9c32e..180786a33d6f 100644
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
2.1.0

