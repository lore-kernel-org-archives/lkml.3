Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab3ITPLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 11:11:42 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:38482 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3ITPLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 11:11:41 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: gregkh@linuxfoundation.org
Cc: burzalodowa@gmail.com, ikerpedrosam@gmail.com, dan.carpenter@oracle.com,
        snsehahn@cip.cs.fau.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rtl8192u: r819xU_cmdpkt: checking NULL value after doing dev_alloc_skb
Date: Fri, 20 Sep 2013 17:11:27 +0200
Message-Id: <1379689887-3243-1-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking the return of dev_alloc_skb as stated in the following bug: https://bugzilla.kernel.org/show_bug.cgi?id=60411

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
Reported-by: RUC_Soft_Sec rucsoftsec@gmail.com
---
 drivers/staging/rtl8192u/r819xU_cmdpkt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtl8192u/r819xU_cmdpkt.c b/drivers/staging/rtl8192u/r819xU_cmdpkt.c
index 5bc361b..5614401 100644
--- a/drivers/staging/rtl8192u/r819xU_cmdpkt.c
+++ b/drivers/staging/rtl8192u/r819xU_cmdpkt.c
@@ -37,6 +37,8 @@ rt_status SendTxCommandPacket(struct net_device *dev, void *pData, u32 DataLen)
 	/* Get TCB and local buffer from common pool.
 	   (It is shared by CmdQ, MgntQ, and USB coalesce DataQ) */
 	skb  = dev_alloc_skb(USB_HWDESC_HEADER_LEN + DataLen + 4);
+	if (!skb)
+		return RT_STATUS_FAILURE;
 	memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
 	tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 	tcb_desc->queue_index = TXCMD_QUEUE;
-- 
1.8.1.2

