Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbaCDHN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:13:57 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:59028 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213AbaCDHNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:13:11 -0500
From: Axel Rasmussen <axel.rasmussen1@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 8/9] drivers: staging: rtl8187se: wrap excessively long lines
Date: Tue,  4 Mar 2014 00:12:56 -0700
Message-Id: <03452712fae5fc727024ca97bb6c4b63fcbdd8da.1393916553.git.axel.rasmussen1@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1393916553.git.axel.rasmussen1@gmail.com>
References: <cover.1393916553.git.axel.rasmussen1@gmail.com>
In-Reply-To: <cover.1393916553.git.axel.rasmussen1@gmail.com>
References: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com> <cover.1393916553.git.axel.rasmussen1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Rasmussen <axel.rasmussen1@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c | 125 ++++++++++++++++++++++-----------
 1 file changed, 83 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index efe1c6e..e89907c 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1996,7 +1996,8 @@ static void rtl8180_rq_tx_ack(struct net_device *dev)
 
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
-	write_nic_byte(dev, CONFIG4, read_nic_byte(dev, CONFIG4) | CONFIG4_PWRMGT);
+	write_nic_byte(dev, CONFIG4,
+		read_nic_byte(dev, CONFIG4) | CONFIG4_PWRMGT);
 	priv->ack_tx_to_ieee = 1;
 }
 
@@ -2044,7 +2045,8 @@ static void rtl8180_hw_wakeup(struct net_device *dev)
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
 	spin_lock_irqsave(&priv->ps_lock, flags);
-	write_nic_byte(dev, CONFIG4, read_nic_byte(dev, CONFIG4) & ~CONFIG4_PWRMGT);
+	write_nic_byte(dev, CONFIG4,
+		read_nic_byte(dev, CONFIG4) & ~CONFIG4_PWRMGT);
 	if (priv->rf_wakeup)
 		priv->rf_wakeup(dev);
 	spin_unlock_irqrestore(&priv->ps_lock, flags);
@@ -2091,7 +2093,8 @@ static void rtl8180_hw_sleep(struct net_device *dev, u32 th, u32 tl)
 
 		priv->DozePeriodInPast2Sec += jiffies_to_msecs(tmp);
 		/* as tl may be less than rb */
-		queue_delayed_work(priv->ieee80211->wq, &priv->ieee80211->hw_wakeup_wq, tmp);
+		queue_delayed_work(priv->ieee80211->wq,
+			&priv->ieee80211->hw_wakeup_wq, tmp);
 	}
 	/*
 	 * If we suspect the TimerInt is gone beyond tl
@@ -2221,7 +2224,8 @@ static void watch_dog_adaptive(unsigned long data)
 
 	/* Tx High Power Mechanism. */
 	if (CheckHighPower((struct net_device *)data))
-		queue_work(priv->ieee80211->wq, (void *)&priv->ieee80211->tx_pw_wq);
+		queue_work(priv->ieee80211->wq,
+			(void *)&priv->ieee80211->tx_pw_wq);
 
 	/* Tx Power Tracking on 87SE. */
 	if (CheckTxPwrTracking((struct net_device *)data))
@@ -2229,12 +2233,17 @@ static void watch_dog_adaptive(unsigned long data)
 
 	/* Perform DIG immediately. */
 	if (CheckDig((struct net_device *)data))
-		queue_work(priv->ieee80211->wq, (void *)&priv->ieee80211->hw_dig_wq);
+		queue_work(priv->ieee80211->wq,
+			(void *)&priv->ieee80211->hw_dig_wq);
+
 	rtl8180_watch_dog((struct net_device *)data);
 
-	queue_work(priv->ieee80211->wq, (void *)&priv->ieee80211->GPIOChangeRFWorkItem);
+	queue_work(priv->ieee80211->wq,
+		(void *)&priv->ieee80211->GPIOChangeRFWorkItem);
+
+	priv->watch_dog_timer.expires = jiffies +
+		MSECS(IEEE80211_WATCH_DOG_TIME);
 
-	priv->watch_dog_timer.expires = jiffies + MSECS(IEEE80211_WATCH_DOG_TIME);
 	add_timer(&priv->watch_dog_timer);
 }
 
@@ -2425,7 +2434,8 @@ static short rtl8180_init(struct net_device *dev)
 	rtl8180_link_detect_init(&priv->link_detect);
 
 	priv->ack_tx_to_ieee = 0;
