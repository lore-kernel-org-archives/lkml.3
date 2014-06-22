Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaFVIi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:38:26 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:51467 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaFVIiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:38:19 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 26/42] staging: rtl8188eu: Replace _cancel_timer_ex() with del_timer_sync()
Date: Sun, 22 Jun 2014 14:06:32 +0530
Message-Id: <1403426208-12413-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
References: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_led.c          |   50 ++++++++++-----------
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c     |   37 ++++++++-------
 drivers/staging/rtl8188eu/include/osdep_service.h |    5 ---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |    2 +-
 drivers/staging/rtl8188eu/os_dep/os_intfs.c       |   16 +++----
 5 files changed, 52 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_led.c b/drivers/staging/rtl8188eu/core/rtw_led.c
index a266f34..384be22 100644
--- a/drivers/staging/rtl8188eu/core/rtw_led.c
+++ b/drivers/staging/rtl8188eu/core/rtw_led.c
@@ -89,7 +89,7 @@ void InitLed871x(struct adapter *padapter, struct LED_871x *pLed)
 void DeInitLed871x(struct LED_871x *pLed)
 {
 	cancel_work_sync(&(pLed->BlinkWorkItem));
-	_cancel_timer_ex(&(pLed->BlinkTimer));
+	del_timer_sync(&(pLed->BlinkTimer));
 	ResetLedStatus(pLed);
 }
 
