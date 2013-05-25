Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3EYLI5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 07:08:57 -0400
Received: from mail.nagafix.co.uk ([194.145.196.85]:45125 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab3EYLIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 07:08:49 -0400
X-Greylist: delayed 799 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 May 2013 07:08:49 EDT
Message-ID: <51A0989A.6070100@nagafix.co.uk>
Date: Sat, 25 May 2013 17:55:22 +0700
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: stable@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org, user-mode-linux-user@lists.sourceforge.net
Subject: UML build broken since 3.0.75 (also affects 3.2.x)
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus' vm patches broke the UML build in 3.0.75 onwards:

  CC      mm/memory.o
mm/memory.c: In function ‘vm_iomap_memory’:
mm/memory.c:2363:2: error: implicit declaration of function
‘io_remap_pfn_range’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[1]: *** [mm/memory.o] Error 1
make: *** [mm] Error 2


This fix is just a copy of what is found in later kernels.
Compiled and boot tested both 3.0.80 and 3.2.45, x86_64 and i386.

Signed-off-by: Antoine Martin <antoine@nagafix.co.uk>

--- a/arch/um/include/asm/pgtable.h	2013-05-25 09:20:51.420000000 +0000
+++ b/arch/um/include/asm/pgtable.h	2013-04-29 00:36:01.000000000 +0000
@@ -69,6 +69,8 @@
 #define PAGE_KERNEL	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY |
_PAGE_ACCESSED)
 #define PAGE_KERNEL_EXEC	__pgprot(__PAGE_KERNEL_EXEC)

+#define io_remap_pfn_range	remap_pfn_range
+
 /*
  * The i386 can't do page protection for execute, and considers that
the same
  * are read.
