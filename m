Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3EUUzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 16:55:49 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53069 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3EUUzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 16:55:07 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v4 6/6] mips/kvm: Use ENOIOCTLCMD to indicate unimplemented ioctls.
Date: Tue, 21 May 2013 13:54:55 -0700
Message-Id: <1369169695-10444-7-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369169695-10444-1-git-send-email-ddaney.cavm@gmail.com>
References: <1369169695-10444-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The Linux Way is to return -ENOIOCTLCMD to the vfs when an
unimplemented ioctl is requested.  Do this in kvm_mips instead of a
random mixture of -ENOTSUPP and -EINVAL.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/kvm/kvm_mips.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/mips/kvm/kvm_mips.c b/arch/mips/kvm/kvm_mips.c
index bc879bd..8ea4bc5 100644
--- a/arch/mips/kvm/kvm_mips.c
+++ b/arch/mips/kvm/kvm_mips.c
@@ -185,7 +185,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 long
 kvm_arch_dev_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
-	return -EINVAL;
+	return -ENOIOCTLCMD;
 }
 
 void kvm_arch_free_memslot(struct kvm_memory_slot *free,
@@ -391,7 +391,7 @@ int
 kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 				    struct kvm_guest_debug *dbg)
 {
-	return -EINVAL;
+	return -ENOIOCTLCMD;
 }
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
@@ -429,14 +429,14 @@ int
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
 
 /*
@@ -483,7 +483,7 @@ long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 
 	switch (ioctl) {
 	default:
-		r = -EINVAL;
+		r = -ENOIOCTLCMD;
 	}
 
 	return r;
@@ -511,13 +511,13 @@ void kvm_arch_exit(void)
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
@@ -527,12 +527,12 @@ int kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
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

