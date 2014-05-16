Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbaEPP7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:59:43 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:56673 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757361AbaEPP7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:59:42 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjASAFk1dlNXQB71/2dsb2JhbABZgwaCQqgmBQUFAZoZAgKBFhd0glMTHCMYgQIkE4hFAdIThVWIeoRHAQOPLYoqAZMZgzk7
Date: Fri, 16 May 2014 17:59:39 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 3/3] fs/hugetlbfs/inode.c: remove null test before kfree
Message-Id: <20140516175939.681b1f8fe1c0cff328e71c00@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/hugetlbfs/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 78cface..f8bf842 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -902,8 +902,7 @@ hugetlbfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_free;
 	return 0;
 out_free:
-	if (sbinfo->spool)
-		kfree(sbinfo->spool);
+	kfree(sbinfo->spool);
 	kfree(sbinfo);
 	return -ENOMEM;
 }
-- 
1.8.4.5

