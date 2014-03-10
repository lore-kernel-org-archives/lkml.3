Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaCJUtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:49:32 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:18478 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753503AbaCJUt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:49:28 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwGAEgkHlNbsHk5/2dsb2JhbABagwaCSIERvn6BIBd0glMTHCMYgQIkE4d9Ac9ojXdkhD8BA5hEAYpWh1eDLjyBLA
Date: Mon, 10 Mar 2014 21:49:25 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/bfs/inode.c: add __init to init_inodecache()
Message-Id: <20140310214925.da91d3ad8c4d21a21ec5dbf4@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_inodecache is only called by __init init_bfs_fs

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/bfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 8defc6b..0693cbf 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -266,7 +266,7 @@ static void init_once(void *foo)
 	inode_init_once(&bi->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	bfs_inode_cachep = kmem_cache_create("bfs_inode_cache",
 					     sizeof(struct bfs_inode_info),
-- 
1.8.1.4
