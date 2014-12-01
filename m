Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbaLAUl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:41:57 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:52637 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbaLAUlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:41:55 -0500
Message-ID: <547CD304.20407@gmail.com>
Date: Tue, 02 Dec 2014 04:43:48 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        minchan@kernel.org, "rth@twiddle.net" <rth@twiddle.net>,
        "ink@jurassic.park.msu.ru" <ink@jurassic.park.msu.ru>,
        "mattst88@gmail.com" <mattst88@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "jejb@parisc-linux.org" <jejb@parisc-linux.org>,
        "deller@gmx.de" <deller@gmx.de>, "chris@zankel.net" <chris@zankel.net>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>
CC: "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] arch: uapi: asm: mman.h: Support MADV_FREE for madvise()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present, kernel supports madvise(MADV_FREE), so can benefit to all
related architectures (can grep MADV_WILLNEED or MADV_REMOVE in "arch/"
to know about all related architectures).

The related git commit: "4fb10ba mm: support madvise(MADV_FREE)".

The related error (with allmodconfig under parisc):

    CC      mm/madvise.o
  mm/madvise.c: In function 'madvise_need_mmap_write':
  mm/madvise.c:42:7: error: 'MADV_FREE' undeclared (first use in this function)
    case MADV_FREE:
       ^
  mm/madvise.c:42:7: note: each undeclared identifier is reported only once for each function it appears in
  mm/madvise.c: In function 'madvise_vma':
  mm/madvise.c:534:7: error: 'MADV_FREE' undeclared (first use in this function)
    case MADV_FREE:
       ^
  mm/madvise.c: In function 'madvise_behavior_valid':
  mm/madvise.c:561:7: error: 'MADV_FREE' undeclared (first use in this function)
    case MADV_FREE:
       ^
  make[1]: *** [mm/madvise.o] Error 1
  make: *** [mm] Error 2

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/alpha/include/uapi/asm/mman.h  | 1 +
 arch/mips/include/uapi/asm/mman.h   | 1 +
 arch/parisc/include/uapi/asm/mman.h | 1 +
 arch/xtensa/include/uapi/asm/mman.h | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/alpha/include/uapi/asm/mman.h b/arch/alpha/include/uapi/asm/mman.h
index 0086b47..836fbd4 100644
--- a/arch/alpha/include/uapi/asm/mman.h
+++ b/arch/alpha/include/uapi/asm/mman.h
@@ -44,6 +44,7 @@
 #define MADV_WILLNEED	3		/* will need these pages */
 #define	MADV_SPACEAVAIL	5		/* ensure resources are available */
 #define MADV_DONTNEED	6		/* don't need these pages */
+#define MADV_FREE	7		/* free pages only if memory pressure */
 
 /* common/generic parameters */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff --git a/arch/mips/include/uapi/asm/mman.h b/arch/mips/include/uapi/asm/mman.h
index cfcb876..106e741 100644
--- a/arch/mips/include/uapi/asm/mman.h
+++ b/arch/mips/include/uapi/asm/mman.h
@@ -67,6 +67,7 @@
 #define MADV_SEQUENTIAL 2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
+#define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff --git a/arch/parisc/include/uapi/asm/mman.h b/arch/parisc/include/uapi/asm/mman.h
index 294d251..6cb8db7 100644
--- a/arch/parisc/include/uapi/asm/mman.h
+++ b/arch/parisc/include/uapi/asm/mman.h
@@ -40,6 +40,7 @@
 #define MADV_SPACEAVAIL 5               /* insure that resources are reserved */
 #define MADV_VPS_PURGE  6               /* Purge pages from VM page cache */
 #define MADV_VPS_INHERIT 7              /* Inherit parents page size */
+#define MADV_FREE	8		/* free pages only if memory pressure */
 
 /* common/generic parameters */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff --git a/arch/xtensa/include/uapi/asm/mman.h b/arch/xtensa/include/uapi/asm/mman.h
index 201aec0..1b19f25 100644
--- a/arch/xtensa/include/uapi/asm/mman.h
+++ b/arch/xtensa/include/uapi/asm/mman.h
@@ -80,6 +80,7 @@
 #define MADV_SEQUENTIAL	2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
+#define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
 #define MADV_REMOVE	9		/* remove these pages & resources */
-- 
1.9.3
