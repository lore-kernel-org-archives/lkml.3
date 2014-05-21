Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaEUAzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 20:55:04 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33202 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaEUAzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 20:55:02 -0400
Message-ID: <537BF961.9070704@gmail.com>
Date: Wed, 21 May 2014 08:54:57 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/unicore32/kernel/ksyms.c: remote 2 export symbols to
 avoid compiling failure
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
