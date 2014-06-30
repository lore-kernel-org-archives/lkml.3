Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaF3L6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:58:16 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52119 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754046AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chen Gang <gang.chen.5i5j@gmail.com>,
        Xuetao Guan <gxt@mprc.pku.edu.cn>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 045/181] arch/unicore32/mm/alignment.c: include "asm/pgtable.h" to avoid compiling error
Date: Mon, 30 Jun 2014 13:51:06 +0200
Message-Id: <5ae2d36b307a43d1ea8f57daa2f949048c572186.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Gang <gang.chen.5i5j@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/unicore32/mm/alignment.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/unicore32/mm/alignment.c b/arch/unicore32/mm/alignment.c
index de7dc5fdd58b..24e836023e6c 100644
--- a/arch/unicore32/mm/alignment.c
+++ b/arch/unicore32/mm/alignment.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/uaccess.h>
 
+#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/unaligned.h>
 
-- 
2.0.0

