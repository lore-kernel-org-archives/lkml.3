Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbaLYJnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 04:43:25 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:61339 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbaLYJnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 04:43:22 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjUWALbbm1RXQ7EK/2dsb2JhbABcgwaBKrQRBQEBAQEBAQUBd5cqBAKBChcBAQEBAX2EOi8jgRo3iDABuCmPUiyGAIkOZB2EEwWNdIkUkVAigUUBgik9MYEDgUABAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, reiserfs-devel@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1 linux-next] fs/reiserfs/inode.c: replace 0 by NULL for pointers
Date: Thu, 25 Dec 2014 10:43:15 +0100
Message-Id: <1419500596-12760-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning:
fs/reiserfs/inode.c:2769:19: warning: Using plain integer as NULL pointer

Cc: reiserfs-devel@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/reiserfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index a7eec98..e72401e 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2766,7 +2766,7 @@ static int reiserfs_write_begin(struct file *file,
 	int old_ref = 0;
 
  	inode = mapping->host;
-	*fsdata = 0;
+	*fsdata = NULL;
  	if (flags & AOP_FLAG_CONT_EXPAND &&
  	    (pos & (inode->i_sb->s_blocksize - 1)) == 0) {
  		pos ++;
-- 
1.9.1

