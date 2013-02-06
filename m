Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3BFQ2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:28:04 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:36160 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab3BFQYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:24:15 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, tiwai@suse.de, w.sang@pengutronix.de
Cc: linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 04/15] drivers/block/mtip32xx: add missing GENERIC_HARDIRQS dependency
Date: Wed,  6 Feb 2013 17:23:52 +0100
Message-Id: <1360167843-3587-5-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
x-cbid: 13020616-4966-0000-0000-000004D4552D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MTIP32XX driver calls devm_request_irq() and therefore needs a
GENERIC_HARDIRQS dependency to prevent building it on s390.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/block/mtip32xx/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/mtip32xx/Kconfig b/drivers/block/mtip32xx/Kconfig
index 0ba837f..1fca1f99 100644
--- a/drivers/block/mtip32xx/Kconfig
+++ b/drivers/block/mtip32xx/Kconfig
@@ -4,6 +4,6 @@
 
 config BLK_DEV_PCIESSD_MTIP32XX
 	tristate "Block Device Driver for Micron PCIe SSDs"
-	depends on PCI
+	depends on PCI && GENERIC_HARDIRQS
 	help
           This enables the block driver for Micron PCIe SSDs.
-- 
1.7.10.4

