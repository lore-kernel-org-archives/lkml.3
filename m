Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbaHHHEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:04:42 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:45260 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290AbaHHHEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:04:31 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH 05/20] powerpc/8xx: Fix comment about DIRTY update
Message-Id: <20140808070340.CFEFC1ABD41@localhost.localdomain>
Date: Fri,  8 Aug 2014 09:03:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 2321f33790a6c5b80322d907a92d5739e7521a13, dirty handling is not
handled here anymore. So we fix the comment.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/kernel/head_8xx.S |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index e59e39e..171c6ef 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -477,12 +477,8 @@ InstructionTLBError:
 	EXC_XFER_LITE(0x1300, handle_page_fault)
 
 /* This is the data TLB error on the MPC8xx.  This could be due to
- * many reasons, including a dirty update to a pte.  We can catch that
- * one here, but anything else is an error.  First, we track down the
- * Linux pte.  If it is valid, write access is allowed, but the
- * page dirty bit is not set, we will set it and reload the TLB.  For
- * any other case, we bail out to a higher level function that can
- * handle it.
+ * many reasons, including a dirty update to a pte.  We bail out to
+ * a higher level function that can handle it.
  */
 	. = 0x1400
 DataTLBError:
-- 
1.7.1

