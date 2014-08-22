Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbaHVP6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:58:51 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:63722 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137AbaHVP6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:58:49 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linux.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8723au: Fix "foo* bar" should be "foo *bar" errors
Date: Fri, 22 Aug 2014 10:57:49 -0500
Message-Id: <1408723069-11621-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "foo* bar" should be "foo *bar" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_ap.c           |  2 +-
 drivers/staging/rtl8723au/core/rtw_cmd.c          |  4 ++--
 drivers/staging/rtl8723au/core/rtw_ieee80211.c    |  4 ++--
 drivers/staging/rtl8723au/core/rtw_mlme.c         | 22 +++++++++++-----------
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c     | 22 +++++++++++-----------
 drivers/staging/rtl8723au/core/rtw_recv.c         |  4 ++--
 drivers/staging/rtl8723au/include/ieee80211.h     |  2 +-
 drivers/staging/rtl8723au/include/rtl8723a_rf.h   |  4 ++--
 drivers/staging/rtl8723au/include/rtw_mlme_ext.h  |  6 +++---
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c |  2 +-
 10 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
index 4d2880a..888abeb 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -644,7 +644,7 @@ static void start_bss_network(struct rtw_adapter *padapter, u8 *pbuf)
 	u32 acparm;
 	struct registry_priv *pregpriv = &padapter->registrypriv;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-	struct security_priv* psecuritypriv = &padapter->securitypriv;
