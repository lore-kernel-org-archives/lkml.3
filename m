Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab3JRTxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 15:53:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab3JRTwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 15:52:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [ 06/11] KVM: PPC: Book3S HV: Fix typo in saving DSCR
Date: Fri, 18 Oct 2013 12:53:35 -0700
Message-Id: <20131018195049.502885156@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131018195049.069623827@linuxfoundation.org>
References: <20131018195049.069623827@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -935,7 +935,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_206)
 BEGIN_FTR_SECTION
 	mfspr	r8, SPRN_DSCR
 	ld	r7, HSTATE_DSCR(r13)
-	std	r8, VCPU_DSCR(r7)
+	std	r8, VCPU_DSCR(r9)
 	mtspr	SPRN_DSCR, r7
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_206)
 


