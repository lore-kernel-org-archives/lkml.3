Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaCXMRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:17:53 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57839 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbaCXMRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:17:51 -0400
Message-ID: <53302268.4030002@gmail.com>
Date: Mon, 24 Mar 2014 20:17:44 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: gxt@mprc.pku.edu.cn,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/unicore32/mm/alignment.c: include "asm/pgtable.h" to
 avoid compiling error
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need include "asm/pgtable.h" to include "asm-generic/pgtable-nopmd.h",
so can let 'pmd_t' defined. The related error with allmodconfig:

    CC      arch/unicore32/mm/alignment.o
  In file included from arch/unicore32/mm/alignment.c:24:
  arch/unicore32/include/asm/tlbflush.h:135: error: expected ‘)’ before ‘*’ token
  arch/unicore32/include/asm/tlbflush.h:154: error: expected ‘)’ before ‘*’ token
  In file included from arch/unicore32/mm/alignment.c:27:
  arch/unicore32/mm/mm.h:15: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘*’ token
  arch/unicore32/mm/mm.h:20: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘*’ token
  arch/unicore32/mm/mm.h:25: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘*’ token
  make[1]: *** [arch/unicore32/mm/alignment.o] Error 1
  make: *** [arch/unicore32/mm] Error 2


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/unicore32/mm/alignment.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/unicore32/mm/alignment.c b/arch/unicore32/mm/alignment.c
index de7dc5f..24e8360 100644
--- a/arch/unicore32/mm/alignment.c
+++ b/arch/unicore32/mm/alignment.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/uaccess.h>
 
+#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/unaligned.h>
 
-- 
1.7.9.5
