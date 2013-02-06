Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab3BFQZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:25:40 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:36195 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597Ab3BFQYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:24:31 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, tiwai@suse.de, w.sang@pengutronix.de
Cc: linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 14/15] drivers/power,goldfisch battery: add missing GENERIC_HARDIRQS dependency
Date: Wed,  6 Feb 2013 17:24:02 +0100
Message-Id: <1360167843-3587-15-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
x-cbid: 13020616-4966-0000-0000-000004D4555E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this link error on s390:

ERROR: "devm_request_threaded_irq" [drivers/power/goldfish_battery.ko] undefined!

Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/power/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 1e47197..9e00c38 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -348,6 +348,7 @@ config AB8500_BM
 
 config BATTERY_GOLDFISH
 	tristate "Goldfish battery driver"
+	depends on GENERIC_HARDIRQS
 	help
 	  Say Y to enable support for the battery and AC power in the
 	  Goldfish emulator.
-- 
1.7.10.4

