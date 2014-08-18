Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaHRPOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:14:17 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:58220 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaHRPOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:14:15 -0400
Date: Mon, 18 Aug 2014 18:14:04 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] vmx: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
Message-ID: <20140818151404.GA25046@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of "rcu_assign_pointer()" is NULLing out the pointer.
According to RCU_INIT_POINTER()'s block comment:
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 arch/x86/kvm/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 801332e..12b840c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -9029,7 +9029,7 @@ static void __exit vmx_exit(void)
 	free_page((unsigned long)vmx_vmread_bitmap);
 
 #ifdef CONFIG_KEXEC
-	rcu_assign_pointer(crash_vmclear_loaded_vmcss, NULL);
+	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
 	synchronize_rcu();
 #endif
 
-- 
1.9.1

