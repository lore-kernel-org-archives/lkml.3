Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbaFPStw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:49:52 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:62790 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582AbaFPStu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:49:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUHAHASn1NbtAal/2dsb2JhbABagw2rFgUBAQEBAQEFAZkkgREXdYRgI4EaN4hGAc8qF4VjiC9kHYQtBI9sileLMIgogX6BRDuBMQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH V2] fs/squashfs/file_direct.c: replace count*size kmalloc by  kmalloc_array
Date: Mon, 16 Jun 2014 20:48:22 +0200
Message-Id: <1402944502-12263-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc_array manages count*sizeof overflow.

Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2:
   use kmalloc_array instead of kcalloc (suggested by Joe Perches).

 fs/squashfs/file_direct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/squashfs/file_direct.c b/fs/squashfs/file_direct.c
index 62a0de6..43e7a7e 100644
--- a/fs/squashfs/file_direct.c
+++ b/fs/squashfs/file_direct.c
@@ -44,7 +44,7 @@ int squashfs_readpage_block(struct page *target_page, u64 block, int bsize)
 
 	pages = end_index - start_index + 1;
 
-	page = kmalloc(sizeof(void *) * pages, GFP_KERNEL);
+	page = kmalloc_array(pages, sizeof(void *), GFP_KERNEL);
 	if (page == NULL)
 		return res;
 
-- 
1.8.4.5

