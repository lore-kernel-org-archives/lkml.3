Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751088AbaCUVJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 17:09:50 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:53560 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaCUVJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 17:09:42 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh@kernel.org>
Subject: [PATCH 2/8] arm64: add FIXMAP_PAGE_NOCACHE definition
Date: Fri, 21 Mar 2014 16:08:42 -0500
Message-Id: <1395436128-11244-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395436128-11244-1-git-send-email-robherring2@gmail.com>
References: <1395436128-11244-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Similar to ioremap and ioremap_nocache, we want the same definition for
both using PROT_DEVICE_nGnRE.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/fixmap.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 5f7bfe6..68eab3c 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -54,7 +54,8 @@ enum fixed_addresses {
 #define FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START	(FIXADDR_TOP - FIXADDR_SIZE)
 
-#define FIXMAP_PAGE_IO     __pgprot(PROT_DEVICE_nGnRE)
+#define FIXMAP_PAGE_IO		__pgprot(PROT_DEVICE_nGnRE)
+#define FIXMAP_PAGE_NOCACHE	__pgprot(PROT_DEVICE_nGnRE)
 
 extern void __early_set_fixmap(enum fixed_addresses idx,
 			       phys_addr_t phys, pgprot_t flags);
-- 
1.8.3.2

