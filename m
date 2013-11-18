Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3KRUbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:31:31 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50008 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3KRUb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:31:26 -0500
From: Elena Ufimtseva <ufimtseva@gmail.com>
To: xen-devel@lists.xenproject.org
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, akpm@linux-foundation.org,
        tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, ian.campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com,
        linux-kernel@vger.kernel.org, Elena Ufimtseva <ufimtseva@gmail.com>
Subject: [PATCH v2 2/2] xen: enable vnuma for PV guest
Date: Mon, 18 Nov 2013 15:25:50 -0500
Message-Id: <1384806350-12651-3-git-send-email-ufimtseva@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1384806350-12651-1-git-send-email-ufimtseva@gmail.com>
References: <1384806350-12651-1-git-send-email-ufimtseva@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enables numa if vnuma topology hypercall is supported and it is domU.

Signed-off-by: Elena Ufimtseva <ufimtseva@gmail.com>
---
 arch/x86/xen/setup.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 68c054f..0aab799 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -20,6 +20,7 @@
 #include <asm/numa.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
+#include <asm/xen/vnuma.h>
 
 #include <xen/xen.h>
 #include <xen/page.h>
@@ -598,6 +599,9 @@ void __init xen_arch_setup(void)
 	WARN_ON(xen_set_default_idle());
 	fiddle_vdso();
 #ifdef CONFIG_NUMA
-	numa_off = 1;
+	if (!xen_initial_domain() && xen_vnuma_supported())
+		numa_off = 0;
+	else
+		numa_off = 1;
 #endif
 }
-- 
1.7.10.4

