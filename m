Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750989AbaFKEBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 00:01:55 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59389 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaFKEBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 00:01:54 -0400
From: A Raghavendra Rao <raghav3276@gmail.com>
X-Google-Original-From: A Raghavendra Rao <arrao@cdac.in>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Raghavendra <arrao@cdac.in>
Subject: [PATCH] Staging: rtl8192e: dot11d: Fixed coding style issues
Date: Wed, 11 Jun 2014 09:25:47 +0530
Message-Id: <1402458947-10214-1-git-send-email-arrao@cdac.in>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra <arrao@cdac.in>

Fixed coding style issues

Signed-off-by: A Raghavendra Rao <arrao@cdac.in>
---
 drivers/staging/rtl8192e/dot11d.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8192e/dot11d.c b/drivers/staging/rtl8192e/dot11d.c
index 53da610..ef9da86 100644
--- a/drivers/staging/rtl8192e/dot11d.c
+++ b/drivers/staging/rtl8192e/dot11d.c
@@ -49,6 +49,7 @@ static struct channel_list ChannelPlan[] = {
 void dot11d_init(struct rtllib_device *ieee)
 {
 	struct rt_dot11d_info *pDot11dInfo = GET_DOT11D_INFO(ieee);
+
 	pDot11dInfo->bEnabled = false;
 
 	pDot11dInfo->State = DOT11D_STATE_NONE;
@@ -133,12 +134,12 @@ void Dot11d_UpdateCountryIe(struct rtllib_device *dev, u8 *pTaddr,
 	pTriple = (struct chnl_txpow_triple *)(pCoutryIe + 3);
 	for (i = 0; i < NumTriples; i++) {
 		if (MaxChnlNum >= pTriple->FirstChnl) {
-			printk(KERN_INFO "Dot11d_UpdateCountryIe(): Invalid country IE, skip it........1\n");
+			netdev_info(dev->dev, "Dot11d_UpdateCountryIe(): Invalid country IE, skip it........1\n");
 			return;
 		}
 		if (MAX_CHANNEL_NUMBER < (pTriple->FirstChnl +
 		    pTriple->NumChnls)) {
-			printk(KERN_INFO "Dot11d_UpdateCountryIe(): Invalid country IE, skip it........2\n");
+			netdev_info(dev->dev, "Dot11d_UpdateCountryIe(): Invalid country IE, skip it........2\n");
 			return;
 		}
 
@@ -165,7 +166,7 @@ u8 DOT11D_GetMaxTxPwrInDbm(struct rtllib_device *dev, u8 Channel)
 	u8 MaxTxPwrInDbm = 255;
 
 	if (MAX_CHANNEL_NUMBER < Channel) {
-		printk(KERN_INFO "DOT11D_GetMaxTxPwrInDbm(): Invalid Channel\n");
+		netdev_info(dev->dev, "DOT11D_GetMaxTxPwrInDbm(): Invalid Channel\n");
 		return MaxTxPwrInDbm;
 	}
 	if (pDot11dInfo->channel_map[Channel])
@@ -204,7 +205,7 @@ int ToLegalChannel(struct rtllib_device *dev, u8 channel)
 	}
 
 	if (MAX_CHANNEL_NUMBER < channel) {
-		printk(KERN_ERR "%s(): Invalid Channel\n", __func__);
+		netdev_err(dev->dev, "%s(): Invalid Channel\n", __func__);
 		return default_chn;
 	}
 
-- 
1.7.9.5

