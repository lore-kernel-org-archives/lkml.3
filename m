Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab3HZPLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:11:51 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:62753 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab3HZPLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:49 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 18/24] Staging: winbond: wb35rx: changed sleep function from msleep to usleep
Date: Mon, 26 Aug 2013 17:10:17 +0200
Message-Id: <1377529823-5116-19-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the documentation it is not recommended to use msleep for 1ms - 20ms because it may sleep longer than 20ms. So, it is recommended to use usleep instead.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/wb35rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/winbond/wb35rx.c b/drivers/staging/winbond/wb35rx.c
index 8d71bc2..48ed95c 100644
--- a/drivers/staging/winbond/wb35rx.c
+++ b/drivers/staging/winbond/wb35rx.c
@@ -339,9 +339,9 @@ void Wb35Rx_destroy(struct hw_data *pHwData)
 	struct wb35_rx *pWb35Rx = &pHwData->Wb35Rx;
 
 	do {
-		msleep(10); /* Delay for waiting function enter */
+		usleep(10000); /* Delay for waiting function enter */
 	} while (pWb35Rx->EP3vm_state != VM_STOP);
-	msleep(10); /* Delay for waiting function exit */
+	usleep(10000); /* Delay for waiting function exit */
 
 	usb_free_urb(pWb35Rx->RxUrb);
 	pr_debug("Wb35Rx_destroy OK\n");
-- 
1.8.1.2

