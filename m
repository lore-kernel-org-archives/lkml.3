Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935457Ab3E3QTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:19:07 -0400
Received: from smtp.citrix.com ([66.165.176.89]:61174 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933826Ab3E3QS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:18:58 -0400
X-IronPort-AV: E=Sophos;i="4.87,772,1363132800"; 
   d="scan'208";a="28290760"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <Stefano.Stabellini@eu.citrix.com>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, <Ian.Campbell@citrix.com>,
        <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH RFC 2/6] arm64/xen: arm/xen header changes to compile on arm64
Date: Thu, 30 May 2013 17:18:29 +0100
Message-ID: <1369930713-6063-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1305301705500.4799@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305301705500.4799@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/include/asm/xen/events.h |    4 ++++
 arch/arm/include/asm/xen/page.h   |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/xen/events.h b/arch/arm/include/asm/xen/events.h
index 8b1f37b..12e4e0b 100644
--- a/arch/arm/include/asm/xen/events.h
+++ b/arch/arm/include/asm/xen/events.h
@@ -13,7 +13,11 @@ enum ipi_vector {
 
 static inline int xen_irqs_disabled(struct pt_regs *regs)
 {
+#ifdef CONFIG_ARM
 	return raw_irqs_disabled_flags(regs->ARM_cpsr);
+#else
+	return raw_irqs_disabled_flags((unsigned long) regs->pstate);
+#endif
 }
 
 #define xchg_xen_ulong(ptr, val) atomic64_xchg(container_of((ptr),	\
diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
index 30cdacb..cb2fa15 100644
--- a/arch/arm/include/asm/xen/page.h
+++ b/arch/arm/include/asm/xen/page.h
@@ -1,7 +1,9 @@
 #ifndef _ASM_ARM_XEN_PAGE_H
 #define _ASM_ARM_XEN_PAGE_H
 
+#ifdef ARM
 #include <asm/mach/map.h>
+#endif
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
-- 
1.7.2.5

