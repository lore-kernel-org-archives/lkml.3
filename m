Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaJFN4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:56:14 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:37186 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaJFNwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:52:51 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Fengguang Wu <fengguang.wu@intel.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Sam Ravnborg <sam@ravnborg.org>,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] ARC: Remove redundant PCI_IOBASE declaration
Date: Mon,  6 Oct 2014 15:52:33 +0200
Message-Id: <1412603561-27653-2-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412603561-27653-1-git-send-email-thierry.reding@gmail.com>
References: <1412603561-27653-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

ARC's asm/io.h includes the asm-generic/io.h which already defines the
PCI_IOBASE variable in exactly the same way, so it can be dropped from
the architecture specific header.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arc/include/asm/io.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arc/include/asm/io.h b/arch/arc/include/asm/io.h
index 334ce7017a18..cabd518cb253 100644
--- a/arch/arc/include/asm/io.h
+++ b/arch/arc/include/asm/io.h
@@ -13,8 +13,6 @@
 #include <asm/byteorder.h>
 #include <asm/page.h>
 
-#define PCI_IOBASE ((void __iomem *)0)
-
 extern void __iomem *ioremap(unsigned long physaddr, unsigned long size);
 extern void __iomem *ioremap_prot(phys_addr_t offset, unsigned long size,
 				  unsigned long flags);
-- 
2.1.0

