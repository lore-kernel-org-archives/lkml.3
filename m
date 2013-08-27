Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3H0Nm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:42:27 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:62420 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3H0Nl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:41:56 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gnatapov@redhat.com
Subject: [PATCH 2/3] KVM: vmx: count exits to userspace during invalid guest emulation
Date: Tue, 27 Aug 2013 15:41:42 +0200
Message-Id: <1377610903-12356-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1377610903-12356-1-git-send-email-pbonzini@redhat.com>
References: <1377610903-12356-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These will happen due to MMIO.

Suggested-by: Gleb Natapov @gleb@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 57b4e12..1f1da43 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5485,6 +5485,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		err = emulate_instruction(vcpu, EMULTYPE_NO_REEXECUTE);
 
 		if (err == EMULATE_USER_EXIT) {
+			++vcpu->stat.mmio_exits;
 			ret = 0;
 			goto out;
 		}
-- 
1.8.3.1


