Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab3BFQY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:24:28 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:58671 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757717Ab3BFQYR (ORCPT
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
Subject: [PATCH 07/15] drivers/hid: add missing GENERIC_HARDIRQ dependency
Date: Wed,  6 Feb 2013 17:23:55 +0100
Message-Id: <1360167843-3587-8-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
x-cbid: 13020616-2966-0000-0000-000006A89980
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HID Sensors framework support (CONFIG_HID_SENSOR_HUB) unconditionally
selects MFD_CORE which however depends on GENERIC_HARDIRQS.
So add this dependency to HID_SENSOR_HUB as well.

Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/hid/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 61d2453..9613c81 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -725,7 +725,7 @@ config HID_ZYDACRON
 
 config HID_SENSOR_HUB
 	tristate "HID Sensors framework support"
-	depends on USB_HID
+	depends on USB_HID && GENERIC_HARDIRQS
 	select MFD_CORE
 	default n
 	-- help---
-- 
1.7.10.4

