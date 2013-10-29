Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab3J2SHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:07:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59292 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab3J2SFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:05:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Mackerras <paulus@samba.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 14/81] KVM: PPC: Book3S HV: Fix typo in saving DSCR
Date: Tue, 29 Oct 2013 11:03:35 -0700
Message-Id: <1383069882-11437-15-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 10b6c35..7395db9 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -964,7 +964,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_206)
 BEGIN_FTR_SECTION
 	mfspr	r8, SPRN_DSCR
 	ld	r7, HSTATE_DSCR(r13)
-	std	r8, VCPU_DSCR(r7)
+	std	r8, VCPU_DSCR(r9)
 	mtspr	SPRN_DSCR, r7
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_206)
 
-- 
1.8.1.2

