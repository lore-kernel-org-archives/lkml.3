Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab3HPOfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:35:15 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58493 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab3HPOed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:34:33 -0400
From: Alex Thorlton <athorlton@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: [PATCH 8/8] fix up references to kernel_fpu_begin/end
Date: Fri, 16 Aug 2013 09:34:04 -0500
Message-Id: <1376663644-153546-9-git-send-email-athorlton@sgi.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1376663644-153546-1-git-send-email-athorlton@sgi.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
 <1376663644-153546-1-git-send-email-athorlton@sgi.com>
In-Reply-To: <87wqo050fc.fsf@tassilo.jf.intel.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 arch/x86/lib/clear_page_nocache_64.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/lib/clear_page_nocache_64.S b/arch/x86/lib/clear_page_nocache_64.S
index a6d938c..d03408e 100644
--- a/arch/x86/lib/clear_page_nocache_64.S
+++ b/arch/x86/lib/clear_page_nocache_64.S
@@ -23,7 +23,7 @@
 ENTRY(clear_page_nocache)
 	CFI_STARTPROC
 	push   %rdi
-	call   kernel_fpu_begin
+	call   __kernel_fpu_begin
 	pop    %rdi
 	sub    $16,%rsp
 	CFI_ADJUST_CFA_OFFSET 16
@@ -43,7 +43,7 @@ ENTRY(clear_page_nocache)
 	movdqu (%rsp),%xmm0
 	addq   $16,%rsp
 	CFI_ADJUST_CFA_OFFSET -16
-	jmp   kernel_fpu_end
+	jmp   __kernel_fpu_end
 	CFI_ENDPROC
 ENDPROC(clear_page_nocache)
 
@@ -65,7 +65,7 @@ ENDPROC(clear_page_nocache)
 ENTRY(clear_page_nocache_avx)
 	CFI_STARTPROC
 	push   %rdi
-	call   kernel_fpu_begin
+	call   __kernel_fpu_begin
 	pop    %rdi
 	sub    $32,%rsp
 	CFI_ADJUST_CFA_OFFSET 32
@@ -85,7 +85,7 @@ ENTRY(clear_page_nocache_avx)
 	vmovdqu (%rsp),%ymm0
 	addq   $32,%rsp
 	CFI_ADJUST_CFA_OFFSET -32
-	jmp   kernel_fpu_end
+	jmp   __kernel_fpu_end
 	CFI_ENDPROC
 ENDPROC(clear_page_nocache_avx)
 
-- 
1.7.12.4

