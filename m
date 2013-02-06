Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab3BFQYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:24:21 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:58672 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757716Ab3BFQYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:24:17 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, tiwai@suse.de, w.sang@pengutronix.de
Cc: linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 06/15] drivers/gpio: add missing GENERIC_HARDIRQ dependency
Date: Wed,  6 Feb 2013 17:23:54 +0100
Message-Id: <1360167843-3587-7-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
x-cbid: 13020616-2966-0000-0000-000006A8997F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VIA VX855/VX875 GPIO and RDC R-321x GPIO support drivers select
MFD_CORE which itself depends on GENERIC_HARDIRQ support.
So add this dependency to these two drivers as well to prevent
selection of MFD_CORE.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/gpio/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 8eafc4b..93aaadf 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -280,7 +280,7 @@ config GPIO_ICH
 
 config GPIO_VX855
 	tristate "VIA VX855/VX875 GPIO"
-	depends on PCI
+	depends on PCI && GENERIC_HARDIRQS
 	select MFD_CORE
 	select MFD_VX855
 	help
@@ -610,7 +610,7 @@ config GPIO_TIMBERDALE
 
 config GPIO_RDC321X
 	tristate "RDC R-321x GPIO support"
-	depends on PCI
+	depends on PCI && GENERIC_HARDIRQS
 	select MFD_CORE
 	select MFD_RDC321X
 	help
-- 
1.7.10.4

