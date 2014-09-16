Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaIPXjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:39:32 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:37546 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbaIPXj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:39:28 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linux.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8723au: Fix "space required after that ','" errors
Date: Tue, 16 Sep 2014 18:37:41 -0500
Message-Id: <1410910661-25279-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "space required after that ','" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_mlme.c        | 39 ++++++++++++------------
 drivers/staging/rtl8723au/include/odm.h          |  2 +-
 drivers/staging/rtl8723au/include/odm_HWConfig.h |  4 +--
 drivers/staging/rtl8723au/include/rtw_cmd.h      |  2 +-
 drivers/staging/rtl8723au/include/rtw_eeprom.h   |  2 +-
 drivers/staging/rtl8723au/include/rtw_efuse.h    |  3 +-
 drivers/staging/rtl8723au/include/rtw_io.h       | 20 ++++++------
 drivers/staging/rtl8723au/include/rtw_mlme_ext.h |  4 +--
 8 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
index 99fbb5c..1f60064 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
@@ -425,7 +425,7 @@ static void update_current_network(struct rtw_adapter *adapter,
 	if (check_fwstate(pmlmepriv, _FW_LINKED) &&
 	    is_same_network23a(&pmlmepriv->cur_network.network, pnetwork)) {
 		update_network23a(&pmlmepriv->cur_network.network,
-				  pnetwork,adapter, true);
+				  pnetwork, adapter, true);
 
 		rtw_update_protection23a(adapter,
 					 pmlmepriv->cur_network.network.IEs,
@@ -510,7 +510,7 @@ static void rtw_update_scanned_network(struct rtw_adapter *adapter,
 		    target->reserved == 1)
 			update_ie = false;
 
-		update_network23a(&pnetwork->network, target,adapter,
+		update_network23a(&pnetwork->network, target, adapter,
 				  update_ie);
 	}
 
@@ -577,7 +577,8 @@ static int rtw_is_desired_network(struct rtw_adapter *adapter,
 /* TODO: Perry : For Power Management */
 void rtw_atimdone_event_callback23a(struct rtw_adapter *adapter, const u8 *pbuf)
 {
-	RT_TRACE(_module_rtl871x_mlme_c_,_drv_err_,("receive atimdone_evet\n"));
+	RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
+		 ("receive atimdone_evet\n"));
 
 	return;
 }
@@ -591,12 +592,12 @@ void rtw_survey_event_cb23a(struct rtw_adapter *adapter, const u8 *pbuf)
 
 	pnetwork = survey->bss;
 
-	RT_TRACE(_module_rtl871x_mlme_c_,_drv_info_,
+	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
 		 ("rtw_survey_event_cb23a, ssid=%s\n", pnetwork->Ssid.ssid));
 
 	len = get_wlan_bssid_ex_sz(pnetwork);
 	if (len > (sizeof(struct wlan_bssid_ex))) {
-		RT_TRACE(_module_rtl871x_mlme_c_,_drv_err_,
+		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
 			 ("\n ****rtw_survey_event_cb23a: return a wrong "
 			  "bss ***\n"));
 		return;
@@ -796,7 +797,7 @@ void rtw_free_assoc_resources23a(struct rtw_adapter *adapter,
 	if (pwlan)
 		pwlan->fixed = false;
 	else
-		RT_TRACE(_module_rtl871x_mlme_c_,_drv_err_,
+		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
 			 ("rtw_free_assoc_resources23a : pwlan== NULL\n"));
 
 	if (check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE) &&
@@ -1094,15 +1095,15 @@ void rtw_joinbss_event_prehandle23a(struct rtw_adapter *adapter, u8 *pbuf)
 	struct wlan_network *pcur_wlan, *ptarget_wlan = NULL;
 	bool the_same_macaddr;
 
-	RT_TRACE(_module_rtl871x_mlme_c_,_drv_info_,
+	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
 		 ("joinbss event call back received with res=%d\n",
 		  pnetwork->join_res));
 
 	if (pmlmepriv->assoc_ssid.ssid_len == 0) {
-		RT_TRACE(_module_rtl871x_mlme_c_,_drv_err_,
+		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
 			 ("@@@@@   joinbss event call back  for Any SSid\n"));
 	} else {
-		RT_TRACE(_module_rtl871x_mlme_c_,_drv_err_,
+		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
 			 ("@@@@@   rtw23a_joinbss_event_cb for SSid:%s\n",
 			  pmlmepriv->assoc_ssid.ssid));
 	}
@@ -1115,7 +1116,7 @@ void rtw_joinbss_event_prehandle23a(struct rtw_adapter *adapter, u8 *pbuf)
 
 	pnetwork->network.Length = get_wlan_bssid_ex_sz(&pnetwork->network);
 	if (pnetwork->network.Length > sizeof(struct wlan_bssid_ex)) {
-		RT_TRACE(_module_rtl871x_mlme_c_,_drv_err_,
+		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
 			 ("\n\n ***joinbss_evt_callback return a wrong bss "
 			  "***\n\n"));
 		return;
@@ -1123,12 +1124,12 @@ void rtw_joinbss_event_prehandle23a(struct rtw_adapter *adapter, u8 *pbuf)
 
 	spin_lock_bh(&pmlmepriv->lock);
 
-	RT_TRACE(_module_rtl871x_mlme_c_,_drv_info_,
+	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
 		 ("\n rtw23a_joinbss_event_cb !! _enter_critical\n"));
 
 	if (pnetwork->join_res > 0) {
 		spin_lock_bh(&pmlmepriv->scanned_queue.lock);
-		if (check_fwstate(pmlmepriv,_FW_UNDER_LINKING)) {
+		if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING)) {
 			/* s1. find ptarget_wlan */
 			if (check_fwstate(pmlmepriv, _FW_LINKED)) {
 				if (the_same_macaddr == true) {
@@ -1172,7 +1173,7 @@ void rtw_joinbss_event_prehandle23a(struct rtw_adapter *adapter, u8 *pbuf)
 							      ptarget_wlan,
 							      pnetwork);
 			else {
-				RT_TRACE(_module_rtl871x_mlme_c_,_drv_err_,
+				RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
 					 ("Can't find ptarget_wlan when "
 					  "joinbss_event callback\n"));
 				spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
@@ -1200,7 +1201,7 @@ void rtw_joinbss_event_prehandle23a(struct rtw_adapter *adapter, u8 *pbuf)
 			else {
 				/* adhoc mode will rtw_indicate_connect23a
 				   when rtw_stassoc_event_callback23a */
-				RT_TRACE(_module_rtl871x_mlme_c_,_drv_info_,
+				RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
 					 ("adhoc mode, fw_state:%x",
 					  get_fwstate(pmlmepriv)));
 			}
@@ -1208,7 +1209,7 @@ void rtw_joinbss_event_prehandle23a(struct rtw_adapter *adapter, u8 *pbuf)
 			/* s5. Cancle assoc_timer */
 			del_timer_sync(&pmlmepriv->assoc_timer);
 
-			RT_TRACE(_module_rtl871x_mlme_c_,_drv_info_,
+			RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_,
 				 ("Cancle assoc_timer\n"));
 		} else {
 			RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
@@ -1278,7 +1279,7 @@ void rtw_stassoc_event_callback23a(struct rtw_adapter *adapter, const u8 *pbuf)
 	psta = rtw_get_stainfo23a(&adapter->stapriv, pstassoc->macaddr);
 	if (psta != NULL) {
 		/* the sta have been in sta_info_queue => do nothing */
-		RT_TRACE(_module_rtl871x_mlme_c_,_drv_err_,
+		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
 			 ("Error: rtw_stassoc_event_callback23a: sta has "
 			  "been in sta_hash_queue\n"));
 		/* between drv has received this event before and
@@ -1289,7 +1290,7 @@ void rtw_stassoc_event_callback23a(struct rtw_adapter *adapter, const u8 *pbuf)
 	psta = rtw_alloc_stainfo23a(&adapter->stapriv, pstassoc->macaddr,
 		GFP_KERNEL);
 	if (!psta) {
-		RT_TRACE(_module_rtl871x_mlme_c_,_drv_err_,
+		RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
 			 ("Can't alloc sta_info when "
 			  "rtw_stassoc_event_callback23a\n"));
 		return;
@@ -1299,7 +1300,7 @@ void rtw_stassoc_event_callback23a(struct rtw_adapter *adapter, const u8 *pbuf)
 	psta->qos_option = 0;
 	psta->mac_id = (uint)pstassoc->cam_id;
 	/* psta->aid = (uint)pstassoc->cam_id; */
-	DBG_8723A("%s\n",__func__);
+	DBG_8723A("%s\n", __func__);
 	/* for ad-hoc mode */
 	rtl8723a_SetHalODMVar(adapter, HAL_ODM_STA_INFO, psta, true);
 
@@ -1794,7 +1795,7 @@ int rtw_set_auth23a(struct rtw_adapter * adapter,
 	pcmd->rsp = NULL;
 	pcmd->rspsz = 0;
 
-	RT_TRACE(_module_rtl871x_mlme_c_,_drv_err_,
+	RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_,
 		 ("after enqueue set_auth_cmd, auth_mode=%x\n",
 		  psecuritypriv->dot11AuthAlgrthm));
 
diff --git a/drivers/staging/rtl8723au/include/odm.h b/drivers/staging/rtl8723au/include/odm.h
index 68ff7bb..5a0561e 100644
--- a/drivers/staging/rtl8723au/include/odm.h
+++ b/drivers/staging/rtl8723au/include/odm.h
@@ -138,7 +138,7 @@ struct dynamic_pwr_sav {
 	int		    Rssi_val_min;
 
 	u8		initialize;
-	u32		Reg874,RegC70,Reg85C,RegA74;
+	u32		Reg874, RegC70, Reg85C, RegA74;
 };
 
 struct false_alarm_stats {
diff --git a/drivers/staging/rtl8723au/include/odm_HWConfig.h b/drivers/staging/rtl8723au/include/odm_HWConfig.h
index 78021a8..ce7abe7 100644
--- a/drivers/staging/rtl8723au/include/odm_HWConfig.h
+++ b/drivers/staging/rtl8723au/include/odm_HWConfig.h
@@ -67,9 +67,9 @@
 
 struct phy_rx_agc_info {
 	#ifdef __LITTLE_ENDIAN
-		u8	gain:7,trsw:1;
+		u8	gain:7, trsw:1;
 	#else
-		u8	trsw:1,gain:7;
+		u8	trsw:1, gain:7;
 	#endif
 };
 
diff --git a/drivers/staging/rtl8723au/include/rtw_cmd.h b/drivers/staging/rtl8723au/include/rtw_cmd.h
index 9b3425e..ef67068 100644
--- a/drivers/staging/rtl8723au/include/rtw_cmd.h
+++ b/drivers/staging/rtl8723au/include/rtw_cmd.h
@@ -699,7 +699,7 @@ int rtw_setrfintfs_cmd(struct rtw_adapter  *padapter, u8 mode);
 int rtw_setrttbl_cmd(struct rtw_adapter  *padapter, struct setratable_parm *prate_table);
 int rtw_getrttbl_cmd(struct rtw_adapter  *padapter, struct getratable_rsp *pval);
 
-int rtw_gettssi_cmd(struct rtw_adapter  *padapter, u8 offset,u8 *pval);
+int rtw_gettssi_cmd(struct rtw_adapter  *padapter, u8 offset, u8 *pval);
 int rtw_setfwdig_cmd(struct rtw_adapter*padapter, u8 type);
 int rtw_setfwra_cmd(struct rtw_adapter*padapter, u8 type);
 
diff --git a/drivers/staging/rtl8723au/include/rtw_eeprom.h b/drivers/staging/rtl8723au/include/rtw_eeprom.h
index d008f03..e5121a2 100644
--- a/drivers/staging/rtl8723au/include/rtw_eeprom.h
+++ b/drivers/staging/rtl8723au/include/rtw_eeprom.h
@@ -128,7 +128,7 @@ struct eeprom_priv {
 void eeprom_write16(struct rtw_adapter *padapter, u16 reg, u16 data);
 u16 eeprom_read16(struct rtw_adapter *padapter, u16 reg);
 void read_eeprom_content(struct rtw_adapter *padapter);
-void eeprom_read_sz(struct rtw_adapter * padapter, u16 reg,u8* data, u32 sz);
+void eeprom_read_sz(struct rtw_adapter *padapter, u16 reg, u8 *data, u32 sz);
 
 void read_eeprom_content_by_attrib(struct rtw_adapter *padapter);
 
diff --git a/drivers/staging/rtl8723au/include/rtw_efuse.h b/drivers/staging/rtl8723au/include/rtw_efuse.h
index 3e9bad5..c577e26 100644
--- a/drivers/staging/rtl8723au/include/rtw_efuse.h
+++ b/drivers/staging/rtl8723au/include/rtw_efuse.h
@@ -95,7 +95,8 @@ void	EFUSE_GetEfuseDefinition23a(struct rtw_adapter *pAdapter, u8 efuseType, u8
 int	efuse_OneByteRead23a(struct rtw_adapter *pAdapter, u16 addr, u8 *data);
 int	efuse_OneByteWrite23a(struct rtw_adapter *pAdapter, u16 addr, u8 data);
 
-void	Efuse_PowerSwitch23a(struct rtw_adapter *pAdapter,u8	bWrite,u8	 PwrState);
+void	Efuse_PowerSwitch23a(struct rtw_adapter *pAdapter, u8 bWrite,
+			     u8 PwrState);
 int	Efuse_PgPacketRead23a(struct rtw_adapter *pAdapter, u8 offset, u8 *data);
 int	Efuse_PgPacketWrite23a(struct rtw_adapter *pAdapter, u8 offset, u8 word_en, u8 *data);
 void	efuse_WordEnableDataRead23a(u8 word_en, u8 *sourdata, u8 *targetdata);
diff --git a/drivers/staging/rtl8723au/include/rtw_io.h b/drivers/staging/rtl8723au/include/rtw_io.h
index cc151b0..c8119e2 100644
--- a/drivers/staging/rtl8723au/include/rtw_io.h
+++ b/drivers/staging/rtl8723au/include/rtw_io.h
@@ -223,15 +223,15 @@ struct reg_protocol_wt {
 
 };
 
-#define PlatformEFIOWrite1Byte(_a,_b,_c)		\
-	rtl8723au_write8(_a,_b,_c)
-#define PlatformEFIOWrite2Byte(_a,_b,_c)		\
-	rtl8723au_write16(_a,_b,_c)
-#define PlatformEFIOWrite4Byte(_a,_b,_c)		\
-	rtl8723au_write32(_a,_b,_c)
-
-#define PlatformEFIORead1Byte(_a,_b)		rtl8723au_read8(_a,_b)
-#define PlatformEFIORead2Byte(_a,_b)		rtl8723au_read16(_a,_b)
-#define PlatformEFIORead4Byte(_a,_b)		rtl8723au_read32(_a,_b)
+#define PlatformEFIOWrite1Byte(_a, _b, _c)		\
+	rtl8723au_write8(_a, _b, _c)
+#define PlatformEFIOWrite2Byte(_a, _b, _c)		\
+	rtl8723au_write16(_a, _b, _c)
+#define PlatformEFIOWrite4Byte(_a, _b, _c)		\
+	rtl8723au_write32(_a, _b, _c)
+
+#define PlatformEFIORead1Byte(_a, _b)		rtl8723au_read8(_a, _b)
+#define PlatformEFIORead2Byte(_a, _b)		rtl8723au_read16(_a, _b)
+#define PlatformEFIORead4Byte(_a, _b)		rtl8723au_read32(_a, _b)
 
 #endif	/* _RTL8711_IO_H_ */
diff --git a/drivers/staging/rtl8723au/include/rtw_mlme_ext.h b/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
index ea53d73..97c3c44 100644
--- a/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
@@ -395,7 +395,7 @@ struct p2p_channels {
 };
 
 struct p2p_oper_class_map {
-	enum hw_mode {IEEE80211G,IEEE80211A} mode;
+	enum hw_mode {IEEE80211G, IEEE80211A} mode;
 	u8 op_class;
 	u8 min_chan;
 	u8 max_chan;
@@ -458,7 +458,7 @@ u8 judge_network_type23a(struct rtw_adapter *padapter, unsigned char *rate,
 		      int ratelen);
 void get_rate_set23a(struct rtw_adapter *padapter, unsigned char *pbssrate,
 		  int *bssrate_len);
-void UpdateBrateTbl23a(struct rtw_adapter *padapter,u8 *mBratesOS);
+void UpdateBrateTbl23a(struct rtw_adapter *padapter, u8 *mBratesOS);
 void Update23aTblForSoftAP(u8 *bssrateset, u32 bssratelen);
 
 u8 rtw_get_oper_ch23a(struct rtw_adapter *adapter);
-- 
1.9.1

