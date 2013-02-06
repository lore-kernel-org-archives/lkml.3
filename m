Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab3BFQYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:24:37 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:33409 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab3BFQYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:24:33 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, tiwai@suse.de, w.sang@pengutronix.de
Cc: linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 08/15] drivers/misc/cb710: add missing GENERIC_HARDIRQS dependency
Date: Wed,  6 Feb 2013 17:23:56 +0100
Message-Id: <1360167843-3587-9-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
x-cbid: 13020616-0342-0000-0000-00000422224E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CB710_CORE (drivers/misc/cb710/core.c) calls devm_request_irq() and
therefore needs a GENERIC_HARDIRQS dependency to prevent a link
error on s390.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/misc/cb710/Kconfig |    2 +-
 drivers/mmc/host/Kconfig   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/cb710/Kconfig b/drivers/misc/cb710/Kconfig
index 22429b8..5acb9c5 100644
--- a/drivers/misc/cb710/Kconfig
+++ b/drivers/misc/cb710/Kconfig
@@ -1,6 +1,6 @@
 config CB710_CORE
 	tristate "ENE CB710/720 Flash memory card reader support"
-	depends on PCI
+	depends on PCI && GENERIC_HARDIRQS
 	help
 	  This option enables support for PCI ENE CB710/720 Flash memory card
 	  reader found in some laptops (ie. some versions of HP Compaq nx9500).
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index aebe265..d88219e 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -475,7 +475,7 @@ config MMC_SDHI
 
 config MMC_CB710
 	tristate "ENE CB710 MMC/SD Interface support"
-	depends on PCI
+	depends on PCI && GENERIC_HARDIRQS
 	select CB710_CORE
 	help
 	  This option enables support for MMC/SD part of ENE CB710/720 Flash
-- 
1.7.10.4