-	priv->ieee80211->current_network.beacon_interval = DEFAULT_BEACONINTERVAL;
+	priv->ieee80211->current_network.beacon_interval =
+		DEFAULT_BEACONINTERVAL;
 	priv->ieee80211->iw_mode = IW_MODE_INFRA;
 	priv->ieee80211->softmac_features  = IEEE_SOFTMAC_SCAN |
 		IEEE_SOFTMAC_ASSOCIATE | IEEE_SOFTMAC_PROBERQ |
@@ -2471,7 +2481,8 @@ static short rtl8180_init(struct net_device *dev)
 	priv->AdRxSsBeforeSwitched = 0;
 	init_timer(&priv->SwAntennaDiversityTimer);
 	priv->SwAntennaDiversityTimer.data = (unsigned long)dev;
-	priv->SwAntennaDiversityTimer.function = (void *)SwAntennaDiversityTimerCallback;
+	priv->SwAntennaDiversityTimer.function =
+		(void *)SwAntennaDiversityTimerCallback;
 	priv->bDigMechanism = true;
 	priv->InitialGain = 6;
 	priv->bXtalCalibration = false;
@@ -2480,7 +2491,8 @@ static short rtl8180_init(struct net_device *dev)
 	priv->bTxPowerTrack = false;
 	priv->ThermalMeter = 0;
 	priv->FalseAlarmRegValue = 0;
-	priv->RegDigOfdmFaUpTh = 0xc; /* Upper threshold of OFDM false alarm, which is used in DIG. */
+	priv->RegDigOfdmFaUpTh = 0xc; /* Upper threshold of OFDM false alarm,
+					which is used in DIG. */
 	priv->DIG_NumberFallbackVote = 0;
 	priv->DIG_NumberUpgradeVote = 0;
 	priv->LastSignalStrengthInPercent = 0;
@@ -2625,7 +2637,8 @@ static short rtl8180_init(struct net_device *dev)
 		priv->bSwAntennaDiverity = priv->EEPROMSwAntennaDiversity;
 	else
 		/* 1:disable antenna diversity, 2: enable antenna diversity. */
-		priv->bSwAntennaDiverity = priv->RegSwAntennaDiversityMechanism == 2;
+		priv->bSwAntennaDiverity =
+			priv->RegSwAntennaDiversityMechanism == 2;
 
 	if (priv->RegDefaultAntenna == 0)
 		/* 0: default from EEPROM. */
@@ -2709,7 +2722,8 @@ static short rtl8180_init(struct net_device *dev)
 				  TX_BEACON_RING_ADDR))
 		return -ENOMEM;
 
