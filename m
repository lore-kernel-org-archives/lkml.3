Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab3FFTwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:52:32 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:63824 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab3FFTwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:52:30 -0400
From: Aldo Iljazi <neonsync1@gmail.com>
To: marek.belisko@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Aldo Iljazi <neonsync1@gmail.com>
Subject: [PATCH] Staging: ft1000-pcmcia: ft1000_dnld.c: fixed four checkpatch
Date: Thu,  6 Jun 2013 22:52:12 +0300
Message-Id: <1370548332-18519-1-git-send-email-neonsync1@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed four checkpatch error complains, specifically:
ft1000_dnld.c:512: ERROR: space prohibited after that '&' (ctx:WxW)
ft1000_dnld.c:514: ERROR: space prohibited after that '&' (ctx:WxW)
ft1000_dnld.c:694: ERROR: space prohibited before that close parenthesis ')'
ft1000_dnld.c:713: ERROR: space prohibited before that close parenthesis ')'

Signed-off-by: Aldo Iljazi <neonsync1@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
index f892598..6311b2f 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -509,9 +509,9 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 						(long)(info->DSPInfoBlklen + 1) / 2;
 					put_request_value(dev, word_length);
 					pMailBoxData =
-						(struct drv_msg *) & info->DSPInfoBlk[0];
+						(struct drv_msg *) &info->DSPInfoBlk[0];
 					pUsData =
-						(u16 *) & pMailBoxData->data[0];
+						(u16 *) &pMailBoxData->data[0];
 					/* Provide mutual exclusive access while reading ASIC registers. */
 					spin_lock_irqsave(&info->dpram_lock,
 							  flags);
@@ -691,7 +691,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 
 			if (pHdr->portdest == 0x80	/* DspOAM */
 				&& (pHdr->portsrc == 0x00	/* Driver */
-				|| pHdr->portsrc == 0x10 /* FMM */ )) {
+				|| pHdr->portsrc == 0x10 /* FMM */)) {
 				uiState = STATE_SECTION_PROV;
 			} else {
 				DEBUG(1,
@@ -710,7 +710,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 			pHdr = (struct pseudo_hdr *) pUcFile;
 
 			if (pHdr->checksum == hdr_checksum(pHdr)) {
-				if (pHdr->portdest != 0x80 /* Dsp OAM */ ) {
+				if (pHdr->portdest != 0x80 /* Dsp OAM */) {
 					uiState = STATE_DONE_PROV;
 					break;
 				}
-- 
1.7.10.4

