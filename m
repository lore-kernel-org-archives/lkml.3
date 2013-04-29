Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3D2Bbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 21:31:45 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:36112 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab3D2Bbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 21:31:43 -0400
From: Matt Kilgore <mattkilgore12@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rtl8187se: fixed coding style issues
Date: Sun, 28 Apr 2013 21:31:33 -0400
Message-Id: <1367199093-32341-1-git-send-email-mattkilgore12@gmail.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Kilgore <MattKilgore12@gmail.com>

Fixed coding style issues with comments, braces, and spacing.

Signed-off-by: Matt Kilgore <mattkilgore12@gmail.com>
---
 drivers/staging/rtl8187se/r8180.h | 657 +++++++++++++++++++-------------------
 1 file changed, 325 insertions(+), 332 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180.h b/drivers/staging/rtl8187se/r8180.h
index 70ea414..d82903c 100644
--- a/drivers/staging/rtl8187se/r8180.h
+++ b/drivers/staging/rtl8187se/r8180.h
@@ -1,19 +1,19 @@
 /*
-   This is part of rtl8180 OpenSource driver.
-   Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
-   Released under the terms of GPL (General Public Licence)
-
-   Parts of this driver are based on the GPL part of the
-   official realtek driver
-
-   Parts of this driver are based on the rtl8180 driver skeleton
-   from Patric Schenke & Andres Salomon
-
-   Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver
-
-   We want to thanks the Authors of those projects and the Ndiswrapper
-   project Authors.
-*/
+ * This is part of rtl8180 OpenSource driver.
+ * Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
+ * Released under the terms of GPL (General Public Licence)
+ *
+ * Parts of this driver are based on the GPL part of the
+ * official realtek driver
+ *
+ * Parts of this driver are based on the rtl8180 driver skeleton
+ * from Patric Schenke & Andres Salomon
+ *
+ * Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver
+ *
+ * We want to thanks the Authors of those projects and the Ndiswrapper
+ * project Authors.
+ */
 
 #ifndef R8180H
 #define R8180H
@@ -21,13 +21,13 @@
 #include <linux/interrupt.h>
 
 #define RTL8180_MODULE_NAME "r8180"
-#define DMESG(x,a...) printk(KERN_INFO RTL8180_MODULE_NAME ": " x "\n", ## a)
-#define DMESGW(x,a...) printk(KERN_WARNING RTL8180_MODULE_NAME ": WW:" x "\n", ## a)
-#define DMESGE(x,a...) printk(KERN_WARNING RTL8180_MODULE_NAME ": EE:" x "\n", ## a)
+#define DMESG(x, a...) printk(KERN_INFO RTL8180_MODULE_NAME ": " x "\n", ## a)
+#define DMESGW(x, a...) printk(KERN_WARNING RTL8180_MODULE_NAME ": WW:" x "\n", ## a)
+#define DMESGE(x, a...) printk(KERN_WARNING RTL8180_MODULE_NAME ": EE:" x "\n", ## a)
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-//#include <linux/config.h>
+/*#include <linux/config.h>*/
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/sched.h>
@@ -37,19 +37,19 @@
 #include <linux/pci.h>
 #include <linux/etherdevice.h>
 #include <linux/delay.h>
-#include <linux/rtnetlink.h>	//for rtnl_lock()
+#include <linux/rtnetlink.h>	/*for rtnl_lock()*/
 #include <linux/wireless.h>
 #include <linux/timer.h>
-#include <linux/proc_fs.h>	// Necessary because we use the proc fs
+#include <linux/proc_fs.h>	/* Necessary because we use the proc fs*/
 #include <linux/if_arp.h>
 #include "ieee80211/ieee80211.h"
 #include <asm/io.h>
-//#include <asm/semaphore.h>
+/*#include <asm/semaphore.h>*/
 
 #define EPROM_93c46 0
 #define EPROM_93c56 1
 
-#define RTL_IOCTL_WPA_SUPPLICANT		SIOCIWFIRSTPRIV+30
+#define RTL_IOCTL_WPA_SUPPLICANT	(SIOCIWFIRSTPRIV+30)
 
 #define DEFAULT_FRAG_THRESHOLD 2342U
 #define MIN_FRAG_THRESHOLD     256U
@@ -61,13 +61,13 @@
 #define DEFAULT_RETRY_RTS 7
 #define DEFAULT_RETRY_DATA 7
 
-#define BEACON_QUEUE					6
+#define BEACON_QUEUE	6
 
-#define aSifsTime 	10
+#define aSifsTime	10
 
 #define sCrcLng         4
