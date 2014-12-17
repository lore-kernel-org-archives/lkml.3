Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaLQRRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:17:41 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48094 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaLQRRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:17:39 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: move APIC types to arch/x86/
Date: Wed, 17 Dec 2014 18:17:29 +0100
Message-Id: <1418836649-3171-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are not used anymore by IA64, move them away.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 10 ++++++++++
 arch/x86/kvm/ioapic.h           | 17 +++++++++++++++++
 include/linux/kvm_types.h       | 27 ---------------------------
 3 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0c4c88c008ce..d89c6b828c96 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -664,6 +664,16 @@ struct msr_data {
 	u64 data;
 };
 
+struct kvm_lapic_irq {
+	u32 vector;
+	u32 delivery_mode;
+	u32 dest_mode;
+	u32 level;
+	u32 trig_mode;
+	u32 shorthand;
+	u32 dest_id;
+};
+
 struct kvm_x86_ops {
 	int (*cpu_has_kvm_support)(void);          /* __init */
 	int (*disabled_by_bios)(void);             /* __init */
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index deac8d509f2a..3c9195535ffc 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -44,6 +44,23 @@ struct rtc_status {
 	DECLARE_BITMAP(dest_map, KVM_MAX_VCPUS);
 };
 
+union kvm_ioapic_redirect_entry {
+	u64 bits;
+	struct {
+		u8 vector;
+		u8 delivery_mode:3;
+		u8 dest_mode:1;
+		u8 delivery_status:1;
+		u8 polarity:1;
+		u8 remote_irr:1;
+		u8 trig_mode:1;
+		u8 mask:1;
+		u8 reserve:7;
+		u8 reserved[4];
+		u8 dest_id;
+	} fields;
+};
+
 struct kvm_ioapic {
 	u64 base_address;
 	u32 ioregsel;
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index b606bb689a3e..931da7e917cf 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -54,33 +54,6 @@ typedef u64            hfn_t;
 
 typedef hfn_t pfn_t;
 
-union kvm_ioapic_redirect_entry {
-	u64 bits;
-	struct {
-		u8 vector;
-		u8 delivery_mode:3;
-		u8 dest_mode:1;
-		u8 delivery_status:1;
-		u8 polarity:1;
-		u8 remote_irr:1;
-		u8 trig_mode:1;
-		u8 mask:1;
-		u8 reserve:7;
-		u8 reserved[4];
-		u8 dest_id;
-	} fields;
-};
-
-struct kvm_lapic_irq {
-	u32 vector;
-	u32 delivery_mode;
-	u32 dest_mode;
-	u32 level;
-	u32 trig_mode;
-	u32 shorthand;
-	u32 dest_id;
-};
-
 struct gfn_to_hva_cache {
 	u64 generation;
 	gpa_t gpa;
-- 
1.8.3.1

