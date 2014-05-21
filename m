Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaEUA57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 20:57:59 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:57077 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaEUA55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 20:57:57 -0400
Message-ID: <537BFA11.4050809@gmail.com>
Date: Wed, 21 May 2014 08:57:53 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] arch/unicore32/kernel/ksyms.c: remove 2 export symbols
 to avoid compiling failure
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'csum_partial' and 'csum_partial_copy_from_user' have already been
exported in "lib/", so need not export them again, or it will cause
compiling error.

The related error (with allmodconfig under unicore32):

    LD      vmlinux.o
  lib/built-in.o:(___ksymtab+csum_partial+0x0): multiple definition of `__ksymtab_csum_partial'
  arch/unicore32/kernel/built-in.o:(___ksymtab+csum_partial+0x0): first defined here
  lib/built-in.o:(___ksymtab+csum_partial_copy_from_user+0x0): multiple definition of `__ksymtab_csum_partial_copy_from_user'
  arch/unicore32/kernel/built-in.o:(___ksymtab+csum_partial_copy_from_user+0x0): first defined here
  make: *** [vmlinux] Error 1


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/unicore32/kernel/ksyms.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/unicore32/kernel/ksyms.c b/arch/unicore32/kernel/ksyms.c
index 63afc7f..bc06140 100644
--- a/arch/unicore32/kernel/ksyms.c
+++ b/arch/unicore32/kernel/ksyms.c
@@ -30,10 +30,6 @@ EXPORT_SYMBOL(find_next_bit);
 EXPORT_SYMBOL(__udelay);
 EXPORT_SYMBOL(__const_udelay);
 
-	/* networking */
-EXPORT_SYMBOL(csum_partial);
-EXPORT_SYMBOL(csum_partial_copy_from_user);
-
 	/* string / mem functions */
 EXPORT_SYMBOL(strchr);
 EXPORT_SYMBOL(strrchr);
-- 
1.9.2.459.g68773ac