-#define sAckCtsLng	112		// bits in ACK and CTS frames
-//+by amy 080312
+#define sAckCtsLng	112	/* bits in ACK and CTS frames*/
+/*+by amy 080312*/
 #define RATE_ADAPTIVE_TIMER_PERIOD	300
 
 typedef enum _WIRELESS_MODE {
@@ -78,71 +78,68 @@ typedef enum _WIRELESS_MODE {
 	WIRELESS_MODE_AUTO = 0x08,
 } WIRELESS_MODE;
 
-typedef struct 	ChnlAccessSetting {
+typedef struct ChnlAccessSetting {
 	u16 SIFS_Timer;
 	u16 DIFS_Timer;
 	u16 SlotTimeTimer;
 	u16 EIFS_Timer;
 	u16 CWminIndex;
 	u16 CWmaxIndex;
-}*PCHANNEL_ACCESS_SETTING,CHANNEL_ACCESS_SETTING;
+} *PCHANNEL_ACCESS_SETTING, CHANNEL_ACCESS_SETTING;
 
-typedef enum{
-        NIC_8185 = 1,
-        NIC_8185B
-        } nic_t;
+typedef enum {
+	NIC_8185 = 1,
+	NIC_8185B
+} nic_t;
 
 typedef u32 AC_CODING;
-#define AC0_BE	0		// ACI: 0x00	// Best Effort
-#define AC1_BK	1		// ACI: 0x01	// Background
-#define AC2_VI	2		// ACI: 0x10	// Video
-#define AC3_VO	3		// ACI: 0x11	// Voice
-#define AC_MAX	4		// Max: define total number; Should not to be used as a real enum.
-
-//
-// ECWmin/ECWmax field.
-// Ref: WMM spec 2.2.2: WME Parameter Element, p.13.
-//
-typedef	union _ECW{
-	u8	charData;
-	struct
-	{
-		u8	ECWmin:4;
-		u8	ECWmax:4;
-	}f;	// Field
-}ECW, *PECW;
-
-//
-// ACI/AIFSN Field.
-// Ref: WMM spec 2.2.2: WME Parameter Element, p.12.
-//
-typedef	union _ACI_AIFSN{
-	u8	charData;
-
-	struct
-	{
-		u8	AIFSN:4;
-		u8	ACM:1;
-		u8	ACI:2;
-		u8	Reserved:1;
-	}f;	// Field
-}ACI_AIFSN, *PACI_AIFSN;
-
-//
-// AC Parameters Record Format.
-// Ref: WMM spec 2.2.2: WME Parameter Element, p.12.
-//
-typedef	union _AC_PARAM{
-	u32	longData;
-	u8	charData[4];
-
-	struct
-	{
+#define AC0_BE	0	/* ACI: 0x00	// Best Effort */
+#define AC1_BK	1	/* ACI: 0x01	// Background */
+#define AC2_VI	2	/* ACI: 0x10	// Video */
+#define AC3_VO	3	/* ACI: 0x11	// Voice */
+#define AC_MAX	4	/* Max: define total number; Should not to be used as a real enum. */
+
+/*
+ * ECWmin/ECWmax field.
+ * Ref: WMM spec 2.2.2: WME Parameter Element, p.13.
+ */
+typedef	union _ECW {
+	u8 charData;
+	struct {
+		u8 ECWmin:4;
+		u8 ECWmax:4;
+	} f; /* Field */
+} ECW, *PECW;
+
+/*
+ * ACI/AIFSN Field.
+ * Ref: WMM spec 2.2.2: WME Parameter Element, p.12.
+ */
+typedef	union _ACI_AIFSN {
+	u8 charData;
+
+	struct {
+		u8 AIFSN:4;
+		u8 ACM:1;
+		u8 ACI:2;
+		u8 Reserved:1;
+	} f; /* Field */
+} ACI_AIFSN, *PACI_AIFSN;
+
+/*
+ * AC Parameters Record Format.
+ * Ref: WMM spec 2.2.2: WME Parameter Element, p.12.
+ */
+typedef	union _AC_PARAM {
+	u32 longData;
+	u8 charData[4];
+
+	struct {
 		ACI_AIFSN	AciAifsn;
 		ECW		Ecw;
 		u16		TXOPLimit;
-	}f;	// Field
-}AC_PARAM, *PAC_PARAM;
+	} f; /* Field */
+} AC_PARAM, *PAC_PARAM;
 
 /* it is a wrong definition. -xiong-2006-11-17
 typedef struct ThreeWireReg {
@@ -156,37 +153,35 @@ typedef struct ThreeWireReg {
 } ThreeWireReg;
 */
 
-typedef	union _ThreeWire{
-	struct _ThreeWireStruc{
-		u16		data:1;
-		u16		clk:1;
-		u16		enableB:1;
-		u16		read_write:1;
-		u16		resv1:12;
-//		u2Byte	resv2:14;
-//		u2Byte	ThreeWireEnable:1;
-//		u2Byte	resv3:1;
-	}struc;
-	u16			longData;
-}ThreeWireReg;
-
-
-typedef struct buffer
-{
+typedef	union _ThreeWire {
+	struct _ThreeWireStruc {
+		u16	data:1;
+		u16	clk:1;
+		u16	enableB:1;
+		u16	read_write:1;
+		u16	resv1:12;
+/*		u2Byte	resv2:14; */
+/*		u2Byte	ThreeWireEnable:1; */
+/*		u2Byte	resv3:1; */
+	} struc;
+	u16	longData;
+} ThreeWireReg;
+
+
+typedef struct buffer {
 	struct buffer *next;
 	u32 *buf;
 	dma_addr_t dma;
 } buffer;
 
-//YJ,modified,080828
-typedef struct Stats
-{
+/* YJ,modified,080828 */
+typedef struct Stats {
 	unsigned long txrdu;
 	unsigned long rxrdu;
 	unsigned long rxnolast;
 	unsigned long rxnodata;
-//	unsigned long rxreset;
-//	unsigned long rxwrkaround;
+/*	unsigned long rxwrkaround; */
+/*	unsigned long rxwrkaround; */
 	unsigned long rxnopointer;
 	unsigned long txnperr;
 	unsigned long txresumed;
@@ -208,52 +203,52 @@ typedef struct Stats
 	unsigned long txbeaconerr;
 	unsigned long txlpokint;
 	unsigned long txlperr;
-	unsigned long txretry;//retry number  tony 20060601
-	unsigned long rxcrcerrmin;//crc error (0-500)
-	unsigned long rxcrcerrmid;//crc error (500-1000)
-	unsigned long rxcrcerrmax;//crc error (>1000)
-	unsigned long rxicverr;//ICV error
+	unsigned long txretry;/*retry number  tony 20060601 */
+	unsigned long rxcrcerrmin;/*crc error (0-500) */
+	unsigned long rxcrcerrmid;/*crc error (500-1000) */
+	unsigned long rxcrcerrmax;/*crc error (>1000) */
+	unsigned long rxicverr;/*ICV error */
 } Stats;
 
 #define MAX_LD_SLOT_NUM 10
-#define KEEP_ALIVE_INTERVAL 				20 // in seconds.
-#define CHECK_FOR_HANG_PERIOD			2 //be equal to watchdog check time
-#define DEFAULT_KEEP_ALIVE_LEVEL			1
-#define DEFAULT_SLOT_NUM					2
-#define POWER_PROFILE_AC					0
-#define POWER_PROFILE_BATTERY			1
-
-typedef struct _link_detect_t
-{
-	u32				RxFrameNum[MAX_LD_SLOT_NUM];	// number of Rx Frame / CheckForHang_period  to determine link status
-	u16				SlotNum;	// number of CheckForHang period to determine link status, default is 2
-	u16				SlotIndex;
-
-	u32				NumTxOkInPeriod;  //number of packet transmitted during CheckForHang
-	u32				NumRxOkInPeriod;  //number of packet received during CheckForHang
-
-	u8				IdleCount;     // (KEEP_ALIVE_INTERVAL / CHECK_FOR_HANG_PERIOD)
-	u32				LastNumTxUnicast;
-	u32				LastNumRxUnicast;
-
-	bool				bBusyTraffic;    //when it is set to 1, UI cann't scan at will.
-}link_detect_t, *plink_detect_t;
-
-//YJ,modified,080828,end
-
-//by amy for led
-//================================================================================
-// LED customization.
-//================================================================================
-
-typedef	enum _LED_STRATEGY_8185{
-	SW_LED_MODE0, //
-	SW_LED_MODE1, //
-	HW_LED, // HW control 2 LEDs, LED0 and LED1 (there are 4 different control modes)
-}LED_STRATEGY_8185, *PLED_STRATEGY_8185;
-//by amy for led
-//by amy for power save
-typedef	enum _LED_CTL_MODE{
+#define KEEP_ALIVE_INTERVAL		20 /* in seconds.*/
+#define CHECK_FOR_HANG_PERIOD		2 /*be equal to watchdog check time */
+#define DEFAULT_KEEP_ALIVE_LEVEL	1
+#define DEFAULT_SLOT_NUM		2
+#define POWER_PROFILE_AC		0
+#define POWER_PROFILE_BATTERY		1
+
+typedef struct _link_detect_t {
+	u32	RxFrameNum[MAX_LD_SLOT_NUM];	/* number of Rx Frame / CheckForHang_period  to determine link status */
+	u16	SlotNum;	/* number of CheckForHang period to determine link status, default is 2 */
+	u16	SlotIndex;
+
+	u32	NumTxOkInPeriod;  /*number of packet transmitted during CheckForHang */
+	u32	NumRxOkInPeriod;  /*number of packet received during CheckForHang */
+
+	u8	IdleCount;     /* (KEEP_ALIVE_INTERVAL / CHECK_FOR_HANG_PERIOD) */
+	u32	LastNumTxUnicast;
+	u32	LastNumRxUnicast;
+
+	bool	bBusyTraffic;    /*when it is set to 1, UI cann't scan at will. */
+} link_detect_t, *plink_detect_t;
+
+/*YJ,modified,080828,end */
+
+/*by amy for led
+ *==============================================================================
+ * LED customization.
+ *==============================================================================
+ */
+typedef	enum _LED_STRATEGY_8185 {
+	SW_LED_MODE0,
+	SW_LED_MODE1,
+	HW_LED, /* HW control 2 LEDs, LED0 and LED1 (there are 4 different control modes) */
+} LED_STRATEGY_8185, *PLED_STRATEGY_8185;
+/*by amy for led
+ *by amy for power save
+ */
+typedef	enum _LED_CTL_MODE {
 	LED_CTL_POWER_ON = 1,
 	LED_CTL_LINK = 2,
 	LED_CTL_NO_LINK = 3,
@@ -261,73 +256,70 @@ typedef	enum _LED_CTL_MODE{
 	LED_CTL_RX = 5,
 	LED_CTL_SITE_SURVEY = 6,
 	LED_CTL_POWER_OFF = 7
-}LED_CTL_MODE;
+} LED_CTL_MODE;
 
-typedef	enum _RT_RF_POWER_STATE
-{
+typedef	enum _RT_RF_POWER_STATE {
 	eRfOn,
 	eRfSleep,
 	eRfOff
-}RT_RF_POWER_STATE;
+} RT_RF_POWER_STATE;
 
-enum	_ReasonCode{
+enum _ReasonCode {
 	unspec_reason	= 0x1,
 	auth_not_valid	= 0x2,
 	deauth_lv_ss	= 0x3,
-	inactivity		= 0x4,
-	ap_overload		= 0x5,
-	class2_err		= 0x6,
-	class3_err		= 0x7,
-	disas_lv_ss		= 0x8,
+	inactivity	= 0x4,
+	ap_overload	= 0x5,
+	class2_err	= 0x6,
+	class3_err	= 0x7,
+	disas_lv_ss	= 0x8,
 	asoc_not_auth	= 0x9,
 
-	//----MIC_CHECK
-	mic_failure		= 0xe,
-	//----END MIC_CHECK
+	/*----MIC_CHECK */
+	mic_failure	= 0xe,
+	/*----END MIC_CHECK */
 
-	// Reason code defined in 802.11i D10.0 p.28.
-	invalid_IE		= 0x0d,
+	/* Reason code defined in 802.11i D10.0 p.28. */
+	invalid_IE	= 0x0d,
 	four_way_tmout	= 0x0f,
 	two_way_tmout	= 0x10,
-	IE_dismatch		= 0x11,
+	IE_dismatch	= 0x11,
 	invalid_Gcipher	= 0x12,
 	invalid_Pcipher	= 0x13,
 	invalid_AKMP	= 0x14,
-	unsup_RSNIEver = 0x15,
+	unsup_RSNIEver	= 0x15,
 	invalid_RSNIE	= 0x16,
-	auth_802_1x_fail= 0x17,
-	ciper_reject		= 0x18,
-
-	// Reason code defined in 7.3.1.7, 802.1e D13.0, p.42. Added by Annie, 2005-11-15.
-	QoS_unspec		= 0x20,	// 32
-	QAP_bandwidth	= 0x21,	// 33
-	poor_condition	= 0x22,	// 34
-	no_facility		= 0x23,	// 35
-							// Where is 36???
-	req_declined	= 0x25,	// 37
-	invalid_param	= 0x26,	// 38
-	req_not_honored= 0x27,	// 39
-	TS_not_created	= 0x2F,	// 47
-	DL_not_allowed	= 0x30,	// 48
-	dest_not_exist	= 0x31,	// 49
-	dest_not_QSTA	= 0x32,	// 50
+	auth_802_1x_fail = 0x17,
+	ciper_reject	= 0x18,
+
+	/* Reason code defined in 7.3.1.7, 802.1e D13.0, p.42. Added by Annie, 2005-11-15. */
+	QoS_unspec	= 0x20,	/* 32 */
+	QAP_bandwidth	= 0x21,	/* 33 */
+	poor_condition	= 0x22,	/* 34 */
+	no_facility	= 0x23,	/* 35 */
+					/* Where is 36??? */
+	req_declined	= 0x25,	/* 37 */
+	invalid_param	= 0x26,	/* 38 */
+	req_not_honored = 0x27,	/* 39 */
+	TS_not_created	= 0x2F,	/* 47 */
+	DL_not_allowed	= 0x30,	/* 48 */
+	dest_not_exist	= 0x31,	/* 49 */
+	dest_not_QSTA	= 0x32,	/* 50 */
 };
-typedef	enum _RT_PS_MODE
-{
-	eActive,	// Active/Continuous access.
-	eMaxPs,		// Max power save mode.
-	eFastPs		// Fast power save mode.
-}RT_PS_MODE;
-//by amy for power save
-typedef struct r8180_priv
-{
+typedef	enum _RT_PS_MODE {
+	eActive,	/* Active/Continuous access. */
+	eMaxPs,		/* Max power save mode. */
+	eFastPs		/* Fast power save mode. */
+} RT_PS_MODE;
+/*by amy for power save */
+typedef struct r8180_priv {
 	struct pci_dev *pdev;
 
 	short epromtype;
 	int irq;
 	struct ieee80211_device *ieee80211;
 
-	short plcp_preamble_mode; // 0:auto 1:short 2:long
+	short plcp_preamble_mode; /* 0:auto 1:short 2:long */
 
 	spinlock_t irq_th_lock;
 	spinlock_t tx_lock;
@@ -340,19 +332,19 @@ typedef struct r8180_priv
 	short chan;
 	short sens;
 	short max_sens;
-	u8 chtxpwr[15]; //channels from 1 to 14, 0 not used
-	u8 chtxpwr_ofdm[15]; //channels from 1 to 14, 0 not used
-	//u8 challow[15]; //channels from 1 to 14, 0 not used
-	u8 channel_plan;  // it's the channel plan index
+	u8 chtxpwr[15]; /*channels from 1 to 14, 0 not used */
+	u8 chtxpwr_ofdm[15]; /*channels from 1 to 14, 0 not used */
+	/*u8 challow[15]; //channels from 1 to 14, 0 not used */
+	u8 channel_plan;  /* it's the channel plan index */
 	short up;
-	short crcmon; //if 1 allow bad crc frame reception in monitor mode
+	short crcmon; /*if 1 allow bad crc frame reception in monitor mode */
 
 	struct timer_list scan_timer;
 	/*short scanpending;
 	short stopscan;*/
 	spinlock_t scan_lock;
 	u8 active_probe;
-	//u8 active_scan_num;
+	/*u8 active_scan_num; */
 	struct semaphore wx_sem;
 	short hw_wep;
 
@@ -360,17 +352,17 @@ typedef struct r8180_priv
 	short antb;
 	short diversity;
 	u32 key0[4];
-	short (*rf_set_sens)(struct net_device *dev,short sens);
-	void (*rf_set_chan)(struct net_device *dev,short ch);
+	short (*rf_set_sens)(struct net_device *dev, short sens);
+	void (*rf_set_chan)(struct net_device *dev, short ch);
 	void (*rf_close)(struct net_device *dev);
 	void (*rf_init)(struct net_device *dev);
 	void (*rf_sleep)(struct net_device *dev);
 	void (*rf_wakeup)(struct net_device *dev);
-	//short rate;
+	/*short rate; */
 	short promisc;
 	/*stats*/
 	struct Stats stats;
-	struct _link_detect_t link_detect;  //YJ,add,080828
+	struct _link_detect_t link_detect;  /* YJ,add,080828 */
 	struct iw_statistics wstats;
 	struct proc_dir_entry *dir_dev;
 
@@ -449,11 +441,11 @@ typedef struct r8180_priv
 
 	int txringcount;
 	int txbuffsize;
-	//struct tx_pendingbuf txnp_pending;
-	//struct tasklet_struct irq_tx_tasklet;
+	/*struct tx_pendingbuf txnp_pending; */
+	/*struct tasklet_struct irq_tx_tasklet; */
 	struct tasklet_struct irq_rx_tasklet;
 	u8 dma_poll_mask;
-	//short tx_suspend;
+	/*short tx_suspend; */
 
 	/* adhoc/master mode stuff */
 	u32 *txbeaconringtail;
@@ -462,158 +454,159 @@ typedef struct r8180_priv
 	int txbeaconcount;
 	struct buffer *txbeaconbufs;
 	struct buffer *txbeaconbufstail;
-	//char *master_essid;
-	//u16 master_beaconinterval;
-	//u32 master_beaconsize;
-	//u16 beacon_interval;
+	/*char *master_essid; */
+	/*u16 master_beaconinterval; */
+	/*u32 master_beaconsize; */
+	/*u16 beacon_interval; */
 
 	u8 retry_data;
 	u8 retry_rts;
 	u16 rts;
 
-//by amy for led
+	/*by amy for led */
 	LED_STRATEGY_8185 LedStrategy;
-//by amy for led
+	/*by amy for led */
 
-//by amy for power save
+	/*by amy for power save */
 	struct timer_list watch_dog_timer;
 	bool bInactivePs;
 	bool bSwRfProcessing;
 	RT_RF_POWER_STATE	eInactivePowerState;
 	RT_RF_POWER_STATE eRFPowerState;
-	u32 RfOffReason;
+	u32  RfOffReason;
 	bool RFChangeInProgress;
 	bool SetRFPowerStateInProgress;
 	u8   RFProgType;
 	bool bLeisurePs;
 	RT_PS_MODE dot11PowerSaveMode;
-	//u32 NumRxOkInPeriod;   //YJ,del,080828
-	//u32 NumTxOkInPeriod;   //YJ,del,080828
-	u8   TxPollingTimes;
+	/*u32 NumRxOkInPeriod;   //YJ,del,080828 */
+	/*u32 NumTxOkInPeriod;   //YJ,del,080828 */
+	u8	TxPollingTimes;
 
-	bool	bApBufOurFrame;// TRUE if AP buffer our unicast data , we will keep eAwake until receive data or timeout.
+	bool	bApBufOurFrame; /* TRUE if AP buffer our unicast data , we will keep eAwake until receive data or timeout. */
 	u8	WaitBufDataBcnCount;
 	u8	WaitBufDataTimeOut;
 
-//by amy for power save
-//by amy for antenna
-	u8 EEPROMSwAntennaDiversity;
+	/*by amy for power save */
+	/*by amy for antenna */
+	u8   EEPROMSwAntennaDiversity;
 	bool EEPROMDefaultAntenna1;
-	u8 RegSwAntennaDiversityMechanism;
+	u8   RegSwAntennaDiversityMechanism;
 	bool bSwAntennaDiverity;
-	u8 RegDefaultAntenna;
+	u8   RegDefaultAntenna;
 	bool bDefaultAntenna1;
-	u8 SignalStrength;
+	u8   SignalStrength;
 	long Stats_SignalStrength;
-	long LastSignalStrengthInPercent; // In percentage, used for smoothing, e.g. Moving Average.
-	u8	 SignalQuality; // in 0-100 index.
+	long LastSignalStrengthInPercent; /* In percentage, used for smoothing, e.g. Moving Average. */
+	u8	SignalQuality; /* in 0-100 index. */
 	long Stats_SignalQuality;
-	long RecvSignalPower; // in dBm.
+	long RecvSignalPower; /* in dBm. */
 	long Stats_RecvSignalPower;
-	u8	 LastRxPktAntenna;	// +by amy 080312 Antenna which received the lasted packet. 0: Aux, 1:Main. Added by Roger, 2008.01.25.
+	u8	LastRxPktAntenna;	/* +by amy 080312 Antenna which received the lasted packet. 0: Aux, 1:Main. Added by Roger, 2008.01.25. */
 	u32 AdRxOkCnt;
 	long AdRxSignalStrength;
-	u8 CurrAntennaIndex;			// Index to current Antenna (both Tx and Rx).
-	u8 AdTickCount;				// Times of SwAntennaDiversityTimer happened.
-	u8 AdCheckPeriod;				// # of period SwAntennaDiversityTimer to check Rx signal strength for SW Antenna Diversity.
-	u8 AdMinCheckPeriod;			// Min value of AdCheckPeriod.
-	u8 AdMaxCheckPeriod;			// Max value of AdCheckPeriod.
-	long AdRxSsThreshold;			// Signal strength threshold to switch antenna.
-	long AdMaxRxSsThreshold;			// Max value of AdRxSsThreshold.
-	bool bAdSwitchedChecking;		// TRUE if we shall shall check Rx signal strength for last time switching antenna.
-	long AdRxSsBeforeSwitched;		// Rx signal strength before we switched antenna.
+	u8 CurrAntennaIndex;			/* Index to current Antenna (both Tx and Rx). */
+	u8 AdTickCount;				/* Times of SwAntennaDiversityTimer happened. */
+	u8 AdCheckPeriod;			/* # of period SwAntennaDiversityTimer to check Rx signal strength for SW Antenna Diversity. */
+	u8 AdMinCheckPeriod;			/* Min value of AdCheckPeriod. */
+	u8 AdMaxCheckPeriod;			/* Max value of AdCheckPeriod. */
+	long AdRxSsThreshold;			/* Signal strength threshold to switch antenna. */
+	long AdMaxRxSsThreshold;		/* Max value of AdRxSsThreshold. */
+	bool bAdSwitchedChecking;		/* TRUE if we shall shall check Rx signal strength for last time switching antenna.*/
+	long AdRxSsBeforeSwitched;		/* Rx signal strength before we switched antenna. */
 	struct timer_list SwAntennaDiversityTimer;
-//by amy for antenna
-//{by amy 080312
-//
-	// Crystal calibration.
-	// Added by Roger, 2007.12.11.
-	//
-	bool		bXtalCalibration; // Crystal calibration.
-	u8			XtalCal_Xin; // Crystal calibration for Xin. 0~7.5pF
-	u8			XtalCal_Xout; // Crystal calibration for Xout. 0~7.5pF
-	//
-	// Tx power tracking with thermal meter indication.
-	// Added by Roger, 2007.12.11.
-	//
-	bool		bTxPowerTrack; // Tx Power tracking.
-	u8			ThermalMeter; // Thermal meter reference indication.
-	//
-	// Dynamic Initial Gain Adjustment Mechanism. Added by Bruce, 2007-02-14.
-	//
-	bool				bDigMechanism; // TRUE if DIG is enabled, FALSE ow.
-	bool				bRegHighPowerMechanism; // For High Power Mechanism. 061010, by rcnjko.
-	u32					FalseAlarmRegValue;
-	u8					RegDigOfdmFaUpTh; // Upper threshold of OFDM false alarm, which is used in DIG.
-	u8					DIG_NumberFallbackVote;
-	u8					DIG_NumberUpgradeVote;
-	// For HW antenna diversity, added by Roger, 2008.01.30.
-	u32			AdMainAntennaRxOkCnt;		// Main antenna Rx OK count.
-	u32			AdAuxAntennaRxOkCnt;		// Aux antenna Rx OK count.
-	bool		bHWAdSwitched;				// TRUE if we has switched default antenna by HW evaluation.
-	// RF High Power upper/lower threshold.
-	u8					RegHiPwrUpperTh;
-	u8					RegHiPwrLowerTh;
-	// RF RSSI High Power upper/lower Threshold.
-	u8					RegRSSIHiPwrUpperTh;
-	u8					RegRSSIHiPwrLowerTh;
-	// Current CCK RSSI value to determine CCK high power, asked by SD3 DZ, by Bruce, 2007-04-12.
-	u8			CurCCKRSSI;
-	bool        bCurCCKPkt;
-	//
-	// High Power Mechanism. Added by amy, 080312.
-	//
-	bool					bToUpdateTxPwr;
-	long					UndecoratedSmoothedSS;
-	long					UndercorateSmoothedRxPower;
-	u8						RSSI;
-	char					RxPower;
-	 u8 InitialGain;
-	 //For adjust Dig Threshold during Legacy/Leisure Power Save Mode
-	u32				DozePeriodInPast2Sec;
-	 // Don't access BB/RF under disable PLL situation.
-	u8					InitialGainBackUp;
-	 u8 RegBModeGainStage;
-//by amy for rate adaptive
-    struct timer_list rateadapter_timer;
-	u32    RateAdaptivePeriod;
-	bool   bEnhanceTxPwr;
-	bool   bUpdateARFR;
-	int	   ForcedDataRate; // Force Data Rate. 0: Auto, 0x02: 1M ~ 0x6C: 54M.)
-	u32     NumTxUnicast; //YJ,add,080828,for keep alive
-	u8      keepAliveLevel; //YJ,add,080828,for KeepAlive
-	unsigned long 	NumTxOkTotal;
-	u16                                 LastRetryCnt;
-        u16                                     LastRetryRate;
-        unsigned long       LastTxokCnt;
-        unsigned long           LastRxokCnt;
-        u16                                     CurrRetryCnt;
-        unsigned long           LastTxOKBytes;
-	unsigned long 		    NumTxOkBytesTotal;
-        u8                          LastFailTxRate;
-        long                        LastFailTxRateSS;
-        u8                          FailTxRateCount;
-        u32                         LastTxThroughput;
-        //for up rate
-        unsigned short          bTryuping;
-        u8                                      CurrTxRate;     //the rate before up
-        u16                                     CurrRetryRate;
-        u16                                     TryupingCount;
-        u8                                      TryDownCountLowData;
-        u8                                      TryupingCountNoData;
-
-        u8                  CurrentOperaRate;
-//by amy for rate adaptive
-//by amy 080312}
-//	short wq_hurryup;
-//	struct workqueue_struct *workqueue;
+	/*by amy for antenna
+	 *{by amy 080312
+	 *
+	 * Crystal calibration.
+	 * Added by Roger, 2007.12.11.
+	 */
+	bool	bXtalCalibration; /* Crystal calibration. */
+	u8	XtalCal_Xin; /* Crystal calibration for Xin. 0~7.5pF */
+	u8	XtalCal_Xout; /* Crystal calibration for Xout. 0~7.5pF */
+	/*
+	 * Tx power tracking with thermal meter indication.
+	 * Added by Roger, 2007.12.11.
+	 */
+	bool	bTxPowerTrack; /* Tx Power tracking. */
+	u8	ThermalMeter; /* Thermal meter reference indication. */
+	/*
+	 * Dynamic Initial Gain Adjustment Mechanism. Added by Bruce, 2007-02-14.
+	 */
+	bool	bDigMechanism; /* TRUE if DIG is enabled, FALSE ow. */
+	bool	bRegHighPowerMechanism; /* For High Power Mechanism. 061010, by rcnjko. */
+	u32	FalseAlarmRegValue;
+	u8	RegDigOfdmFaUpTh; /* Upper threshold of OFDM false alarm, which is used in DIG. */
+	u8	DIG_NumberFallbackVote;
+	u8	DIG_NumberUpgradeVote;
+	/* For HW antenna diversity, added by Roger, 2008.01.30. */
+	u32	AdMainAntennaRxOkCnt;		/* Main antenna Rx OK count. */
+	u32	AdAuxAntennaRxOkCnt;		/* Aux antenna Rx OK count. */
+	bool	bHWAdSwitched;			/* TRUE if we has switched default antenna by HW evaluation. */
+	/* RF High Power upper/lower threshold. */
+	u8	RegHiPwrUpperTh;
+	u8	RegHiPwrLowerTh;
+	/* RF RSSI High Power upper/lower Threshold. */
+	u8	RegRSSIHiPwrUpperTh;
+	u8	RegRSSIHiPwrLowerTh;
+	/* Current CCK RSSI value to determine CCK high power, asked by SD3 DZ, by Bruce, 2007-04-12. */
+	u8	CurCCKRSSI;
+	bool	bCurCCKPkt;
+	/*
+	 * High Power Mechanism. Added by amy, 080312.
+	 */
+	bool			bToUpdateTxPwr;
+	long			UndecoratedSmoothedSS;
+	long			UndercorateSmoothedRxPower;
+	u8			RSSI;
+	char			RxPower;
+	u8 InitialGain;
+	/* For adjust Dig Threshold during Legacy/Leisure Power Save Mode */
+	u32		DozePeriodInPast2Sec;
+	/* Don't access BB/RF under disable PLL situation. */
+	u8			InitialGainBackUp;
+	u8 RegBModeGainStage;
+	/*by amy for rate adaptive */
+	struct timer_list rateadapter_timer;
+	u32	RateAdaptivePeriod;
+	bool	bEnhanceTxPwr;
+	bool	bUpdateARFR;
+	int	ForcedDataRate; /* Force Data Rate. 0: Auto, 0x02: 1M ~ 0x6C: 54M.) */
+	u32	NumTxUnicast; /* YJ,add,080828,for keep alive */
+	u8	keepAliveLevel; /* YJ,add,080828,for KeepAlive */
+	unsigned long	NumTxOkTotal;
+	u16 LastRetryCnt;
+	u16 LastRetryRate;
+	unsigned long		LastTxokCnt;
+	unsigned long		LastRxokCnt;
+	u16			CurrRetryCnt;
+	unsigned long		LastTxOKBytes;
+	unsigned long		NumTxOkBytesTotal;
+	u8			LastFailTxRate;
+	long			LastFailTxRateSS;
+	u8			FailTxRateCount;
+	u32			LastTxThroughput;
+	/*for up rate */
+	unsigned short		bTryuping;
+	u8			CurrTxRate;	/*the rate before up */
+	u16			CurrRetryRate;
+	u16			TryupingCount;
+	u8			TryDownCountLowData;
+	u8			TryupingCountNoData;
+
+	u8			CurrentOperaRate;
+	/*by amy for rate adaptive
+	 *by amy 080312}
+	 *	short wq_hurryup;
+	 *	struct workqueue_struct *workqueue;
+	 */
 	struct work_struct reset_wq;
 	struct work_struct watch_dog_wq;
 	short ack_tx_to_ieee;
 
 	u8 dma_poll_stop_mask;
 
-	//u8 RegThreeWireMode;
+	/*u8 RegThreeWireMode; */
 	u16 ShortRetryLimit;
 	u16 LongRetryLimit;
 	u16 EarlyRxThreshold;
@@ -621,8 +614,8 @@ typedef struct r8180_priv
 	u32 ReceiveConfig;
 	u32 IntrMask;
 
-	struct 	ChnlAccessSetting  ChannelAccessSetting;
-}r8180_priv;
+	struct ChnlAccessSetting ChannelAccessSetting;
+} r8180_priv;
 
 #define MANAGE_PRIORITY 0
 #define BK_PRIORITY 1
@@ -634,26 +627,26 @@ typedef struct r8180_priv
 
 #define LOW_PRIORITY VI_PRIORITY
 #define NORM_PRIORITY VO_PRIORITY
-//AC2Queue mapping
+/*AC2Queue mapping */
 #define AC2Q(_ac) (((_ac) == WME_AC_VO) ? VO_PRIORITY : \
 		((_ac) == WME_AC_VI) ? VI_PRIORITY : \
 		((_ac) == WME_AC_BK) ? BK_PRIORITY : \
 		BE_PRIORITY)
 
-short rtl8180_tx(struct net_device *dev,u8* skbuf, int len,int priority,
-	short morefrag,short fragdesc,int rate);
+short rtl8180_tx(struct net_device *dev, u8 *skbuf, int len, int priority,
+	short morefrag, short fragdesc, int rate);
 
 u8 read_nic_byte(struct net_device *dev, int x);
 u32 read_nic_dword(struct net_device *dev, int x);
 u16 read_nic_word(struct net_device *dev, int x) ;
-void write_nic_byte(struct net_device *dev, int x,u8 y);
-void write_nic_word(struct net_device *dev, int x,u16 y);
-void write_nic_dword(struct net_device *dev, int x,u32 y);
+void write_nic_byte(struct net_device *dev, int x, u8 y);
+void write_nic_word(struct net_device *dev, int x, u16 y);
+void write_nic_dword(struct net_device *dev, int x, u32 y);
 void force_pci_posting(struct net_device *dev);
 
 void rtl8180_rtx_disable(struct net_device *);
-void rtl8180_set_anaparam(struct net_device *dev,u32 a);
-void rtl8185_set_anaparam2(struct net_device *dev,u32 a);
+void rtl8180_set_anaparam(struct net_device *dev, u32 a);
+void rtl8185_set_anaparam2(struct net_device *dev, u32 a);
 void rtl8180_set_hw_wep(struct net_device *dev);
 void rtl8180_no_hw_wep(struct net_device *dev);
 void rtl8180_update_msr(struct net_device *dev);
@@ -662,7 +655,7 @@ void rtl8180_beacon_rx_disable(struct net_device *dev);
 int rtl8180_down(struct net_device *dev);
 int rtl8180_up(struct net_device *dev);
 void rtl8180_commit(struct net_device *dev);
-void rtl8180_set_chan(struct net_device *dev,short ch);
+void rtl8180_set_chan(struct net_device *dev, short ch);
 void write_phy(struct net_device *dev, u8 adr, u8 data);
 void write_phy_cck(struct net_device *dev, u8 adr, u32 data);
 void write_phy_ofdm(struct net_device *dev, u8 adr, u32 data);
@@ -672,9 +665,9 @@ void IPSEnter(struct net_device *dev);
 void IPSLeave(struct net_device *dev);
 int get_curr_tx_free_desc(struct net_device *dev, int priority);
 void UpdateInitialGain(struct net_device *dev);
-bool SetAntennaConfig87SE(struct net_device *dev, u8  DefaultAnt, bool bAntDiversity);
+bool SetAntennaConfig87SE(struct net_device *dev, u8 DefaultAnt, bool bAntDiversity);
 
-//#ifdef CONFIG_RTL8185B
+/*#ifdef CONFIG_RTL8185B */
 void rtl8185b_adapter_start(struct net_device *dev);
 void rtl8185b_rx_enable(struct net_device *dev);
 void rtl8185b_tx_enable(struct net_device *dev);
@@ -683,8 +676,8 @@ void rtl8185b_irq_enable(struct net_device *dev);
 void fix_rx_fifo(struct net_device *dev);
 void fix_tx_fifo(struct net_device *dev);
 void rtl8225z2_SetTXPowerLevel(struct net_device *dev, short ch);
-void rtl8180_rate_adapter(struct work_struct * work);
-//#endif
+void rtl8180_rate_adapter(struct work_struct *work);
+/*#endif */
 bool MgntActSet_RF_State(struct net_device *dev, RT_RF_POWER_STATE StateToSet, u32 ChangeSource);
 
 #endif
-- 
1.8.2.2

