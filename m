Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab3IPNp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:45:57 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:57927 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab3IPNod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:44:33 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 20/24] Staging: winbond: wb35tx: changed sleep function from msleep to usleep
Date: Mon, 16 Sep 2013 15:43:40 +0200
Message-Id: <1379339024-12157-21-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
References: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the documentation it is not recommended to use msleep for 1ms - 20ms because it may sleep longer than 20ms. So, it is recommended to use usleep instead.

In the first revision Greg KH pointed out that this change broke the build. In my computer it builds properly so if someone has the same problem please copy the output so that I can figure out what is the problem.

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

