Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab3GBOoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 10:44:06 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:42778 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3GBOoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 10:44:05 -0400
Message-ID: <51D2E72A.2010509@gmail.com>
Date: Tue, 02 Jul 2013 22:43:54 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, mingo@redhat.com
CC: x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, mm: Move declarations level3_ident_pgt and level2_ident_pgt
 into CONFIG_XEN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

After commit 8170e6b ("x86, 64bit:  Use a #PF handler to materialize
early mappings on demand"), we don't define level3_ident_pgt and
level2_ident_pgt if !CONFIG_XEN. So move the two variables' declaration
into CONFIG_XEN.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/include/asm/pgtable_64.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index e22c1db..d0544ec 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -15,10 +15,12 @@
 #include <linux/threads.h>
 
 extern pud_t level3_kernel_pgt[512];
+#ifdef CONFIG_XEN
 extern pud_t level3_ident_pgt[512];
+extern pmd_t level2_ident_pgt[512];
+#endif
 extern pmd_t level2_kernel_pgt[512];
 extern pmd_t level2_fixmap_pgt[512];
-extern pmd_t level2_ident_pgt[512];
 extern pgd_t init_level4_pgt[];
 
 #define swapper_pg_dir init_level4_pgt
-- 
1.7.1
