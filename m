Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaETKeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:34:06 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38191 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaETKeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:34:03 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] drivers/staging: Remove useless return variables
Date: Tue, 20 May 2014 12:33:43 +0200
Message-Id: <1400582028-24990-3-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove variables that are initialized with a constant,
are never updated, and are only used as parameter of return.
Return the constant instead of using a variable.

Verified by compilation only.

The coccinelle script that find and fixes this issue is:
// <smpl>
@@
type T;
constant C;
identifier ret;
@@
- T ret = C;
... when != ret
- return ret;
+ return C;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/staging/bcm/Bcmchar.c                             |    3 +--
 drivers/staging/bcm/InterfaceIdleMode.c                   |    3 +--
 drivers/staging/bcm/PHSModule.c                           |    9 +++------
 drivers/staging/gdm72xx/gdm_wimax.c                       |    3 +--
 drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c            |    3 +--
 drivers/staging/rtl8192e/rtllib_rx.c                      |    3 +--
 drivers/staging/rtl8192e/rtllib_softmac.c                 |    3 +--
 drivers/staging/rtl8192e/rtllib_softmac_wx.c              |    4 +---
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c         |    3 +--
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c    |    3 +--
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c |    4 +---
 drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c       |    3 +--
 drivers/staging/rtl8192u/r819xU_cmdpkt.c                  |    3 +--
 drivers/staging/rtl8192u/r819xU_phy.c                     |    3 +--
 drivers/staging/sep/sep_main.c                            |    3 +--
 drivers/staging/silicom/bpctl_mod.c                       |    4 ++--
 drivers/staging/wlan-ng/hfa384x_usb.c                     |    3 +--
 drivers/staging/wlan-ng/p80211req.c                       |    3 +--
 18 files changed, 21 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index ae7490b..777a13a 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1800,7 +1800,6 @@ static int bcm_char_ioctl_flash2x_section_bitmap(void __user *argp,
 {
 	struct bcm_flash2x_bitmap *psFlash2xBitMap;
 	struct bcm_ioctl_buffer IoBuffer;
-	INT Status = STATUS_FAILURE;
 
 BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
 	"IOCTL_BCM_GET_FLASH2X_SECTION_BITMAP Called");
@@ -1841,7 +1840,7 @@ BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
 	}
 
 	kfree(psFlash2xBitMap);
-	return Status;
+	return STATUS_FAILURE;
 }
 
 static int bcm_char_ioctl_set_active_section(void __user *argp,
diff --git a/drivers/staging/bcm/InterfaceIdleMode.c b/drivers/staging/bcm/InterfaceIdleMode.c
index fecf81f..c84ee49 100644
--- a/drivers/staging/bcm/InterfaceIdleMode.c
+++ b/drivers/staging/bcm/InterfaceIdleMode.c
@@ -223,7 +223,6 @@ static int InterfaceAbortIdlemode(struct bcm_mini_adapter *Adapter,
 }
 int InterfaceIdleModeWakeup(struct bcm_mini_adapter *Adapter)
 {
-	ULONG	Status = 0;
 	if (Adapter->bTriedToWakeUpFromlowPowerMode) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
 		IDLE_MODE, DBG_LVL_ALL,
@@ -233,7 +232,7 @@ int InterfaceIdleModeWakeup(struct bcm_mini_adapter *Adapter)
 		InterfaceAbortIdlemode(Adapter, Adapter->usIdleModePattern);
 
 	}
-	return Status;
+	return 0;
 }
 
 void InterfaceHandleShutdownModeWakeup(struct bcm_mini_adapter *Adapter)
diff --git a/drivers/staging/bcm/PHSModule.c b/drivers/staging/bcm/PHSModule.c
index afc7bcc..07c5a0b 100644
--- a/drivers/staging/bcm/PHSModule.c
+++ b/drivers/staging/bcm/PHSModule.c
@@ -409,7 +409,6 @@ ULONG PhsUpdateClassifierRule(IN void *pvContext,
  */
 ULONG PhsDeletePHSRule(IN void *pvContext, IN B_UINT16 uiVcid, IN B_UINT8 u8PHSI)
 {
-	ULONG lStatus = 0;
 	UINT nSFIndex = 0, nClsidIndex = 0;
 	struct bcm_phs_entry *pstServiceFlowEntry = NULL;
 	struct bcm_phs_classifier_table *pstClassifierRulesTable = NULL;
@@ -446,7 +445,7 @@ ULONG PhsDeletePHSRule(IN void *pvContext, IN B_UINT16 uiVcid, IN B_UINT8 u8PHSI
 			}
 		}
 	}
