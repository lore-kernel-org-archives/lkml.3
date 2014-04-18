Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbaDRPyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 11:54:46 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:62702 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaDRPyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 11:54:43 -0400
From: Julien Grall <julien.grall@linaro.org>
To: stefano.stabellini@eu.citrix.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, ian.campbell@citrix.com,
        david.vrabel@citrix.com, konrad.wilk@oracle.com,
        Julien Grall <julien.grall@linaro.org>
Subject: [PATCH] arm/xen: Remove definiition of virt_to_pfn in asm/xen/page.h
Date: Fri, 18 Apr 2014 16:54:34 +0100
Message-Id: <1397836474-10478-1-git-send-email-julien.grall@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virt_to_pfn has been defined in asm/memory.h by the commit e26a9e0 "ARM: Better
virt_to_page() handling"

This will result of a compilation warning when CONFIG_XEN is enabled.

arch/arm/include/asm/xen/page.h:80:0: warning: "virt_to_pfn" redefined [enabled by default]
 #define virt_to_pfn(v)          (PFN_DOWN(__pa(v)))
 ^
In file included from arch/arm/include/asm/page.h:163:0,
                 from arch/arm/include/asm/xen/page.h:4,
                 from include/xen/page.h:4,
                 from arch/arm/xen/grant-table.c:33:

The definition in memory.h is nearly the same (it directly expand PFN_DOWN),
so we can safely drop virt_to_pfn in xen include.

Signed-off-by: Julien Grall <julien.grall@linaro.org>
---
 arch/arm/include/asm/xen/page.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
index cf4f3e8..ded062f 100644
--- a/arch/arm/include/asm/xen/page.h
+++ b/arch/arm/include/asm/xen/page.h
@@ -77,7 +77,6 @@ static inline xpaddr_t machine_to_phys(xmaddr_t machine)
 }
 /* VIRT <-> MACHINE conversion */
 #define virt_to_machine(v)	(phys_to_machine(XPADDR(__pa(v))))
-#define virt_to_pfn(v)          (PFN_DOWN(__pa(v)))
 #define virt_to_mfn(v)		(pfn_to_mfn(virt_to_pfn(v)))
 #define mfn_to_virt(m)		(__va(mfn_to_pfn(m) << PAGE_SHIFT))
 
-- 
1.7.10.4

