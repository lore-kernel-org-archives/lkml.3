Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496AbaJaODI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:03:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759544AbaJaOAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:00:45 -0400
From: Juergen Gross <jgross@suse.com>
To: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 13/17] x86: Clean up pgtable_types.h
Date: Fri, 31 Oct 2014 15:00:29 +0100
Message-Id: <1414764033-30011-14-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414764033-30011-1-git-send-email-jgross@suse.com>
References: <1414764033-30011-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove no longer used defines from pgtable_types.h as they are not
used any longer.

Switch __PAGE_KERNEL_NOCACHE to use cache mode type instead of pte
bits.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/pgtable_types.h | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 5124642..6d5f6d1 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -128,11 +128,6 @@
 			 _PAGE_SOFT_DIRTY | _PAGE_NUMA)
 #define _HPAGE_CHG_MASK (_PAGE_CHG_MASK | _PAGE_PSE | _PAGE_NUMA)
 
-#define _PAGE_CACHE_WB		(0)
-#define _PAGE_CACHE_WC		(_PAGE_PWT)
-#define _PAGE_CACHE_UC_MINUS	(_PAGE_PCD)
-#define _PAGE_CACHE_UC		(_PAGE_PCD | _PAGE_PWT)
-
 /*
  * The cache modes defined here are used to translate between pure SW usage
  * and the HW defined cache mode bits and/or PAT entries.
@@ -178,41 +173,27 @@ enum page_cache_mode {
 
 #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
-#define __PAGE_KERNEL_EXEC_NOCACHE	(__PAGE_KERNEL_EXEC | _PAGE_PCD | _PAGE_PWT)
-#define __PAGE_KERNEL_WC		(__PAGE_KERNEL | _PAGE_CACHE_WC)
-#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
-#define __PAGE_KERNEL_UC_MINUS		(__PAGE_KERNEL | _PAGE_PCD)
+#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_NOCACHE)
 #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
 #define __PAGE_KERNEL_VVAR		(__PAGE_KERNEL_RO | _PAGE_USER)
-#define __PAGE_KERNEL_VVAR_NOCACHE	(__PAGE_KERNEL_VVAR | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
-#define __PAGE_KERNEL_LARGE_NOCACHE	(__PAGE_KERNEL | _PAGE_CACHE_UC | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
 
 #define __PAGE_KERNEL_IO		(__PAGE_KERNEL)
 #define __PAGE_KERNEL_IO_NOCACHE	(__PAGE_KERNEL_NOCACHE)
-#define __PAGE_KERNEL_IO_UC_MINUS	(__PAGE_KERNEL_UC_MINUS)
-#define __PAGE_KERNEL_IO_WC		(__PAGE_KERNEL_WC)
 
 #define PAGE_KERNEL			__pgprot(__PAGE_KERNEL)
 #define PAGE_KERNEL_RO			__pgprot(__PAGE_KERNEL_RO)
 #define PAGE_KERNEL_EXEC		__pgprot(__PAGE_KERNEL_EXEC)
 #define PAGE_KERNEL_RX			__pgprot(__PAGE_KERNEL_RX)
-#define PAGE_KERNEL_WC			__pgprot(__PAGE_KERNEL_WC)
 #define PAGE_KERNEL_NOCACHE		__pgprot(__PAGE_KERNEL_NOCACHE)
-#define PAGE_KERNEL_UC_MINUS		__pgprot(__PAGE_KERNEL_UC_MINUS)
-#define PAGE_KERNEL_EXEC_NOCACHE	__pgprot(__PAGE_KERNEL_EXEC_NOCACHE)
 #define PAGE_KERNEL_LARGE		__pgprot(__PAGE_KERNEL_LARGE)
-#define PAGE_KERNEL_LARGE_NOCACHE	__pgprot(__PAGE_KERNEL_LARGE_NOCACHE)
 #define PAGE_KERNEL_LARGE_EXEC		__pgprot(__PAGE_KERNEL_LARGE_EXEC)
 #define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL)
 #define PAGE_KERNEL_VVAR		__pgprot(__PAGE_KERNEL_VVAR)
-#define PAGE_KERNEL_VVAR_NOCACHE	__pgprot(__PAGE_KERNEL_VVAR_NOCACHE)
 
 #define PAGE_KERNEL_IO			__pgprot(__PAGE_KERNEL_IO)
 #define PAGE_KERNEL_IO_NOCACHE		__pgprot(__PAGE_KERNEL_IO_NOCACHE)
-#define PAGE_KERNEL_IO_UC_MINUS		__pgprot(__PAGE_KERNEL_IO_UC_MINUS)
-#define PAGE_KERNEL_IO_WC		__pgprot(__PAGE_KERNEL_IO_WC)
 
 /*         xwr */
 #define __P000	PAGE_NONE
-- 
1.8.4.5

