Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbaFRRxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:53:08 -0400
Received: from mail-ie0-f194.google.com ([209.85.223.194]:42219 "EHLO
	mail-ie0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaFRRxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:53:06 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, valentina.manea.m@gmail.com, ben@decadent.org.uk,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Checks for Null return of skb_alloc in function fw_download_code
Date: Wed, 18 Jun 2014 13:53:00 -0400
Message-Id: <1403113980-7587-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
index 11e915e..fde17ff 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
@@ -62,12 +62,15 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 
 		skb  = dev_alloc_skb(frag_length + 4);
+		if (!skb) {
+				rt_status = false;
+				return rt_status;
+
+		}
 		memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
 		tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 		tcb_desc->queue_index = TXCMD_QUEUE;
 		tcb_desc->bCmdOrInit = DESC_PACKET_TYPE_INIT;
 		tcb_desc->bLastIniPkt = bLastIniPkt;
-		}
 
 		seg_ptr = skb->data;
 		for (i = 0; i < frag_length; i += 4) {
-- 
1.9.1

