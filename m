Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab3L3IN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 03:13:28 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55409 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3L3IN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 03:13:26 -0500
From: Chen Baozi <baozich@gmail.com>
To: linux-arm-kernel@lists.infradead.org, xen-devel@lists.xenproject.org
Cc: catalin.marinas@arm.com, stefano.stabellini@eu.citrix.com,
        linux-kernel@vger.kernel.org, msalter@redhat.com,
        Chen Baozi <baozich@gmail.com>
Subject: [PATCH] arm64/xen: redefine xen_remap on arm64
Date: Mon, 30 Dec 2013 14:55:11 +0800
Message-Id: <1388386511-32276-1-git-send-email-baozich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen_remap used to be defined as ioremap_cached on arm64. In commit
c04e8e2fe, a new ioremap_cache was implemented, and ioremap_cached
was deleted, while xen_remap stays the same. This would lead to
the failure when building with CONFIG_HVC_XEN. Redefined xen_remap
on arm64 as ioremap_cache on arm64 to fix it.

Signed-off-by: Chen Baozi <baozich@gmail.com>
---
 arch/arm/include/asm/xen/page.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
index 75579a9..b3368df 100644
--- a/arch/arm/include/asm/xen/page.h
+++ b/arch/arm/include/asm/xen/page.h
@@ -117,6 +117,10 @@ static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 	return __set_phys_to_machine(pfn, mfn);
 }
 
+#ifdef CONFIG_ARM64
+#define xen_remap(cookie, size) ioremap_cache((cookie), (size))
+#else
 #define xen_remap(cookie, size) ioremap_cached((cookie), (size));
+#endif
 
 #endif /* _ASM_ARM_XEN_PAGE_H */
-- 
1.8.4.3

