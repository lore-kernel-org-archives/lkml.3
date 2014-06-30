Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbaF3RyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:54:10 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17620 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbaF3RyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:54:07 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-efi@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: andrew.cooper3@citrix.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, eshelton@pobox.com, fenghua.yu@intel.com,
        hpa@zytor.com, ian.campbell@citrix.com, jbeulich@suse.com,
        jeremy@goop.org, konrad.wilk@oracle.com, matt.fleming@intel.com,
        mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de,
        tony.luck@intel.com
Subject: [PATCH v7 01/10] arch/ia64: Define early_memunmap()
Date: Mon, 30 Jun 2014 19:52:55 +0200
Message-Id: <1404150784-27921-2-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404150784-27921-1-git-send-email-daniel.kiper@oracle.com>
References: <1404150784-27921-1-git-send-email-daniel.kiper@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is odd to use early_iounmap() function do tear down mapping
created by early_memremap() function, even if it works right now,
because they belong to different set of functions. The former is
I/O related function and the later is memory related. So, create
early_memunmap() macro which in real is early_iounmap(). This
thing will help to not confuse code readers longer by mixing
functions from different classes.

EFI patches following this patch uses that functionality.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/ia64/include/asm/io.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index 0d2bcb3..bee0acd 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -426,6 +426,7 @@ extern void iounmap (volatile void __iomem *addr);
 extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned long size);
 #define early_memremap(phys_addr, size)        early_ioremap(phys_addr, size)
 extern void early_iounmap (volatile void __iomem *addr, unsigned long size);
+#define early_memunmap(addr, size)             early_iounmap(addr, size)
 static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
 {
 	return ioremap(phys_addr, size);
-- 
1.7.10.4

