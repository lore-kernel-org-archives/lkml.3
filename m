Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab3FYWzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 18:55:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49248 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab3FYWzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 18:55:00 -0400
Date: Tue, 25 Jun 2013 15:54:47 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-buq1evi5dpykxx7ak6amaam0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, hpa@zytor.com,
        mingo@kernel.org, mtosatti@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org, mtosatti@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Rename X86_CR4_RDWRGSFS to X86_CR4_FSGSBASE
Git-Commit-ID: 3451e4dd93a878282669edbfeeac4a7f10bfc9af
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 25 Jun 2013 15:54:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3451e4dd93a878282669edbfeeac4a7f10bfc9af
Gitweb:     http://git.kernel.org/tip/3451e4dd93a878282669edbfeeac4a7f10bfc9af
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Sat, 27 Apr 2013 16:37:47 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 25 Jun 2013 15:50:05 -0700

x86: Rename X86_CR4_RDWRGSFS to X86_CR4_FSGSBASE

Rename X86_CR4_RDWRGSFS to X86_CR4_FSGSBASE to match the SDM.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Link: http://lkml.kernel.org/n/tip-buq1evi5dpykxx7ak6amaam0@git.kernel.org
---
 arch/x86/include/asm/kvm_host.h             | 2 +-
 arch/x86/include/uapi/asm/processor-flags.h | 2 +-
 arch/x86/kvm/x86.c                          | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3741c65..af9c552 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -59,7 +59,7 @@
 	(~(unsigned long)(X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD | X86_CR4_DE\
 			  | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_MCE     \
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
-			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_RDWRGSFS \
+			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_VMXE))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
diff --git a/arch/x86/include/uapi/asm/processor-flags.h b/arch/x86/include/uapi/asm/processor-flags.h
index b16e6d2..1b34df5 100644
--- a/arch/x86/include/uapi/asm/processor-flags.h
+++ b/arch/x86/include/uapi/asm/processor-flags.h
@@ -61,7 +61,7 @@
 #define X86_CR4_OSFXSR	0x00000200 /* enable fast FPU save and restore */
 #define X86_CR4_OSXMMEXCPT 0x00000400 /* enable unmasked SSE exceptions */
 #define X86_CR4_VMXE	0x00002000 /* enable VMX virtualization */
-#define X86_CR4_RDWRGSFS 0x00010000 /* enable RDWRGSFS support */
+#define X86_CR4_FSGSBASE 0x00010000 /* enable RDWRGSFS support */
 #define X86_CR4_PCIDE	0x00020000 /* enable PCID support */
 #define X86_CR4_OSXSAVE 0x00040000 /* enable xsave and xrestore */
 #define X86_CR4_SMEP	0x00100000 /* enable SMEP support */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 094b5d9..6b941b4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -619,7 +619,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	if (!guest_cpuid_has_smep(vcpu) && (cr4 & X86_CR4_SMEP))
 		return 1;
 
-	if (!guest_cpuid_has_fsgsbase(vcpu) && (cr4 & X86_CR4_RDWRGSFS))
+	if (!guest_cpuid_has_fsgsbase(vcpu) && (cr4 & X86_CR4_FSGSBASE))
 		return 1;
 
 	if (is_long_mode(vcpu)) {
