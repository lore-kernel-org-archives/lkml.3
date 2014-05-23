Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaEWOhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:37:31 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:50370 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751562AbaEWOh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:37:28 -0400
Message-ID: <1400855845.31526.40.camel@x220>
Subject: [PATCH] Hexagon: remove checks for CONFIG_PAGE_SIZE_1MB
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 23 May 2014 16:37:25 +0200
In-Reply-To: <20140521002524.GF12698@codeaurora.org>
References: <1400326363.13824.8.camel@x220>
	 <20140521002524.GF12698@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 May 2014 14:37:25.0846 (UTC) FILETIME=[83F9D760:01CF7694]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two checks for CONFIG_PAGE_SIZE_1MB in hexagon's code. But
there is no Kconfig symbol PAGE_SIZE_1MB. Remove these unneeded checks
and the code they hide.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

Richard preferred this over the equally trivial patch to add an entry
for PAGE_SIZE_1MB.

 arch/hexagon/include/asm/page.h    | 5 -----
 arch/hexagon/include/asm/pgtable.h | 4 ----
 2 files changed, 9 deletions(-)

diff --git a/arch/hexagon/include/asm/page.h b/arch/hexagon/include/asm/page.h
index 93f5669b4aa1..7bcec3c0447c 100644
--- a/arch/hexagon/include/asm/page.h
+++ b/arch/hexagon/include/asm/page.h
@@ -45,11 +45,6 @@
 #define HEXAGON_L1_PTE_SIZE __HVM_PDE_S_256KB
 #endif
 
-#ifdef CONFIG_PAGE_SIZE_1MB
-#define PAGE_SHIFT 20
-#define HEXAGON_L1_PTE_SIZE __HVM_PDE_S_1MB
-#endif
-
 /*
  *  These should be defined in hugetlb.h, but apparently not.
  *  "Huge" for us should be 4MB or 16MB, which are both represented
diff --git a/arch/hexagon/include/asm/pgtable.h b/arch/hexagon/include/asm/pgtable.h
index d8bd54fa431e..861a993afb7e 100644
--- a/arch/hexagon/include/asm/pgtable.h
+++ b/arch/hexagon/include/asm/pgtable.h
@@ -111,10 +111,6 @@ extern unsigned long zero_page_mask;
 #define PTRS_PER_PTE 16
 #endif
 
-#ifdef CONFIG_PAGE_SIZE_1MB
-#define PTRS_PER_PTE 4
-#endif
-
 /*  Any bigger and the PTE disappears.  */
 #define pgd_ERROR(e) \
 	printk(KERN_ERR "%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__,\
-- 
1.9.0

