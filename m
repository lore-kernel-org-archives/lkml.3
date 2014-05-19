Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaESGvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:51:38 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:15682 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbaESGvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:51:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As8BALaoeVOERCABjGdsb2JhbABZwHCHQoEOFg4BAQEnPIMlgVGIQctnhVgXjWxkHYQqBIoPph+Baw
X-IPAS-Result: As8BALaoeVOERCABjGdsb2JhbABZwHCHQoEOFg4BAQEnPIMlgVGIQctnhVgXjWxkHYQqBIoPph+Baw
X-IronPort-AV: E=Sophos;i="4.98,865,1392156000"; 
   d="scan'208";a="106954717"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH] KVM: vmx: DR7 masking on task switch emulation is wrong
Date: Mon, 19 May 2014 09:50:50 +0300
Message-Id: <1400482250-16631-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DR7 masking which is done on task switch emulation should be in hex format
(clearing the local breakpoints enable bits 0,2,4 and 6).

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 138ceff..286d510 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5439,7 +5439,7 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
 	}
 
 	/* clear all local breakpoint enable flags */
-	vmcs_writel(GUEST_DR7, vmcs_readl(GUEST_DR7) & ~55);
+	vmcs_writel(GUEST_DR7, vmcs_readl(GUEST_DR7) & ~0x55);
 
 	/*
 	 * TODO: What about debug traps on tss switch?
-- 
1.9.1

