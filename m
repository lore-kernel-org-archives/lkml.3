Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaKZQHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:07:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbaKZQHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:07:54 -0500
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: x86: use MSR_ICR instead of a number
Date: Wed, 26 Nov 2014 17:07:05 +0100
Message-Id: <1417018025-1189-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0x830 MSR is 0x300 xAPIC MMIO, which is MSR_ICR.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 This applies on top of Amit's
   [PATCH v2] KVM: x86: Fix reserved x2apic registers
 in which I noticed this minor deficit.

 arch/x86/kvm/lapic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9c90d31..687874f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1887,7 +1887,7 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		return 1;
 
 	/* if this is ICR write vector before command */
-	if (msr == 0x830)
+	if (reg == APIC_ICR)
 		apic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
 	return apic_reg_write(apic, reg, (u32)data);
 }
@@ -1908,7 +1908,7 @@ int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 
 	if (apic_reg_read(apic, reg, 4, &low))
 		return 1;
-	if (msr == 0x830)
+	if (reg == APIC_ICR)
 		apic_reg_read(apic, APIC_ICR2, 4, &high);
 
 	*data = (((u64)high) << 32) | low;
-- 
2.1.0

