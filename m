Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbaHHV5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:57:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758649AbaHHVgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 29/39] sparc64: Give more detailed information in {pgd,pmd}_ERROR() and kill pte_ERROR().
Date: Fri,  8 Aug 2014 14:35:15 -0700
Message-Id: <20140808213356.215934140@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213354.980430919@linuxfoundation.org>
References: <20140808213354.980430919@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/asm/pgtable_64.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -96,9 +96,12 @@ static inline bool kern_addr_valid(unsig
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
 


