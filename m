Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbaFSCYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 22:24:47 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:35233 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041AbaFSCYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 22:24:46 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, valentina.manea.m@gmail.com, ben@decadent.org.uk,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8192e: check return value of dev_skb_alloc
Date: Wed, 18 Jun 2014 22:24:41 -0400
Message-Id: <1403144681-6902-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checks if dev_skb_alloc returns Null in function, fw_download_code.
If the return value of dev_skb_alloc is NULL return false and exit
this function.
Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
index 1a95d1f..38ae236 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
@@ -62,6 +62,8 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 
 		skb  = dev_alloc_skb(frag_length + 4);
 		memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
+		if (!skb)
+			return !rt_status;
 		tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 		tcb_desc->queue_index = TXCMD_QUEUE;
 		tcb_desc->bCmdOrInit = DESC_PACKET_TYPE_INIT;
-- 
1.9.1