-	if (request_irq(dev->irq, rtl8180_interrupt, IRQF_SHARED, dev->name, dev)) {
+	if (request_irq(dev->irq, rtl8180_interrupt,
+		IRQF_SHARED, dev->name, dev)) {
 		DMESGE("Error allocating IRQ %d", dev->irq);
 		return -1;
 	} else {
@@ -2808,16 +2822,19 @@ static void rtl8185_write_phy(struct net_device *dev, u8 adr, u32 data)
 
 	phyw = ((data<<8) | adr);
 
-	/* Note that, we must write 0xff7c after 0x7d-0x7f to write BB register. */
+	/* Note: we must write 0xff7c after 0x7d-0x7f to write BB register. */
 	write_nic_byte(dev, 0x7f, ((phyw & 0xff000000) >> 24));
 	write_nic_byte(dev, 0x7e, ((phyw & 0x00ff0000) >> 16));
 	write_nic_byte(dev, 0x7d, ((phyw & 0x0000ff00) >> 8));
 	write_nic_byte(dev, 0x7c, ((phyw & 0x000000ff)));
 
-	/* this is ok to fail when we write AGC table. check for AGC table might be
-	 * done by masking with 0x7f instead of 0xff
+	/* this is ok to fail when we write AGC table. check for AGC table
+	 * might be done by masking with 0x7f instead of 0xff
 	 */
-	/* if (phyr != (data&0xff)) DMESGW("Phy write timeout %x %x %x", phyr, data, adr); */
+	/*
+	if (phyr != (data&0xff))
+		DMESGW("Phy write timeout %x %x %x", phyr, data, adr);
+	*/
 }
 
 inline void write_phy_ofdm(struct net_device *dev, u8 adr, u32 data)
@@ -2886,25 +2903,26 @@ static bool MgntActSet_802_11_PowerSaveMode(struct r8180_priv *priv,
 
 static void LeisurePSEnter(struct r8180_priv *priv)
 {
-	if (priv->bLeisurePs) {
+	if (priv->bLeisurePs)
 		if (priv->ieee80211->ps == IEEE80211_PS_DISABLED)
 			/* IEEE80211_PS_ENABLE */
-			MgntActSet_802_11_PowerSaveMode(priv, IEEE80211_PS_MBCAST|IEEE80211_PS_UNICAST);
-	}
+			MgntActSet_802_11_PowerSaveMode(priv,
+				IEEE80211_PS_MBCAST | IEEE80211_PS_UNICAST);
 }
 
 static void LeisurePSLeave(struct r8180_priv *priv)
 {
-	if (priv->bLeisurePs) {
+	if (priv->bLeisurePs)
 		if (priv->ieee80211->ps != IEEE80211_PS_DISABLED)
-			MgntActSet_802_11_PowerSaveMode(priv, IEEE80211_PS_DISABLED);
-	}
+			MgntActSet_802_11_PowerSaveMode(
+				priv, IEEE80211_PS_DISABLED);
 }
 
 void rtl8180_hw_wakeup_wq(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
-	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, hw_wakeup_wq);
+	struct ieee80211_device *ieee = container_of(
+		dwork, struct ieee80211_device, hw_wakeup_wq);
 	struct net_device *dev = ieee->dev;
 
 	rtl8180_hw_wakeup(dev);
@@ -2913,7 +2931,8 @@ void rtl8180_hw_wakeup_wq(struct work_struct *work)
 void rtl8180_hw_sleep_wq(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
-	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, hw_sleep_wq);
+	struct ieee80211_device *ieee = container_of(
+		dwork, struct ieee80211_device, hw_sleep_wq);
 	struct net_device *dev = ieee->dev;
 
 	rtl8180_hw_sleep_down(dev);
@@ -2930,23 +2949,30 @@ static void MgntLinkKeepAlive(struct r8180_priv *priv)
 		 */
 
 		if ((priv->keepAliveLevel == 2) ||
-			(priv->link_detect.last_num_tx_unicast == priv->NumTxUnicast &&
-			priv->link_detect.last_num_rx_unicast == priv->ieee80211->NumRxUnicast)
+			(priv->link_detect.last_num_tx_unicast ==
+				priv->NumTxUnicast &&
+			priv->link_detect.last_num_rx_unicast ==
+				priv->ieee80211->NumRxUnicast)
 			) {
 			priv->link_detect.idle_count++;
 
 			/*
-			 * Send a Keep-Alive packet packet to AP if we had been idle for a while.
+			 * Send a Keep-Alive packet packet to AP if we had
+			 * been idle for a while.
 			 */
-			if (priv->link_detect.idle_count >= ((KEEP_ALIVE_INTERVAL / CHECK_FOR_HANG_PERIOD)-1)) {
+			if (priv->link_detect.idle_count >=
+				KEEP_ALIVE_INTERVAL /
+				CHECK_FOR_HANG_PERIOD - 1) {
 				priv->link_detect.idle_count = 0;
-				ieee80211_sta_ps_send_null_frame(priv->ieee80211, false);
+				ieee80211_sta_ps_send_null_frame(
+					priv->ieee80211, false);
 			}
 		} else {
 			priv->link_detect.idle_count = 0;
 		}
 		priv->link_detect.last_num_tx_unicast = priv->NumTxUnicast;
-		priv->link_detect.last_num_rx_unicast = priv->ieee80211->NumRxUnicast;
+		priv->link_detect.last_num_rx_unicast =
+			priv->ieee80211->NumRxUnicast;
 	}
 }
 
@@ -2966,15 +2992,22 @@ void rtl8180_watch_dog(struct net_device *dev)
 			IPSEnter(dev);
 	}
 	/* YJ,add,080828,for link state check */
