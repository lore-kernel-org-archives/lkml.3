Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934717AbaFTH3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 03:29:50 -0400
Received: from mail.zhinst.com ([212.126.164.98]:54452 "EHLO mail.zhinst.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934032AbaFTH3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:29:48 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: nommu: Remove unnecessary prototype for kobjsize()
Date: Fri, 20 Jun 2014 09:29:47 +0200
Message-Id: <1403249387-27797-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prototype for kobjsize() is already defined in linux/mm.h which is
included where kobjsize() is used.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 arch/arm/include/asm/pgtable-nommu.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-nommu.h b/arch/arm/include/asm/pgtable-nommu.h
index 0642228..e184eaf 100644
--- a/arch/arm/include/asm/pgtable-nommu.h
+++ b/arch/arm/include/asm/pgtable-nommu.h
@@ -69,12 +69,6 @@ static inline int pte_file(pte_t pte) { return 0; }
 #define pgprot_writecombine(prot) __pgprot(0)
 #define pgprot_dmacoherent(prot) __pgprot(0)
 
-
-/*
- * These would be in other places but having them here reduces the diffs.
- */
-extern unsigned int kobjsize(const void *objp);
-
 /*
  * No page table caches to initialise.
  */
-- 
1.7.9.5


