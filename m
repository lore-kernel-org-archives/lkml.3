Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195AbaEXFqL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 01:46:11 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:56315 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbaEXFqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 01:46:09 -0400
Message-ID: <1400910366.31526.65.camel@x220>
Subject: [PATCH] rtlwifi: rtl8192cu: remove check for CONFIG_AUTOSUSPEND
From: Paul Bolle <pebolle@tiscali.nl>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 24 May 2014 07:46:06 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 May 2014 05:46:07.0227 (UTC) FILETIME=[75405CB0:01CF7713]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A check for CONFIG_AUTOSUSPEND was included in this driver when it was
added in v2.6.39. But that Kconfig symbol doesn't exist. Remove that
check and the single line it hides.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested.

It's hard to say whether or not the intention was to allow enabling
usb's autosuspend functionality. But that functionality has been
disabled (as leaving this member zero probably means) for three years
now and I don't have access to this hardware. So I opted for safety.

 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index c61311084d7e..361435f8608a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -395,9 +395,6 @@ static struct usb_driver rtl8192cu_driver = {
 	/* .resume = rtl_usb_resume, */
 	/* .reset_resume = rtl8192c_resume, */
 #endif /* CONFIG_PM */
-#ifdef CONFIG_AUTOSUSPEND
-	.supports_autosuspend = 1,
-#endif
 	.disable_hub_initiated_lpm = 1,
 };
 
-- 
1.9.0

