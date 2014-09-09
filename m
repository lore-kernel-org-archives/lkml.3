Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbaIIBvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 21:51:18 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:48572 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbaIIBvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 21:51:16 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linux.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8723au: Fix 'code indent should use tabs where possible' errors
Date: Mon,  8 Sep 2014 20:50:23 -0500
Message-Id: <1410227423-14326-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl 'code indent should use tabs where possible' errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_cmd.c       |  4 ++--
 drivers/staging/rtl8723au/core/rtw_led.c       |  2 +-
 drivers/staging/rtl8723au/core/rtw_mlme.c      | 12 ++++++------
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c  |  6 +++---
 drivers/staging/rtl8723au/core/rtw_recv.c      | 10 +++++-----
 drivers/staging/rtl8723au/core/rtw_security.c  | 10 +++-------
 drivers/staging/rtl8723au/core/rtw_wlan_util.c |  2 +-
 drivers/staging/rtl8723au/core/rtw_xmit.c      |  4 ++--
 drivers/staging/rtl8723au/include/ieee80211.h  | 14 +++++++-------
 drivers/staging/rtl8723au/include/rtw_cmd.h    | 10 +++++-----
 10 files changed, 35 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
index 9fd9b10..4eaa502 100644
--- a/drivers/staging/rtl8723au/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
@@ -717,11 +717,11 @@ int rtw_setstakey_cmd23a(struct rtw_adapter *padapter, u8 *psta, u8 unicast_key)
 
 	if (unicast_key == true) {
 		memcpy(&psetstakey_para->key, &sta->dot118021x_UncstKey, 16);
-        } else {
+	} else {
 		int idx = psecuritypriv->dot118021XGrpKeyid;
 		memcpy(&psetstakey_para->key,
 		       &psecuritypriv->dot118021XGrpKey[idx].skey, 16);
-        }
+	}
 
 	/* jeff: set this because at least sw key is ready */
 	padapter->securitypriv.busetkipkey = 1;
diff --git a/drivers/staging/rtl8723au/core/rtw_led.c b/drivers/staging/rtl8723au/core/rtw_led.c
index e21a42c5..989cda2 100644
--- a/drivers/staging/rtl8723au/core/rtw_led.c
+++ b/drivers/staging/rtl8723au/core/rtw_led.c
@@ -1842,7 +1842,7 @@ LedControl871x23a(struct rtw_adapter *padapter, enum led_ctl_mode LedAction) {
 	if ((padapter->bSurpriseRemoved == true) ||
 	    (padapter->bDriverStopped == true) ||
 	    (padapter->hw_init_completed == false)) {
-             return;
+		return;
 	}
 
 	if (ledpriv->bRegUseLed == false)
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
index 099ef8c..99fbb5c 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
@@ -159,7 +159,7 @@ rtw_find_network23a(struct rtw_queue *scanned_queue, u8 *addr)
 			break;
 
 		plist = plist->next;
-        }
+	}
 
 	if (plist == phead)
 		pnetwork = NULL;
@@ -556,7 +556,7 @@ static int rtw_is_desired_network(struct rtw_adapter *adapter,
 		/* for  correct flow of 8021X  to do.... */
 		if (desired_encmode == Ndis802_11EncryptionDisabled &&
 		    privacy != 0)
-	            bselected = false;
+			bselected = false;
 	}
 
 	if (desired_encmode != Ndis802_11EncryptionDisabled && privacy == 0) {
@@ -637,7 +637,7 @@ void rtw_survey_event_cb23a(struct rtw_adapter *adapter, const u8 *pbuf)
 
 	/*  lock pmlmepriv->lock when you accessing network_q */
 	if (!check_fwstate(pmlmepriv, _FW_UNDER_LINKING)) {
-	        if (pnetwork->Ssid.ssid[0] == 0)
+		if (pnetwork->Ssid.ssid[0] == 0)
 			pnetwork->Ssid.ssid_len = 0;
 
 		rtw_add_network(adapter, pnetwork);
@@ -743,7 +743,7 @@ static void free_scanqueue(struct mlme_priv *pmlmepriv)
 		pnetwork = container_of(plist, struct wlan_network, list);
 		pnetwork->fixed = false;
 		_rtw_free_network23a(pmlmepriv, pnetwork);
-        }
+	}
 
 	spin_unlock_bh(&scan_queue->lock);
 }
@@ -855,7 +855,7 @@ void rtw_indicate_disconnect23a(struct rtw_adapter *padapter)
 
 	_clr_fwstate_(pmlmepriv, _FW_UNDER_LINKING|WIFI_UNDER_WPS);
 
-        /* DBG_8723A("clear wps when %s\n", __func__); */
+	/* DBG_8723A("clear wps when %s\n", __func__); */
 
 	if (padapter->mlmepriv.to_roaming > 0)
 		_clr_fwstate_(pmlmepriv, _FW_LINKED);
