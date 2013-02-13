Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab3BMDBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 22:01:53 -0500
Received: from mout.gmx.net ([212.227.15.18]:49766 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759784Ab3BMDBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 22:01:20 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+Zefc4dRiZzWyC0VaEF8VO6iyB9O6DaDIzvl3wWJ
	6UwXRXQjk8jgdE
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Huewe <peterhuewe@gmx.de>, Andrew Miller <amiller@amilx.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] staging/rtl8187se: Mark functions as static to silence sparse
Date: Wed, 13 Feb 2013 04:05:26 +0100
Message-Id: <1360724726-2997-9-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360724302-2794-4-git-send-email-peterhuewe@gmx.de>
References: <1360724302-2794-4-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse complains that some functions can be declared as static:
123:6: warning: symbol 'PlatformIOWrite1Byte' was not declared. Should it be static?
129:6: warning: symbol 'PlatformIOWrite2Byte' was not declared. Should it be static?
135:6: warning: symbol 'PlatformIOWrite4Byte' was not declared. Should it be static?
178:6: warning: symbol 'SetOutputEnableOfRfPins' was not declared.  Should it be static?
354:6: warning: symbol 'ZEBRA_Config_85BASIC_HardCode' was not declared.  Should it be static?
655:6: warning: symbol 'InitTxPwrTracking87SE' was not declared. Should it be static?
665:6: warning: symbol 'PhyConfig8185' was not declared. Should it be static?
692:6: warning: symbol 'HwConfigureRTL8185' was not declared. Should it be static?
817:4: warning: symbol 'GetSupportedWirelessMode8185' was not declared.  Should it be static?
822:6: warning: symbol 'ActUpdateChannelAccessSetting' was not declared.  Should it be static?
857:6: warning: symbol 'ActSetWirelessMode8185' was not declared. Should it be static?
914:6: warning: symbol 'MgntDisconnectIBSS' was not declared. Should it be static?
940:6: warning: symbol 'MlmeDisassociateRequest' was not declared.  Should it be static?
957:6: warning: symbol 'MgntDisconnectAP' was not declared. Should it be static?
975:6: warning: symbol 'MgntDisconnect' was not declared. Should it be static?
1011:6: warning: symbol 'SetRFPowerState' was not declared. Should it be static?
1115:6: warning: symbol 'InactivePowerSave' was not declared. Should it be static?

-> Add the static keyword.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/rtl8187se/r8185b_init.c |   34 +++++++++++++++---------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 2ca857d..978dc5f 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -120,19 +120,19 @@ static u8 PlatformIORead1Byte(struct net_device *dev, u32 offset)
 	return read_nic_byte(dev, offset);
 }
 
-void PlatformIOWrite1Byte(struct net_device *dev, u32 offset, u8 data)
+static void PlatformIOWrite1Byte(struct net_device *dev, u32 offset, u8 data)
 {
 	write_nic_byte(dev, offset, data);
 	read_nic_byte(dev, offset); /* To make sure write operation is completed, 2005.11.09, by rcnjko. */
 }
 
-void PlatformIOWrite2Byte(struct net_device *dev, u32 offset, u16 data)
+static void PlatformIOWrite2Byte(struct net_device *dev, u32 offset, u16 data)
 {
 	write_nic_word(dev, offset, data);
 	read_nic_word(dev, offset); /* To make sure write operation is completed, 2005.11.09, by rcnjko. */
 }
 
-void PlatformIOWrite4Byte(struct net_device *dev, u32 offset, u32 data)
+static void PlatformIOWrite4Byte(struct net_device *dev, u32 offset, u32 data)
 {
 	if (offset == PhyAddr) {
 	/* For Base Band configuration. */
@@ -175,7 +175,7 @@ void PlatformIOWrite4Byte(struct net_device *dev, u32 offset, u32 data)
 	}
 }
 
-void SetOutputEnableOfRfPins(struct net_device *dev)
+static void SetOutputEnableOfRfPins(struct net_device *dev)
 {
 	write_nic_word(dev, RFPinsEnable, 0x1bff);
 }
