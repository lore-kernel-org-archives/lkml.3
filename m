Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3JaRsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 13:48:08 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:46902 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab3JaRsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 13:48:06 -0400
From: Salil Kapur <salilkapur93@gmail.com>
To: lauro.venancio@openbossa.org
Cc: aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        linux-wireless@vger.kernel.org, linux-nfc@ml01.01.org,
        linux-kernel@vger.kernel.org, Salil Kapur <salilkapur93@gmail.com>
Subject: [PATCH] NFC: mei_phy: using kfree_skb() instead of kfree()
Date: Thu, 31 Oct 2013 23:17:46 +0530
Message-Id: <1383241666-3806-1-git-send-email-salilkapur93@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

using kfree_skb() instead of kfree() for struct sk_buff

Signed-off-by: Salil Kapur <salilkapur93@gmail.com>
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

