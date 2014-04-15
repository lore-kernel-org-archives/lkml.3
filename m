Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaDOBuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:50:04 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44963 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaDOBuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:50:02 -0400
Message-ID: <534C903C.6050904@gmail.com>
Date: Tue, 15 Apr 2014 09:49:48 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>, viro@zeniv.linux.org.uk
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] unicore32: include: asm: add missing ')' for PAGE_* macros
 in pgtable.h
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missing related ')', the related compiling error:

    CC [M]  drivers/gpu/drm/udl/udl_fb.o
  drivers/gpu/drm/udl/udl_fb.c: In function ‘udl_fb_mmap’:
  drivers/gpu/drm/udl/udl_fb.c:273: error: expected ‘)’ before ‘return’
  drivers/gpu/drm/udl/udl_fb.c:281: error: expected expression before ‘}’ token
  make[4]: *** [drivers/gpu/drm/udl/udl_fb.o] Error 1
  make[3]: *** [drivers/gpu/drm/udl] Error 2
  make[2]: *** [drivers/gpu/drm] Error 2
  make[1]: *** [drivers/gpu] Error 2
  make: *** [drivers] Error 2


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/unicore32/include/asm/pgtable.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/unicore32/include/asm/pgtable.h b/arch/unicore32/include/asm/pgtable.h
index 233c258..ed6f7d0 100644
--- a/arch/unicore32/include/asm/pgtable.h
+++ b/arch/unicore32/include/asm/pgtable.h
@@ -87,16 +87,16 @@ extern pgprot_t pgprot_kernel;
 
 #define PAGE_NONE		pgprot_user
 #define PAGE_SHARED		__pgprot(pgprot_val(pgprot_user | PTE_READ \
-								| PTE_WRITE)
+								| PTE_WRITE))
 #define PAGE_SHARED_EXEC	__pgprot(pgprot_val(pgprot_user | PTE_READ \
 								| PTE_WRITE \
-								| PTE_EXEC)
+								| PTE_EXEC))
 #define PAGE_COPY		__pgprot(pgprot_val(pgprot_user | PTE_READ)
 #define PAGE_COPY_EXEC		__pgprot(pgprot_val(pgprot_user | PTE_READ \
-								| PTE_EXEC)
-#define PAGE_READONLY		__pgprot(pgprot_val(pgprot_user | PTE_READ)
+								| PTE_EXEC))
+#define PAGE_READONLY		__pgprot(pgprot_val(pgprot_user | PTE_READ))
 #define PAGE_READONLY_EXEC	__pgprot(pgprot_val(pgprot_user | PTE_READ \
-								| PTE_EXEC)
+								| PTE_EXEC))
 #define PAGE_KERNEL		pgprot_kernel
 #define PAGE_KERNEL_EXEC	__pgprot(pgprot_val(pgprot_kernel | PTE_EXEC))
 
-- 
1.7.9.5
