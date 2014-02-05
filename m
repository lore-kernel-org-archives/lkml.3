Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbaBEU6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:58:20 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48129 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbaBEUFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:24 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 076/213] NFSv3: Ensure that do_proc_get_root() reports errors correctly
Date: Wed, 5 Feb 2014 15:00:31 -0500
Message-ID: <1391630568-49251-77-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 086600430493e04b802bee6e5b3ce0458e4eb77f upstream.

If the rpc call to NFS3PROC_FSINFO fails, then we need to report that
error so that the mount fails. Otherwise we can end up with a
superblock with completely unusable values for block sizes, maxfilesize,
etc.

Reported-by: Yuanming Chen <hikvision_linux@163.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfs/nfs3proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index e701002694e5..4958497da25b 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -68,7 +68,7 @@ do_proc_get_root(struct rpc_clnt *client, struct nfs_fh *fhandle,
 	nfs_fattr_init(info->fattr);
 	status = rpc_call_sync(client, &msg, 0);
 	dprintk("%s: reply fsinfo: %d\n", __func__, status);
-	if (!(info->fattr->valid & NFS_ATTR_FATTR)) {
+	if (status == 0 && !(info->fattr->valid & NFS_ATTR_FATTR)) {
 		msg.rpc_proc = &nfs3_procedures[NFS3PROC_GETATTR];
 		msg.rpc_resp = info->fattr;
 		status = rpc_call_sync(client, &msg, 0);
-- 
1.8.5.2

