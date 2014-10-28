Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbaJ1Hwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:52:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbaJ1DiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:38:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.17 058/146] nfs: fix duplicate proc entries
Date: Tue, 28 Oct 2014 11:33:20 +0800
Message-Id: <20141028033345.906079197@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1318,7 +1318,7 @@ static int nfs_server_list_show(struct s
  */
 static int nfs_volume_list_open(struct inode *inode, struct file *file)
 {
-	return seq_open_net(inode, file, &nfs_server_list_ops,
+	return seq_open_net(inode, file, &nfs_volume_list_ops,
 			   sizeof(struct seq_net_private));
 }
 


