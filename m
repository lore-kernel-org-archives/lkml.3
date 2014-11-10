Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaKJTTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:19:21 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57183 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaKJTTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:19:19 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Avi Kivity <avi.kivity@gmail.com>, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86, kvm, vmx: Don't set LOAD_IA32_EFER when host and guest match
Date: Mon, 10 Nov 2014 11:19:15 -0800
Message-Id: <8c96514e921897d40c79d4892fcbadee46aff8e9.1415646977.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's nothing to switch if the host and guest values are the same.
I am unable to find evidence that this makes any difference
whatsoever.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kvm/vmx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e72b9660e51c..c430b01b012b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1670,7 +1670,9 @@ static bool update_transition_efer(struct vcpu_vmx *vmx, int efer_offset)
 		guest_efer = vmx->vcpu.arch.efer;
 		if (!(guest_efer & EFER_LMA))
 			guest_efer &= ~EFER_LME;
-		add_atomic_switch_msr(vmx, MSR_EFER, guest_efer, host_efer);
+		if (guest_efer != host_efer)
+			add_atomic_switch_msr(vmx, MSR_EFER,
+					      guest_efer, host_efer);
 		return false;
 	}
 
-- 
1.9.3

