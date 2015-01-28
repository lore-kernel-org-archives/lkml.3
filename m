Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761716AbbA1Gog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:44:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760750AbbA1Gob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:44:31 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 1/5] xen: cleanup arch/x86/xen/setup.c
Date: Wed, 28 Jan 2015 07:44:21 +0100
Message-Id: <1422427465-25239-2-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1422427465-25239-1-git-send-email-jgross@suse.com>
References: <1422427465-25239-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove extern declarations in arch/x86/xen/setup.c which are either
not used or redundant. Move needed other extern declarations to
xen-ops.h

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/setup.c   | 10 ----------
 arch/x86/xen/xen-ops.h |  6 ++++++
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 865e56c..d2520c3 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -32,16 +32,6 @@
 #include "p2m.h"
 #include "mmu.h"
 
-/* These are code, but not functions.  Defined in entry.S */
-extern const char xen_hypervisor_callback[];
-extern const char xen_failsafe_callback[];
-#ifdef CONFIG_X86_64
-extern asmlinkage void nmi(void);
-#endif
-extern void xen_sysenter_target(void);
-extern void xen_syscall_target(void);
-extern void xen_syscall32_target(void);
-
 /* Amount of extra memory space we add to the e820 ranges */
 struct xen_memory_region xen_extra_mem[XEN_EXTRA_MEM_MAX_REGIONS] __initdata;
 
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 5686bd9..9e195c6 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -10,6 +10,12 @@
 extern const char xen_hypervisor_callback[];
 extern const char xen_failsafe_callback[];
 
+void xen_sysenter_target(void);
+#ifdef CONFIG_X86_64
+void xen_syscall_target(void);
+void xen_syscall32_target(void);
+#endif
+
 extern void *xen_initial_gdt;
 
 struct trap_info;
-- 
2.1.2

