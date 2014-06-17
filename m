Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaFQDXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 23:23:19 -0400
Received: from mail-ie0-f196.google.com ([209.85.223.196]:37043 "EHLO
	mail-ie0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbaFQDXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 23:23:18 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: gregkh@linuxfoundation.org
Cc: valentina.manea.m@gmail.com, lisa@xenapiadmin.com, ben@decadent.org.uk,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Check if skb_alloc returns Null in function fw_download_code
Date: Mon, 16 Jun 2014 23:23:13 -0400
Message-Id: <1402975393-26830-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
index 1a95d1f..11e915e 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
@@ -61,11 +61,13 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 		}
 
 		skb  = dev_alloc_skb(frag_length + 4);
+		if (!skb) {
 		memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
 		tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 		tcb_desc->queue_index = TXCMD_QUEUE;
 		tcb_desc->bCmdOrInit = DESC_PACKET_TYPE_INIT;
 		tcb_desc->bLastIniPkt = bLastIniPkt;
+		}
 
 		seg_ptr = skb->data;
 		for (i = 0; i < frag_length; i += 4) {
-- 
1.9.1

