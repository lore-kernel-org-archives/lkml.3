Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762008AbaGSLhu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 07:37:50 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:49423 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761022AbaGSLhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 07:37:48 -0400
Date: Sat, 19 Jul 2014 17:07:41 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] parisc: Eliminate memset after alloc_bootmem_pages
Message-ID: <20140719113741.GA23655@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_bootmem and related function always return zeroed region of
memory. Thus a memset after calls to these functions is unnecessary.

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
 arch/parisc/mm/init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index ae085ad..0bef864 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -728,7 +728,6 @@ static void __init pagetable_init(void)
 #endif
 
 	empty_zero_page = alloc_bootmem_pages(PAGE_SIZE);
-	memset(empty_zero_page, 0, PAGE_SIZE);
 }
 
 static void __init gateway_init(void)
-- 
1.9.1

