Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbaHAQLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:11:22 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:37981 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaHAQLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:11:19 -0400
Date: Fri, 1 Aug 2014 21:41:15 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] ath6kl: convert a driver to use module_usb_driver()
Message-ID: <20140801161115.GA13979@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts a driver in drivers/net/* to use the
module_usb_driver() macro which makes the code smaller and a
bit simpler.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/net/wireless/ath/ath6kl/usb.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index c443258..a6a5e40 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -1229,26 +1229,7 @@ static struct usb_driver ath6kl_usb_driver = {
 	.disable_hub_initiated_lpm = 1,
 };
 
-static int ath6kl_usb_init(void)
-{
-	int ret;
-
-	ret = usb_register(&ath6kl_usb_driver);
-	if (ret) {
-		ath6kl_err("usb registration failed: %d\n", ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-static void ath6kl_usb_exit(void)
-{
-	usb_deregister(&ath6kl_usb_driver);
-}
-
-module_init(ath6kl_usb_init);
-module_exit(ath6kl_usb_exit);
+module_usb_driver(ath6kl_usb_driver);
 
 MODULE_AUTHOR("Atheros Communications, Inc.");
 MODULE_DESCRIPTION("Driver support for Atheros AR600x USB devices");
-- 
1.9.1

