Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab3JSWUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 18:20:00 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:63861 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab3JSWT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 18:19:58 -0400
From: Salil Kapur <salilkapur93@gmail.com>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, linux-wireless@vger.kernel.org,
        linux-nfc@ml01.01.org, linux-kernel@vger.kernel.org
Cc: Salil Kapur <salilkapur93@gmail.com>
Subject: [PATCH] using kfree_skb() instead of kfree() to free sk_buff
Date: Sun, 20 Oct 2013 03:49:40 +0530
Message-Id: <1382221180-14223-1-git-send-email-salilkapur93@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Signed-off-by: Salil Kapur <salilkapur93@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/nfc/mei_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/mei_phy.c b/drivers/nfc/mei_phy.c
index 606bf55..bc30081 100644
--- a/drivers/nfc/mei_phy.c
+++ b/drivers/nfc/mei_phy.c
@@ -127,7 +127,7 @@ void nfc_mei_event_cb(struct mei_cl_device *device, u32 events, void *context)
 
 		reply_size = mei_cl_recv(device, skb->data, MEI_NFC_MAX_READ);
 		if (reply_size < MEI_NFC_HEADER_SIZE) {
-			kfree(skb);
+			kfree_skb(skb);
 			return;
 		}
 
-- 
1.8.1.2