-	return lStatus;
+	return 0;
 }
 
 /*
@@ -467,7 +466,6 @@ ULONG PhsDeletePHSRule(IN void *pvContext, IN B_UINT16 uiVcid, IN B_UINT8 u8PHSI
  */
 ULONG PhsDeleteClassifierRule(IN void *pvContext, IN B_UINT16 uiVcid, IN B_UINT16 uiClsId)
 {
-	ULONG lStatus = 0;
 	UINT nSFIndex = 0, nClsidIndex = 0;
 	struct bcm_phs_entry *pstServiceFlowEntry = NULL;
 	struct bcm_phs_classifier_entry *pstClassifierEntry = NULL;
@@ -504,7 +502,7 @@ ULONG PhsDeleteClassifierRule(IN void *pvContext, IN B_UINT16 uiVcid, IN B_UINT1
 			memset(pstClassifierEntry, 0, sizeof(struct bcm_phs_classifier_entry));
 		}
 	}
-	return lStatus;
+	return 0;
 }
 
 /*
@@ -524,7 +522,6 @@ ULONG PhsDeleteClassifierRule(IN void *pvContext, IN B_UINT16 uiVcid, IN B_UINT1
  */
 ULONG PhsDeleteSFRules(IN void *pvContext, IN B_UINT16 uiVcid)
 {
-	ULONG lStatus = 0;
 	UINT nSFIndex = 0, nClsidIndex = 0;
 	struct bcm_phs_entry *pstServiceFlowEntry = NULL;
 	struct bcm_phs_classifier_table *pstClassifierRulesTable = NULL;
@@ -573,7 +570,7 @@ ULONG PhsDeleteSFRules(IN void *pvContext, IN B_UINT16 uiVcid)
 		pstServiceFlowEntry->uiVcid = 0;
 	}
 
