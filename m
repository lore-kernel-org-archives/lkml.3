Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbbAMKZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:25:46 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:54850 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbbAMKW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:22:59 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: mpe@ellerman.id.au, benh@kernel.crashing.org, anton@samba.org,
        mikey@neuling.org, shuahkh@osg.samsung.com
Subject: [PATCH V2 03/12] powerpc, offset: Change PACA_DSCR to PACA_DSCR_DEFAULT
Date: Tue, 13 Jan 2015 15:52:31 +0530
Message-Id: <1421144560-15901-4-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011310-0029-0000-0000-000000FC59AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PACA_DSCR offset macro tracks dscr_default element in the paca
structure. Better change the name of this macro to match that
of the data element it tracks. Makes the code more readable.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/asm-offsets.c       | 2 +-
 arch/powerpc/kernel/entry_64.S          | 2 +-
 arch/powerpc/kernel/tm.S                | 4 ++--
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index e624f96..dcfffe2 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -246,7 +246,7 @@ int main(void)
 #endif
 	DEFINE(PACAHWCPUID, offsetof(struct paca_struct, hw_cpu_id));
 	DEFINE(PACAKEXECSTATE, offsetof(struct paca_struct, kexec_state));
-	DEFINE(PACA_DSCR, offsetof(struct paca_struct, dscr_default));
+	DEFINE(PACA_DSCR_DEFAULT, offsetof(struct paca_struct, dscr_default));
 	DEFINE(PACA_STARTTIME, offsetof(struct paca_struct, starttime));
 	DEFINE(PACA_STARTTIME_USER, offsetof(struct paca_struct, starttime_user));
 	DEFINE(PACA_USER_TIME, offsetof(struct paca_struct, user_time));
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 194e46d..b5cd2b59 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -564,7 +564,7 @@ BEGIN_FTR_SECTION
 	ld	r0,THREAD_DSCR(r4)
 	cmpwi	r6,0
 	bne	1f
-	ld	r0,PACA_DSCR(r13)
+	ld	r0,PACA_DSCR_DEFAULT(r13)
 1:
 BEGIN_FTR_SECTION_NESTED(70)
 	mfspr	r8, SPRN_FSCR
diff --git a/arch/powerpc/kernel/tm.S b/arch/powerpc/kernel/tm.S
index 2a324f4..dbd2c18 100644
--- a/arch/powerpc/kernel/tm.S
+++ b/arch/powerpc/kernel/tm.S
@@ -293,7 +293,7 @@ dont_backup_fp:
 	ld	r2, STK_GOT(r1)
 
 	/* Load CPU's default DSCR */
-	ld	r0, PACA_DSCR(r13)
+	ld	r0, PACA_DSCR_DEFAULT(r13)
 	mtspr	SPRN_DSCR, r0
 
 	blr
@@ -473,7 +473,7 @@ restore_gprs:
 	ld	r2, STK_GOT(r1)
 
 	/* Load CPU's default DSCR */
-	ld	r0, PACA_DSCR(r13)
+	ld	r0, PACA_DSCR_DEFAULT(r13)
 	mtspr	SPRN_DSCR, r0
 
 	blr
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 10554df..109794b 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -283,7 +283,7 @@ kvm_start_guest:
 kvm_secondary_got_guest:
 
 	/* Set HSTATE_DSCR(r13) to something sensible */
-	ld	r6, PACA_DSCR(r13)
+	ld	r6, PACA_DSCR_DEFAULT(r13)
 	std	r6, HSTATE_DSCR(r13)
 
 	bl	kvmppc_hv_entry
-- 
1.9.3

