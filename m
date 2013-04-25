Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab3DYWWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:22:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59483 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757640Ab3DYWWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:22:07 -0400
From: Borislav Petkov <bp@alien8.de>
To: kvm@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] kvm, svm: Fix typo in printk message
Date: Fri, 26 Apr 2013 00:22:01 +0200
Message-Id: <1366928521-10073-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.2.135.g7b592fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

It is "exit_int_info". It is actually EXITINTINFO in the official docs
but we don't like screaming docs.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kvm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a3bba7786ecc..272d29844cc5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3491,7 +3491,7 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 	    exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR &&
 	    exit_code != SVM_EXIT_NPF && exit_code != SVM_EXIT_TASK_SWITCH &&
 	    exit_code != SVM_EXIT_INTR && exit_code != SVM_EXIT_NMI)
-		printk(KERN_ERR "%s: unexpected exit_ini_info 0x%x "
+		printk(KERN_ERR "%s: unexpected exit_int_info 0x%x "
 		       "exit_code 0x%x\n",
 		       __func__, svm->vmcb->control.exit_int_info,
 		       exit_code);
-- 
1.8.2.135.g7b592fa

