Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875Ab3EWQt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:49:27 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:50156 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759844Ab3EWQtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:49:22 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v6 6/6] mips/kvm: Use ENOIOCTLCMD to indicate unimplemented ioctls.
Date: Thu, 23 May 2013 09:49:10 -0700
Message-Id: <1369327750-28580-7-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369327750-28580-1-git-send-email-ddaney.cavm@gmail.com>
References: <1369327750-28580-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The Linux Way is to return -ENOIOCTLCMD to the vfs when an
unimplemented ioctl is requested.  Do this in kvm_mips instead of a
random mixture of -ENOTSUPP and -EINVAL.

Signed-off-by: David Daney <david.daney@cavium.com>
Acked-by: Sanjay Lal <sanjayl@kymasys.com>
---
 arch/mips/kvm/kvm_mips.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/mips/kvm/kvm_mips.c b/arch/mips/kvm/kvm_mips.c
index 3caa006..d934b01 100644
--- a/arch/mips/kvm/kvm_mips.c
+++ b/arch/mips/kvm/kvm_mips.c
@@ -195,7 +195,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 long
 kvm_arch_dev_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
-	return -EINVAL;
+	return -ENOIOCTLCMD;
 }
 
 void kvm_arch_free_memslot(struct kvm_memory_slot *free,
@@ -401,7 +401,7 @@ int
 kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 				    struct kvm_guest_debug *dbg)
 {
-	return -EINVAL;
+	return -ENOIOCTLCMD;
 }
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
@@ -475,14 +475,14 @@ int
 kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				struct kvm_mp_state *mp_state)
 {
-	return -EINVAL;
+	return -ENOIOCTLCMD;
 }
 
 int
 kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 				struct kvm_mp_state *mp_state)
 {
-	return -EINVAL;
+	return -ENOIOCTLCMD;
 }
 
 #define KVM_REG_MIPS_CP0_INDEX (0x10000 + 8 * 0 + 0)
@@ -801,7 +801,7 @@ long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 
 	switch (ioctl) {
 	default:
-		r = -EINVAL;
+		r = -ENOIOCTLCMD;
 	}
 
 	return r;
@@ -829,13 +829,13 @@ void kvm_arch_exit(void)
 int
 kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
-	return -ENOTSUPP;
+	return -ENOIOCTLCMD;
 }
 
 int
 kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
-	return -ENOTSUPP;
+	return -ENOIOCTLCMD;
 }
 
 int kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
@@ -845,12 +845,12 @@ int kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	return -ENOTSUPP;
+	return -ENOIOCTLCMD;
 }
 
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	return -ENOTSUPP;
+	return -ENOIOCTLCMD;
 }
 
 int kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
-- 
1.7.11.7