@@ -1351,7 +1351,7 @@ void rtw_stadel_event_callback23a(struct rtw_adapter *adapter, const u8 *pbuf)
 	DBG_8723A("%s(mac_id=%d)=" MAC_FMT "\n", __func__, mac_id,
 		  MAC_ARG(pstadel->macaddr));
 
-        if (check_fwstate(pmlmepriv, WIFI_AP_STATE))
+	if (check_fwstate(pmlmepriv, WIFI_AP_STATE))
 		return;
 
 	mlmeext_sta_del_event_callback23a(adapter);
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
index 23621a8..fcba087 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
@@ -625,7 +625,7 @@ _mgt_dispatcher23a(struct rtw_adapter *padapter, struct mlme_handler *ptable,
 			return;
 
 		ptable->func(padapter, precv_frame);
-        }
+	}
 }
 
 void mgt_dispatcher23a(struct rtw_adapter *padapter,
@@ -1949,7 +1949,7 @@ OnDisassoc23a(struct rtw_adapter *padapter, struct recv_frame *precv_frame)
 
 	reason = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
-        DBG_8723A("%s Reason code(%d)\n", __func__, reason);
+	DBG_8723A("%s Reason code(%d)\n", __func__, reason);
 
 #ifdef CONFIG_8723AU_AP_MODE
 	if (check_fwstate(pmlmepriv, WIFI_AP_STATE)) {
@@ -5564,7 +5564,7 @@ int join_cmd_hdl23a(struct rtw_adapter *padapter, const u8 *pbuf)
 	struct ieee80211_ht_operation *pht_info;
 	u32 i;
 	u8 *p;
-        /* u32	initialgain; */
+	/* u32	initialgain; */
 	/* u32	acparm; */
 
 	/* check already connecting to AP or not */
diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 5138ea0..5bc7734 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -577,7 +577,7 @@ static struct recv_frame *portctrl(struct rtw_adapter *adapter,
 				 ("########portctrl:psta->ieee8021x_blocked =="
 				  "1\n"));
 
-		        if (ether_type == eapol_type) {
+			if (ether_type == eapol_type) {
 				prtnframe = precv_frame;
 			} else {
 				/* free this frame */
@@ -1170,7 +1170,7 @@ static int validate_recv_ctrl_frame(struct rtw_adapter *padapter,
 
 				if (psta->sleepq_len>0)
 					pxmitframe->attrib.mdata = 1;
-                                else
+				else
 					pxmitframe->attrib.mdata = 0;
 
 				pxmitframe->attrib.triggered = 1;
@@ -1891,7 +1891,7 @@ int check_indicate_seq(struct recv_reorder_ctrl *preorder_ctrl, u16 seq_num)
 }
 
 static int enqueue_reorder_recvframe23a(struct recv_reorder_ctrl *preorder_ctrl,
-				        struct recv_frame *prframe)
+					struct recv_frame *prframe)
 {
 	struct rx_pkt_attrib *pattrib = &prframe->attrib;
 	struct rtw_queue *ppending_recvframe_queue;
@@ -1975,7 +1975,7 @@ int recv_indicatepkts_in_order(struct rtw_adapter *padapter,
 		}
 
 		prframe = container_of(plist, struct recv_frame, list);
-	        pattrib = &prframe->attrib;
+		pattrib = &prframe->attrib;
 		preorder_ctrl->indicate_seq = pattrib->seq_num;
 	}
 
@@ -2125,7 +2125,7 @@ int recv_indicatepkt_reorder(struct rtw_adapter *padapter,
 
 _err_exit:
 
-        spin_unlock_bh(&ppending_recvframe_queue->lock);
+	spin_unlock_bh(&ppending_recvframe_queue->lock);
 	return _FAIL;
 }
 
diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 0fea2e4..76371ae 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -702,7 +702,7 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 		}
 		else{
 			RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_encrypt23a: stainfo == NULL!!!\n"));
-		                DBG_8723A("%s, psta == NUL\n", __func__);
+			DBG_8723A("%s, psta == NUL\n", __func__);
 			res = _FAIL;
 		}
 
@@ -1071,12 +1071,8 @@ static void construct_mic_header1(u8 *mic_header1, int header_length, u8 *mpdu)
 /* Builds the last MIC header block from        */
 /* header fields.                               */
 /************************************************/
-static void construct_mic_header2(
-		        u8 *mic_header2,
-		        u8 *mpdu,
-		        int a4_exists,
-		        int qc_exists
-		      )
+static void construct_mic_header2(u8 *mic_header2, u8 *mpdu, int a4_exists,
+				  int qc_exists)
 {
 	int i;
 
diff --git a/drivers/staging/rtl8723au/core/rtw_wlan_util.c b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
index bc587b3..09c44a5 100644
--- a/drivers/staging/rtl8723au/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
@@ -352,7 +352,7 @@ static void set_bwmode(struct rtw_adapter *padapter, unsigned short bwmode,
 }
 
 void set_channel_bwmode23a(struct rtw_adapter *padapter, unsigned char channel,
-		        unsigned char channel_offset, unsigned short bwmode)
+			   unsigned char channel_offset, unsigned short bwmode)
 {
 	u8 center_ch;
 
diff --git a/drivers/staging/rtl8723au/core/rtw_xmit.c b/drivers/staging/rtl8723au/core/rtw_xmit.c
index d83af87..7a80381 100644
--- a/drivers/staging/rtl8723au/core/rtw_xmit.c
+++ b/drivers/staging/rtl8723au/core/rtw_xmit.c
@@ -254,14 +254,14 @@ static void update_attrib_vcs_info(struct rtw_adapter *padapter, struct xmit_fra
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info *pmlmeinfo = &pmlmeext->mlmext_info;
 
-        if (pattrib->psta) {
+	if (pattrib->psta) {
 		psta = pattrib->psta;
 	} else {
 		DBG_8723A("%s, call rtw_get_stainfo23a()\n", __func__);
 		psta = rtw_get_stainfo23a(&padapter->stapriv, &pattrib->ra[0]);
 	}
 
-        if (psta == NULL) {
+	if (psta == NULL) {
 		DBG_8723A("%s, psta == NUL\n", __func__);
 		return;
 	}
diff --git a/drivers/staging/rtl8723au/include/ieee80211.h b/drivers/staging/rtl8723au/include/ieee80211.h
index c1a334d..cb23cd0 100644
--- a/drivers/staging/rtl8723au/include/ieee80211.h
+++ b/drivers/staging/rtl8723au/include/ieee80211.h
@@ -159,10 +159,10 @@ enum NETWORK_TYPE
 #define P80211_OUI_LEN 3
 
 struct ieee80211_snap_hdr {
-        u8    dsap;   /* always 0xAA */
-        u8    ssap;   /* always 0xAA */
-        u8    ctrl;   /* always 0x03 */
-        u8    oui[P80211_OUI_LEN];    /* organizational universal id */
+	u8    dsap;   /* always 0xAA */
+	u8    ssap;   /* always 0xAA */
+	u8    ctrl;   /* always 0x03 */
+	u8    oui[P80211_OUI_LEN];    /* organizational universal id */
 } __attribute__ ((packed));
 
 
@@ -221,8 +221,8 @@ struct ieee80211_snap_hdr {
 #define IEEE80211_CCK_BASIC_RATES_MASK	(IEEE80211_CCK_RATE_1MB_MASK | \
 	IEEE80211_CCK_RATE_2MB_MASK)
 #define IEEE80211_CCK_DEFAULT_RATES_MASK	(IEEE80211_CCK_BASIC_RATES_MASK | \
-        IEEE80211_CCK_RATE_5MB_MASK | \
-        IEEE80211_CCK_RATE_11MB_MASK)
+	IEEE80211_CCK_RATE_5MB_MASK | \
+	IEEE80211_CCK_RATE_11MB_MASK)
 
 #define IEEE80211_OFDM_RATES_MASK		0x00000FF0
 #define IEEE80211_OFDM_BASIC_RATES_MASK	(IEEE80211_OFDM_RATE_6MB_MASK | \
@@ -235,7 +235,7 @@ struct ieee80211_snap_hdr {
 	IEEE80211_OFDM_RATE_48MB_MASK | \
 	IEEE80211_OFDM_RATE_54MB_MASK)
 #define IEEE80211_DEFAULT_RATES_MASK (IEEE80211_OFDM_DEFAULT_RATES_MASK | \
-                                IEEE80211_CCK_DEFAULT_RATES_MASK)
+				      IEEE80211_CCK_DEFAULT_RATES_MASK)
 
 #define IEEE80211_NUM_OFDM_RATES	    8
 #define IEEE80211_NUM_CCK_RATES	            4
diff --git a/drivers/staging/rtl8723au/include/rtw_cmd.h b/drivers/staging/rtl8723au/include/rtw_cmd.h
index c49237b..9b3425e 100644
--- a/drivers/staging/rtl8723au/include/rtw_cmd.h
+++ b/drivers/staging/rtl8723au/include/rtw_cmd.h
@@ -547,14 +547,14 @@ struct setratable_parm {
 };
 
 struct getratable_parm {
-                uint rsvd;
+	uint rsvd;
 };
 
 struct getratable_rsp {
-        u8 ss_ForceUp[NumRates];
-        u8 ss_ULevel[NumRates];
-        u8 ss_DLevel[NumRates];
-        u8 count_judge[NumRates];
+	u8 ss_ForceUp[NumRates];
+	u8 ss_ULevel[NumRates];
+	u8 ss_DLevel[NumRates];
+	u8 count_judge[NumRates];
 };
 
 /* to get TX,RX retry count */
-- 
1.9.1

