Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbaF3JDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:03:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37386 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722AbaF3JDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:03:04 -0400
From: Borislav Petkov <bp@alien8.de>
To: KVM <kvm@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH TRIVIAL] kvm: Correct kvm_multiple_exception's naming
Date: Mon, 30 Jun 2014 11:02:59 +0200
Message-Id: <1404118979-12109-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

While staring at kvm exception code in conjunction with the recent #DF
splat, this function's name was bugging me because it clearly deals with
multiple exceptionS(!) but it is missing the plural in the naming. Fix
that so that I can sleep at night :-)

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kvm/x86.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f32a02578c0d..10a144c5456f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -310,7 +310,7 @@ static int exception_class(int vector)
 	return EXCPT_BENIGN;
 }
 
-static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
+static void kvm_multiple_exceptions(struct kvm_vcpu *vcpu,
 		unsigned nr, bool has_error, u32 error_code,
 		bool reinject)
 {
@@ -354,13 +354,13 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr)
 {
-	kvm_multiple_exception(vcpu, nr, false, 0, false);
+	kvm_multiple_exceptions(vcpu, nr, false, 0, false);
 }
 EXPORT_SYMBOL_GPL(kvm_queue_exception);
 
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr)
 {
-	kvm_multiple_exception(vcpu, nr, false, 0, true);
+	kvm_multiple_exceptions(vcpu, nr, false, 0, true);
 }
 EXPORT_SYMBOL_GPL(kvm_requeue_exception);
 
@@ -398,13 +398,13 @@ EXPORT_SYMBOL_GPL(kvm_inject_nmi);
 
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
 {
-	kvm_multiple_exception(vcpu, nr, true, error_code, false);
+	kvm_multiple_exceptions(vcpu, nr, true, error_code, false);
 }
 EXPORT_SYMBOL_GPL(kvm_queue_exception_e);
 
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
 {
-	kvm_multiple_exception(vcpu, nr, true, error_code, true);
+	kvm_multiple_exceptions(vcpu, nr, true, error_code, true);
 }
 EXPORT_SYMBOL_GPL(kvm_requeue_exception_e);
 
-- 
2.0.0

