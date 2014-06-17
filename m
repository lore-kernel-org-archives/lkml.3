Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965413AbaFQVSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:18:23 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:38551 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965386AbaFQVSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:18:21 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: gregkh@linuxfoundation.org
Cc: valentina.manea.m@gmail.com, ben@decadent.org.uk, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2] Fixes function fw_download_code to check for Null return from dev_skb_alloc
Date: Tue, 17 Jun 2014 17:18:01 -0400
Message-Id: <1403039881-16050-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
index 11e915e..e4c8224 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
@@ -62,12 +62,14 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 
 		skb  = dev_alloc_skb(frag_length + 4);
 		if (!skb){
+			rt_status = false;
+			return rt_status;
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

