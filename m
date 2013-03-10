Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab3CJNq3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:46:29 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:52062 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3CJNq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:46:27 -0400
From: Ioan Orghici <ioanorghici@gmail.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Ioan Orghici <ioan.orghici@gmail.com>
Subject: [PATCH] kvm: remove cast for kmalloc return value
Date: Sun, 10 Mar 2013 15:46:00 +0200
Message-Id: <1362923160-26300-1-git-send-email-ioan.orghici@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ioan Orghici<ioan.orghici@gmail.com>
---
 arch/x86/kvm/vmx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7cc566b..35c2c8f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5261,8 +5261,7 @@ static struct loaded_vmcs *nested_get_current_vmcs02(struct vcpu_vmx *vmx)
 	}
 
 	/* Create a new VMCS */
-	item = (struct vmcs02_list *)
-		kmalloc(sizeof(struct vmcs02_list), GFP_KERNEL);
+	item = kmalloc(sizeof(struct vmcs02_list), GFP_KERNEL);
 	if (!item)
 		return NULL;
 	item->vmcs02.vmcs = alloc_vmcs();
-- 
1.7.10.4

