Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaKZVPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:15:41 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33286 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbaKZVPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:15:03 -0500
From: Dave Gerlach <d-gerlach@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: Russ Dill <russ.dill@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, Tony Lindgren <tony@atomide.com>,
        <Anson.Huang@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        Dave Gerlach <d-gerlach@ti.com>
Subject: [RFC PATCH 1/2] asm-generic: io: Add exec versions of ioremap
Date: Wed, 26 Nov 2014 15:14:00 -0600
Message-ID: <cb5e9dd7bd71b13551cd3f32f28feb405ea9fcdd.1417029918.git.d-gerlach@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1417029918.git.d-gerlach@ti.com>
References: <cover.1417029918.git.d-gerlach@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russ Dill <Russ.Dill@ti.com>

If code is to be copied into and area (such as SRAM) and run,
it needs to be marked as exec. Currently only an ARM version
of this exists.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
---
 arch/arm/include/asm/io.h   | 2 ++
 include/asm-generic/iomap.h | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 1805674..1d99d42 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -344,6 +344,8 @@ extern void _memset_io(volatile void __iomem *, int, size_t);
 #define ioremap_nocache(cookie,size)	__arm_ioremap((cookie), (size), MT_DEVICE)
 #define ioremap_cache(cookie,size)	__arm_ioremap((cookie), (size), MT_DEVICE_CACHED)
 #define ioremap_wc(cookie,size)		__arm_ioremap((cookie), (size), MT_DEVICE_WC)
+#define ioremap_exec(cookie,size)	__arm_ioremap_exec((cookie), (size), true)
+#define ioremap_exec_nocache(cookie,size) __arm_ioremap_exec((cookie), (size), false)
 #define iounmap				__arm_iounmap
 
 /*
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index 1b41011..6648ff3 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -66,6 +66,11 @@ extern void ioport_unmap(void __iomem *);
 #define ioremap_wc ioremap_nocache
 #endif
 
+#ifndef ARCH_HAS_IOREMAP_EXEC
+#define ioremap_exec ioremap
+#define ioremap_exec_nocache ioremap_nocache
+#endif
+
 #ifdef CONFIG_PCI
 /* Destroy a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
-- 
2.1.0

