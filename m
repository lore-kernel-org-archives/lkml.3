Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934492AbaFST3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:29:32 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:64215 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934452AbaFST3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:29:24 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: gregkh@linuxfoundation.org
Cc: valentina.manea.m@gmail.com, lisa@xenapiadmin.com, ben@decadent.org.uk,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8192e: check return value of dev_skb_alloc
Date: Thu, 19 Jun 2014 15:29:16 -0400
Message-Id: <1403206156-3702-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
index 1a95d1f..d8a9427 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
@@ -36,7 +36,6 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 			     u32 buffer_len)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
-	bool		    rt_status = true;
 	u16		    frag_threshold;
 	u16		    frag_length, frag_offset = 0;
 	int		    i;
@@ -59,7 +58,8 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 			bLastIniPkt = 1;
 
 		}
-
+		if (!skb)
+			return false;
 		skb  = dev_alloc_skb(frag_length + 4);
 		memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
 		tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
@@ -99,7 +99,7 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 
 	write_nic_byte(dev, TPPoll, TPPoll_CQ);
 
-	return rt_status;
+	return true;
 }
 
 static bool CPUcheck_maincodeok_turnonCPU(struct net_device *dev)
-- 
1.9.1

