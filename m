Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966856AbaCUBSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:18:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760462AbaCUADt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Don Zickus <dzickus@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 062/149] x86: fix compile error due to X86_TRAP_NMI use in asm files
Date: Thu, 20 Mar 2014 17:03:45 -0700
Message-Id: <20140321000439.108251563@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/head_32.S |    2 +-
 arch/x86/kernel/head_64.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -545,7 +545,7 @@ ENDPROC(early_idt_handlers)
 ENTRY(early_idt_handler)
 	cld
 
-	cmpl $X86_TRAP_NMI,(%esp)
+	cmpl $2,(%esp)		# X86_TRAP_NMI
 	je is_nmi		# Ignore NMI
 
 	cmpl $2,%ss:early_recursion_flag
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -343,7 +343,7 @@ early_idt_handlers:
 ENTRY(early_idt_handler)
 	cld
 
-	cmpl $X86_TRAP_NMI,(%rsp)
+	cmpl $2,(%rsp)		# X86_TRAP_NMI
 	je is_nmi		# Ignore NMI
 
 	cmpl $2,early_recursion_flag(%rip)


