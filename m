Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaCBFYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 00:24:09 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:63733 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaCBFXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 00:23:03 -0500
From: Axel Rasmussen <axel.rasmussen1@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 1/9] drivers: staging: rtl8187se: use netdev_* instead of prink
Date: Sat,  1 Mar 2014 22:22:45 -0700
Message-Id: <1393737773-13937-2-git-send-email-axel.rasmussen1@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com>
References: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Rasmussen <axel.rasmussen1@gmail.com>
---
 drivers/staging/rtl8187se/Module.symvers | 0
 drivers/staging/rtl8187se/r8180_core.c   | 8 ++++----
 2 files changed, 4 insertions(+), 4 deletions(-)
 create mode 100644 drivers/staging/rtl8187se/Module.symvers

diff --git a/drivers/staging/rtl8187se/Module.symvers b/drivers/staging/rtl8187se/Module.symvers
new file mode 100644
index 0000000..e69de29
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 7480a39..e5f8a56 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -649,7 +649,7 @@ void rtl8180_set_chan(struct net_device *dev, short ch)
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 
 	if ((ch > 14) || (ch < 1)) {
-		printk("In %s: Invalid chnanel %d\n", __func__, ch);
+		netdev_err(dev, "In %s: Invalid channel %d\n", __func__, ch);
 		return;
 	}
 
@@ -2019,13 +2019,13 @@ static void rtl8180_hw_sleep(struct net_device *dev, u32 th, u32 tl)
 	tl -= MSECS(4+16+7);
 
 	/*
-	 * If the interval in witch we are requested to sleep is too
+	 * If the interval in which we are requested to sleep is too
 	 * short then give up and remain awake
 	 */
 	if (((tl >= rb) && (tl-rb) <= MSECS(MIN_SLEEP_TIME))
 		|| ((rb > tl) && (rb-tl) < MSECS(MIN_SLEEP_TIME))) {
 		spin_unlock_irqrestore(&priv->ps_lock, flags);
-		printk("too short to sleep\n");
+		netdev_warn(dev, "too short to sleep\n");
 		return;
 	}
 
@@ -2316,7 +2316,7 @@ static short rtl8180_init(struct net_device *dev)
 	eeprom_93cx6_read(&eeprom, EEPROM_COUNTRY_CODE>>1, &eeprom_val);
 	priv->channel_plan = eeprom_val & 0xFF;
 	if (priv->channel_plan > COUNTRY_CODE_GLOBAL_DOMAIN) {
-		printk("rtl8180_init:Error channel plan! Set to default.\n");
+		netdev_err(dev, "rtl8180_init: Invalid channel plan! Set to default.\n");
 		priv->channel_plan = 0;
 	}
 
-- 
1.8.3.2

