Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161873AbaDPPrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:47:49 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:57629 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161580AbaDPPrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:47:45 -0400
Message-ID: <1397663263.28548.13.camel@x220>
Subject: [PATCH] [media] sms: Remove CONFIG_ prefix from Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Martin Walch <walch.martin@web.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 16 Apr 2014 17:47:43 +0200
In-Reply-To: <1392122724.13064.18.camel@x220>
References: <3513955.N5RNgL3hPx@tacticalops>
	 <1383420054.4378.3.camel@x220.thuisdomein>
	 <20131102174047.70c24ed8@samsung.com> <1392122724.13064.18.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Apr 2014 15:47:43.0504 (UTC) FILETIME=[349CA100:01CF598B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the CONFIG_ prefix from two Kconfig symbols in a dependency for
SMS_SIANO_DEBUGFS. This prefix is invalid inside Kconfig files.

Note that the current (common sense) dependency on SMS_USB_DRV and
SMS_SDIO_DRV being equal ensures that SMS_SIANO_DEBUGFS will not
violate its constraints. These constraint are that:
- it should only be built if SMS_USB_DRV is set;
- it can't be builtin if USB support is modular.

So drop the dependency on SMS_USB_DRV, as it is unneeded.

Fixes: 6c84b214284e ("[media] sms: fix randconfig building error")
Reported-by: Martin Walch <walch.martin@web.de>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
This is not runtime tested, as I don't have the hardware.

A matrix of the three cases in which this symbol can be set, to aid
review and to see whether I actually understood the constraints:

USB  SMS_USB_DRV  SMS_SDIO_DRV  SMS_SIANO_MDTV  SMS_SIANO_DEBUGFS
m    m            m             m               y 
y    m            m             m               y 
y    y            y             y               y 

By the way, I found myself staring at the entries in this file for quite
some time. Perhaps things would have been easier to understand if
SMS_USB_DRV and SMS_SDIO_DRV both selected SMS_SIANO_MDTV. But I didn't
dare to test that idea.

 drivers/media/common/siano/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/common/siano/Kconfig b/drivers/media/common/siano/Kconfig
index f953d33ee151..4bfbd5f463d1 100644
--- a/drivers/media/common/siano/Kconfig
+++ b/drivers/media/common/siano/Kconfig
@@ -22,8 +22,7 @@ config SMS_SIANO_DEBUGFS
 	bool "Enable debugfs for smsdvb"
 	depends on SMS_SIANO_MDTV
 	depends on DEBUG_FS
-	depends on SMS_USB_DRV
-	depends on CONFIG_SMS_USB_DRV = CONFIG_SMS_SDIO_DRV
+	depends on SMS_USB_DRV = SMS_SDIO_DRV
 
 	---help---
 	  Choose Y to enable visualizing a dump of the frontend
-- 
1.9.0

