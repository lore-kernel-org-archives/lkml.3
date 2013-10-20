Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab3JTOaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 10:30:07 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:38300 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3JTOaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 10:30:06 -0400
X-Originating-IP: 77.221.165.98
Date: Sun, 20 Oct 2013 15:29:57 +0100
From: Josh Triplett <josh@joshtriplett.org>
To: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kvm: Delete prototype for non-existent function
 complete_pio
Message-ID: <20131020142954.GA2962@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

complete_pio ceased to exist in commit
7972995b0c346de76fe260ce0fd6bcc8ffab724a ("KVM: x86 emulator: Move
string pio emulation into emulator.c"), but the prototype remained.
Remove its prototype.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c76ff74..00c5f44 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -926,7 +926,6 @@ void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_enable_tdp(void);
 void kvm_disable_tdp(void);
 
-int complete_pio(struct kvm_vcpu *vcpu);
 bool kvm_check_iopl(struct kvm_vcpu *vcpu);
 
 static inline gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access)
-- 
1.8.4.rc3

