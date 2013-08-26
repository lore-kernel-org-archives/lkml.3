Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3HZPM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:12:57 -0400
Received: from mail-wg0-f65.google.com ([74.125.82.65]:35533 "EHLO
	mail-wg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab3HZPLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:54 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 20/24] Staging: winbond: wb35tx: changed sleep function from msleep to usleep
Date: Mon, 26 Aug 2013 17:10:19 +0200
Message-Id: <1377529823-5116-21-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the documentation it is not recommended to use msleep for 1ms - 20ms because it may sleep longer than 20ms. So, it is recommended to use usleep instead.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/wb35tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index 30a77cc..8c25cbd 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -166,9 +166,9 @@ void Wb35Tx_destroy(struct hw_data *pHwData)
 
 	/* Wait for VM stop */
 	do {
-		msleep(10); /* Delay for waiting function enter 940623.1.a */
+		usleep(10000); /* Delay for waiting function enter 940623.1.a */
 	} while ((pWb35Tx->EP2vm_state != VM_STOP) && (pWb35Tx->EP4vm_state != VM_STOP));
-	msleep(10); /* Delay for waiting function enter 940623.1.b */
+	usleep(10000); /* Delay for waiting function enter 940623.1.b */
 
 	usb_free_urb(pWb35Tx->Tx4Urb);
 	usb_free_urb(pWb35Tx->Tx2Urb);
-- 
1.8.1.2

