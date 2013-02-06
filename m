Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab3BFQYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:24:32 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:60029 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab3BFQY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:24:29 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, tiwai@suse.de, w.sang@pengutronix.de
Cc: linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 11/15] drivers/spi: add missing GENERIC_HARDIRQS dependencies
Date: Wed,  6 Feb 2013 17:23:59 +0100
Message-Id: <1360167843-3587-12-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
x-cbid: 13020616-2966-0000-0000-000006A899B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Altera SPI Controller driver and PXA2xx SSP SPI master driver
have calls to devm_request_irq() and request_irq() and therefore
should have a dependency to GENERIC_HARDIRQS.
Otherwise this causes link errors on platforms without
GENERIC_HARDIRQS support.

Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/spi/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 5c8fda6..5b76212 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -55,6 +55,7 @@ comment "SPI Master Controller Drivers"
 
 config SPI_ALTERA
 	tristate "Altera SPI Controller"
+	depends on GENERIC_HARDIRQS
 	select SPI_BITBANG
 	help
 	  This is the driver for the Altera SPI Controller.
@@ -299,7 +300,7 @@ config SPI_PPC4xx
 
 config SPI_PXA2XX
 	tristate "PXA2xx SSP SPI master"
-	depends on ARCH_PXA || PCI
+	depends on (ARCH_PXA || PCI) && GENERIC_HARDIRQS
 	select PXA_SSP if ARCH_PXA
 	help
 	  This enables using a PXA2xx or Sodaville SSP port as a SPI master
-- 
1.7.10.4

