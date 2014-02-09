Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaBIPN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 10:13:28 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:60207 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612AbaBIPN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 10:13:27 -0500
Message-ID: <1391958806.25424.24.camel@x220>
Subject: [PATCH] Staging: rtl8812ae: remove undefined Kconfig macros
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sun, 09 Feb 2014 16:13:26 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 15:13:26.0579 (UTC) FILETIME=[7B534830:01CF25A9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are references to four undefined Kconfig macros in the code.
Remove these as the checks for them will always evaluate to false.

There are additional cleanups possible now, but I'll gladly leave those
to people that are actually familiar with the code.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested (that is, tested with "git grep" only).

 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c b/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c
index 9d9fa4d..1152fc8 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c
@@ -732,17 +732,7 @@ bool exhalbtc_initlize_variables(struct rtl_priv *adapter)
 	else
 		btcoexist->binded = true;
 
-#if ( defined(CONFIG_PCI_HCI))
-	btcoexist->chip_interface = BTC_INTF_PCI;
-#elif ( defined(CONFIG_USB_HCI))
-	btcoexist->chip_interface = BTC_INTF_USB;
-#elif ( defined(CONFIG_SDIO_HCI))
-	btcoexist->chip_interface = BTC_INTF_SDIO;
-#elif ( defined(CONFIG_GSPI_HCI))
-	btcoexist->chip_interface = BTC_INTF_GSPI;
-#else
 	btcoexist->chip_interface = BTC_INTF_UNKNOWN;
-#endif
 
 	if (NULL == btcoexist->adapter)
 		btcoexist->adapter = adapter;
-- 
1.8.5.3

