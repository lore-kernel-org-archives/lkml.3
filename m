Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaFTH3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 03:29:42 -0400
Received: from mail.zhinst.com ([212.126.164.98]:54448 "EHLO mail.zhinst.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbaFTH3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:29:41 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: Greg Ungerer <gerg@uclinux.org>, Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] m68knommu: Remove unnecessary prototype for kobjsize()
Date: Fri, 20 Jun 2014 09:29:36 +0200
Message-Id: <1403249376-27739-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prototype for kobjsize() is already defined in linux/mm.h which is
included where kobjsize() is used.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 arch/m68k/include/asm/pgtable_no.h |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/m68k/include/asm/pgtable_no.h b/arch/m68k/include/asm/pgtable_no.h
index c527fc2..11859b8 100644
--- a/arch/m68k/include/asm/pgtable_no.h
+++ b/arch/m68k/include/asm/pgtable_no.h
@@ -46,11 +46,6 @@ static inline int pte_file(pte_t pte) { return 0; }
 #define ZERO_PAGE(vaddr)	(virt_to_page(0))
 
 /*
- * These would be in other places but having them here reduces the diffs.
- */
-extern unsigned int kobjsize(const void *objp);
-
-/*
  * No page table caches to initialise.
  */
 #define pgtable_cache_init()	do { } while (0)
-- 
1.7.9.5


