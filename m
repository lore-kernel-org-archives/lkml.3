Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787Ab3BFQ11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:27:27 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:56269 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707Ab3BFQYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:24:16 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, tiwai@suse.de, w.sang@pengutronix.de
Cc: linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [PATCH 05/15] drivers/dma/dw_dmac: add missing GENERIC_HARDIRQS dependency
Date: Wed,  6 Feb 2013 17:23:53 +0100
Message-Id: <1360167843-3587-6-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
x-cbid: 13020616-3548-0000-0000-0000047B5C83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Synopsys DesignWare AHB DMA drivers calls devm_request_irq() and
therefore depends on GENERIC_HARDIRQS.
Add the missing dependency.

Cc: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/dma/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 3600234..26d3127 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -83,6 +83,7 @@ config INTEL_IOP_ADMA
 
 config DW_DMAC
 	tristate "Synopsys DesignWare AHB DMA support"
+	depends on GENERIC_HARDIRQS
 	select DMA_ENGINE
 	default y if CPU_AT32AP7000
 	help
-- 
1.7.10.4

