Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135Ab3JPETX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 00:19:23 -0400
Received: from critiquepaper.com ([69.172.205.218]:34334 "EHLO
	mcser.mjdsystems.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750844Ab3JPETW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 00:19:22 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Oct 2013 00:19:22 EDT
From: Matthew Dawson <matthew@mjdsystems.ca>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        trivial@kernel.org, Matthew Dawson <matthew@mjdsystems.ca>
Subject: [PATCH] usb: misc: usb3503: Fix compile error due to incorrect regmap depedency
Date: Wed, 16 Oct 2013 00:11:24 -0400
Message-Id: <1381896684-13402-1-git-send-email-matthew@mjdsystems.ca>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB3503 driver had an incorrect depedency on REGMAP, instead of
REGMAP_I2C.  This caused the build to fail since the necessary regmap
i2c pieces were not available.

Signed-off-by: Matthew Dawson <matthew@mjdsystems.ca>
---
 drivers/usb/misc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
index e2b21c1..ba5f70f 100644
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -246,6 +246,6 @@ config USB_EZUSB_FX2
 config USB_HSIC_USB3503
        tristate "USB3503 HSIC to USB20 Driver"
        depends on I2C
-       select REGMAP
+       select REGMAP_I2C
        help
          This option enables support for SMSC USB3503 HSIC to USB 2.0 Driver.
-- 
1.8.1.5

