Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3FEMPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:15:45 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:43345 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab3FEMPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:15:43 -0400
X-IronPort-AV: E=Sophos;i="4.87,806,1363132800"; 
   d="scan'208";a="27976485"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <Stefano.Stabellini@eu.citrix.com>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, <Ian.Campbell@citrix.com>,
        <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3 1/6] arm/xen: define xen_remap as ioremap_cached
Date: Wed, 5 Jun 2013 13:15:25 +0100
Message-ID: <1370434530-22428-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1306041712100.4589@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1306041712100.4589@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define xen_remap as ioremap_cache (MT_MEMORY and MT_DEVICE_CACHED end up
having the same AttrIndx encoding).

Remove include asm/mach/map.h, not unneeded.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/include/asm/xen/page.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
index 30cdacb..359a7b5 100644
--- a/arch/arm/include/asm/xen/page.h
+++ b/arch/arm/include/asm/xen/page.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_ARM_XEN_PAGE_H
 #define _ASM_ARM_XEN_PAGE_H
 
-#include <asm/mach/map.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
@@ -88,6 +87,6 @@ static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 	return __set_phys_to_machine(pfn, mfn);
 }
 
-#define xen_remap(cookie, size) __arm_ioremap((cookie), (size), MT_MEMORY);
+#define xen_remap(cookie, size) ioremap_cached((cookie), (size));
 
 #endif /* _ASM_ARM_XEN_PAGE_H */
-- 
1.7.2.5

