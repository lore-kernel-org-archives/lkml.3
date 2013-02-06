Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab3BFQ0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:26:42 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:58680 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab3BFQYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:24:18 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, tiwai@suse.de, w.sang@pengutronix.de
Cc: linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 09/15] drivers/media: add missing GENERIC_HARDIRQS dependencies
Date: Wed,  6 Feb 2013 17:23:57 +0100
Message-Id: <1360167843-3587-10-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
x-cbid: 13020616-2966-0000-0000-000006A8998D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SuperH VEU mem2mem video processing driver (VIDEO_SH_VEU)
calls devm_request_threaded_irq() and therefore should depend
on GENERIC_HARDIRQS.
Texas Instruments WL1273 I2C FM Radio (RADIO_WL1273) selects
MFD_CORE, which itself depends on GENERIC_HARDIRQS.
So add the dependency to the TI driver as well.

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/media/platform/Kconfig |    2 +-
 drivers/media/radio/Kconfig    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 05d7b63..a0639e7 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -204,7 +204,7 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 
 config VIDEO_SH_VEU
 	tristate "SuperH VEU mem2mem video processing driver"
-	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on VIDEO_DEV && VIDEO_V4L2 && GENERIC_HARDIRQS
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index ead9928..24e64a0 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -192,7 +192,7 @@ config RADIO_TIMBERDALE
 
 config RADIO_WL1273
 	tristate "Texas Instruments WL1273 I2C FM Radio"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && GENERIC_HARDIRQS
 	select MFD_CORE
 	select MFD_WL1273_CORE
 	select FW_LOADER
-- 
1.7.10.4