-	return lStatus;
+	return 0;
 }
 
 /*
diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 492bc78..2c917c1 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -167,7 +167,6 @@ static inline int gdm_wimax_header(struct sk_buff **pskb)
 {
 	u16 buf[HCI_HEADER_SIZE / sizeof(u16)];
 	struct sk_buff *skb = *pskb;
-	int ret = 0;
 
 	if (unlikely(skb_headroom(skb) < HCI_HEADER_SIZE)) {
 		struct sk_buff *skb2;
@@ -187,7 +186,7 @@ static inline int gdm_wimax_header(struct sk_buff **pskb)
 	memcpy(skb->data, buf, HCI_HEADER_SIZE);
 
 	*pskb = skb;
-	return ret;
+	return 0;
 }
 
 static void gdm_wimax_event_rcv(struct net_device *dev, u16 type, void *msg,
diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
index b4bfafe..8848921 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
@@ -729,7 +729,6 @@ u8 rtl8192_phy_ConfigRFWithHeaderFile(struct net_device *dev,
 {
 
 	int i;
-	u8 ret = 0;
 
 	switch (eRFPath) {
 	case RF90_PATH_A:
@@ -787,7 +786,7 @@ u8 rtl8192_phy_ConfigRFWithHeaderFile(struct net_device *dev,
 		break;
 	}
 
-	return ret;
+	return 0;
 
 }
 static void rtl8192_SetTxPowerLevel(struct net_device *dev, u8 channel)
diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index 7413816..60de54c 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -1589,7 +1589,6 @@ static int rtllib_qos_convert_ac_to_parameters(struct rtllib_qos_parameter_info
 {
 	struct rtllib_qos_ac_parameter *ac_params;
 	struct rtllib_qos_parameters *qos_param = &(qos_data->parameters);
-	int rc = 0;
 	int i;
 	u8 aci;
 	u8 acm;
@@ -1640,7 +1639,7 @@ static int rtllib_qos_convert_ac_to_parameters(struct rtllib_qos_parameter_info
 		    (ac_params->aci_aifsn & 0x10) ? 0x01 : 0x00;
 		qos_param->tx_op_limit[aci] = ac_params->tx_op_limit;
 	}
-	return rc;
+	return 0;
 }
 
 /*
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index d65cba4..684ceed 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -3239,7 +3239,6 @@ static int rtllib_wpa_set_auth_algs(struct rtllib_device *ieee, int value)
 	struct rtllib_security sec = {
 		.flags = SEC_AUTH_MODE,
 	};
-	int ret = 0;
 
 	if (value & AUTH_ALG_SHARED_KEY) {
 		sec.auth_mode = WLAN_AUTH_SHARED_KEY;
@@ -3259,7 +3258,7 @@ static int rtllib_wpa_set_auth_algs(struct rtllib_device *ieee, int value)
 	if (ieee->set_security)
 		ieee->set_security(ieee->dev, &sec);
 
-	return ret;
+	return 0;
 }
 
 static int rtllib_wpa_set_param(struct rtllib_device *ieee, u8 name, u32 value)
diff --git a/drivers/staging/rtl8192e/rtllib_softmac_wx.c b/drivers/staging/rtl8192e/rtllib_softmac_wx.c
index e6af8cf..65b650c 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac_wx.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac_wx.c
@@ -628,8 +628,6 @@ int rtllib_wx_get_power(struct rtllib_device *ieee,
 				 struct iw_request_info *info,
 				 union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
-
 	down(&ieee->wx_sem);
 
 	if (ieee->ps == RTLLIB_PS_DISABLED) {
@@ -657,7 +655,7 @@ int rtllib_wx_get_power(struct rtllib_device *ieee,
 
 exit:
 	up(&ieee->wx_sem);
-	return ret;
+	return 0;
 
 }
 EXPORT_SYMBOL(rtllib_wx_get_power);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index a98414a..05cc92e 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -1479,7 +1479,6 @@ static int ieee80211_qos_convert_ac_to_parameters(struct
 						  ieee80211_qos_parameters
 						  *qos_param)
 {
-	int rc = 0;
 	int i;
 	struct ieee80211_qos_ac_parameter *ac_params;
 	u8 aci;
@@ -1506,7 +1505,7 @@ static int ieee80211_qos_convert_ac_to_parameters(struct
 		    (ac_params->aci_aifsn & 0x10) ? 0x01 : 0x00;
 		qos_param->tx_op_limit[aci] = le16_to_cpu(ac_params->tx_op_limit);
 	}
-	return rc;
+	return 0;
 }
 
 /*
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index 9caf6fd..e2d9521 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -2843,7 +2843,6 @@ static int ieee80211_wpa_set_auth_algs(struct ieee80211_device *ieee, int value)
 	struct ieee80211_security sec = {
 		.flags = SEC_AUTH_MODE,
 	};
-	int ret = 0;
 
 	if (value & AUTH_ALG_SHARED_KEY) {
 		sec.auth_mode = WLAN_AUTH_SHARED_KEY;
@@ -2866,7 +2865,7 @@ static int ieee80211_wpa_set_auth_algs(struct ieee80211_device *ieee, int value)
 	//else
 	//	ret = -EOPNOTSUPP;
 
-	return ret;
+	return 0;
 }
 
 static int ieee80211_wpa_set_param(struct ieee80211_device *ieee, u8 name, u32 value)
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
index 7b7d929..3dfdc7a 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
@@ -559,8 +559,6 @@ int ieee80211_wx_get_power(struct ieee80211_device *ieee,
 				 struct iw_request_info *info,
 				 union iwreq_data *wrqu, char *extra)
 {
-	int ret =0;
-
 	down(&ieee->wx_sem);
 
 	if(ieee->ps == IEEE80211_PS_DISABLED){
@@ -590,7 +588,7 @@ int ieee80211_wx_get_power(struct ieee80211_device *ieee,
 
 exit:
 	up(&ieee->wx_sem);
-	return ret;
+	return 0;
 
 }
 EXPORT_SYMBOL(ieee80211_wx_get_essid);
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
index 53ec2d4..38adecf 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
@@ -415,8 +415,7 @@ static void HTIOTPeerDetermine(struct ieee80211_device *ieee)
   * *****************************************************************************************************************/
 static u8 HTIOTActIsDisableMCS14(struct ieee80211_device *ieee, u8 *PeerMacAddr)
 {
-	u8 ret = 0;
-	return ret;
+	return 0;
  }
 
 
diff --git a/drivers/staging/rtl8192u/r819xU_cmdpkt.c b/drivers/staging/rtl8192u/r819xU_cmdpkt.c
index 723c863..545f49e 100644
--- a/drivers/staging/rtl8192u/r819xU_cmdpkt.c
+++ b/drivers/staging/rtl8192u/r819xU_cmdpkt.c
@@ -28,7 +28,6 @@
 
 rt_status SendTxCommandPacket(struct net_device *dev, void *pData, u32 DataLen)
 {
-	rt_status	rtStatus = RT_STATUS_SUCCESS;
 	struct r8192_priv   *priv = ieee80211_priv(dev);
 	struct sk_buff	    *skb;
 	cb_desc		    *tcb_desc;
@@ -58,7 +57,7 @@ rt_status SendTxCommandPacket(struct net_device *dev, void *pData, u32 DataLen)
 		priv->ieee80211->softmac_hard_start_xmit(skb, dev);
 	}
 
