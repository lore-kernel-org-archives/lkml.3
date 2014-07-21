Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbaGULii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:38:38 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:48127 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754157AbaGULih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:38:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjcBAIb6zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBSdSEFFXGYhCuCiGTBePSwcWhDAFil+oPGk
X-IPAS-Result: AjcBAIb6zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBSdSEFFXGYhCuCiGTBePSwcWhDAFil+oPGk
X-IronPort-AV: E=Sophos;i="5.01,700,1400014800"; 
   d="scan'208";a="116353322"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 3/7] KVM: x86: Clearing rflags.rf upon skipped emulated instruction
Date: Mon, 21 Jul 2014 14:37:26 +0300
Message-Id: <1405942650-22589-4-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
References: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When skipping an emulated instruction, rflags.rf should be cleared as it would
be on real x86 CPU.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c2aa58e..120ee83 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5264,6 +5264,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 
 	if (emulation_type & EMULTYPE_SKIP) {
 		kvm_rip_write(vcpu, ctxt->_eip);
+		if (ctxt->eflags & X86_EFLAGS_RF)
+			kvm_set_rflags(vcpu, ctxt->eflags & ~X86_EFLAGS_RF);
 		return EMULATE_DONE;
 	}
 
-- 
1.9.1

