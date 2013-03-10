Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab3CJMlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 08:41:45 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:49523 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3CJMlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 08:41:44 -0400
From: Andrei Epure <epure.andrei@gmail.com>
To: linville@tuxdriver.com
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrei Epure <epure.andrei@gmail.com>
Subject: [PATCH] ath: changed kmalloc to kmemdup
Date: Sun, 10 Mar 2013 14:39:58 +0200
Message-Id: <1362919199-16292-1-git-send-email-epure.andrei@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/usb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index 5fcd342..ffa1daa 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -856,11 +856,9 @@ static int ath6kl_usb_submit_ctrl_out(struct ath6kl_usb *ar_usb,
 	int ret;
 
 	if (size > 0) {
-		buf = kmalloc(size, GFP_KERNEL);
+		buf = kmemdup(data, size, GFP_KERNEL);
 		if (buf == NULL)
 			return -ENOMEM;
-
-		memcpy(buf, data, size);
 	}
 
 	/* note: if successful returns number of bytes transfered */
-- 
1.7.10.4

