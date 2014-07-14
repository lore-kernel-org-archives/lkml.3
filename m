Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbaGNLji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:39:38 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:58985 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbaGNLjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:39:09 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Bandan Das <bsd@redhat.com>
Subject: [PATCH 09/19] KVM: emulate: Remove ctxt->intercept and ctxt->check_perm checks
Date: Mon, 14 Jul 2014 13:38:33 +0200
Message-Id: <1405337923-4776-10-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
References: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bandan Das <bsd@redhat.com>

The same information can be gleaned from ctxt->d and avoids having
to zero/NULL initialize intercept and check_perm

Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 851315d93bf7..000fc7398832 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4599,7 +4599,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 				fetch_possible_mmx_operand(ctxt, &ctxt->dst);
 		}
 
-		if (unlikely(ctxt->guest_mode) && ctxt->intercept) {
+		if (unlikely(ctxt->guest_mode) && (ctxt->d & Intercept)) {
 			rc = emulator_check_intercept(ctxt, ctxt->intercept,
 						      X86_ICPT_PRE_EXCEPT);
 			if (rc != X86EMUL_CONTINUE)
@@ -4619,13 +4619,13 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 		}
 
 		/* Do instruction specific permission checks */
-		if (ctxt->check_perm) {
+		if (ctxt->d & CheckPerm) {
 			rc = ctxt->check_perm(ctxt);
 			if (rc != X86EMUL_CONTINUE)
 				goto done;
 		}
 
-		if (unlikely(ctxt->guest_mode) && ctxt->intercept) {
+		if (unlikely(ctxt->guest_mode) && (ctxt->d & Intercept)) {
 			rc = emulator_check_intercept(ctxt, ctxt->intercept,
 						      X86_ICPT_POST_EXCEPT);
 			if (rc != X86EMUL_CONTINUE)
@@ -4671,7 +4671,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 
 special_insn:
 
-	if (unlikely(ctxt->guest_mode) && ctxt->intercept) {
+	if (unlikely(ctxt->guest_mode) && (ctxt->d & Intercept)) {
 		rc = emulator_check_intercept(ctxt, ctxt->intercept,
 					      X86_ICPT_POST_MEMACCESS);
 		if (rc != X86EMUL_CONTINUE)
-- 
1.8.3.1


