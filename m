Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaHSRcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:32:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:32762 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbaHSRcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:32:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,896,1400050800"; 
   d="scan'208";a="578872015"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@kernel.org>,
        Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 01/12] dmaengine: dw: move dw_dmac.h to where it belongs to
Date: Tue, 19 Aug 2014 20:29:12 +0300
Message-Id: <1408469363-15901-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a common storage for platform data related structures and definitions
inside kernel source tree. The patch moves file from include/linux to
include/linux/platform_data and renames it acoordingly. The users are also
updated.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 MAINTAINERS                                     |   2 +-
 arch/avr32/mach-at32ap/at32ap700x.c             |   2 +-
 arch/avr32/mach-at32ap/include/mach/atmel-mci.h |   2 +-
 drivers/dma/dw/internal.h                       |   2 +-
 drivers/dma/dw/regs.h                           |   6 +-
 include/linux/dw_dmac.h                         | 111 ------------------------
 include/linux/platform_data/dma-dw.h            | 111 ++++++++++++++++++++++++
 include/sound/atmel-abdac.h                     |   2 +-
 include/sound/atmel-ac97c.h                     |   2 +-
 sound/atmel/abdac.c                             |   2 +-
 sound/atmel/ac97c.c                             |   2 +-
 11 files changed, 122 insertions(+), 122 deletions(-)
 delete mode 100644 include/linux/dw_dmac.h
 create mode 100644 include/linux/platform_data/dma-dw.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 04bf956..cd4a118 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7888,7 +7888,7 @@ SYNOPSYS DESIGNWARE DMAC DRIVER
 M:	Viresh Kumar <viresh.linux@gmail.com>
 M:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
 S:	Maintained
-F:	include/linux/dw_dmac.h
+F:	include/linux/platform_data/dma-dw.h
 F:	drivers/dma/dw/
 
 SYNOPSYS DESIGNWARE MMC/SD/SDIO DRIVER
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index db85b5e..2a1aa71 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -7,7 +7,7 @@
  */
 #include <linux/clk.h>
 #include <linux/delay.h>
-#include <linux/dw_dmac.h>
+#include <linux/platform_data/dma-dw.h>
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
diff --git a/arch/avr32/mach-at32ap/include/mach/atmel-mci.h b/arch/avr32/mach-at32ap/include/mach/atmel-mci.h
index 4bba585..11d7f4b 100644
--- a/arch/avr32/mach-at32ap/include/mach/atmel-mci.h
+++ b/arch/avr32/mach-at32ap/include/mach/atmel-mci.h
@@ -1,7 +1,7 @@
 #ifndef __MACH_ATMEL_MCI_H
 #define __MACH_ATMEL_MCI_H
 
-#include <linux/dw_dmac.h>
+#include <linux/platform_data/dma-dw.h>
 
 /**
  * struct mci_dma_data - DMA data for MCI interface
diff --git a/drivers/dma/dw/internal.h b/drivers/dma/dw/internal.h
index 32667f9..43cc1df 100644
--- a/drivers/dma/dw/internal.h
+++ b/drivers/dma/dw/internal.h
@@ -12,7 +12,7 @@
 #define _DW_DMAC_INTERNAL_H
 
 #include <linux/device.h>
-#include <linux/dw_dmac.h>
+#include <linux/platform_data/dma-dw.h>
 
 #include "regs.h"
 
diff --git a/drivers/dma/dw/regs.h b/drivers/dma/dw/regs.h
index bb98d3e..af02439 100644
--- a/drivers/dma/dw/regs.h
+++ b/drivers/dma/dw/regs.h
@@ -11,7 +11,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/dmaengine.h>
-#include <linux/dw_dmac.h>
+#include <linux/platform_data/dma-dw.h>
 
 #define DW_DMA_MAX_NR_CHANNELS	8
 #define DW_DMA_MAX_NR_REQUESTS	16
@@ -161,7 +161,7 @@ struct dw_dma_regs {
 #define DWC_CTLH_DONE		0x00001000
 #define DWC_CTLH_BLOCK_TS_MASK	0x00000fff
 
-/* Bitfields in CFG_LO. Platform-configurable bits are in <linux/dw_dmac.h> */
+/* Bitfields in CFG_LO. Platform-configurable bits are in <linux/platform_data/dma-dw.h> */
 #define DWC_CFGL_CH_PRIOR_MASK	(0x7 << 5)	/* priority mask */
 #define DWC_CFGL_CH_PRIOR(x)	((x) << 5)	/* priority */
 #define DWC_CFGL_CH_SUSP	(1 << 8)	/* pause xfer */
