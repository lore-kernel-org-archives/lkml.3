Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaJQHx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:53:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45983 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753398AbaJQHxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:53:13 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <chris@printf.net>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 3/3] avr32: remove mach/atmel-mci.h
Date: Fri, 17 Oct 2014 09:52:46 +0200
Message-Id: <1413532366-1317-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413532366-1317-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1413532366-1317-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic platform_data header file instead of mach/atmel-mci.h

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/avr32/mach-at32ap/at32ap700x.c             |  2 +-
 arch/avr32/mach-at32ap/include/mach/atmel-mci.h | 17 -----------------
 2 files changed, 1 insertion(+), 18 deletions(-)
 delete mode 100644 arch/avr32/mach-at32ap/include/mach/atmel-mci.h

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index db85b5ec3351..f8deca560e4d 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -17,7 +17,7 @@
 #include <linux/spi/spi.h>
 #include <linux/usb/atmel_usba_udc.h>
 
-#include <mach/atmel-mci.h>
+#include <linux/platform_data/mmc-atmel-mci.h>
 #include <linux/atmel-mci.h>
 
 #include <asm/io.h>
diff --git a/arch/avr32/mach-at32ap/include/mach/atmel-mci.h b/arch/avr32/mach-at32ap/include/mach/atmel-mci.h
deleted file mode 100644
index 4bba58561d5c..000000000000
--- a/arch/avr32/mach-at32ap/include/mach/atmel-mci.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef __MACH_ATMEL_MCI_H
-#define __MACH_ATMEL_MCI_H
-
-#include <linux/dw_dmac.h>
-
-/**
- * struct mci_dma_data - DMA data for MCI interface
- */
-struct mci_dma_data {
-	struct dw_dma_slave	sdata;
-};
-
-/* accessor macros */
-#define	slave_data_ptr(s)	(&(s)->sdata)
-#define find_slave_dev(s)	((s)->sdata.dma_dev)
-
-#endif /* __MACH_ATMEL_MCI_H */
-- 
1.9.1

