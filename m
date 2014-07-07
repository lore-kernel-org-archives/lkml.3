Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaGHAsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:48:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbaGGXyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Xuetao Guan <gxt@mprc.pku.edu.cn>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.15 120/122] arch/unicore32/mm/alignment.c: include "asm/pgtable.h" to avoid compiling error
Date: Mon,  7 Jul 2014 16:58:02 -0700
Message-Id: <20140707235737.836998204@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen.5i5j@gmail.com>

commit 1ff38c56cbd095c4c0dfa581a859ba3557830f78 upstream.

Need include "asm/pgtable.h" to include "asm-generic/pgtable-nopmd.h",
so can let 'pmd_t' defined. The related error with allmodconfig:

    CC      arch/unicore32/mm/alignment.o
  In file included from arch/unicore32/mm/alignment.c:24:
  arch/unicore32/include/asm/tlbflush.h:135: error: expected .). before .*. token
  arch/unicore32/include/asm/tlbflush.h:154: error: expected .). before .*. token
  In file included from arch/unicore32/mm/alignment.c:27:
  arch/unicore32/mm/mm.h:15: error: expected .=., .,., .;., .sm. or ._attribute__. before .*. token
  arch/unicore32/mm/mm.h:20: error: expected .=., .,., .;., .sm. or ._attribute__. before .*. token
  arch/unicore32/mm/mm.h:25: error: expected .=., .,., .;., .sm. or ._attribute__. before .*. token
  make[1]: *** [arch/unicore32/mm/alignment.o] Error 1
  make: *** [arch/unicore32/mm] Error 2

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>
Signed-off-by: Xuetao Guan <gxt@mprc.pku.edu.cn>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/unicore32/mm/alignment.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/unicore32/mm/alignment.c
+++ b/arch/unicore32/mm/alignment.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/uaccess.h>
 
+#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/unaligned.h>
 


