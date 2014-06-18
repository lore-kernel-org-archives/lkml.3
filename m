Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaFRWXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:23:09 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:38101 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaFRWXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:23:07 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: gregkh@linuxfoundation.org
Cc: valentina.manea.m@gmail.com, ben@decadent.org.uk, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2]staging:rtl8192e:check return value of dev_skb_alloc 
Date: Wed, 18 Jun 2014 18:23:00 -0400
Message-Id: <1403130180-5634-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
index 11e915e..fde17ff 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
@@ -62,12 +62,15 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 
 		skb  = dev_alloc_skb(frag_length + 4);
+		if (!skb) 
+			return !rt_status;
 		memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
 		tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 		tcb_desc->queue_index = TXCMD_QUEUE;
 		tcb_desc->bCmdOrInit = DESC_PACKET_TYPE_INIT;
 		tcb_desc->bLastIniPkt = bLastIniPkt;
-		
 
 		seg_ptr = skb->data;
 		for (i = 0; i < frag_length; i += 4) {
-- 
1.9.1

