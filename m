Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbaFWQwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:52:17 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:58317 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755894AbaFWQwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:52:15 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkHAApaqFNbskjJ/2dsb2JhbABZgw2rZwUBAQEBAQEFAZk1gQ8XdYRgI4EaN4hGAcQnF4VjiDVkHYQtBI9yilqTY4NEO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Axel Lin <axel.lin@ingics.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/ramfs/file-nommu.c:  replace count*size kzalloc by kcalloc
Date: Mon, 23 Jun 2014 18:50:58 +0200
Message-Id: <1403542258-11701-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Axel Lin <axel.lin@ingics.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ramfs/file-nommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index dda012a..bbafbde 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -222,7 +222,7 @@ static unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
 
 	/* gang-find the pages */
 	ret = -ENOMEM;
-	pages = kzalloc(lpages * sizeof(struct page *), GFP_KERNEL);
+	pages = kcalloc(lpages, sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
 		goto out_free;
 
-- 
1.8.4.5

