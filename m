Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaHQTnc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 15:43:32 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:65150 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaHQTnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 15:43:14 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/5] staging: vt6655: remove remaining comments of PLICE_DEBUG
Date: Sun, 17 Aug 2014 20:42:29 +0100
Message-Id: <1408304549-22363-5-git-send-email-tvboxspy@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408304549-22363-1-git-send-email-tvboxspy@gmail.com>
References: <1408304549-22363-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h | 4 ----
 drivers/staging/vt6655/dpc.c    | 7 +++----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index fadebe9..1abad5d 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -141,9 +141,7 @@
 
 #define	AVAIL_TD(p, q)	((p)->sOpts.nTxDescs[(q)] - ((p)->iTDUsed[(q)]))
 
-//PLICE_DEBUG ->
 #define	NUM				64
-//PLICE_DEUBG <-
 
 #define PRIVATE_Message                 0
 
@@ -404,11 +402,9 @@ struct vnt_private {
 
 	spinlock_t                  lock;
 
-//PLICE_DEBUG ->
 	pid_t			MLMEThr_pid;
 	struct completion	notify;
 	struct semaphore	mlme_semaphore;
-//PLICE_DEBUG <-
 
 	u32                         rx_bytes;
 
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 7589cb4..60eb129 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -312,10 +312,9 @@ device_receive_frame(
 
 	skb = pRDInfo->skb;
 
-//PLICE_DEBUG->
 	pci_unmap_single(pDevice->pcid, pRDInfo->skb_dma,
 			 pDevice->rx_buf_sz, PCI_DMA_FROMDEVICE);
-//PLICE_DEBUG<-
+
 	pwFrameSize = (unsigned short *)(skb->data + 2);
 	FrameSize = cpu_to_le16(pCurrRD->m_rd1RD1.wReqCount) - cpu_to_le16(pCurrRD->m_rd0RD0.wResCount);
 
@@ -344,7 +343,7 @@ device_receive_frame(
 		pr_debug("---------- WRONG Length 2\n");
 		return false;
 	}
-//PLICE_DEBUG->
+
 	// update receive statistic counter
 	STAvUpdateRDStatCounter(&pDevice->scStatistic,
 				*pbyRsr,
@@ -354,7 +353,7 @@ device_receive_frame(
 				FrameSize);
 
 	pMACHeader = (PS802_11Header)((unsigned char *)(skb->data) + 8);
-//PLICE_DEBUG<-
+
 	if (pDevice->bMeasureInProgress) {
 		if ((*pbyRsr & RSR_CRCOK) != 0)
 			pDevice->byBasicMap |= 0x01;
-- 
1.9.1