+	struct security_priv *psecuritypriv = &padapter->securitypriv;
 	struct wlan_bssid_ex *pnetwork = &pmlmepriv->cur_network.network;
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info *pmlmeinfo = &pmlmeext->mlmext_info;
diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
index 7241a5a..71a0878 100644
--- a/drivers/staging/rtl8723au/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
@@ -1513,8 +1513,8 @@ void rtw_setassocsta_cmdrsp_callback23a(struct rtw_adapter *padapter,
 {
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-	struct set_assocsta_parm* passocsta_parm;
-	struct set_assocsta_rsp* passocsta_rsp;
+	struct set_assocsta_parm *passocsta_parm;
+	struct set_assocsta_rsp *passocsta_rsp;
 	struct sta_info *psta;
 
 	passocsta_parm = (struct set_assocsta_parm *)(pcmd->parmbuf);
diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
index 23e6662..6274cb3 100644
--- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
@@ -295,7 +295,7 @@ exit:
 	return ret;
 }
 
-void rtw_set_supported_rate23a(u8* SupportedRates, uint mode)
+void rtw_set_supported_rate23a(u8 *SupportedRates, uint mode)
 {
 
 
@@ -520,7 +520,7 @@ int rtw_parse_wpa_ie23a(const u8* wpa_ie, int wpa_ie_len, int *group_cipher, int
 	return ret;
 }
 
-int rtw_parse_wpa2_ie23a(const u8* rsn_ie, int rsn_ie_len, int *group_cipher,
+int rtw_parse_wpa2_ie23a(const u8 *rsn_ie, int rsn_ie_len, int *group_cipher,
 		      int *pairwise_cipher, int *is_8021x)
 {
 	int i, ret = _SUCCESS;
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
index c475b79..57f93f5 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
@@ -208,7 +208,7 @@ int rtw_if_up23a(struct rtw_adapter *padapter)
 	return res;
 }
 
-void rtw_generate_random_ibss23a(u8* pibss)
+void rtw_generate_random_ibss23a(u8 *pibss)
 {
 	unsigned long curtime = jiffies;
 
@@ -610,7 +610,7 @@ void rtw_survey_event_cb23a(struct rtw_adapter *adapter, const u8 *pbuf)
 		   "rtw_survey_event_cb23a : WIFI_ADHOC_MASTER_STATE\n\n"); */
 		if (ether_addr_equal(pmlmepriv->cur_network.network.MacAddress,
 				     pnetwork->MacAddress)) {
-			struct wlan_network* ibss_wlan;
+			struct wlan_network *ibss_wlan;
 
 			pmlmepriv->cur_network.network.beacon_interval =
 				pnetwork->beacon_interval;
@@ -754,11 +754,11 @@ static void free_scanqueue(struct mlme_priv *pmlmepriv)
 void rtw_free_assoc_resources23a(struct rtw_adapter *adapter,
 				 int lock_scanned_queue)
 {
-	struct wlan_network* pwlan;
+	struct wlan_network *pwlan;
 	struct mlme_priv *pmlmepriv = &adapter->mlmepriv;
 	struct sta_priv *pstapriv = &adapter->stapriv;
 	struct wlan_network *tgt_network = &pmlmepriv->cur_network;
-	struct sta_info* psta;
+	struct sta_info *psta;
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_notice_,
 		 ("+rtw_free_assoc_resources23a\n"));
@@ -1335,7 +1335,7 @@ void rtw_stadel_event_callback23a(struct rtw_adapter *adapter, const u8 *pbuf)
 {
 	int mac_id;
 	struct sta_info *psta;
-	struct wlan_network* pwlan;
+	struct wlan_network *pwlan;
 	struct wlan_bssid_ex *pdev_network;
 	struct mlme_priv *pmlmepriv = &adapter->mlmepriv;
 	struct stadel_event *pstadel = (struct stadel_event *)pbuf;
@@ -1768,7 +1768,7 @@ exit:
 int rtw_set_auth23a(struct rtw_adapter * adapter,
 		    struct security_priv *psecuritypriv)
 {
-	struct cmd_obj* pcmd;
+	struct cmd_obj *pcmd;
 	struct setauth_parm *psetauthparm;
 	struct cmd_priv *pcmdpriv = &adapter->cmdpriv;
 	int res = _SUCCESS;
@@ -2048,10 +2048,10 @@ int rtw_restruct_sec_ie23a(struct rtw_adapter *adapter, u8 *in_ie, u8 *out_ie,
 	return ielength;
 }
 
-void rtw_init_registrypriv_dev_network23a(struct rtw_adapter* adapter)
+void rtw_init_registrypriv_dev_network23a(struct rtw_adapter *adapter)
 {
-	struct registry_priv* pregistrypriv = &adapter->registrypriv;
-	struct eeprom_priv* peepriv = &adapter->eeprompriv;
+	struct registry_priv *pregistrypriv = &adapter->registrypriv;
+	struct eeprom_priv *peepriv = &adapter->eeprompriv;
 	struct wlan_bssid_ex    *pdev_network = &pregistrypriv->dev_network;
 	u8 *myhwaddr = myid(peepriv);
 
@@ -2063,10 +2063,10 @@ void rtw_init_registrypriv_dev_network23a(struct rtw_adapter* adapter)
 	pdev_network->beacon_interval = 100;
 }
 
-void rtw_update_registrypriv_dev_network23a(struct rtw_adapter* adapter)
+void rtw_update_registrypriv_dev_network23a(struct rtw_adapter *adapter)
 {
 	int sz = 0;
-	struct registry_priv* pregistrypriv = &adapter->registrypriv;
+	struct registry_priv *pregistrypriv = &adapter->registrypriv;
 	struct wlan_bssid_ex *pdev_network = &pregistrypriv->dev_network;
 	struct security_priv *psecuritypriv = &adapter->securitypriv;
 	struct wlan_network *cur_network = &adapter->mlmepriv.cur_network;
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
index c5fdcb8..c5511ea 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
@@ -356,7 +356,7 @@ int init_hw_mlme_ext23a(struct rtw_adapter *padapter)
 	return _SUCCESS;
 }
 
-static void init_mlme_ext_priv23a_value(struct rtw_adapter* padapter)
+static void init_mlme_ext_priv23a_value(struct rtw_adapter *padapter)
 {
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info *pmlmeinfo = &pmlmeext->mlmext_info;
@@ -480,7 +480,7 @@ static void init_channel_list(struct rtw_adapter *padapter,
 	channel_list->reg_classes = cla;
 }
 
-static u8 init_channel_set(struct rtw_adapter* padapter, u8 cplan,
+static u8 init_channel_set(struct rtw_adapter *padapter, u8 cplan,
 			   struct rt_channel_info *c_set)
 {
 	u8 i, ch_size = 0;
@@ -564,10 +564,10 @@ static u8 init_channel_set(struct rtw_adapter* padapter, u8 cplan,
 	return ch_size;
 }
 
-int init_mlme_ext_priv23a(struct rtw_adapter* padapter)
+int init_mlme_ext_priv23a(struct rtw_adapter *padapter)
 {
 	int res = _SUCCESS;
-	struct registry_priv* pregistrypriv = &padapter->registrypriv;
+	struct registry_priv *pregistrypriv = &padapter->registrypriv;
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct mlme_ext_info *pmlmeinfo = &pmlmeext->mlmext_info;
@@ -4313,7 +4313,7 @@ fail:
 	return NULL;
 }
 
-static void start_create_ibss(struct rtw_adapter* padapter)
+static void start_create_ibss(struct rtw_adapter *padapter)
 {
 	unsigned short caps;
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
@@ -4362,7 +4362,7 @@ static void start_create_ibss(struct rtw_adapter* padapter)
 	}
 }
 
-static void start_clnt_join(struct rtw_adapter* padapter)
+static void start_clnt_join(struct rtw_adapter *padapter)
 {
 	unsigned short caps;
 	u8 val8;
@@ -4422,7 +4422,7 @@ static void start_clnt_join(struct rtw_adapter* padapter)
 	}
 }
 
-static void start_clnt_auth(struct rtw_adapter* padapter)
+static void start_clnt_auth(struct rtw_adapter *padapter)
 {
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info *pmlmeinfo = &pmlmeext->mlmext_info;
@@ -4453,7 +4453,7 @@ static void start_clnt_auth(struct rtw_adapter* padapter)
 	set_link_timer(pmlmeext, REAUTH_TO);
 }
 
-static void start_clnt_assoc(struct rtw_adapter* padapter)
+static void start_clnt_assoc(struct rtw_adapter *padapter)
 {
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info *pmlmeinfo = &pmlmeext->mlmext_info;
@@ -4878,7 +4878,7 @@ void report_join_res23a(struct rtw_adapter *padapter, int res)
 }
 
 void report_del_sta_event23a(struct rtw_adapter *padapter,
-			     unsigned char* MacAddr, unsigned short reason)
+			     unsigned char *MacAddr, unsigned short reason)
 {
 	struct cmd_obj *pcmd_obj;
 	u8 *pevtcmd;
@@ -4934,7 +4934,7 @@ void report_del_sta_event23a(struct rtw_adapter *padapter,
 }
 
 void report_add_sta_event23a(struct rtw_adapter *padapter,
-			     unsigned char* MacAddr, int cam_idx)
+			     unsigned char *MacAddr, int cam_idx)
 {
 	struct cmd_obj *pcmd_obj;
 	u8 *pevtcmd;
@@ -6022,7 +6022,7 @@ int add_ba_hdl23a(struct rtw_adapter *padapter, const u8 *pbuf)
 	return H2C_SUCCESS;
 }
 
-int set_tx_beacon_cmd23a(struct rtw_adapter* padapter)
+int set_tx_beacon_cmd23a(struct rtw_adapter *padapter)
 {
 	struct cmd_obj *ph2c;
 	struct Tx_Beacon_param *ptxBeacon_parm;
diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index a9f8183..0cdcd12 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -1230,7 +1230,7 @@ static int validate_recv_ctrl_frame(struct rtw_adapter *padapter,
 	return _FAIL;
 }
 
-struct recv_frame* recvframe_chk_defrag23a(struct rtw_adapter *padapter,
+struct recv_frame *recvframe_chk_defrag23a(struct rtw_adapter *padapter,
 					struct recv_frame *precv_frame);
 static int validate_recv_mgnt_frame(struct rtw_adapter *padapter,
 				    struct recv_frame *precv_frame)
@@ -1705,7 +1705,7 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 }
 
 /* check if need to defrag, if needed queue the frame to defrag_q */
-struct recv_frame* recvframe_chk_defrag23a(struct rtw_adapter *padapter,
+struct recv_frame *recvframe_chk_defrag23a(struct rtw_adapter *padapter,
 					struct recv_frame *precv_frame)
 {
 	u8	ismfrag;
diff --git a/drivers/staging/rtl8723au/include/ieee80211.h b/drivers/staging/rtl8723au/include/ieee80211.h
index e9f465f..c1a334d 100644
--- a/drivers/staging/rtl8723au/include/ieee80211.h
+++ b/drivers/staging/rtl8723au/include/ieee80211.h
@@ -332,7 +332,7 @@ u8 *rtw_get_ie23a(u8*pbuf, int index, int *len, int limit);
 u8 *rtw_get_ie23a_ex(u8 *in_ie, uint in_len, u8 eid, u8 *oui, u8 oui_len, u8 *ie, uint *ielen);
 int rtw_ies_remove_ie23a(u8 *ies, uint *ies_len, uint offset, u8 eid, u8 *oui, u8 oui_len);
 
-void rtw_set_supported_rate23a(u8* SupportedRates, uint mode) ;
+void rtw_set_supported_rate23a(u8 *SupportedRates, uint mode);
 
 int rtw_parse_wpa_ie23a(const u8* wpa_ie, int wpa_ie_len, int *group_cipher, int *pairwise_cipher, int *is_8021x);
 int rtw_parse_wpa2_ie23a(const u8* wpa_ie, int wpa_ie_len, int *group_cipher, int *pairwise_cipher, int *is_8021x);
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_rf.h b/drivers/staging/rtl8723au/include/rtl8723a_rf.h
index 166a45f..0432799 100644
--- a/drivers/staging/rtl8723au/include/rtl8723a_rf.h
+++ b/drivers/staging/rtl8723au/include/rtl8723a_rf.h
@@ -47,9 +47,9 @@
 void rtl8723a_phy_rf6052set_bw(struct rtw_adapter *Adapter,
 			       enum ht_channel_width Bandwidth);
 void rtl823a_phy_rf6052setccktxpower(struct rtw_adapter *Adapter,
-				      u8* pPowerlevel);
+				      u8 *pPowerlevel);
 void rtl8723a_PHY_RF6052SetOFDMTxPower(struct rtw_adapter *Adapter,
-				       u8* pPowerLevel, u8 Channel);
+				       u8 *pPowerLevel, u8 Channel);
 
 /*--------------------------Exported Function prototype---------------------*/
 
diff --git a/drivers/staging/rtl8723au/include/rtw_mlme_ext.h b/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
index 2e32c83..ea53d73 100644
--- a/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
@@ -266,7 +266,7 @@ struct mlme_handler {
 
 struct action_handler {
 	unsigned int   num;
-	char* str;
+	char *str;
 	int (*func)(struct rtw_adapter *padapter, struct recv_frame *precv_frame);
 };
 
@@ -446,7 +446,7 @@ struct mlme_ext_priv {
 	u8 active_keep_alive_check;
 };
 
-int init_mlme_ext_priv23a(struct rtw_adapter* padapter);
+int init_mlme_ext_priv23a(struct rtw_adapter *padapter);
 int init_hw_mlme_ext23a(struct rtw_adapter *padapter);
 void free_mlme_ext_priv23a (struct mlme_ext_priv *pmlmeext);
 void init_mlme_ext_timer23a(struct rtw_adapter *padapter);
@@ -514,7 +514,7 @@ void update_capinfo23a(struct rtw_adapter *Adapter, u16 updateCap);
 void update_wireless_mode23a(struct rtw_adapter * padapter);
 void update_tx_basic_rate23a(struct rtw_adapter *padapter, u8 modulation);
 void update_bmc_sta_support_rate23a(struct rtw_adapter *padapter, u32 mac_id);
-int update_sta_support_rate23a(struct rtw_adapter *padapter, u8* pvar_ie,
+int update_sta_support_rate23a(struct rtw_adapter *padapter, u8 *pvar_ie,
 			    uint var_ie_len, int cam_idx);
 
 /* for sta/adhoc mode */
diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index 93dc844..4b39476 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -1118,7 +1118,7 @@ exit:
 	return ret;
 }
 
-int cfg80211_infrastructure_mode(struct rtw_adapter* padapter,
+int cfg80211_infrastructure_mode(struct rtw_adapter *padapter,
 				 enum nl80211_iftype ifmode)
 {
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-- 
1.9.1

