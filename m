Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab3GWJw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:52:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482Ab3GWJwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:52:23 -0400
From: Jason Wang <jasowang@redhat.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 2/4] xen: switch to use hypervisor_cpuid_base()
Date: Tue, 23 Jul 2013 17:41:03 +0800
Message-Id: <1374572465-15278-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1374572465-15278-1-git-send-email-jasowang@redhat.com>
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to use hypervisor_cpuid_base() to detect Xen.

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: xen-devel@lists.xensource.com
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 arch/x86/include/asm/xen/hypervisor.h |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index 125f344..d866959 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -40,21 +40,7 @@ extern struct start_info *xen_start_info;
 
 static inline uint32_t xen_cpuid_base(void)
 {
-	uint32_t base, eax, ebx, ecx, edx;
-	char signature[13];
-
-	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
-		cpuid(base, &eax, &ebx, &ecx, &edx);
-		*(uint32_t *)(signature + 0) = ebx;
-		*(uint32_t *)(signature + 4) = ecx;
-		*(uint32_t *)(signature + 8) = edx;
-		signature[12] = 0;
-
-		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
-			return base;
-	}
-
-	return 0;
+	return hypervisor_cpuid_base("XenVMMXenVMM", 2);
 }
 
 #ifdef CONFIG_XEN
-- 
1.7.1

