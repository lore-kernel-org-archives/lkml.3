Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761847AbaGSLfX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 07:35:23 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63729 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761781AbaGSLfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 07:35:20 -0400
Date: Sat, 19 Jul 2014 17:05:13 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] mm/m68k: Eliminate memset after alloc_bootmem_pages
Message-ID: <20140719113513.GA23586@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_bootmem and related functions always return a zeroed region of memory.
Thus a memset after calls to these functions is unnecessary.

The following Coccinelle semantic patch was used for making the change:

@@
expression E,E1;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
... when != E
- memset(E,0,E1);

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
To send to: Geert Uytterhoeven <geert@linux-m68k.org>,linux-m68k@lists.linux-m68k.org,linux-kernel@vger.kernel.org
 arch/m68k/mm/init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
index acaff6a..b09a3cb 100644
--- a/arch/m68k/mm/init.c
+++ b/arch/m68k/mm/init.c
@@ -94,7 +94,6 @@ void __init paging_init(void)
 	high_memory = (void *) end_mem;
 
 	empty_zero_page = alloc_bootmem_pages(PAGE_SIZE);
-	memset(empty_zero_page, 0, PAGE_SIZE);
 
 	/*
 	 * Set up SFC/DFC registers (user data space).
-- 
1.9.1

