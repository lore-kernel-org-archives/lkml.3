Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab3FMIkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:40:51 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:48931 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704Ab3FMIkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:40:47 -0400
From: <ludovic.desroches@atmel.com>
To: <vinod.koul@intel.com>, <arnd@arndb.de>, <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <nicolas.ferre@atmel.com>, <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [PATCH v3 1/2] ARM: at91: dt: add header to define at_hdmac configuration
Date: Thu, 13 Jun 2013 10:39:38 +0200
Message-ID: <1371112779-22738-2-git-send-email-ludovic.desroches@atmel.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1371112779-22738-1-git-send-email-ludovic.desroches@atmel.com>
References: <1371112779-22738-1-git-send-email-ludovic.desroches@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ludovic Desroches <ludovic.desroches@atmel.com>

DMA-cell content is a concatenation of several values. In order to keep this
stuff human readable, macros are introduced.

The values for the FIFO configuration are not the same as the ones used in the
configuration register in order to keep backward compatibility. Most devices
use the half FIFO configuration but USART ones have to use the ASAP
configuration. This parameter was not initially planed to be into the at91 dma
dt binding. The third cell will be used to store this parameter, it will
become a concatenation of the FIFO configuration and of the peripheral ID. In
order to keep backward compatibility i.e. FIFO configuration is equal to 0, we
have to perform a translation since the value to put in the register to set
half FIFO is 1.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
---
 include/dt-bindings/dma/at91.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 include/dt-bindings/dma/at91.h

diff --git a/include/dt-bindings/dma/at91.h b/include/dt-bindings/dma/at91.h
new file mode 100644
index 0000000..e835037
--- /dev/null
+++ b/include/dt-bindings/dma/at91.h
@@ -0,0 +1,27 @@
+/*
+ * This header provides macros for at91 dma bindings.
+ *
+ * Copyright (C) 2013 Ludovic Desroches <ludovic.desroches@atmel.com>
+ *
+ * GPLv2 only
+ */
+
+#ifndef __DT_BINDINGS_AT91_DMA_H__
+#define __DT_BINDINGS_AT91_DMA_H__
+
+/*
+ * Source and/or destination peripheral ID
+ */
+#define AT91_DMA_CFG_PER_ID_MASK	(0xff)
+#define AT91_DMA_CFG_PER_ID(id)		(id & AT91_DMA_CFG_PER_ID_MASK)
+
+/*
+ * FIFO configuration: it defines when a request is serviced.
+ */
+#define AT91_DMA_CFG_FIFOCFG_OFFSET	(8)
+#define AT91_DMA_CFG_FIFOCFG_MASK	(0xf << AT91_DMA_CFG_FIFOCFG_OFFSET)
+#define AT91_DMA_CFG_FIFOCFG_HALF	(0x0 << AT91_DMA_CFG_FIFOCFG_OFFSET)	/* half FIFO (default behavior) */
+#define AT91_DMA_CFG_FIFOCFG_ALAP	(0x1 << AT91_DMA_CFG_FIFOCFG_OFFSET)	/* largest defined AHB burst */
+#define AT91_DMA_CFG_FIFOCFG_ASAP	(0x2 << AT91_DMA_CFG_FIFOCFG_OFFSET)	/* single AHB access */
+
+#endif /* __DT_BINDINGS_AT91_DMA_H__ */
-- 
1.7.11.3

