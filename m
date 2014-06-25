Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaFYSqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:46:07 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:57093 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138AbaFYSqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:46:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4HAIAYq1NXQ7ge/2dsb2JhbABZgw2rLgsFAZR6hECBDhd1hGAjgRo3iEYBqxGYFxeFY4g1ZB2ELQWPdIpdizaINYNEO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/pstore/ram_core.c: replace count*size kmalloc by kmalloc_array
Date: Wed, 25 Jun 2014 20:45:27 +0200
Message-Id: <1403721927-19568-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc_array manages count*sizeof overflow.

Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/pstore/ram_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 34a1e5a..9d7b9a8 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -394,7 +394,7 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size)
 
 	prot = pgprot_noncached(PAGE_KERNEL);
 
-	pages = kmalloc(sizeof(struct page *) * page_count, GFP_KERNEL);
+	pages = kmalloc_array(page_count, sizeof(struct page *), GFP_KERNEL);
 	if (!pages) {
 		pr_err("%s: Failed to allocate array for %u pages\n",
 		       __func__, page_count);
-- 
1.9.1

