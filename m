Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab3IYBSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:18:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988Ab3IYAQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: [ 019/110] ARM: PCI: versatile: Fix SMAP register offsets
Date: Tue, 24 Sep 2013 17:14:17 -0700
Message-Id: <20130925001325.508754855@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Maydell <peter.maydell@linaro.org>

commit 99f2b130370b904ca5300079243fdbcafa2c708b upstream.

The SMAP register offsets in the versatile PCI controller code were
all off by four.  (This didn't have any observable bad effects
because on this board PHYS_OFFSET is zero, and (a) writing zero to
the flags register at offset 0x10 has no effect and (b) the reset
value of the SMAP register is zero anyway, so failing to write SMAP2
didn't matter.)

Signed-off-by: Peter Maydell <peter.maydell@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-versatile/pci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -43,9 +43,9 @@
 #define PCI_IMAP0		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x0)
 #define PCI_IMAP1		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x4)
 #define PCI_IMAP2		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x8)
-#define PCI_SMAP0		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x10)
-#define PCI_SMAP1		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x14)
-#define PCI_SMAP2		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x18)
+#define PCI_SMAP0		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x14)
+#define PCI_SMAP1		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x18)
+#define PCI_SMAP2		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0x1c)
 #define PCI_SELFID		__IO_ADDRESS(VERSATILE_PCI_CORE_BASE+0xc)
 
 #define DEVICE_ID_OFFSET		0x00


