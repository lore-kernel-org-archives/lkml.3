Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658AbaGSLdY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 07:33:24 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:34378 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760830AbaGSLdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 07:33:23 -0400
Date: Sat, 19 Jul 2014 17:03:16 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] uml: Eliminate NULL test after alloc_bootmem
Message-ID: <20140719113316.GA23543@himangi-Dell>
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
 arch/um/kernel/initrd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/um/kernel/initrd.c b/arch/um/kernel/initrd.c
index 55cead8..48bae81 100644
--- a/arch/um/kernel/initrd.c
+++ b/arch/um/kernel/initrd.c
@@ -37,8 +37,6 @@ static int __init read_initrd(void)
 	}
 
 	area = alloc_bootmem(size);
-	if (area == NULL)
-		return 0;
 
 	if (load_initrd(initrd, area, size) == -1)
 		return 0;
-- 
1.9.1