-	if ((priv->ieee80211->state == IEEE80211_LINKED) && (priv->ieee80211->iw_mode == IW_MODE_INFRA)) {
-		SlotIndex = (priv->link_detect.slot_index++) % priv->link_detect.slot_num;
-		priv->link_detect.rx_frame_num[SlotIndex] = priv->ieee80211->NumRxDataInPeriod + priv->ieee80211->NumRxBcnInPeriod;
+	if ((priv->ieee80211->state == IEEE80211_LINKED) &&
+		(priv->ieee80211->iw_mode == IW_MODE_INFRA)) {
+		SlotIndex = (priv->link_detect.slot_index++) %
+			priv->link_detect.slot_num;
+
+		priv->link_detect.rx_frame_num[SlotIndex] =
+			priv->ieee80211->NumRxDataInPeriod +
+			priv->ieee80211->NumRxBcnInPeriod;
+
 		for (i = 0; i < priv->link_detect.slot_num; i++)
 			TotalRxNum += priv->link_detect.rx_frame_num[i];
 
 		if (TotalRxNum == 0) {
 			priv->ieee80211->state = IEEE80211_ASSOCIATING;
-			queue_work(priv->ieee80211->wq, &priv->ieee80211->associate_procedure_wq);
+			queue_work(priv->ieee80211->wq,
+				&priv->ieee80211->associate_procedure_wq);
 		}
 	}
 
@@ -2985,12 +3018,14 @@ void rtl8180_watch_dog(struct net_device *dev)
 	LeisurePSLeave(priv);
 
 	if (priv->ieee80211->state == IEEE80211_LINKED) {
-		priv->link_detect.num_rx_ok_in_period = priv->ieee80211->NumRxDataInPeriod;
+		priv->link_detect.num_rx_ok_in_period =
+			priv->ieee80211->NumRxDataInPeriod;
 		if (priv->link_detect.num_rx_ok_in_period > 666 ||
 			priv->link_detect.num_tx_ok_in_period > 666) {
 			bBusyTraffic = true;
 		}
-		if (((priv->link_detect.num_rx_ok_in_period + priv->link_detect.num_tx_ok_in_period) > 8)
+		if ((priv->link_detect.num_rx_ok_in_period +
+			priv->link_detect.num_tx_ok_in_period > 8)
 			|| (priv->link_detect.num_rx_ok_in_period > 2)) {
 			bEnterPS = false;
 		} else
@@ -3088,14 +3123,16 @@ int rtl8180_down(struct net_device *dev)
 	cancel_delayed_work(&priv->ieee80211->tx_pw_wq);
 	del_timer_sync(&priv->SwAntennaDiversityTimer);
 	SetZebraRFPowerState8185(dev, eRfOff);
-	memset(&(priv->ieee80211->current_network), 0, sizeof(struct ieee80211_network));
+	memset(&priv->ieee80211->current_network,
+		0, sizeof(struct ieee80211_network));
 	priv->ieee80211->state = IEEE80211_NOLINK;
 	return 0;
 }
 
 void rtl8180_restart_wq(struct work_struct *work)
 {
-	struct r8180_priv *priv = container_of(work, struct r8180_priv, reset_wq);
+	struct r8180_priv *priv = container_of(
+		work, struct r8180_priv, reset_wq);
 	struct net_device *dev = priv->dev;
 
 	down(&priv->wx_sem);
@@ -3156,7 +3193,8 @@ static int r8180_set_mac_adr(struct net_device *dev, void *mac)
 	memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
 
 	if (priv->ieee80211->iw_mode == IW_MODE_MASTER)
-		memcpy(priv->ieee80211->current_network.bssid, dev->dev_addr, ETH_ALEN);
+		memcpy(priv->ieee80211->current_network.bssid,
+			dev->dev_addr, ETH_ALEN);
 
 	if (priv->up) {
 		rtl8180_down(dev);
@@ -3177,7 +3215,8 @@ static int rtl8180_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 	switch (cmd) {
 	case RTL_IOCTL_WPA_SUPPLICANT:
-		ret = ieee80211_wpa_supplicant_ioctl(priv->ieee80211, &wrq->u.data);
+		ret = ieee80211_wpa_supplicant_ioctl(
+			priv->ieee80211, &wrq->u.data);
 		return ret;
 	default:
 		return -EOPNOTSUPP;
@@ -3728,7 +3767,8 @@ void rtl8180_irq_rx_tasklet(struct r8180_priv *priv)
 
 void GPIOChangeRFWorkItemCallBack(struct work_struct *work)
 {
-	struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, GPIOChangeRFWorkItem.work);
+	struct ieee80211_device *ieee = container_of(
+		work, struct ieee80211_device, GPIOChangeRFWorkItem.work);
 	struct net_device *dev = ieee->dev;
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	u8 btPSR;
@@ -3738,7 +3778,8 @@ void GPIOChangeRFWorkItemCallBack(struct work_struct *work)
 
 	char *argv[3];
 	static char *RadioPowerPath = "/etc/acpi/events/RadioPower.sh";
-	static char *envp[] = {"HOME=/", "TERM=linux", "PATH=/usr/bin:/bin", NULL};
+	static char *envp[] = {"HOME=/", "TERM=linux",
+		"PATH=/usr/bin:/bin", NULL};
 	static int readf_count;
 
 	readf_count = (readf_count+1)%0xffff;
-- 
1.8.3.2

