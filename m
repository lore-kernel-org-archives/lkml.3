Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbaIOWS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:18:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51121 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969AbaIOWSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:18:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 025/187] sparc64: Give more detailed information in {pgd,pmd}_ERROR() and kill pte_ERROR().
Date: Mon, 15 Sep 2014 15:07:15 -0700
Message-Id: <1410818997-9432-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit fe866433f843b080246ce729b5e6b27b5f5d9a58 ]

pte_ERROR() is not used anywhere, delete it.

For pgd_ERROR() and pmd_ERROR(), output something similar to x86, giving the address
of the pgd/pmd as well as it's value.

Also provide the caller, since these macros are invoked from pgd_clear_bad() and
pmd_clear_bad() which provides little context as to what high level operation was
occuring when the BAD state was detected.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/include/asm/pgtable_64.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index baccf35..fde5aba 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -96,9 +96,12 @@ static inline bool kern_addr_valid(unsigned long addr)
 /* Kernel has a separate 44bit address space. */
 #define FIRST_USER_ADDRESS	0
 
-#define pte_ERROR(e)	__builtin_trap()
-#define pmd_ERROR(e)	__builtin_trap()
-#define pgd_ERROR(e)	__builtin_trap()
+#define pmd_ERROR(e)							\
+	pr_err("%s:%d: bad pmd %p(%016lx) seen at (%pS)\n",		\
+	       __FILE__, __LINE__, &(e), pmd_val(e), __builtin_return_address(0))
+#define pgd_ERROR(e)							\
+	pr_err("%s:%d: bad pgd %p(%016lx) seen at (%pS)\n",		\
+	       __FILE__, __LINE__, &(e), pgd_val(e), __builtin_return_address(0))
 
 #endif /* !(__ASSEMBLY__) */
 
-- 
1.9.1