@@ -251,11 +251,11 @@ static void SwLedControlMode1(struct adapter *padapter, enum LED_CTL_MODE LedAct
 			if (pLed->CurrLedState == LED_BLINK_SCAN || IS_LED_WPS_BLINKING(pLed))
 				return;
 			if (pLed->bLedLinkBlinkInProgress) {
-				_cancel_timer_ex(&(pLed->BlinkTimer));
+				del_timer_sync(&(pLed->BlinkTimer));
 				pLed->bLedLinkBlinkInProgress = false;
 			}
 			if (pLed->bLedBlinkInProgress) {
-				_cancel_timer_ex(&(pLed->BlinkTimer));
+				del_timer_sync(&(pLed->BlinkTimer));
 				pLed->bLedBlinkInProgress = false;
 			}
 
@@ -273,11 +273,11 @@ static void SwLedControlMode1(struct adapter *padapter, enum LED_CTL_MODE LedAct
 			if (pLed->CurrLedState == LED_BLINK_SCAN || IS_LED_WPS_BLINKING(pLed))
 				return;
 			if (pLed->bLedNoLinkBlinkInProgress) {
-				_cancel_timer_ex(&(pLed->BlinkTimer));
+				del_timer_sync(&(pLed->BlinkTimer));
 				pLed->bLedNoLinkBlinkInProgress = false;
 			}
 			if (pLed->bLedBlinkInProgress) {
-				_cancel_timer_ex(&(pLed->BlinkTimer));
+				del_timer_sync(&(pLed->BlinkTimer));
 				pLed->bLedBlinkInProgress = false;
 			}
 			pLed->bLedLinkBlinkInProgress = true;
@@ -296,15 +296,15 @@ static void SwLedControlMode1(struct adapter *padapter, enum LED_CTL_MODE LedAct
 			if (IS_LED_WPS_BLINKING(pLed))
 				return;
 			if (pLed->bLedNoLinkBlinkInProgress) {
-				_cancel_timer_ex(&(pLed->BlinkTimer));
+				del_timer_sync(&(pLed->BlinkTimer));
 				pLed->bLedNoLinkBlinkInProgress = false;
 			}
 			if (pLed->bLedLinkBlinkInProgress) {
-				_cancel_timer_ex(&(pLed->BlinkTimer));
+				del_timer_sync(&(pLed->BlinkTimer));
 				 pLed->bLedLinkBlinkInProgress = false;
 			}
 			if (pLed->bLedBlinkInProgress) {
-				_cancel_timer_ex(&(pLed->BlinkTimer));
+				del_timer_sync(&(pLed->BlinkTimer));
 				pLed->bLedBlinkInProgress = false;
 			}
 			pLed->bLedScanBlinkInProgress = true;
@@ -323,11 +323,11 @@ static void SwLedControlMode1(struct adapter *padapter, enum LED_CTL_MODE LedAct
 			if (pLed->CurrLedState == LED_BLINK_SCAN || IS_LED_WPS_BLINKING(pLed))
 				return;
 			if (pLed->bLedNoLinkBlinkInProgress) {
-				_cancel_timer_ex(&(pLed->BlinkTimer));
+				del_timer_sync(&(pLed->BlinkTimer));
 				pLed->bLedNoLinkBlinkInProgress = false;
 			}
 			if (pLed->bLedLinkBlinkInProgress) {
-				_cancel_timer_ex(&(pLed->BlinkTimer));
+				del_timer_sync(&(pLed->BlinkTimer));
 				pLed->bLedLinkBlinkInProgress = false;
 			}
 			pLed->bLedBlinkInProgress = true;
@@ -344,19 +344,19 @@ static void SwLedControlMode1(struct adapter *padapter, enum LED_CTL_MODE LedAct
 	case LED_CTL_START_WPS_BOTTON:
 		 if (!pLed->bLedWPSBlinkInProgress) {
 			if (pLed->bLedNoLinkBlinkInProgress) {
-				_cancel_timer_ex(&(pLed->BlinkTimer));
+				del_timer_sync(&(pLed->BlinkTimer));
 				pLed->bLedNoLinkBlinkInProgress = false;
 			}
 			if (pLed->bLedLinkBlinkInProgress) {
-				_cancel_timer_ex(&(pLed->BlinkTimer));
+				del_timer_sync(&(pLed->BlinkTimer));
 				 pLed->bLedLinkBlinkInProgress = false;
 			}
 			if (pLed->bLedBlinkInProgress) {
-				_cancel_timer_ex(&(pLed->BlinkTimer));
+				del_timer_sync(&(pLed->BlinkTimer));
 				pLed->bLedBlinkInProgress = false;
 			}
 			if (pLed->bLedScanBlinkInProgress) {
-				_cancel_timer_ex(&(pLed->BlinkTimer));
+				del_timer_sync(&(pLed->BlinkTimer));
 				pLed->bLedScanBlinkInProgress = false;
 			}
 			pLed->bLedWPSBlinkInProgress = true;
@@ -370,23 +370,23 @@ static void SwLedControlMode1(struct adapter *padapter, enum LED_CTL_MODE LedAct
 		break;
 	case LED_CTL_STOP_WPS:
 		if (pLed->bLedNoLinkBlinkInProgress) {
-			_cancel_timer_ex(&(pLed->BlinkTimer));
+			del_timer_sync(&(pLed->BlinkTimer));
 			pLed->bLedNoLinkBlinkInProgress = false;
 		}
 		if (pLed->bLedLinkBlinkInProgress) {
-			_cancel_timer_ex(&(pLed->BlinkTimer));
+			del_timer_sync(&(pLed->BlinkTimer));
 			 pLed->bLedLinkBlinkInProgress = false;
 		}
 		if (pLed->bLedBlinkInProgress) {
-			_cancel_timer_ex(&(pLed->BlinkTimer));
+			del_timer_sync(&(pLed->BlinkTimer));
 			pLed->bLedBlinkInProgress = false;
 		}
 		if (pLed->bLedScanBlinkInProgress) {
-			_cancel_timer_ex(&(pLed->BlinkTimer));
+			del_timer_sync(&(pLed->BlinkTimer));
 			pLed->bLedScanBlinkInProgress = false;
 		}
 		if (pLed->bLedWPSBlinkInProgress)
-			_cancel_timer_ex(&(pLed->BlinkTimer));
+			del_timer_sync(&(pLed->BlinkTimer));
 		else
 			pLed->bLedWPSBlinkInProgress = true;
 		pLed->CurrLedState = LED_BLINK_WPS_STOP;
@@ -400,7 +400,7 @@ static void SwLedControlMode1(struct adapter *padapter, enum LED_CTL_MODE LedAct
 		break;
 	case LED_CTL_STOP_WPS_FAIL:
 		if (pLed->bLedWPSBlinkInProgress) {
-			_cancel_timer_ex(&(pLed->BlinkTimer));
+			del_timer_sync(&(pLed->BlinkTimer));
 			pLed->bLedWPSBlinkInProgress = false;
 		}
 		pLed->bLedNoLinkBlinkInProgress = true;
@@ -415,23 +415,23 @@ static void SwLedControlMode1(struct adapter *padapter, enum LED_CTL_MODE LedAct
 		pLed->CurrLedState = RTW_LED_OFF;
 		pLed->BlinkingLedState = RTW_LED_OFF;
 		if (pLed->bLedNoLinkBlinkInProgress) {
-			_cancel_timer_ex(&(pLed->BlinkTimer));
+			del_timer_sync(&(pLed->BlinkTimer));
 			pLed->bLedNoLinkBlinkInProgress = false;
 		}
 		if (pLed->bLedLinkBlinkInProgress) {
-			_cancel_timer_ex(&(pLed->BlinkTimer));
+			del_timer_sync(&(pLed->BlinkTimer));
 			pLed->bLedLinkBlinkInProgress = false;
 		}
 		if (pLed->bLedBlinkInProgress) {
-			_cancel_timer_ex(&(pLed->BlinkTimer));
+			del_timer_sync(&(pLed->BlinkTimer));
 			pLed->bLedBlinkInProgress = false;
 		}
 		if (pLed->bLedWPSBlinkInProgress) {
-			_cancel_timer_ex(&(pLed->BlinkTimer));
+			del_timer_sync(&(pLed->BlinkTimer));
 			pLed->bLedWPSBlinkInProgress = false;
 		}
 		if (pLed->bLedScanBlinkInProgress) {
-			_cancel_timer_ex(&(pLed->BlinkTimer));
+			del_timer_sync(&(pLed->BlinkTimer));
 			pLed->bLedScanBlinkInProgress = false;
 		}
 		SwLedOff(padapter, pLed);
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index 480c6de..1b855b4 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -408,9 +408,8 @@ void free_mlme_ext_priv(struct mlme_ext_priv *pmlmeext)
 		return;
 
 	if (padapter->bDriverStopped) {
-		_cancel_timer_ex(&pmlmeext->survey_timer);
-		_cancel_timer_ex(&pmlmeext->link_timer);
-		/* _cancel_timer_ex(&pmlmeext->ADDBA_timer); */
+		del_timer_sync(&pmlmeext->survey_timer);
+		del_timer_sync(&pmlmeext->link_timer);
 	}
 }
 
@@ -1495,7 +1494,7 @@ unsigned int OnAssocRsp(struct adapter *padapter, struct recv_frame *precv_frame
 	if (pmlmeinfo->state & WIFI_FW_ASSOC_SUCCESS)
 		return _SUCCESS;
 
-	_cancel_timer_ex(&pmlmeext->link_timer);
+	del_timer_sync(&pmlmeext->link_timer);
 
 	/* status */
 	status = le16_to_cpu(*(__le16 *)(pframe + WLAN_HDR_A3_LEN + 2));
@@ -1578,7 +1577,7 @@ unsigned int OnDeAuth(struct adapter *padapter, struct recv_frame *precv_frame)
 
 #ifdef CONFIG_88EU_P2P
 	if (pwdinfo->rx_invitereq_info.scan_op_ch_only) {
-		_cancel_timer_ex(&pwdinfo->reset_ch_sitesurvey);
+		del_timer_sync(&pwdinfo->reset_ch_sitesurvey);
 		_set_timer(&pwdinfo->reset_ch_sitesurvey, 10);
 	}
 #endif /* CONFIG_88EU_P2P */
@@ -1642,7 +1641,7 @@ unsigned int OnDisassoc(struct adapter *padapter, struct recv_frame *precv_frame
 
 #ifdef CONFIG_88EU_P2P
 	if (pwdinfo->rx_invitereq_info.scan_op_ch_only) {
-		_cancel_timer_ex(&pwdinfo->reset_ch_sitesurvey);
+		del_timer_sync(&pwdinfo->reset_ch_sitesurvey);
 		_set_timer(&pwdinfo->reset_ch_sitesurvey, 10);
 	}
 #endif /* CONFIG_88EU_P2P */
@@ -3912,7 +3911,7 @@ static unsigned int on_action_public_p2p(struct recv_frame *precv_frame)
 		return _FAIL;
 
 #ifdef CONFIG_88EU_P2P
-	_cancel_timer_ex(&pwdinfo->reset_ch_sitesurvey);
+	del_timer_sync(&pwdinfo->reset_ch_sitesurvey);
 	/*	Do nothing if the driver doesn't enable the P2P function. */
 	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE) || rtw_p2p_chk_state(pwdinfo, P2P_STATE_IDLE))
 		return _SUCCESS;
@@ -3930,7 +3929,7 @@ static unsigned int on_action_public_p2p(struct recv_frame *precv_frame)
 		if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_GONEGO_FAIL)) {
 			/*	Commented by Albert 20110526 */
 			/*	In this case, this means the previous nego fail doesn't be reset yet. */
-			_cancel_timer_ex(&pwdinfo->restore_p2p_state_timer);
+			del_timer_sync(&pwdinfo->restore_p2p_state_timer);
 			/*	Restore the previous p2p state */
 			rtw_p2p_set_state(pwdinfo, rtw_p2p_pre_state(pwdinfo));
 			DBG_88E("[%s] Restore the previous p2p state to %d\n", __func__, rtw_p2p_state(pwdinfo));
@@ -3960,7 +3959,7 @@ static unsigned int on_action_public_p2p(struct recv_frame *precv_frame)
 		if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_GONEGO_ING)) {
 			/*	Commented by Albert 20110425 */
 			/*	The restore timer is enabled when issuing the nego request frame of rtw_p2p_connect function. */
-			_cancel_timer_ex(&pwdinfo->restore_p2p_state_timer);
+			del_timer_sync(&pwdinfo->restore_p2p_state_timer);
 			pwdinfo->nego_req_info.benable = false;
 			result = process_p2p_group_negotation_resp(pwdinfo, frame_body, len);
 			issue_p2p_GO_confirm(pwdinfo->padapter, GetAddr2Ptr(pframe), result);
@@ -4111,7 +4110,7 @@ static unsigned int on_action_public_p2p(struct recv_frame *precv_frame)
 		u32	attr_contentlen = 0;
 
 		DBG_88E("[%s] Got invite response frame!\n", __func__);
-		_cancel_timer_ex(&pwdinfo->restore_p2p_state_timer);
+		del_timer_sync(&pwdinfo->restore_p2p_state_timer);
 		p2p_ie = rtw_get_p2p_ie(frame_body + _PUBLIC_ACTION_IE_OFFSET_, len - _PUBLIC_ACTION_IE_OFFSET_, NULL, &p2p_ielen);
 		if (p2p_ie) {
 			rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_STATUS, &attr_content, &attr_contentlen);
@@ -4169,7 +4168,7 @@ static unsigned int on_action_public_p2p(struct recv_frame *precv_frame)
 		DBG_88E("[%s] Got Provisioning Discovery Response Frame\n", __func__);
 		/*	Commented by Albert 20110426 */
 		/*	The restore timer is enabled when issuing the provisioing request frame in rtw_p2p_prov_disc function. */
-		_cancel_timer_ex(&pwdinfo->restore_p2p_state_timer);
+		del_timer_sync(&pwdinfo->restore_p2p_state_timer);
 		rtw_p2p_set_state(pwdinfo, P2P_STATE_RX_PROVISION_DIS_RSP);
 		process_p2p_provdisc_resp(pwdinfo, pframe);
 		_set_timer(&pwdinfo->restore_p2p_state_timer, P2P_PROVISION_TIMEOUT);
@@ -5866,7 +5865,7 @@ static int _issue_deauth(struct adapter *padapter, unsigned char *da, unsigned s
 
 #ifdef CONFIG_88EU_P2P
 	if (!(rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE)) && (pwdinfo->rx_invitereq_info.scan_op_ch_only)) {
-		_cancel_timer_ex(&pwdinfo->reset_ch_sitesurvey);
+		del_timer_sync(&pwdinfo->reset_ch_sitesurvey);
 		_set_timer(&pwdinfo->reset_ch_sitesurvey, 10);
 	}
 #endif /* CONFIG_88EU_P2P */
@@ -6813,7 +6812,7 @@ void start_clnt_auth(struct adapter *padapter)
 	struct mlme_ext_priv	*pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
 
-	_cancel_timer_ex(&pmlmeext->link_timer);
+	del_timer_sync(&pmlmeext->link_timer);
 
 	pmlmeinfo->state &= (~WIFI_FW_AUTH_NULL);
 	pmlmeinfo->state |= WIFI_FW_AUTH_STATE;
@@ -6844,7 +6843,7 @@ void start_clnt_assoc(struct adapter *padapter)
 	struct mlme_ext_priv	*pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
 
-	_cancel_timer_ex(&pmlmeext->link_timer);
+	del_timer_sync(&pmlmeext->link_timer);
 
 	pmlmeinfo->state &= (~(WIFI_FW_AUTH_NULL | WIFI_FW_AUTH_STATE));
 	pmlmeinfo->state |= (WIFI_FW_AUTH_SUCCESS | WIFI_FW_ASSOC_STATE);
@@ -7491,7 +7490,7 @@ void mlmeext_sta_del_event_callback(struct adapter *padapter)
 		/* set MSR to no link state -> infra. mode */
 		Set_MSR(padapter, _HW_STATE_STATION_);
 
-		_cancel_timer_ex(&pmlmeext->link_timer);
+		del_timer_sync(&pmlmeext->link_timer);
 	}
 }
 
@@ -7829,7 +7828,7 @@ u8 createbss_hdl(struct adapter *padapter, u8 *pbuf)
 		/* rtw_hal_set_hwreg(padapter, HW_VAR_INITIAL_GAIN, (u8 *)(&initialgain)); */
 
 		/* cancel link timer */
-		_cancel_timer_ex(&pmlmeext->link_timer);
+		del_timer_sync(&pmlmeext->link_timer);
 
 		/* clear CAM */
 		flush_all_cam_entry(padapter);
@@ -7869,7 +7868,7 @@ u8 join_cmd_hdl(struct adapter *padapter, u8 *pbuf)
 		/* clear CAM */
 		flush_all_cam_entry(padapter);
 
-		_cancel_timer_ex(&pmlmeext->link_timer);
+		del_timer_sync(&pmlmeext->link_timer);
 
 		/* set MSR to nolink -> infra. mode */
 		Set_MSR(padapter, _HW_STATE_STATION_);
@@ -7955,7 +7954,7 @@ u8 join_cmd_hdl(struct adapter *padapter, u8 *pbuf)
 	rtw_hal_set_hwreg(padapter, HW_VAR_MLME_JOIN, (u8 *)(&join_type));
 
 	/* cancel link timer */
-	_cancel_timer_ex(&pmlmeext->link_timer);
+	del_timer_sync(&pmlmeext->link_timer);
 
 	start_clnt_join(padapter);
 
@@ -7999,7 +7998,7 @@ u8 disconnect_hdl(struct adapter *padapter, unsigned char *pbuf)
 
 	flush_all_cam_entry(padapter);
 
-	_cancel_timer_ex(&pmlmeext->link_timer);
+	del_timer_sync(&pmlmeext->link_timer);
 
 	rtw_free_uc_swdec_pending_queue(padapter);
 
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 27a610f..64ef9bd 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -171,11 +171,6 @@ u32  rtw_systime_to_ms(u32 systime);
 u32  rtw_ms_to_systime(u32 ms);
 s32  rtw_get_passing_time_ms(u32 start);
 
-static inline unsigned char _cancel_timer_ex(struct timer_list *ptimer)
-{
-	return del_timer_sync(ptimer);
-}
-
 static inline void thread_enter(char *name)
 {
 	allow_signal(SIGTERM);
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 128efc4..221366f 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -3441,7 +3441,7 @@ static int rtw_p2p_connect(struct net_device *dev,
 		memcpy(pwdinfo->nego_req_info.peerDevAddr, pnetwork->network.MacAddress, ETH_ALEN);
 		pwdinfo->nego_req_info.benable = true;
 
-		_cancel_timer_ex(&pwdinfo->restore_p2p_state_timer);
+		del_timer_sync(&pwdinfo->restore_p2p_state_timer);
 		if (rtw_p2p_state(pwdinfo) != P2P_STATE_GONEGO_OK) {
 			/*	Restore to the listen state if the current p2p state is not nego OK */
 			rtw_p2p_set_state(pwdinfo, P2P_STATE_LISTEN);
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index 19fd812..7536be6 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -930,22 +930,22 @@ void rtw_cancel_all_timer(struct adapter *padapter)
 {
 	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("+rtw_cancel_all_timer\n"));
 
-	_cancel_timer_ex(&padapter->mlmepriv.assoc_timer);
+	del_timer_sync(&padapter->mlmepriv.assoc_timer);
 	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("rtw_cancel_all_timer:cancel association timer complete!\n"));
 
-	_cancel_timer_ex(&padapter->mlmepriv.scan_to_timer);
+	del_timer_sync(&padapter->mlmepriv.scan_to_timer);
 	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("rtw_cancel_all_timer:cancel scan_to_timer!\n"));
 
-	_cancel_timer_ex(&padapter->mlmepriv.dynamic_chk_timer);
+	del_timer_sync(&padapter->mlmepriv.dynamic_chk_timer);
 	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("rtw_cancel_all_timer:cancel dynamic_chk_timer!\n"));
 
 	/*  cancel sw led timer */
 	rtw_hal_sw_led_deinit(padapter);
 	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("rtw_cancel_all_timer:cancel DeInitSwLeds!\n"));
 
-	_cancel_timer_ex(&padapter->pwrctrlpriv.pwr_state_check_timer);
+	del_timer_sync(&padapter->pwrctrlpriv.pwr_state_check_timer);
 
-	_cancel_timer_ex(&padapter->recvpriv.signal_stat_timer);
+	del_timer_sync(&padapter->recvpriv.signal_stat_timer);
 }
 
 u8 rtw_free_drv_sw(struct adapter *padapter)
@@ -959,9 +959,9 @@ u8 rtw_free_drv_sw(struct adapter *padapter)
 	{
 		struct wifidirect_info *pwdinfo = &padapter->wdinfo;
 		if (!rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE)) {
-			_cancel_timer_ex(&pwdinfo->find_phase_timer);
-			_cancel_timer_ex(&pwdinfo->restore_p2p_state_timer);
-			_cancel_timer_ex(&pwdinfo->pre_tx_scan_timer);
+			del_timer_sync(&pwdinfo->find_phase_timer);
+			del_timer_sync(&pwdinfo->restore_p2p_state_timer);
+			del_timer_sync(&pwdinfo->pre_tx_scan_timer);
 			rtw_p2p_set_state(pwdinfo, P2P_STATE_NONE);
 		}
 	}
-- 
1.7.10.4

