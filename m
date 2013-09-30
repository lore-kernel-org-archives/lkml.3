Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab3I3KQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:16:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43834 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab3I3KNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Maydell <peter.maydell@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 097/104] ARM: PCI: versatile: Fix SMAP register offsets
Date: Mon, 30 Sep 2013 11:11:14 +0100
Message-Id: <1380535881-9239-98-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-versatile/pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
index 2dbaee9..474e76d 100644
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
-- 
1.8.3.2