@@ -327,7 +327,7 @@ bool SetAntennaConfig87SE(struct net_device *dev,
  *--------------------------------------------------------------
  */
 
-void ZEBRA_Config_85BASIC_HardCode(struct net_device *dev)
+static void ZEBRA_Config_85BASIC_HardCode(struct net_device *dev)
 {
 
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
@@ -628,7 +628,7 @@ void UpdateInitialGain(struct net_device *dev)
  *		Tx Power tracking mechanism routine on 87SE.
  *	Created by Roger, 2007.12.11.
  */
-void InitTxPwrTracking87SE(struct net_device *dev)
+static void InitTxPwrTracking87SE(struct net_device *dev)
 {
 	u32	u4bRfReg;
 
@@ -638,7 +638,7 @@ void InitTxPwrTracking87SE(struct net_device *dev)
 	RF_WriteReg(dev, 0x02, u4bRfReg|PWR_METER_EN);			mdelay(1);
 }
 
-void PhyConfig8185(struct net_device *dev)
+static void PhyConfig8185(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 		write_nic_dword(dev, RCR, priv->ReceiveConfig);
@@ -665,7 +665,7 @@ void PhyConfig8185(struct net_device *dev)
 	return;
 }
 
-void HwConfigureRTL8185(struct net_device *dev)
+static void HwConfigureRTL8185(struct net_device *dev)
 {
 	/* RTL8185_TODO: Determine Retrylimit, TxAGC, AutoRateFallback control. */
 	u8 bUNIVERSAL_CONTROL_RL = 0;
@@ -790,12 +790,12 @@ static void MacConfig_85BASIC(struct net_device *dev)
 	write_nic_byte(dev, 0x24E, 0x01);
 }
 
-u8 GetSupportedWirelessMode8185(struct net_device *dev)
+static u8 GetSupportedWirelessMode8185(struct net_device *dev)
 {
 	return WIRELESS_MODE_B | WIRELESS_MODE_G;
 }
 
-void ActUpdateChannelAccessSetting(struct net_device *dev,
+static void ActUpdateChannelAccessSetting(struct net_device *dev,
 				   WIRELESS_MODE WirelessMode,
 				   PCHANNEL_ACCESS_SETTING ChnlAccessSetting)
 {
@@ -830,7 +830,7 @@ void ActUpdateChannelAccessSetting(struct net_device *dev,
 	}
 }
 
-void ActSetWirelessMode8185(struct net_device *dev, u8 btWirelessMode)
+static void ActSetWirelessMode8185(struct net_device *dev, u8 btWirelessMode)
 {
 	struct  r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	struct  ieee80211_device *ieee = priv->ieee80211;
@@ -887,7 +887,7 @@ void rtl8185b_irq_enable(struct net_device *dev)
 	write_nic_dword(dev, IMR, priv->IntrMask);
 }
 
-void MgntDisconnectIBSS(struct net_device *dev)
+static void MgntDisconnectIBSS(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	u8 i;
@@ -913,7 +913,7 @@ void MgntDisconnectIBSS(struct net_device *dev)
 	notify_wx_assoc_event(priv->ieee80211);
 }
 
-void MlmeDisassociateRequest(struct net_device *dev, u8 *asSta, u8 asRsn)
+static void MlmeDisassociateRequest(struct net_device *dev, u8 *asSta, u8 asRsn)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	u8 i;
@@ -930,7 +930,7 @@ void MlmeDisassociateRequest(struct net_device *dev, u8 *asSta, u8 asRsn)
 	}
 }
 
-void MgntDisconnectAP(struct net_device *dev, u8 asRsn)
+static void MgntDisconnectAP(struct net_device *dev, u8 asRsn)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 
@@ -948,7 +948,7 @@ void MgntDisconnectAP(struct net_device *dev, u8 asRsn)
 	priv->ieee80211->state = IEEE80211_NOLINK;
 }
 
-bool MgntDisconnect(struct net_device *dev, u8 asRsn)
+static bool MgntDisconnect(struct net_device *dev, u8 asRsn)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	/*
@@ -984,7 +984,7 @@ bool MgntDisconnect(struct net_device *dev, u8 asRsn)
  *	Assumption:
  *		PASSIVE LEVEL.
  */
-bool SetRFPowerState(struct net_device *dev, RT_RF_POWER_STATE eRFPowerState)
+static bool SetRFPowerState(struct net_device *dev, RT_RF_POWER_STATE eRFPowerState)
 {
 	struct	r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	bool	bResult = false;
@@ -1088,7 +1088,7 @@ bool MgntActSet_RF_State(struct net_device *dev, RT_RF_POWER_STATE StateToSet, u
 	return bActionAllowed;
 }
 
-void InactivePowerSave(struct net_device *dev)
+static void InactivePowerSave(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	/*
-- 
1.7.8.6

