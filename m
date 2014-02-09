Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaBIO4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 09:56:20 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:54181 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751501AbaBIO4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 09:56:19 -0500
Message-ID: <1391957777.25424.15.camel@x220>
Subject: [PATCH] [media] si4713: Remove "select SI4713"
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 09 Feb 2014 15:56:17 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 14:56:17.0629 (UTC) FILETIME=[1605F8D0:01CF25A7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commits 7391232e1215 ("[media] si4713: Reorganized drivers/media/radio
directory") and b874b39fcd2f ("[media] si4713: Added the USB driver for
Si4713") both added a "select SI4713". But there's no Kconfig symbol
SI4713, so these selects are nops. It's not clear why they were added
but it's safe to remove them anyway.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested!

 drivers/media/radio/si4713/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/radio/si4713/Kconfig b/drivers/media/radio/si4713/Kconfig
index a7c3ba8..ed51ed0 100644
--- a/drivers/media/radio/si4713/Kconfig
+++ b/drivers/media/radio/si4713/Kconfig
@@ -1,7 +1,6 @@
 config USB_SI4713
 	tristate "Silicon Labs Si4713 FM Radio Transmitter support with USB"
 	depends on USB && RADIO_SI4713
-	select SI4713
 	---help---
 	  This is a driver for USB devices with the Silicon Labs SI4713
 	  chip. Currently these devices are known to work.
@@ -16,7 +15,6 @@ config USB_SI4713
 config PLATFORM_SI4713
 	tristate "Silicon Labs Si4713 FM Radio Transmitter support with I2C"
 	depends on I2C && RADIO_SI4713
-	select SI4713
 	---help---
 	  This is a driver for I2C devices with the Silicon Labs SI4713
 	  chip.
-- 
1.8.5.3



