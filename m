Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab3J1Osv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:48:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51051 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948Ab3J1Oss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:48:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Mackerras <paulus@samba.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 10/64] KVM: PPC: Book3S HV: Fix typo in saving DSCR
Date: Mon, 28 Oct 2013 14:47:29 +0000
Message-Id: <1382971703-17393-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Mackerras <paulus@samba.org>

commit cfc860253abd73e1681696c08ea268d33285a2c4 upstream.

This fixes a typo in the code that saves the guest DSCR (Data Stream
Control Register) into the kvm_vcpu_arch struct on guest exit.  The
effect of the typo was that the DSCR value was saved in the wrong place,
so changes to the DSCR by the guest didn't persist across guest exit
and entry, and some host kernel memory got corrupted.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Acked-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index a1044f4..86af817 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -963,7 +963,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_206)
 BEGIN_FTR_SECTION
 	mfspr	r8, SPRN_DSCR
 	ld	r7, HSTATE_DSCR(r13)
-	std	r8, VCPU_DSCR(r7)
+	std	r8, VCPU_DSCR(r9)
 	mtspr	SPRN_DSCR, r7
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_206)
 
-- 
1.8.3.2

