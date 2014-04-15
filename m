Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaDOL2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:28:14 -0400
Received: from relay.parallels.com ([195.214.232.42]:54428 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaDOL2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:28:11 -0400
Subject: [PATCH 1/7] fuse: do not use uninitialized i_mode
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Date: Tue, 15 Apr 2014 15:28:10 +0400
Message-ID: <20140415112756.11860.43431.stgit@dhcp-10-30-30-94.sw.ru>
In-Reply-To: <20140415112413.11860.1451.stgit@dhcp-10-30-30-94.sw.ru>
References: <20140415112413.11860.1451.stgit@dhcp-10-30-30-94.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When inode is in I_NEW state, inode->i_mode is not initialized yet. Do not
use it before fuse_init_inode() is called.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 8d61169..299e553 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -303,7 +303,7 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 
 	if ((inode->i_state & I_NEW)) {
 		inode->i_flags |= S_NOATIME;
-		if (!fc->writeback_cache || !S_ISREG(inode->i_mode))
+		if (!fc->writeback_cache || !S_ISREG(attr->mode))
 			inode->i_flags |= S_NOCMTIME;
 		inode->i_generation = generation;
 		inode->i_data.backing_dev_info = &fc->bdi;

