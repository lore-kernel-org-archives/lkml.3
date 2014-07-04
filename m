Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbaGDSFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 14:05:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbaGDSFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 14:05:39 -0400
Date: Fri, 4 Jul 2014 20:04:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: kill ptregscall_common
Message-ID: <20140704180408.GA15032@redhat.com>
References: <100531b7498c9148eaf7163ead7adef263d9981c.1404340903.git.luto@amacapital.net> <CALCETrVkg7_GzR0QqyW-hNS8iJGr3i_R6AbrjwjwwUboWCiNOw@mail.gmail.com> <CALCETrVRJZeLam5jbNrgptETbXbsnPXMBgLwcO_uAMK6CSF65g@mail.gmail.com> <CA+55aFzMSswoVaHhM41rATubj+rqBsa4jyQaBVPNHO_-BpyHJg@mail.gmail.com> <CALCETrUDCDfm8+xEFiPDwJbSu25yo2xNKYYfCiU9RO5C_X=bDg@mail.gmail.com> <CA+55aFwehdBTK=dXFQkXK2ZB6GYXxEcnY7Eg8jwSV5E6yaJNTQ@mail.gmail.com> <20140703184215.GA21542@redhat.com> <20140704161316.GA6241@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140704161316.GA6241@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has no users since commit b3af11afe06a "x86: get rid of pt_regs
argument of iopl(2)".

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/entry_64.S |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b25ca96..fa64128 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -640,19 +640,6 @@ END(\label)
 	FORK_LIKE  vfork
 	FIXED_FRAME stub_iopl, sys_iopl
 
-ENTRY(ptregscall_common)
-	DEFAULT_FRAME 1 8	/* offset 8: return address */
-	RESTORE_TOP_OF_STACK %r11, 8
-	movq_cfi_restore R15+8, r15
-	movq_cfi_restore R14+8, r14
-	movq_cfi_restore R13+8, r13
-	movq_cfi_restore R12+8, r12
-	movq_cfi_restore RBP+8, rbp
-	movq_cfi_restore RBX+8, rbx
-	ret $REST_SKIP		/* pop extended registers */
-	CFI_ENDPROC
-END(ptregscall_common)
-
 ENTRY(stub_execve)
 	CFI_STARTPROC
 	addq $8, %rsp
-- 
1.5.5.1


