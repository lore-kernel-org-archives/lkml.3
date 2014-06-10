Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaFJRE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:04:29 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56838 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaFJRE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:04:28 -0400
From: Raghavendra <raghav3276@gmail.com>
X-Google-Original-From: Raghavendra <arrao@cdac.in>
To: gregkh@linuxfoundation.org
Cc: archanakumari959@gmail.com, paulmck@linux.vnet.ibm.com,
        ashvinivaratharaj@gmail.com, josh@joshtriplett.org,
        gulsah.1004@gmail.com, arrao@cdac.in, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rtl8192e: dot11d: Fixed coding style issues
Date: Tue, 10 Jun 2014 22:33:51 +0530
Message-Id: <1402419831-24436-1-git-send-email-arrao@cdac.in>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced 'printk' with 'netdev_info' and 'netdev_err' wherever necessary.
Also fixed the coding issue cooresponding to line gap after the declarations.

Signed-off-by: Raghavendra <arrao@cdac.in>
---
 drivers/staging/rtl8192e/dot11d.c | 9 +++++----
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
1.8.1.2

