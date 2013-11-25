Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab3KYOGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:06:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58946 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754597Ab3KYNxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:46 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paul Mackerras" <paulus@samba.org>,
        "Alexander Graf" <agraf@suse.de>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.767457033@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 56/87] KVM: PPC: Book3S HV: Fix typo in saving DSCR
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -922,7 +922,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_206)
 BEGIN_FTR_SECTION
 	mfspr	r8, SPRN_DSCR
 	ld	r7, HSTATE_DSCR(r13)
-	std	r8, VCPU_DSCR(r7)
+	std	r8, VCPU_DSCR(r9)
 	mtspr	SPRN_DSCR, r7
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_206)
 

