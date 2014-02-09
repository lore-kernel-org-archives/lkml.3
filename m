Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaBILJE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 06:09:04 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:46777 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaBILJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 06:09:02 -0500
Date: Sun, 9 Feb 2014 16:38:57 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        xen-devel@lists.xenproject.org, josh@joshtriplett.org
Subject: [PATCH 3/4] drivers: xen: Move prototype declaration to appropriate
 header file from arch/x86/xen/xen-ops.h
Message-ID: <a609cbd7fcce1a4f5df0b00e3f866461b9ad071f.1391943416.git.rashika.kheria@gmail.com>
References: <3826f170dae13e3ee700ad9e26a8c88be4b7aaa2.1391943416.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3826f170dae13e3ee700ad9e26a8c88be4b7aaa2.1391943416.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declaration to header file include/xen/xen-ops.h from
arch/x86/xen/xen-ops.h because they are used by more than one file.

This eliminates the following warning in drivers/xen/events/:
drivers/xen/events_2l.c:1231:13: warning: no previous prototype for ‘xen_debug_interrupt’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/xen/xen-ops.h |    2 --
 include/xen/xen-ops.h  |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 1cb6f4c..e5edc7f 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -55,8 +55,6 @@ void xen_setup_cpu_clockevents(void);
 void __init xen_init_time_ops(void);
 void __init xen_hvm_init_time_ops(void);
 
-irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
-
 bool xen_vcpu_stolen(int vcpu);
 
 void xen_setup_vcpu_info_placement(void);
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index fb2ea8f..9a86337 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -2,6 +2,7 @@
 #define INCLUDE_XEN_OPS_H
 
 #include <linux/percpu.h>
+#include <linux/interrupt.h>
 #include <asm/xen/interface.h>
 
 DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
@@ -35,4 +36,6 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
 			       int numpgs, struct page **pages);
 
 bool xen_running_on_version_or_later(unsigned int major, unsigned int minor);
+
+irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
 #endif /* INCLUDE_XEN_OPS_H */
-- 
1.7.9.5

