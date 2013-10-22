Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab3JVQJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:09:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:3152 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab3JVQII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:08:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="422985818"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        konrad.wilk@oracle.com
Subject: [PATCH 7/7] x86, asmlinkage, xen: Fix type of nmi
Date: Tue, 22 Oct 2013 09:07:59 -0700
Message-Id: <1382458079-24450-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382458079-24450-1-git-send-email-andi@firstfloor.org>
References: <1382458079-24450-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

LTO requires consistent types of symbols over all files.

So "nmi" cannot be declared as a char [] here, need to use the
correct function type.

Cc: konrad.wilk@oracle.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/xen/setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 09f3059..a55ff2f 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -34,7 +34,7 @@
 extern const char xen_hypervisor_callback[];
 extern const char xen_failsafe_callback[];
 #ifdef CONFIG_X86_64
-extern const char nmi[];
+extern asmlinkage void nmi(void);
 #endif
 extern void xen_sysenter_target(void);
 extern void xen_syscall_target(void);
@@ -559,7 +559,7 @@ void xen_enable_syscall(void)
 void __cpuinit xen_enable_nmi(void)
 {
 #ifdef CONFIG_X86_64
-	if (register_callback(CALLBACKTYPE_nmi, nmi))
+	if (register_callback(CALLBACKTYPE_nmi, (char *)nmi))
 		BUG();
 #endif
 }
-- 
1.8.3.1

