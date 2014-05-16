Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbaEPP5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:57:41 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:18619 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751030AbaEPP5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:57:40 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjASAKM0dlNXQB71/2dsb2JhbABZgwaCQqgmBQUFAZoZAgKBFhd0gmYcIxiBAiQTiEUB0haFVYgWZIRHAQOPLYoqAYsRiAiDOTuBMQ
Date: Fri, 16 May 2014 17:57:36 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/3] fs/hugetlbfs/inode.c: add static to
 hugetlbfs_i_mmap_mutex_key
Message-Id: <20140516175736.41d55f952e3f073871220936@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hugetlbfs_i_mmap_mutex_key is only used in inode.c

Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/hugetlbfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index e19d4c0..1c766f4 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -475,7 +475,7 @@ static struct inode *hugetlbfs_get_root(struct super_block *sb,
  * annotation because huge_pmd_share() does an allocation under
  * i_mmap_mutex.
  */
-struct lock_class_key hugetlbfs_i_mmap_mutex_key;
+static struct lock_class_key hugetlbfs_i_mmap_mutex_key;
 
 static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 					struct inode *dir,
-- 
1.8.4.5

