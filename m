Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaA2UKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 15:10:48 -0500
Received: from [195.214.232.25] ([195.214.232.25]:20621 "EHLO relay.sw.ru"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaA2UKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 15:10:47 -0500
From: Andrey Vagin <avagin@openvz.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, criu@openvz.org,
        Andrey Vagin <avagin@openvz.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>, Borislav Petkov <bp@suse.de>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH] mm: don't lose the SOFT_DIRTY flag on mprotect
Date: Thu, 30 Jan 2014 00:04:59 +0400
Message-Id: <1391025899-25299-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SOFT_DIRTY bit shows that the content of memory was changed
after a defined point in the past. mprotect() doesn't change the
content of memory, so it must not change the SOFT_DIRTY bit.

This patch does nothing with _PAGE_SWP_SOFT_DIRTY, becase pte_modify()
is called only for present pages.

Fixes: 0f8975ec4db2 (mm: soft-dirty bits for user memory changes tracking)
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 arch/x86/include/asm/pgtable_types.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index a83aa44..1aa9ccd 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -121,7 +121,8 @@
 
 /* Set of bits not changed in pte_modify */
 #define _PAGE_CHG_MASK	(PTE_PFN_MASK | _PAGE_PCD | _PAGE_PWT |		\
-			 _PAGE_SPECIAL | _PAGE_ACCESSED | _PAGE_DIRTY)
+			 _PAGE_SPECIAL | _PAGE_ACCESSED | _PAGE_DIRTY |	\
+			 _PAGE_SOFT_DIRTY)
 #define _HPAGE_CHG_MASK (_PAGE_CHG_MASK | _PAGE_PSE)
 
 #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
-- 
1.8.5.3

