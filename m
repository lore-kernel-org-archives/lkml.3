Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbaABJQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 04:16:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:23554 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbaABJQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 04:16:06 -0500
X-IronPort-AV: E=Sophos;i="4.95,589,1384272000"; 
   d="scan'208";a="9363999"
From: Chen Fan <chen.fan.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gleb@redhat.com, pbonzini@redhat.com
Subject: [PATCH] kvm: x86: Fix debug typo error in lapic
Date: Thu, 2 Jan 2014 17:14:11 +0800
Message-Id: <1388654051-5968-1-git-send-email-chen.fan.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/02 17:15:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/02 17:15:04,
	Serialize complete at 2014/01/02 17:15:04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix the 'vcpi' typos when apic_debug is enabled.

Signed-off-by: Chen Fan <chen.fan.fnst@cn.fujitsu.com>
---
 arch/x86/kvm/lapic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index dec48bf..ce736ec 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -435,7 +435,7 @@ static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
 	u8 val;
 	if (pv_eoi_get_user(vcpu, &val) < 0)
 		apic_debug("Can't read EOI MSR value: 0x%llx\n",
-			   (unsigned long long)vcpi->arch.pv_eoi.msr_val);
+			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
 	return val & 0x1;
 }
 
@@ -443,7 +443,7 @@ static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
 {
 	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_ENABLED) < 0) {
 		apic_debug("Can't set EOI MSR value: 0x%llx\n",
-			   (unsigned long long)vcpi->arch.pv_eoi.msr_val);
+			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
 		return;
 	}
 	__set_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
@@ -453,7 +453,7 @@ static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
 {
 	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0) {
 		apic_debug("Can't clear EOI MSR value: 0x%llx\n",
-			   (unsigned long long)vcpi->arch.pv_eoi.msr_val);
+			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
 		return;
 	}
 	__clear_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
-- 
1.8.1.4

