Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbaFPSNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:13:39 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:31105 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755350AbaFPSNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:13:38 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUHAHASn1NbtAal/2dsb2JhbABagw2rFgUBAQEBAQEFAZkkgREXdYRgI4EaN4hGAc8qF4VjiC9kHYQtBI9sileLMIgog0I7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/squashfs/file_direct.c: replace count*size kmalloc by kcalloc
Date: Mon, 16 Jun 2014 20:12:19 +0200
Message-Id: <1402942339-8993-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc manages count*sizeof overflow.

Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/squashfs/file_direct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/squashfs/file_direct.c b/fs/squashfs/file_direct.c
index 62a0de6..e9f9cf2 100644
--- a/fs/squashfs/file_direct.c
+++ b/fs/squashfs/file_direct.c
@@ -44,7 +44,7 @@ int squashfs_readpage_block(struct page *target_page, u64 block, int bsize)
 
 	pages = end_index - start_index + 1;
 
-	page = kmalloc(sizeof(void *) * pages, GFP_KERNEL);
+	page = kcalloc(pages, sizeof(void *), GFP_KERNEL);
 	if (page == NULL)
 		return res;
 
-- 
1.8.4.5

