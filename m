Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162624AbaDCING (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:13:06 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:52496 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162421AbaDCIMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:12:55 -0400
Message-ID: <1396512771.31985.5.camel@x220>
Subject: [PATCH] rtlwifi: btcoexist: remove undefined Kconfig macros
From: Paul Bolle <pebolle@tiscali.nl>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2014 10:12:51 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Apr 2014 08:12:52.0075 (UTC) FILETIME=[82484BB0:01CF4F14]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are references to four undefined Kconfig macros in the code.
Commit 8542373dccd2 ("Staging: rtl8812ae: remove undefined Kconfig
macros") removed identical references from that staging driver, but
they resurfaced in rtlwifi. Remove these again as the checks for them
still will always evaluate to false.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested by grepping the tree only.

A follow up could now remove both "enum btc_chip_interface" and
"chip_interface", couldn't it?

 drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
index b6722de6..33da3df 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -625,17 +625,7 @@ bool exhalbtc_initlize_variables(struct rtl_priv *adapter)
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

