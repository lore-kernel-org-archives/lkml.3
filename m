Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbaAITpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 14:45:55 -0500
Received: from mail-pa0-f65.google.com ([209.85.220.65]:40426 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733AbaAITpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 14:45:42 -0500
From: Anmol Sarma <me@anmolsarma.in>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, Anmol Sarma <me@anmolsarma.in>
Subject: [PATCH v2 1/3] Staging: rtl8187se: r8180_core.c: mark symbols as static
Date: Fri, 10 Jan 2014 01:14:42 +0530
Message-Id: <368b9f52ce460dce7eceaa9e63d8afc1b1f4bac6.1389295289.git.me@anmolsarma.in>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1389295289.git.me@anmolsarma.in>
References: <20140109151518.GS30234@mwanda>
 <cover.1389295289.git.me@anmolsarma.in>
In-Reply-To: <cover.1389295289.git.me@anmolsarma.in>
References: <cover.1389295289.git.me@anmolsarma.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warnings for undeclared symbols not marked static like:
390:6: warning: symbol 'buffer_free' was not declared. Should it be static?
1031:5: warning: symbol 'ComputeTxTime' was not declared. Should it be static?

Signed-off-by: Anmol Sarma <me@anmolsarma.in>
---
 drivers/staging/rtl8187se/r8180_core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 297136b..45a60c0 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -387,7 +387,7 @@ static short buffer_add(struct buffer **buffer, u32 *buf, dma_addr_t dma,
 	return 0;
 }
 
-void buffer_free(struct net_device *dev, struct buffer **buffer, int len,
+static void buffer_free(struct net_device *dev, struct buffer **buffer, int len,
 		 short consistent)
 {
 
@@ -1028,7 +1028,7 @@ inline u8 rtl8180_IsWirelessBMode(u16 rate)
 
 u16 N_DBPSOfRate(u16 DataRate);
 
-u16 ComputeTxTime(u16 FrameLength, u16 DataRate, u8 bManagementFrame,
+static u16 ComputeTxTime(u16 FrameLength, u16 DataRate, u8 bManagementFrame,
 		  u8 bShortPreamble)
 {
 	u16	FrameTime;
@@ -2342,7 +2342,7 @@ static void rtl8187se_eeprom_register_write(struct eeprom_93cx6 *eeprom)
 	udelay(10);
 }
 
-short rtl8180_init(struct net_device *dev)
+static short rtl8180_init(struct net_device *dev)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	u16 word;
@@ -2832,7 +2832,7 @@ static struct net_device_stats *rtl8180_stats(struct net_device *dev)
 /*
  * Change current and default preamble mode.
  */
-bool MgntActSet_802_11_PowerSaveMode(struct r8180_priv *priv,
+static bool MgntActSet_802_11_PowerSaveMode(struct r8180_priv *priv,
 				     RT_PS_MODE rtPsMode)
 {
 	/* Currently, we do not change power save mode on IBSS mode. */
@@ -2844,7 +2844,7 @@ bool MgntActSet_802_11_PowerSaveMode(struct r8180_priv *priv,
 	return true;
 }
 
-void LeisurePSEnter(struct r8180_priv *priv)
+static void LeisurePSEnter(struct r8180_priv *priv)
 {
 	if (priv->bLeisurePs) {
 		if (priv->ieee80211->ps == IEEE80211_PS_DISABLED)
@@ -2853,7 +2853,7 @@ void LeisurePSEnter(struct r8180_priv *priv)
 	}
 }
 
-void LeisurePSLeave(struct r8180_priv *priv)
+static void LeisurePSLeave(struct r8180_priv *priv)
 {
 	if (priv->bLeisurePs) {
 		if (priv->ieee80211->ps != IEEE80211_PS_DISABLED)
@@ -3526,7 +3526,7 @@ static void rtl8180_tx_isr(struct net_device *dev, int pri, short error)
 	spin_unlock_irqrestore(&priv->tx_lock, flag);
 }
 
-irqreturn_t rtl8180_interrupt(int irq, void *netdev)
+static irqreturn_t rtl8180_interrupt(int irq, void *netdev)
 {
 	struct net_device *dev = (struct net_device *) netdev;
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
-- 
1.8.3.2