@@ -172,7 +172,7 @@ struct dw_dma_regs {
 #define DWC_CFGL_RELOAD_SAR	(1 << 30)
 #define DWC_CFGL_RELOAD_DAR	(1 << 31)
 
-/* Bitfields in CFG_HI. Platform-configurable bits are in <linux/dw_dmac.h> */
+/* Bitfields in CFG_HI. Platform-configurable bits are in <linux/platform_data/dma-dw.h> */
 #define DWC_CFGH_DS_UPD_EN	(1 << 5)
 #define DWC_CFGH_SS_UPD_EN	(1 << 6)
 
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
deleted file mode 100644
index 68b4024..0000000
--- a/include/linux/dw_dmac.h
+++ /dev/null
@@ -1,111 +0,0 @@
-/*
- * Driver for the Synopsys DesignWare DMA Controller
- *
- * Copyright (C) 2007 Atmel Corporation
- * Copyright (C) 2010-2011 ST Microelectronics
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef DW_DMAC_H
-#define DW_DMAC_H
-
-#include <linux/dmaengine.h>
-
-/**
- * struct dw_dma_slave - Controller-specific information about a slave
- *
- * @dma_dev: required DMA master device. Depricated.
- * @bus_id: name of this device channel, not just a device name since
- *          devices may have more than one channel e.g. "foo_tx"
- * @cfg_hi: Platform-specific initializer for the CFG_HI register
- * @cfg_lo: Platform-specific initializer for the CFG_LO register
- * @src_master: src master for transfers on allocated channel.
- * @dst_master: dest master for transfers on allocated channel.
- */
-struct dw_dma_slave {
-	struct device		*dma_dev;
-	u32			cfg_hi;
-	u32			cfg_lo;
-	u8			src_master;
-	u8			dst_master;
-};
-
-/**
- * struct dw_dma_platform_data - Controller configuration parameters
- * @nr_channels: Number of channels supported by hardware (max 8)
- * @is_private: The device channels should be marked as private and not for
- *	by the general purpose DMA channel allocator.
- * @chan_allocation_order: Allocate channels starting from 0 or 7
- * @chan_priority: Set channel priority increasing from 0 to 7 or 7 to 0.
- * @block_size: Maximum block size supported by the controller
- * @nr_masters: Number of AHB masters supported by the controller
- * @data_width: Maximum data width supported by hardware per AHB master
- *		(0 - 8bits, 1 - 16bits, ..., 5 - 256bits)
- */
-struct dw_dma_platform_data {
-	unsigned int	nr_channels;
-	bool		is_private;
-#define CHAN_ALLOCATION_ASCENDING	0	/* zero to seven */
-#define CHAN_ALLOCATION_DESCENDING	1	/* seven to zero */
-	unsigned char	chan_allocation_order;
-#define CHAN_PRIORITY_ASCENDING		0	/* chan0 highest */
-#define CHAN_PRIORITY_DESCENDING	1	/* chan7 highest */
-	unsigned char	chan_priority;
-	unsigned short	block_size;
-	unsigned char	nr_masters;
-	unsigned char	data_width[4];
-};
-
-/* bursts size */
-enum dw_dma_msize {
-	DW_DMA_MSIZE_1,
-	DW_DMA_MSIZE_4,
-	DW_DMA_MSIZE_8,
-	DW_DMA_MSIZE_16,
-	DW_DMA_MSIZE_32,
-	DW_DMA_MSIZE_64,
-	DW_DMA_MSIZE_128,
-	DW_DMA_MSIZE_256,
-};
-
-/* Platform-configurable bits in CFG_HI */
-#define DWC_CFGH_FCMODE		(1 << 0)
-#define DWC_CFGH_FIFO_MODE	(1 << 1)
-#define DWC_CFGH_PROTCTL(x)	((x) << 2)
-#define DWC_CFGH_SRC_PER(x)	((x) << 7)
-#define DWC_CFGH_DST_PER(x)	((x) << 11)
-
-/* Platform-configurable bits in CFG_LO */
-#define DWC_CFGL_LOCK_CH_XFER	(0 << 12)	/* scope of LOCK_CH */
-#define DWC_CFGL_LOCK_CH_BLOCK	(1 << 12)
-#define DWC_CFGL_LOCK_CH_XACT	(2 << 12)
-#define DWC_CFGL_LOCK_BUS_XFER	(0 << 14)	/* scope of LOCK_BUS */
-#define DWC_CFGL_LOCK_BUS_BLOCK	(1 << 14)
-#define DWC_CFGL_LOCK_BUS_XACT	(2 << 14)
-#define DWC_CFGL_LOCK_CH	(1 << 15)	/* channel lockout */
-#define DWC_CFGL_LOCK_BUS	(1 << 16)	/* busmaster lockout */
-#define DWC_CFGL_HS_DST_POL	(1 << 18)	/* dst handshake active low */
-#define DWC_CFGL_HS_SRC_POL	(1 << 19)	/* src handshake active low */
-
-/* DMA API extensions */
-struct dw_cyclic_desc {
-	struct dw_desc	**desc;
-	unsigned long	periods;
-	void		(*period_callback)(void *param);
-	void		*period_callback_param;
-};
-
-struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
-		dma_addr_t buf_addr, size_t buf_len, size_t period_len,
-		enum dma_transfer_direction direction);
-void dw_dma_cyclic_free(struct dma_chan *chan);
-int dw_dma_cyclic_start(struct dma_chan *chan);
-void dw_dma_cyclic_stop(struct dma_chan *chan);
-
-dma_addr_t dw_dma_get_src_addr(struct dma_chan *chan);
-
-dma_addr_t dw_dma_get_dst_addr(struct dma_chan *chan);
-
-#endif /* DW_DMAC_H */
diff --git a/include/linux/platform_data/dma-dw.h b/include/linux/platform_data/dma-dw.h
new file mode 100644
index 0000000..68b4024
--- /dev/null
+++ b/include/linux/platform_data/dma-dw.h
@@ -0,0 +1,111 @@
+/*
+ * Driver for the Synopsys DesignWare DMA Controller
+ *
+ * Copyright (C) 2007 Atmel Corporation
+ * Copyright (C) 2010-2011 ST Microelectronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef DW_DMAC_H
+#define DW_DMAC_H
+
+#include <linux/dmaengine.h>
+
+/**
+ * struct dw_dma_slave - Controller-specific information about a slave
+ *
+ * @dma_dev: required DMA master device. Depricated.
+ * @bus_id: name of this device channel, not just a device name since
+ *          devices may have more than one channel e.g. "foo_tx"
+ * @cfg_hi: Platform-specific initializer for the CFG_HI register
+ * @cfg_lo: Platform-specific initializer for the CFG_LO register
+ * @src_master: src master for transfers on allocated channel.
+ * @dst_master: dest master for transfers on allocated channel.
+ */
+struct dw_dma_slave {
+	struct device		*dma_dev;
+	u32			cfg_hi;
+	u32			cfg_lo;
+	u8			src_master;
+	u8			dst_master;
+};
+
+/**
+ * struct dw_dma_platform_data - Controller configuration parameters
+ * @nr_channels: Number of channels supported by hardware (max 8)
+ * @is_private: The device channels should be marked as private and not for
+ *	by the general purpose DMA channel allocator.
+ * @chan_allocation_order: Allocate channels starting from 0 or 7
+ * @chan_priority: Set channel priority increasing from 0 to 7 or 7 to 0.
+ * @block_size: Maximum block size supported by the controller
+ * @nr_masters: Number of AHB masters supported by the controller
+ * @data_width: Maximum data width supported by hardware per AHB master
+ *		(0 - 8bits, 1 - 16bits, ..., 5 - 256bits)
+ */
+struct dw_dma_platform_data {
+	unsigned int	nr_channels;
+	bool		is_private;
+#define CHAN_ALLOCATION_ASCENDING	0	/* zero to seven */
+#define CHAN_ALLOCATION_DESCENDING	1	/* seven to zero */
+	unsigned char	chan_allocation_order;
+#define CHAN_PRIORITY_ASCENDING		0	/* chan0 highest */
+#define CHAN_PRIORITY_DESCENDING	1	/* chan7 highest */
+	unsigned char	chan_priority;
+	unsigned short	block_size;
+	unsigned char	nr_masters;
+	unsigned char	data_width[4];
+};
+
+/* bursts size */
+enum dw_dma_msize {
+	DW_DMA_MSIZE_1,
+	DW_DMA_MSIZE_4,
+	DW_DMA_MSIZE_8,
+	DW_DMA_MSIZE_16,
+	DW_DMA_MSIZE_32,
+	DW_DMA_MSIZE_64,
+	DW_DMA_MSIZE_128,
+	DW_DMA_MSIZE_256,
+};
+
+/* Platform-configurable bits in CFG_HI */
+#define DWC_CFGH_FCMODE		(1 << 0)
+#define DWC_CFGH_FIFO_MODE	(1 << 1)
+#define DWC_CFGH_PROTCTL(x)	((x) << 2)
+#define DWC_CFGH_SRC_PER(x)	((x) << 7)
+#define DWC_CFGH_DST_PER(x)	((x) << 11)
+
+/* Platform-configurable bits in CFG_LO */
+#define DWC_CFGL_LOCK_CH_XFER	(0 << 12)	/* scope of LOCK_CH */
+#define DWC_CFGL_LOCK_CH_BLOCK	(1 << 12)
+#define DWC_CFGL_LOCK_CH_XACT	(2 << 12)
+#define DWC_CFGL_LOCK_BUS_XFER	(0 << 14)	/* scope of LOCK_BUS */
+#define DWC_CFGL_LOCK_BUS_BLOCK	(1 << 14)
+#define DWC_CFGL_LOCK_BUS_XACT	(2 << 14)
+#define DWC_CFGL_LOCK_CH	(1 << 15)	/* channel lockout */
+#define DWC_CFGL_LOCK_BUS	(1 << 16)	/* busmaster lockout */
+#define DWC_CFGL_HS_DST_POL	(1 << 18)	/* dst handshake active low */
+#define DWC_CFGL_HS_SRC_POL	(1 << 19)	/* src handshake active low */
+
+/* DMA API extensions */
+struct dw_cyclic_desc {
+	struct dw_desc	**desc;
+	unsigned long	periods;
+	void		(*period_callback)(void *param);
+	void		*period_callback_param;
+};
+
+struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
+		dma_addr_t buf_addr, size_t buf_len, size_t period_len,
+		enum dma_transfer_direction direction);
+void dw_dma_cyclic_free(struct dma_chan *chan);
+int dw_dma_cyclic_start(struct dma_chan *chan);
+void dw_dma_cyclic_stop(struct dma_chan *chan);
+
+dma_addr_t dw_dma_get_src_addr(struct dma_chan *chan);
+
+dma_addr_t dw_dma_get_dst_addr(struct dma_chan *chan);
+
+#endif /* DW_DMAC_H */
diff --git a/include/sound/atmel-abdac.h b/include/sound/atmel-abdac.h
index edff6a8..a8f735d 100644
--- a/include/sound/atmel-abdac.h
+++ b/include/sound/atmel-abdac.h
@@ -10,7 +10,7 @@
 #ifndef __INCLUDE_SOUND_ATMEL_ABDAC_H
 #define __INCLUDE_SOUND_ATMEL_ABDAC_H
 
