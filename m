Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaFRXIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:08:37 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:62844 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaFRXIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:08:36 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ben@decadent.org.uk, lisa@xenapiadmin.com, valentina.manea.m@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Fixes no Null check of dev_skb_alloc in fw_download_code
Date: Wed, 18 Jun 2014 19:08:31 -0400
Message-Id: <1403132911-6597-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
index 1a95d1f..1a90546 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
@@ -61,6 +61,10 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 		}
 
 		skb  = dev_alloc_skb(frag_length + 4);
+		if (!skb)
+			!return rt_status;
 		memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
 		tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 		tcb_desc->queue_index = TXCMD_QUEUE;
--
