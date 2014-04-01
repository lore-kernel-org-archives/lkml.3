Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaDAQPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:15:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44618 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbaDAQPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:15:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Don Zickus <dzickus@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 56/86] x86: fix compile error due to X86_TRAP_NMI use in asm files
Date: Tue,  1 Apr 2014 09:08:09 -0700
Message-Id: <1396368519-12728-57-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit b01d4e68933ec23e43b1046fa35d593cefcf37d1 upstream.

It's an enum, not a #define, you can't use it in asm files.

Introduced in commit 5fa10196bdb5 ("x86: Ignore NMIs that come in during
early boot"), and sadly I didn't compile-test things like I should have
before pushing out.

My weak excuse is that the x86 tree generally doesn't introduce stupid
things like this (and the ARM pull afterwards doesn't cause me to do a
compile-test either, since I don't cross-compile).

Cc: Don Zickus <dzickus@redhat.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/head_32.S | 2 +-
 arch/x86/kernel/head_64.S | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 53c38f9..81e692b 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -577,7 +577,7 @@ ENDPROC(early_idt_handlers)
 ENTRY(early_idt_handler)
 	cld
 
-	cmpl $X86_TRAP_NMI,(%esp)
+	cmpl $2,(%esp)		# X86_TRAP_NMI
 	je is_nmi		# Ignore NMI
 
 	cmpl $2,%ss:early_recursion_flag
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 7dd8d41..e2ff827 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -306,7 +306,7 @@ early_idt_handlers:
 ENTRY(early_idt_handler)
 	cld
 
-	cmpl $X86_TRAP_NMI,(%rsp)
+	cmpl $2,(%rsp)		# X86_TRAP_NMI
 	je is_nmi		# Ignore NMI
 
 	cmpl $2,early_recursion_flag(%rip)
-- 
1.8.3.2