-	return rtStatus;
+	return RT_STATUS_SUCCESS;
 }
 
 /*-----------------------------------------------------------------------------
diff --git a/drivers/staging/rtl8192u/r819xU_phy.c b/drivers/staging/rtl8192u/r819xU_phy.c
index 87e07ba..02554c9 100644
--- a/drivers/staging/rtl8192u/r819xU_phy.c
+++ b/drivers/staging/rtl8192u/r819xU_phy.c
@@ -991,7 +991,6 @@ u8 rtl8192_phy_ConfigRFWithHeaderFile(struct net_device *dev,
 {
 
 	int i;
-	u8 ret = 0;
 
 	switch (eRFPath) {
 	case RF90_PATH_A:
@@ -1058,7 +1057,7 @@ u8 rtl8192_phy_ConfigRFWithHeaderFile(struct net_device *dev,
 		break;
 	}
 
-	return ret;
+	return 0;
 
 }
 
diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index e301207..75ca15e 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -1400,7 +1400,6 @@ static int sep_lli_table_secure_dma(struct sep_device *sep,
 	struct sep_dma_context *dma_ctx)
 
 {
-	int error = 0;
 	u32 count;
 	/* The the page of the end address of the user space buffer */
 	u32 end_page;
@@ -1491,7 +1490,7 @@ static int sep_lli_table_secure_dma(struct sep_device *sep,
 	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_map_array = NULL;
 	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_map_num_entries = 0;
 
-	return error;
+	return 0;
 }
 
 /**
diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 7f3d884..3f2e38e 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -1562,7 +1562,7 @@ int pulse_set_fn(struct bpctl_dev *pbpctl_dev, unsigned int counter)
 
 int zero_set_fn(struct bpctl_dev *pbpctl_dev)
 {
-	uint32_t ctrl_ext = 0, ctrl_value = 0;
+	uint32_t ctrl_ext = 0;
 	if (!pbpctl_dev)
 		return -1;
 
@@ -1582,7 +1582,7 @@ int zero_set_fn(struct bpctl_dev *pbpctl_dev)
 							   BPCTLI_CTRL_EXT_MDIO_DATA)));
 
 	}
-	return ctrl_value;
+	return 0;
 }
 
 int pulse_get2_fn(struct bpctl_dev *pbpctl_dev)
diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index f0ab5a2..98343ff7 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -2642,7 +2642,6 @@ done:
 ----------------------------------------------------------------*/
 int hfa384x_drvr_stop(hfa384x_t *hw)
 {
-	int result = 0;
 	int i;
 
 	might_sleep();
@@ -2667,7 +2666,7 @@ int hfa384x_drvr_stop(hfa384x_t *hw)
 	for (i = 0; i < HFA384x_NUMPORTS_MAX; i++)
 		hw->port_enabled[i] = 0;
 
-	return result;
+	return 0;
 }
 
 /*----------------------------------------------------------------
diff --git a/drivers/staging/wlan-ng/p80211req.c b/drivers/staging/wlan-ng/p80211req.c
index cdfd808..ba3bde5 100644
--- a/drivers/staging/wlan-ng/p80211req.c
+++ b/drivers/staging/wlan-ng/p80211req.c
@@ -95,7 +95,6 @@ static void p80211req_mibset_mibget(wlandevice_t *wlandev,
 ----------------------------------------------------------------*/
 int p80211req_dorequest(wlandevice_t *wlandev, u8 *msgbuf)
 {
-	int result = 0;
 	struct p80211msg *msg = (struct p80211msg *) msgbuf;
 
 	/* Check to make sure the MSD is running */
@@ -129,7 +128,7 @@ int p80211req_dorequest(wlandevice_t *wlandev, u8 *msgbuf)
 		wlandev->mlmerequest(wlandev, msg);
 
 	clear_bit(1, &(wlandev->request_pending));
-	return result;	/* if result==0, msg->status still may contain an err */
+	return 0;	/* if result==0, msg->status still may contain an err */
 }
 
 /*----------------------------------------------------------------

