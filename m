Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474AbaGSLcH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 07:32:07 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:61483 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760830AbaGSLcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 07:32:05 -0400
Date: Sat, 19 Jul 2014 17:01:57 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] UML: Eliminate NULL test after alloc_bootmem_low_pages
Message-ID: <20140719113157.GA23517@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_bootmem and related functions never return NULL. Thus a NULL
test after calls to these functions is unnecessary.

The following Coccinelle semantic patch was used for making the change:

@@
expression E;
statement S;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
... when != E
- if (E == NULL) S

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 arch/um/kernel/physmem.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/um/kernel/physmem.c b/arch/um/kernel/physmem.c
index 30fdd5d..fb041cf 100644
--- a/arch/um/kernel/physmem.c
+++ b/arch/um/kernel/physmem.c
@@ -43,8 +43,6 @@ int __init init_maps(unsigned long physmem, unsigned long iomem,
 	total_len = phys_len + iomem_len + highmem_len;
 
 	map = alloc_bootmem_low_pages(total_len);
-	if (map == NULL)
-		return -ENOMEM;
 
 	for (i = 0; i < total_pages; i++) {
 		p = &map[i];
-- 
1.9.1

