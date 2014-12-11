Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438AbaLKSHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:07:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39001 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758570AbaLKSGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:06:51 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 2/4] xen: synchronize include/xen/interface/xen.h with xen
Date: Thu, 11 Dec 2014 19:04:23 +0100
Message-Id: <1418321065-10212-3-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1418321065-10212-1-git-send-email-jgross@suse.com>
References: <1418321065-10212-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header include/xen/interface/xen.h doesn't contain all definitions
from Xen's version of that header. Update it accordingly.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/trace.c        | 2 +-
 include/xen/interface/xen.h | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/trace.c b/arch/x86/xen/trace.c
index 520022d..8296cdf 100644
--- a/arch/x86/xen/trace.c
+++ b/arch/x86/xen/trace.c
@@ -29,7 +29,7 @@ static const char *xen_hypercall_names[] = {
 	N(vcpu_op),
 	N(set_segment_base),
 	N(mmuext_op),
-	N(acm_op),
+	N(xsm_op),
 	N(nmi_op),
 	N(sched_op),
 	N(callback_op),
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index f68719f..a483789 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -67,7 +67,7 @@
 #define __HYPERVISOR_vcpu_op              24
 #define __HYPERVISOR_set_segment_base     25 /* x86/64 only */
 #define __HYPERVISOR_mmuext_op            26
-#define __HYPERVISOR_acm_op               27
+#define __HYPERVISOR_xsm_op               27
 #define __HYPERVISOR_nmi_op               28
 #define __HYPERVISOR_sched_op             29
 #define __HYPERVISOR_callback_op          30
@@ -75,7 +75,11 @@
 #define __HYPERVISOR_event_channel_op     32
 #define __HYPERVISOR_physdev_op           33
 #define __HYPERVISOR_hvm_op               34
+#define __HYPERVISOR_sysctl               35
+#define __HYPERVISOR_domctl               36
+#define __HYPERVISOR_kexec_op             37
 #define __HYPERVISOR_tmem_op              38
+#define __HYPERVISOR_xc_reserved_op       39 /* reserved for XenClient */
 
 /* Architecture-specific hypercall definitions. */
 #define __HYPERVISOR_arch_0               48
-- 
2.1.2

