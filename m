Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbbADAo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 19:44:57 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43351 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbbADAow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 19:44:52 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Brett Rudley <brudley@broadcom.com>, Arend van Spriel <arend@broadcom.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Hante Meuleman <meuleman@broadcom.com>, Kalle Valo <kvalo@adurom.com>,
        Fabian Frederick <fabf@skynet.be>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] brcm80211: brcmsmac: dma: Remove some unused functions
Date: Sun,  4 Jan 2015 01:47:49 +0100
Message-Id: <1420332469-5907-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
dma_txflush() dma_txsuspended()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/wireless/brcm80211/brcmsmac/dma.c |   19 -------------------
 drivers/net/wireless/brcm80211/brcmsmac/dma.h |    2 --
 2 files changed, 21 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 796f5f9..bca233a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -1192,16 +1192,6 @@ void dma_txresume(struct dma_pub *pub)
 	bcma_mask32(di->core, DMA64TXREGOFFS(di, control), ~D64_XC_SE);
 }
 
-bool dma_txsuspended(struct dma_pub *pub)
-{
-	struct dma_info *di = container_of(pub, struct dma_info, dma);
-
-	return (di->ntxd == 0) ||
-	       ((bcma_read32(di->core,
-			     DMA64TXREGOFFS(di, control)) & D64_XC_SE) ==
-		D64_XC_SE);
-}
-
 void dma_txreclaim(struct dma_pub *pub, enum txd_range range)
 {
 	struct dma_info *di = container_of(pub, struct dma_info, dma);
@@ -1425,15 +1415,6 @@ int dma_txfast(struct brcms_c_info *wlc, struct dma_pub *pub,
 	return -ENOSPC;
 }
 
-void dma_txflush(struct dma_pub *pub)
-{
-	struct dma_info *di = container_of(pub, struct dma_info, dma);
-	struct brcms_ampdu_session *session = &di->ampdu_session;
-
-	if (!skb_queue_empty(&session->skb_list))
-		ampdu_finalize(di);
-}
-
 int dma_txpending(struct dma_pub *pub)
 {
 	struct dma_info *di = container_of(pub, struct dma_info, dma);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.h b/drivers/net/wireless/brcm80211/brcmsmac/dma.h
index ff5b80b..210ec72 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.h
@@ -88,11 +88,9 @@ bool dma_txreset(struct dma_pub *pub);
 void dma_txinit(struct dma_pub *pub);
 int dma_txfast(struct brcms_c_info *wlc, struct dma_pub *pub,
 	       struct sk_buff *p0);
-void dma_txflush(struct dma_pub *pub);
 int dma_txpending(struct dma_pub *pub);
 void dma_kick_tx(struct dma_pub *pub);
 void dma_txsuspend(struct dma_pub *pub);
-bool dma_txsuspended(struct dma_pub *pub);
 void dma_txresume(struct dma_pub *pub);
 void dma_txreclaim(struct dma_pub *pub, enum txd_range range);
 void dma_rxreclaim(struct dma_pub *pub);
-- 
1.7.10.4

