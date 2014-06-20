Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965856AbaFTQuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:50:17 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:46328 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935084AbaFTQuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:50:00 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ben@decadent.org.uk, lisa@xenapiadmin.com, valentina.manea.m@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8192 Check for Null return from dev_skb_alloc
Date: Fri, 20 Jun 2014 12:49:55 -0400
Message-Id: <1403282995-6688-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checks for Null return from dev_skb_alloc if it returns Null,
fw_download returns false. Otherwise it returns true.Also
removed rt_status due to returning true of false directly.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
index 1a95d1f..affa89a 100644
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
@@ -59,7 +58,9 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 			bLastIniPkt = 1;
 
 		}
       skb  = dev_alloc_skb(frag_length + 4);
+		if (!skb)
+			return false;
 		memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
 		tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
@@ -99,7 +100,7 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 
 	write_nic_byte(dev, TPPoll, TPPoll_CQ);
 
-	return rt_status;
+	return true;
 }
 
 static bool CPUcheck_maincodeok_turnonCPU(struct net_device *dev)
-- 
1.9.1

