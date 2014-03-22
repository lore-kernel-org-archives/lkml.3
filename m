Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbaCVG7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 02:59:14 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:56491 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaCVG7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 02:59:11 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch/x86: Use RCU_INIT_POINTER(x, NULL) in kvm/vmx.c
Date: Sat, 22 Mar 2014 12:28:10 +0530
Message-Id: <1395471490-3025-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here rcu_assign_pointer() is ensuring that the
initialization of a structure is carried out before storing a pointer
to that structure.  
So, rcu_assign_pointer(p, NULL) can always safely be converted to
RCU_INIT_POINTER(p, NULL). 

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 3927528..e37c0da 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8787,7 +8787,7 @@ static void __exit vmx_exit(void)
 	free_page((unsigned long)vmx_vmread_bitmap);
 
 #ifdef CONFIG_KEXEC
-	rcu_assign_pointer(crash_vmclear_loaded_vmcss, NULL);
+	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
 	synchronize_rcu();
 #endif
 
-- 
1.7.9.5

