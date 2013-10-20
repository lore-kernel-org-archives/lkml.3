Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab3JTOab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 10:30:31 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33195 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3JTOaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 10:30:24 -0400
X-Originating-IP: 77.221.165.98
Date: Sun, 20 Oct 2013 15:30:16 +0100
From: Josh Triplett <josh@joshtriplett.org>
To: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] kvm: Delete prototype for non-existent function
 kvm_check_iopl
Message-ID: <20131020143015.GA2996@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prototype for kvm_check_iopl appeared in commit
f850e2e603bf5a05b0aee7901857cf85715aa694 ("KVM: x86 emulator: Check IOPL
level during io instruction emulation"), but the function never actually
existed.  Remove the prototype.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/include/asm/kvm_host.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 00c5f44..ea52306 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -926,8 +926,6 @@ void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_enable_tdp(void);
 void kvm_disable_tdp(void);
 
-bool kvm_check_iopl(struct kvm_vcpu *vcpu);
-
 static inline gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access)
 {
 	return gpa;
-- 
1.8.4.rc3