-#include <linux/dw_dmac.h>
+#include <linux/platform_data/dma-dw.h>
 
 /**
  * struct atmel_abdac_pdata - board specific ABDAC configuration
diff --git a/include/sound/atmel-ac97c.h b/include/sound/atmel-ac97c.h
index 00e6c289..f2a1cdc 100644
--- a/include/sound/atmel-ac97c.h
+++ b/include/sound/atmel-ac97c.h
@@ -10,7 +10,7 @@
 #ifndef __INCLUDE_SOUND_ATMEL_AC97C_H
 #define __INCLUDE_SOUND_ATMEL_AC97C_H
 
-#include <linux/dw_dmac.h>
+#include <linux/platform_data/dma-dw.h>
 
 #define AC97C_CAPTURE	0x01
 #define AC97C_PLAYBACK	0x02
diff --git a/sound/atmel/abdac.c b/sound/atmel/abdac.c
index edf2ca7..154a7c4 100644
--- a/sound/atmel/abdac.c
+++ b/sound/atmel/abdac.c
@@ -9,7 +9,7 @@
  */
 #include <linux/clk.h>
 #include <linux/bitmap.h>
-#include <linux/dw_dmac.h>
+#include <linux/platform_data/dma-dw.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 #include <linux/init.h>
diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
index a04d2317..1dfb35a 100644
--- a/sound/atmel/ac97c.c
+++ b/sound/atmel/ac97c.c
@@ -31,7 +31,7 @@
 #include <sound/atmel-ac97c.h>
 #include <sound/memalloc.h>
 
-#include <linux/dw_dmac.h>
+#include <linux/platform_data/dma-dw.h>
 
 #include <mach/cpu.h>
 
-- 
2.1.0

