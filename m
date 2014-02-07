Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaBGMFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:05:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42403 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbaBGLwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Jones <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 202/233] kvm: x86: fix apic_base enable check
Date: Fri,  7 Feb 2014 11:47:01 +0000
Message-Id: <1391773652-25214-203-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jones <drjones@redhat.com>

commit 0dce7cd67fd9055c4a2ff278f8af1431e646d346 upstream.

Commit e66d2ae7c67bd moved the assignment
vcpu->arch.apic_base = value above a condition with
(vcpu->arch.apic_base ^ value), causing that check
to always fail. Use old_value, vcpu->arch.apic_base's
old value, in the condition instead.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f213cbc..256816b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1366,7 +1366,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	vcpu->arch.apic_base = value;
 
 	/* update jump label if enable bit changes */
-	if ((vcpu->arch.apic_base ^ value) & MSR_IA32_APICBASE_ENABLE) {
+	if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE) {
 		if (value & MSR_IA32_APICBASE_ENABLE)
 			static_key_slow_dec_deferred(&apic_hw_disabled);
 		else
-- 
1.8.3.2

