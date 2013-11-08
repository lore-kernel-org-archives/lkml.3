Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab3KHQYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:24:14 -0500
Received: from mail1.windriver.com ([147.11.146.13]:45310 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560Ab3KHQYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:24:13 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH] xen: delete new instances of added __cpuinit
Date: Fri, 8 Nov 2013 11:21:51 -0500
Message-ID: <1383927711-26742-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 6efa20e49b9cb1db1ab66870cc37323474a75a13
("xen: Support 64-bit PV guest receiving NMIs") and
commit cd9151e26d31048b2b5e00fd02e110e07d2200c9
( "xen/balloon: set a mapping for ballooned out pages")
added new instances of __cpuinit usage.

We removed this a couple versions ago; we now want to remove
the compat no-op stubs.  Introducing new users is not what
we want to see at this point in time, as it will break once
the stubs are gone.

Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/xen/setup.c  | 2 +-
 drivers/xen/balloon.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 09f3059..68c054f 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -556,7 +556,7 @@ void xen_enable_syscall(void)
 	}
 #endif /* CONFIG_X86_64 */
 }
-void __cpuinit xen_enable_nmi(void)
+void xen_enable_nmi(void)
 {
 #ifdef CONFIG_X86_64
 	if (register_callback(CALLBACKTYPE_nmi, nmi))
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index b232908..3143fa1 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -596,7 +596,7 @@ static void __init balloon_add_region(unsigned long start_pfn,
 	}
 }
 
-static int __cpuinit balloon_cpu_notify(struct notifier_block *self,
+static int balloon_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
 {
 	int cpu = (long)hcpu;
@@ -616,7 +616,7 @@ static int __cpuinit balloon_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block balloon_cpu_notifier __cpuinitdata = {
+static struct notifier_block balloon_cpu_notifier = {
 	.notifier_call	= balloon_cpu_notify,
 };
 
-- 
1.8.4.1

