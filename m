Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaEZOpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 10:45:51 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:50315 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752469AbaEZOpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 10:45:50 -0400
Message-ID: <1401115547.6068.11.camel@x220>
Subject: [PATCH] [next-20140526] rtl8192ee: btcoexist: remove undefined
 Kconfig macros
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 26 May 2014 16:45:47 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2014 14:45:48.0125 (UTC) FILETIME=[2E98C8D0:01CF78F1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are references to four undefined Kconfig macros in the code.
Commit 8542373dccd2 ("Staging: rtl8812ae: remove undefined Kconfig
macros") removed identical references from another staging driver, but
they resurfaced in rtl8192ee. Remove these again as the checks for them
still will always evaluate to false.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with git grep.

See also the almost identical commit 5212f518ac0f ("rtlwifi: btcoexist:
remove undefined Kconfig macros").

 drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.c b/drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.c
index 9757f138a37f..2d9fc24b1e21 100644
--- a/drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.c
+++ b/drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.c
@@ -736,17 +736,7 @@ bool exhalbtc92e_initlize_variables(struct rtl_priv *adapter)
 	else
 		btcoexist->binded = true;
 
-#if (defined(CONFIG_PCI_HCI))
-	btcoexist->chip_interface = BTC_INTF_PCI;
-#elif (defined(CONFIG_USB_HCI))
-	btcoexist->chip_interface = BTC_INTF_USB;
-#elif (defined(CONFIG_SDIO_HCI))
-	btcoexist->chip_interface = BTC_INTF_SDIO;
-#elif (defined(CONFIG_GSPI_HCI))
-	btcoexist->chip_interface = BTC_INTF_GSPI;
-#else
 	btcoexist->chip_interface = BTC_INTF_UNKNOWN;
-#endif
 
 	if (NULL == btcoexist->adapter)
 		btcoexist->adapter = adapter;
-- 
1.9.0

