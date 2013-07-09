Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3GIIC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:02:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:47003 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab3GIICq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:02:46 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [v3][PATCH 1/8] powerpc/book3e: rename interrupt_end_book3e with __end_interrupts
Date: Tue, 9 Jul 2013 16:03:20 +0800
Message-ID: <1373357007-30785-2-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373357007-30785-1-git-send-email-tiejun.chen@windriver.com>
References: <1373357007-30785-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can rename 'interrupt_end_book3e' with '__end_interrupts' then
book3s/book3e can share this unique label to make sure we can use
this conveniently.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/kernel/exceptions-64e.S |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
index 645170a..a518e48 100644
--- a/arch/powerpc/kernel/exceptions-64e.S
+++ b/arch/powerpc/kernel/exceptions-64e.S
@@ -309,8 +309,8 @@ interrupt_base_book3e:					/* fake trap */
 	EXCEPTION_STUB(0x300, hypercall)
 	EXCEPTION_STUB(0x320, ehpriv)
 
-	.globl interrupt_end_book3e
-interrupt_end_book3e:
+	.globl __end_interrupts
+__end_interrupts:
 
 /* Critical Input Interrupt */
 	START_EXCEPTION(critical_input);
@@ -493,7 +493,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 	beq+	1f
 
 	LOAD_REG_IMMEDIATE(r14,interrupt_base_book3e)
-	LOAD_REG_IMMEDIATE(r15,interrupt_end_book3e)
+	LOAD_REG_IMMEDIATE(r15,__end_interrupts)
 	cmpld	cr0,r10,r14
 	cmpld	cr1,r10,r15
 	blt+	cr0,1f
@@ -559,7 +559,7 @@ kernel_dbg_exc:
 	beq+	1f
 
 	LOAD_REG_IMMEDIATE(r14,interrupt_base_book3e)
-	LOAD_REG_IMMEDIATE(r15,interrupt_end_book3e)
+	LOAD_REG_IMMEDIATE(r15,__end_interrupts)
 	cmpld	cr0,r10,r14
 	cmpld	cr1,r10,r15
 	blt+	cr0,1f
-- 
1.7.9.5

