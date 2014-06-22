Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaFVIhH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:37:07 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:48369 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaFVIg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:36:57 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 17/42] staging: rtl8188eu:Remove rtw_zmalloc(), wrapper for kzalloc()
Date: Sun, 22 Jun 2014 14:06:23 +0530
Message-Id: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c          |  124 ++++++++++-----------
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |    4 +-
 drivers/staging/rtl8188eu/core/rtw_mlme.c         |    8 +-
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c     |   28 ++---
 drivers/staging/rtl8188eu/core/rtw_mp.c           |    2 +-
 drivers/staging/rtl8188eu/core/rtw_p2p.c          |    8 +-
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c    |    2 +-
 drivers/staging/rtl8188eu/core/rtw_xmit.c         |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c      |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c    |    2 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c       |    2 +-
 drivers/staging/rtl8188eu/include/osdep_service.h |    2 -
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |   24 ++--
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |   11 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c       |    4 +-
 drivers/staging/rtl8188eu/os_dep/xmit_linux.c     |    2 +-
 16 files changed, 108 insertions(+), 119 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 29f45e8..3f37927 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -47,7 +47,7 @@ int _rtw_init_cmd_priv(struct cmd_priv *pcmdpriv)
 
 	pcmdpriv->cmd_seq = 1;
 
-	pcmdpriv->cmd_allocated_buf = rtw_zmalloc(MAX_CMDSZ + CMDBUFF_ALIGN_SZ);
+	pcmdpriv->cmd_allocated_buf = kzalloc(MAX_CMDSZ + CMDBUFF_ALIGN_SZ, GFP_KERNEL);
 
 	if (pcmdpriv->cmd_allocated_buf == NULL) {
 		res = _FAIL;
@@ -56,7 +56,7 @@ int _rtw_init_cmd_priv(struct cmd_priv *pcmdpriv)
 
 	pcmdpriv->cmd_buf = pcmdpriv->cmd_allocated_buf  +  CMDBUFF_ALIGN_SZ - ((size_t)(pcmdpriv->cmd_allocated_buf) & (CMDBUFF_ALIGN_SZ-1));
 
-	pcmdpriv->rsp_allocated_buf = rtw_zmalloc(MAX_RSPSZ + 4);
+	pcmdpriv->rsp_allocated_buf = kzalloc(MAX_RSPSZ + 4, GFP_KERNEL);
 
 	if (pcmdpriv->rsp_allocated_buf == NULL) {
 		res = _FAIL;
@@ -437,11 +437,11 @@ u8 rtw_sitesurvey_cmd(struct adapter  *padapter, struct ndis_802_11_ssid *ssid,
 	if (check_fwstate(pmlmepriv, _FW_LINKED) == true)
 		p2p_ps_wk_cmd(padapter, P2P_PS_SCAN, 1);
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL)
 		return _FAIL;
 
-	psurveyPara = (struct sitesurvey_parm *)rtw_zmalloc(sizeof(struct sitesurvey_parm));
+	psurveyPara = kzalloc(sizeof(struct sitesurvey_parm), GFP_KERNEL);
 	if (psurveyPara == NULL) {
 		kfree(ph2c);
 		return _FAIL;
@@ -506,13 +506,13 @@ u8 rtw_setdatarate_cmd(struct adapter *padapter, u8 *rateset)
 	u8	res = _SUCCESS;
 
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
 
-	pbsetdataratepara = (struct setdatarate_parm *)rtw_zmalloc(sizeof(struct setdatarate_parm));
+	pbsetdataratepara = kzalloc(sizeof(struct setdatarate_parm), GFP_KERNEL);
 	if (pbsetdataratepara == NULL) {
 		kfree(ph2c);
 		res = _FAIL;
@@ -537,12 +537,12 @@ u8 rtw_setbasicrate_cmd(struct adapter *padapter, u8 *rateset)
 	u8	res = _SUCCESS;
 
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
-	pssetbasicratepara = (struct setbasicrate_parm *)rtw_zmalloc(sizeof(struct setbasicrate_parm));
+	pssetbasicratepara = kzalloc(sizeof(struct setbasicrate_parm), GFP_KERNEL);
 
 	if (pssetbasicratepara == NULL) {
 		kfree(ph2c);
@@ -577,12 +577,12 @@ u8 rtw_setphy_cmd(struct adapter *padapter, u8 modem, u8 ch)
 	u8	res = _SUCCESS;
 
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 		}
-	psetphypara = (struct setphy_parm *)rtw_zmalloc(sizeof(struct setphy_parm));
+	psetphypara = kzalloc(sizeof(struct setphy_parm), GFP_KERNEL);
 
 	if (psetphypara == NULL) {
 		kfree(ph2c);
@@ -609,12 +609,12 @@ u8 rtw_setbbreg_cmd(struct adapter *padapter, u8 offset, u8 val)
 	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
 	u8	res = _SUCCESS;
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 		}
-	pwritebbparm = (struct writeBB_parm *)rtw_zmalloc(sizeof(struct writeBB_parm));
+	pwritebbparm = kzalloc(sizeof(struct writeBB_parm), GFP_KERNEL);
 
 	if (pwritebbparm == NULL) {
 		kfree(ph2c);
@@ -639,12 +639,12 @@ u8 rtw_getbbreg_cmd(struct adapter  *padapter, u8 offset, u8 *pval)
 	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
 	u8	res = _SUCCESS;
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 		}
-	prdbbparm = (struct readBB_parm *)rtw_zmalloc(sizeof(struct readBB_parm));
+	prdbbparm = kzalloc(sizeof(struct readBB_parm), GFP_KERNEL);
 
 	if (prdbbparm == NULL) {
 		kfree(ph2c);
@@ -671,12 +671,12 @@ u8 rtw_setrfreg_cmd(struct adapter  *padapter, u8 offset, u32 val)
 	struct writeRF_parm *pwriterfparm;
 	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
 	u8	res = _SUCCESS;
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
-	pwriterfparm = (struct writeRF_parm *)rtw_zmalloc(sizeof(struct writeRF_parm));
+	pwriterfparm = kzalloc(sizeof(struct writeRF_parm), GFP_KERNEL);
 
 	if (pwriterfparm == NULL) {
 		kfree(ph2c);
@@ -702,13 +702,13 @@ u8 rtw_getrfreg_cmd(struct adapter  *padapter, u8 offset, u8 *pval)
 	u8	res = _SUCCESS;
 
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
 
-	prdrfparm = (struct readRF_parm *)rtw_zmalloc(sizeof(struct readRF_parm));
+	prdrfparm = kzalloc(sizeof(struct readRF_parm), GFP_KERNEL);
 	if (prdrfparm == NULL) {
 		kfree(ph2c);
 		res = _FAIL;
@@ -768,7 +768,7 @@ u8 rtw_createbss_cmd(struct adapter  *padapter)
 	else
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_info_, (" createbss for SSid:%s\n", pmlmepriv->assoc_ssid.Ssid));
 
-	pcmd = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	pcmd = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (pcmd == NULL) {
 		res = _FAIL;
 		goto exit;
@@ -795,7 +795,7 @@ u8 rtw_createbss_cmd_ex(struct adapter  *padapter, unsigned char *pbss, unsigned
 	u8	res = _SUCCESS;
 
 
-	pcmd = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	pcmd = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (pcmd == NULL) {
 		res = _FAIL;
 		goto exit;
@@ -840,7 +840,7 @@ u8 rtw_joinbss_cmd(struct adapter  *padapter, struct wlan_network *pnetwork)
 	else
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_notice_, ("+Join cmd: SSid =[%s]\n", pmlmepriv->assoc_ssid.Ssid));
 
-	pcmd = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	pcmd = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (pcmd == NULL) {
 		res = _FAIL;
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_, ("rtw_joinbss_cmd: memory allocate for cmd_obj fail!!!\n"));
@@ -969,7 +969,7 @@ u8 rtw_disassoc_cmd(struct adapter *padapter, u32 deauth_timeout_ms, bool enqueu
 	RT_TRACE(_module_rtl871x_cmd_c_, _drv_notice_, ("+rtw_disassoc_cmd\n"));
 
 	/* prepare cmd parameter */
-	param = (struct disconnect_parm *)rtw_zmalloc(sizeof(*param));
+	param = kzalloc(sizeof(*param), GFP_KERNEL);
 	if (param == NULL) {
 		res = _FAIL;
 		goto exit;
@@ -978,7 +978,7 @@ u8 rtw_disassoc_cmd(struct adapter *padapter, u32 deauth_timeout_ms, bool enqueu
 
 	if (enqueue) {
 		/* need enqueue, prepare cmd_obj and enqueue */
-		cmdobj = (struct cmd_obj *)rtw_zmalloc(sizeof(*cmdobj));
+		cmdobj = kzalloc(sizeof(*cmdobj), GFP_KERNEL);
 		if (cmdobj == NULL) {
 			res = _FAIL;
 			kfree(param);
@@ -1008,12 +1008,12 @@ u8 rtw_setopmode_cmd(struct adapter  *padapter, enum ndis_802_11_network_infra n
 	u8	res = _SUCCESS;
 
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = false;
 		goto exit;
 	}
-	psetop = (struct setopmode_parm *)rtw_zmalloc(sizeof(struct setopmode_parm));
+	psetop = kzalloc(sizeof(struct setopmode_parm), GFP_KERNEL);
 
 	if (psetop == NULL) {
 		kfree(ph2c);
@@ -1045,20 +1045,20 @@ u8 rtw_setstakey_cmd(struct adapter *padapter, u8 *psta, u8 unicast_key)
 	u8	res = _SUCCESS;
 
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
 
-	psetstakey_para = (struct set_stakey_parm *)rtw_zmalloc(sizeof(struct set_stakey_parm));
+	psetstakey_para = kzalloc(sizeof(struct set_stakey_parm), GFP_KERNEL);
 	if (psetstakey_para == NULL) {
 		kfree(ph2c);
 		res = _FAIL;
 		goto exit;
 	}
 
-	psetstakey_rsp = (struct set_stakey_rsp *)rtw_zmalloc(sizeof(struct set_stakey_rsp));
+	psetstakey_rsp = kzalloc(sizeof(struct set_stakey_rsp), GFP_KERNEL);
 	if (psetstakey_rsp == NULL) {
 		kfree(ph2c);
 		kfree(psetstakey_para);
@@ -1106,20 +1106,20 @@ u8 rtw_clearstakey_cmd(struct adapter *padapter, u8 *psta, u8 entry, u8 enqueue)
 	if (!enqueue) {
 		clear_cam_entry(padapter, entry);
 	} else {
-		ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+		ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 		if (ph2c == NULL) {
 			res = _FAIL;
 			goto exit;
 		}
 
-		psetstakey_para = (struct set_stakey_parm *)rtw_zmalloc(sizeof(struct set_stakey_parm));
+		psetstakey_para = kzalloc(sizeof(struct set_stakey_parm), GFP_KERNEL);
 		if (psetstakey_para == NULL) {
 			kfree(ph2c);
 			res = _FAIL;
 			goto exit;
 		}
 
-		psetstakey_rsp = (struct set_stakey_rsp *)rtw_zmalloc(sizeof(struct set_stakey_rsp));
+		psetstakey_rsp = kzalloc(sizeof(struct set_stakey_rsp), GFP_KERNEL);
 		if (psetstakey_rsp == NULL) {
 			kfree(ph2c);
 			kfree(psetstakey_para);
@@ -1152,12 +1152,12 @@ u8 rtw_setrttbl_cmd(struct adapter  *padapter, struct setratable_parm *prate_tab
 	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
 	u8	res = _SUCCESS;
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
-	psetrttblparm = (struct setratable_parm *)rtw_zmalloc(sizeof(struct setratable_parm));
+	psetrttblparm = kzalloc(sizeof(struct setratable_parm), GFP_KERNEL);
 
 	if (psetrttblparm == NULL) {
 		kfree(ph2c);
@@ -1181,12 +1181,12 @@ u8 rtw_getrttbl_cmd(struct adapter  *padapter, struct getratable_rsp *pval)
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 	u8	res = _SUCCESS;
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
-	pgetrttblparm = (struct getratable_parm *)rtw_zmalloc(sizeof(struct getratable_parm));
+	pgetrttblparm = kzalloc(sizeof(struct getratable_parm), GFP_KERNEL);
 
 	if (pgetrttblparm == NULL) {
 		kfree(ph2c);
@@ -1218,20 +1218,20 @@ u8 rtw_setassocsta_cmd(struct adapter  *padapter, u8 *mac_addr)
 	u8	res = _SUCCESS;
 
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
 
-	psetassocsta_para = (struct set_assocsta_parm *)rtw_zmalloc(sizeof(struct set_assocsta_parm));
+	psetassocsta_para = kzalloc(sizeof(struct set_assocsta_parm), GFP_KERNEL);
 	if (psetassocsta_para == NULL) {
 		kfree(ph2c);
 		res = _FAIL;
 		goto exit;
 	}
 
-	psetassocsta_rsp = (struct set_stakey_rsp *)rtw_zmalloc(sizeof(struct set_assocsta_rsp));
+	psetassocsta_rsp = kzalloc(sizeof(struct set_assocsta_rsp), GFP_KERNEL);
 	if (psetassocsta_rsp == NULL) {
 		kfree(ph2c);
 		kfree(psetassocsta_para);
@@ -1260,13 +1260,13 @@ u8 rtw_addbareq_cmd(struct adapter *padapter, u8 tid, u8 *addr)
 	u8	res = _SUCCESS;
 
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
 
-	paddbareq_parm = (struct addBaReq_parm *)rtw_zmalloc(sizeof(struct addBaReq_parm));
+	paddbareq_parm = kzalloc(sizeof(struct addBaReq_parm), GFP_KERNEL);
 	if (paddbareq_parm == NULL) {
 		kfree(ph2c);
 		res = _FAIL;
@@ -1297,13 +1297,13 @@ u8 rtw_dynamic_chk_wk_cmd(struct adapter *padapter)
 	u8	res = _SUCCESS;
 
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
 
-	pdrvextra_cmd_parm = (struct drvextra_cmd_parm *)rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
+	pdrvextra_cmd_parm = kzalloc(sizeof(struct drvextra_cmd_parm), GFP_KERNEL);
 	if (pdrvextra_cmd_parm == NULL) {
 		kfree(ph2c);
 		res = _FAIL;
@@ -1338,7 +1338,7 @@ u8 rtw_set_ch_cmd(struct adapter *padapter, u8 ch, u8 bw, u8 ch_offset, u8 enque
 	/* check input parameter */
 
 	/* prepare cmd parameter */
-	set_ch_parm = (struct set_ch_parm *)rtw_zmalloc(sizeof(*set_ch_parm));
+	set_ch_parm = kzalloc(sizeof(*set_ch_parm), GFP_KERNEL);
 	if (set_ch_parm == NULL) {
 		res = _FAIL;
 		goto exit;
@@ -1349,7 +1349,7 @@ u8 rtw_set_ch_cmd(struct adapter *padapter, u8 ch, u8 bw, u8 ch_offset, u8 enque
 
 	if (enqueue) {
 		/* need enqueue, prepare cmd_obj and enqueue */
-		pcmdobj = (struct cmd_obj *)rtw_zmalloc(sizeof(struct	cmd_obj));
+		pcmdobj = kzalloc(sizeof(struct	cmd_obj), GFP_KERNEL);
 		if (pcmdobj == NULL) {
 			kfree(set_ch_parm);
 			res = _FAIL;
@@ -1394,7 +1394,7 @@ u8 rtw_set_chplan_cmd(struct adapter *padapter, u8 chplan, u8 enqueue)
 	}
 
 	/* prepare cmd parameter */
-	setChannelPlan_param = (struct	SetChannelPlan_param *)rtw_zmalloc(sizeof(struct SetChannelPlan_param));
+	setChannelPlan_param = kzalloc(sizeof(struct SetChannelPlan_param), GFP_KERNEL);
 	if (setChannelPlan_param == NULL) {
 		res = _FAIL;
 		goto exit;
@@ -1403,7 +1403,7 @@ u8 rtw_set_chplan_cmd(struct adapter *padapter, u8 chplan, u8 enqueue)
 
 	if (enqueue) {
 		/* need enqueue, prepare cmd_obj and enqueue */
-		pcmdobj = (struct cmd_obj *)rtw_zmalloc(sizeof(struct	cmd_obj));
+		pcmdobj = kzalloc(sizeof(struct	cmd_obj), GFP_KERNEL);
 		if (pcmdobj == NULL) {
 			kfree(setChannelPlan_param);
 			res = _FAIL;
@@ -1441,13 +1441,13 @@ u8 rtw_set_csa_cmd(struct adapter *padapter, u8 new_ch_no)
 
 	RT_TRACE(_module_rtl871x_cmd_c_, _drv_notice_, ("+rtw_set_csa_cmd\n"));
 
-	pcmdobj = (struct cmd_obj *)rtw_zmalloc(sizeof(struct	cmd_obj));
+	pcmdobj = kzalloc(sizeof(struct	cmd_obj), GFP_KERNEL);
 	if (pcmdobj == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
 
-	setChannelSwitch_param = (struct SetChannelSwitch_param *)rtw_zmalloc(sizeof(struct	SetChannelSwitch_param));
+	setChannelSwitch_param = kzalloc(sizeof(struct	SetChannelSwitch_param), GFP_KERNEL);
 	if (setChannelSwitch_param == NULL) {
 		kfree(pcmdobj);
 		res = _FAIL;
@@ -1602,13 +1602,13 @@ u8 rtw_lps_ctrl_wk_cmd(struct adapter *padapter, u8 lps_ctrl_type, u8 enqueue)
 	u8	res = _SUCCESS;
 
 	if (enqueue) {
-		ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+		ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 		if (ph2c == NULL) {
 			res = _FAIL;
 			goto exit;
 		}
 
-		pdrvextra_cmd_parm = (struct drvextra_cmd_parm *)rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
+		pdrvextra_cmd_parm = kzalloc(sizeof(struct drvextra_cmd_parm), GFP_KERNEL);
 		if (pdrvextra_cmd_parm == NULL) {
 			kfree(ph2c);
 			res = _FAIL;
@@ -1645,13 +1645,13 @@ u8 rtw_rpt_timer_cfg_cmd(struct adapter *padapter, u16 min_time)
 
 	u8	res = _SUCCESS;
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
 
-	pdrvextra_cmd_parm = (struct drvextra_cmd_parm *)rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
+	pdrvextra_cmd_parm = kzalloc(sizeof(struct drvextra_cmd_parm), GFP_KERNEL);
 	if (pdrvextra_cmd_parm == NULL) {
 		kfree(ph2c);
 		res = _FAIL;
@@ -1687,13 +1687,13 @@ u8 rtw_antenna_select_cmd(struct adapter *padapter, u8 antenna, u8 enqueue)
 		return res;
 
 	if (enqueue) {
-		ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+		ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 		if (ph2c == NULL) {
 			res = _FAIL;
 			goto exit;
 		}
 
-		pdrvextra_cmd_parm = (struct drvextra_cmd_parm *)rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
+		pdrvextra_cmd_parm = kzalloc(sizeof(struct drvextra_cmd_parm), GFP_KERNEL);
 		if (pdrvextra_cmd_parm == NULL) {
 			kfree(ph2c);
 			res = _FAIL;
@@ -1733,13 +1733,13 @@ u8 p2p_protocol_wk_cmd(struct adapter *padapter, int intCmdType)
 	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE))
 		return res;
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
 
-	pdrvextra_cmd_parm = (struct drvextra_cmd_parm *)rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
+	pdrvextra_cmd_parm = kzalloc(sizeof(struct drvextra_cmd_parm), GFP_KERNEL);
 	if (pdrvextra_cmd_parm == NULL) {
 		kfree(ph2c);
 		res = _FAIL;
@@ -1769,13 +1769,13 @@ u8 rtw_ps_cmd(struct adapter *padapter)
 
 	u8	res = _SUCCESS;
 
-	ppscmd = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ppscmd = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ppscmd == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
 
-	pdrvextra_cmd_parm = (struct drvextra_cmd_parm *)rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
+	pdrvextra_cmd_parm = kzalloc(sizeof(struct drvextra_cmd_parm), GFP_KERNEL);
 	if (pdrvextra_cmd_parm == NULL) {
 		kfree(ppscmd);
 		res = _FAIL;
@@ -1843,13 +1843,13 @@ u8 rtw_chk_hi_queue_cmd(struct adapter *padapter)
 	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
 	u8	res = _SUCCESS;
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
 
-	pdrvextra_cmd_parm = (struct drvextra_cmd_parm *)rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
+	pdrvextra_cmd_parm = kzalloc(sizeof(struct drvextra_cmd_parm), GFP_KERNEL);
 	if (pdrvextra_cmd_parm == NULL) {
 		kfree(ph2c);
 		res = _FAIL;
@@ -1875,13 +1875,13 @@ u8 rtw_c2h_wk_cmd(struct adapter *padapter, u8 *c2h_evt)
 	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
 	u8	res = _SUCCESS;
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
 
-	pdrvextra_cmd_parm = (struct drvextra_cmd_parm *)rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
+	pdrvextra_cmd_parm = kzalloc(sizeof(struct drvextra_cmd_parm), GFP_KERNEL);
 	if (pdrvextra_cmd_parm == NULL) {
 		kfree(ph2c);
 		res = _FAIL;
diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index baaf276..82a54b5 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -103,7 +103,7 @@ efuse_phymap_to_logical(u8 *phymap, u16 _offset, u16 _size_byte, u8  *pbuf)
 	u16	efuse_utilized = 0;
 	u8 u1temp = 0;
 
-	efuseTbl = (u8 *)rtw_zmalloc(EFUSE_MAP_LEN_88E);
+	efuseTbl = kzalloc(EFUSE_MAP_LEN_88E, GFP_KERNEL);
 	if (efuseTbl == NULL) {
 		DBG_88E("%s: alloc efuseTbl fail!\n", __func__);
 		goto exit;
@@ -1083,7 +1083,7 @@ u8 rtw_efuse_map_write(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
 	if ((addr + cnts) > mapLen)
 		return _FAIL;
 
-	map = rtw_zmalloc(mapLen);
+	map = kzalloc(mapLen, GFP_KERNEL);
 	if (map == NULL)
 		return _FAIL;
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index f0ad0c5..f619829 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -1666,13 +1666,13 @@ int rtw_set_auth(struct adapter *adapter, struct security_priv *psecuritypriv)
 	struct	cmd_priv *pcmdpriv = &(adapter->cmdpriv);
 	int		res = _SUCCESS;
 
-	pcmd = (struct	cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	pcmd = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (pcmd == NULL) {
 		res = _FAIL;  /* try again */
 		goto exit;
 	}
 
-	psetauthparm = (struct setauth_parm *)rtw_zmalloc(sizeof(struct setauth_parm));
+	psetauthparm = kzalloc(sizeof(struct setauth_parm), GFP_KERNEL);
 	if (psetauthparm == NULL) {
 		kfree(pcmd);
 		res = _FAIL;
@@ -1703,11 +1703,11 @@ int rtw_set_key(struct adapter *adapter, struct security_priv *psecuritypriv, in
 	struct mlme_priv		*pmlmepriv = &(adapter->mlmepriv);
 	int	res = _SUCCESS;
 
-	pcmd = (struct	cmd_obj *)rtw_zmalloc(sizeof(struct	cmd_obj));
+	pcmd = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (pcmd == NULL)
 		return _FAIL;  /* try again */
 
-	psetkeyparm = (struct setkey_parm *)rtw_zmalloc(sizeof(struct setkey_parm));
+	psetkeyparm = kzalloc(sizeof(struct setkey_parm), GFP_KERNEL);
 	if (psetkeyparm == NULL) {
 		res = _FAIL;
 		goto err_free_cmd;
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index 6244555..08b5620 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -7055,12 +7055,12 @@ void report_survey_event(struct adapter *padapter,
 	pcmdpriv = &padapter->cmdpriv;
 
 
-	pcmd_obj = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	pcmd_obj = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (pcmd_obj == NULL)
 		return;
 
 	cmdsz = (sizeof(struct survey_event) + sizeof(struct C2HEvent_Header));
-	pevtcmd = (u8 *)rtw_zmalloc(cmdsz);
+	pevtcmd = kzalloc(cmdsz, GFP_KERNEL);
 	if (pevtcmd == NULL) {
 		kfree(pcmd_obj);
 		return;
@@ -7107,12 +7107,12 @@ void report_surveydone_event(struct adapter *padapter)
 	struct mlme_ext_priv		*pmlmeext = &padapter->mlmeextpriv;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	pcmd_obj = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	pcmd_obj = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (pcmd_obj == NULL)
 		return;
 
 	cmdsz = (sizeof(struct surveydone_event) + sizeof(struct C2HEvent_Header));
-	pevtcmd = (u8 *)rtw_zmalloc(cmdsz);
+	pevtcmd = kzalloc(cmdsz, GFP_KERNEL);
 	if (pevtcmd == NULL) {
 		kfree(pcmd_obj);
 		return;
@@ -7153,12 +7153,12 @@ void report_join_res(struct adapter *padapter, int res)
 	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	pcmd_obj = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	pcmd_obj = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (pcmd_obj == NULL)
 		return;
 
 	cmdsz = (sizeof(struct joinbss_event) + sizeof(struct C2HEvent_Header));
-	pevtcmd = (u8 *)rtw_zmalloc(cmdsz);
+	pevtcmd = kzalloc(cmdsz, GFP_KERNEL);
 	if (pevtcmd == NULL) {
 		kfree(pcmd_obj);
 		return;
@@ -7206,12 +7206,12 @@ void report_del_sta_event(struct adapter *padapter, unsigned char *MacAddr, unsi
 	struct mlme_ext_priv		*pmlmeext = &padapter->mlmeextpriv;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	pcmd_obj = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	pcmd_obj = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (pcmd_obj == NULL)
 		return;
 
 	cmdsz = (sizeof(struct stadel_event) + sizeof(struct C2HEvent_Header));
-	pevtcmd = (u8 *)rtw_zmalloc(cmdsz);
+	pevtcmd = kzalloc(cmdsz, GFP_KERNEL);
 	if (pevtcmd == NULL) {
 		kfree(pcmd_obj);
 		return;
@@ -7261,12 +7261,12 @@ void report_add_sta_event(struct adapter *padapter, unsigned char *MacAddr, int
 	struct mlme_ext_priv		*pmlmeext = &padapter->mlmeextpriv;
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 
-	pcmd_obj = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	pcmd_obj = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (pcmd_obj == NULL)
 		return;
 
 	cmdsz = (sizeof(struct stassoc_event) + sizeof(struct C2HEvent_Header));
-	pevtcmd = (u8 *)rtw_zmalloc(cmdsz);
+	pevtcmd = kzalloc(cmdsz, GFP_KERNEL);
 	if (pevtcmd == NULL) {
 		kfree(pcmd_obj);
 		return;
@@ -7686,11 +7686,11 @@ void survey_timer_hdl(struct adapter *padapter)
 			pmlmeext->scan_abort = false;/* reset */
 		}
 
-		ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+		ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 		if (ph2c == NULL)
 			goto exit_survey_timer_hdl;
 
-		psurveyPara = (struct sitesurvey_parm *)rtw_zmalloc(sizeof(struct sitesurvey_parm));
+		psurveyPara = kzalloc(sizeof(struct sitesurvey_parm), GFP_KERNEL);
 		if (psurveyPara == NULL) {
 			kfree(ph2c);
 			goto exit_survey_timer_hdl;
@@ -8268,13 +8268,13 @@ u8 set_tx_beacon_cmd(struct adapter *padapter)
 	int len_diff = 0;
 
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
 
-	ptxBeacon_parm = (struct Tx_Beacon_param *)rtw_zmalloc(sizeof(struct Tx_Beacon_param));
+	ptxBeacon_parm = kzalloc(sizeof(struct Tx_Beacon_param), GFP_KERNEL);
 	if (ptxBeacon_parm == NULL) {
 		kfree(ph2c);
 		res = _FAIL;
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp.c b/drivers/staging/rtl8188eu/core/rtw_mp.c
index 2469a82..ca323db 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp.c
@@ -687,7 +687,7 @@ void SetPacketTx(struct adapter *padapter)
 	kfree(pmp_priv->tx.pallocated_buf);
 	pmp_priv->tx.write_size = pkt_size;
 	pmp_priv->tx.buf_size = pkt_size + XMITBUF_ALIGN_SZ;
-	pmp_priv->tx.pallocated_buf = rtw_zmalloc(pmp_priv->tx.buf_size);
+	pmp_priv->tx.pallocated_buf = kzalloc(pmp_priv->tx.buf_size, GFP_KERNEL);
 	if (pmp_priv->tx.pallocated_buf == NULL) {
 		DBG_88E("%s: malloc(%d) fail!!\n", __func__, pmp_priv->tx.buf_size);
 		return;
diff --git a/drivers/staging/rtl8188eu/core/rtw_p2p.c b/drivers/staging/rtl8188eu/core/rtw_p2p.c
index e6ce5ce..0840470 100644
--- a/drivers/staging/rtl8188eu/core/rtw_p2p.c
+++ b/drivers/staging/rtl8188eu/core/rtw_p2p.c
@@ -50,7 +50,7 @@ static u32 go_add_group_info_attr(struct wifidirect_info *pwdinfo, u8 *pbuf)
 
 	DBG_88E("%s\n", __func__);
 
-	pdata_attr = rtw_zmalloc(MAX_P2P_IE_LEN);
+	pdata_attr = kzalloc(MAX_P2P_IE_LEN, GFP_KERNEL);
 
 	pstart = pdata_attr;
 	pcur = pdata_attr;
@@ -891,7 +891,7 @@ u32 process_assoc_req_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pframe, uint l
 		/* Check P2P Device Info ATTR */
 		if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_DEVICE_INFO, NULL, (uint *)&attr_contentlen)) {
 			DBG_88E("[%s] Got P2P DEVICE INFO Attr!!\n", __func__);
-			pattr_content = rtw_zmalloc(attr_contentlen);
+			pattr_content = kzalloc(attr_contentlen, GFP_KERNEL);
 			pbuf = pattr_content;
 			if (pattr_content) {
 				u8 num_of_secdev_type;
@@ -1738,13 +1738,13 @@ u8 p2p_ps_wk_cmd(struct adapter *padapter, u8 p2p_ps_state, u8 enqueue)
 		return res;
 
 	if (enqueue) {
-		ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+		ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 		if (ph2c == NULL) {
 			res = _FAIL;
 			goto exit;
 		}
 
-		pdrvextra_cmd_parm = (struct drvextra_cmd_parm *)rtw_zmalloc(sizeof(struct drvextra_cmd_parm));
+		pdrvextra_cmd_parm = kzalloc(sizeof(struct drvextra_cmd_parm), GFP_KERNEL);
 		if (pdrvextra_cmd_parm == NULL) {
 			kfree(ph2c);
 			res = _FAIL;
diff --git a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
index a0b1576..2e709e6 100644
--- a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
@@ -935,7 +935,7 @@ int rtw_check_bcn_info(struct adapter  *Adapter, u8 *pframe, u32 packet_len)
 		return true;
 	}
 
-	bssid = (struct wlan_bssid_ex *)rtw_zmalloc(sizeof(struct wlan_bssid_ex));
+	bssid = kzalloc(sizeof(struct wlan_bssid_ex), GFP_KERNEL);
 
 	subtype = GetFrameSubType(pframe) >> 4;
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index 8f380f3..d358651 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -1637,7 +1637,7 @@ void rtw_alloc_hwxmits(struct adapter *padapter)
 
 	pxmitpriv->hwxmit_entry = HWXMIT_ENTRY;
 
-	pxmitpriv->hwxmits = (struct hw_xmit *)rtw_zmalloc(sizeof(struct hw_xmit) * pxmitpriv->hwxmit_entry);
+	pxmitpriv->hwxmits = kzalloc(sizeof(struct hw_xmit) * pxmitpriv->hwxmit_entry, GFP_KERNEL);
 
 	hwxmits = pxmitpriv->hwxmits;
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
index 2ab1c80..99ad9c7 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
@@ -503,7 +503,7 @@ static void SetFwRsvdPagePkt(struct adapter *adapt, bool bDLFinished)
 	struct rsvdpage_loc RsvdPageLoc;
 
 	DBG_88E("%s\n", __func__);
-	ReservedPagePacket = (u8 *)rtw_zmalloc(1000);
+	ReservedPagePacket = kzalloc(1000, GFP_KERNEL);
 	if (ReservedPagePacket == NULL) {
 		DBG_88E("%s: alloc ReservedPagePacket fail!\n", __func__);
 		return;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index ad966e5..f25c87c 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -41,7 +41,7 @@ int	rtl8188eu_init_recv_priv(struct adapter *padapter)
 	/* init recv_buf */
 	_rtw_init_queue(&precvpriv->free_recv_buf_queue);
 
-	precvpriv->pallocated_recv_buf = rtw_zmalloc(NR_RECVBUFF * sizeof(struct recv_buf) + 4);
+	precvpriv->pallocated_recv_buf = kzalloc(NR_RECVBUFF * sizeof(struct recv_buf) + 4, GFP_KERNEL);
 	if (precvpriv->pallocated_recv_buf == NULL) {
 		res = _FAIL;
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_, ("alloc recv_buf fail!\n"));
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 3a539e4..19cf5f5 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -2211,7 +2211,7 @@ void rtl8188eu_set_hal_ops(struct adapter *adapt)
 	struct hal_ops	*halfunc = &adapt->HalFunc;
 
 
-	adapt->HalData = rtw_zmalloc(sizeof(struct hal_data_8188e));
+	adapt->HalData = kzalloc(sizeof(struct hal_data_8188e), GFP_KERNEL);
 	if (adapt->HalData == NULL)
 		DBG_88E("cant not alloc memory for HAL DATA\n");
 
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 7c2336f..acce3e6 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -188,11 +188,9 @@ extern unsigned char WPA_TKIP_CIPHER[4];
 extern unsigned char RSN_TKIP_CIPHER[4];
 
 #define rtw_update_mem_stat(flag, sz) do {} while (0)
-u8 *_rtw_zmalloc(u32 sz);
 u8 *_rtw_malloc(u32 sz);
 void _rtw_mfree(u8 *pbuf, u32 sz);
 #define rtw_malloc(sz)			_rtw_malloc((sz))
-#define rtw_zmalloc(sz)			_rtw_zmalloc((sz))
 #define rtw_mfree(pbuf, sz)		_rtw_mfree((pbuf), (sz))
 
 void *rtw_malloc2d(int h, int w, int size);
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 5cca278..284a28e 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -632,7 +632,7 @@ static int rtw_set_wpa_ie(struct adapter *padapter, char *pie, unsigned short ie
 	}
 
 	if (ielen) {
-		buf = rtw_zmalloc(ielen);
+		buf = kzalloc(ielen, GFP_KERNEL);
 		if (buf == NULL) {
 			ret =  -ENOMEM;
 			goto exit;
@@ -4721,13 +4721,13 @@ static u8 set_pairwise_key(struct adapter *padapter, struct sta_info *psta)
 	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
 	u8 res = _SUCCESS;
 
-	ph2c = (struct cmd_obj *)rtw_zmalloc(sizeof(struct cmd_obj));
+	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
 	if (ph2c == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
 
-	psetstakey_para = (struct set_stakey_parm *)rtw_zmalloc(sizeof(struct set_stakey_parm));
+	psetstakey_para = kzalloc(sizeof(struct set_stakey_parm), GFP_KERNEL);
 	if (psetstakey_para == NULL) {
 		kfree(ph2c);
 		res = _FAIL;
@@ -4759,12 +4759,12 @@ static int set_group_key(struct adapter *padapter, u8 *key, u8 alg, int keyid)
 
 	DBG_88E("%s\n", __func__);
 
-	pcmd = (struct cmd_obj *)rtw_zmalloc(sizeof(struct	cmd_obj));
+	pcmd = kzalloc(sizeof(struct	cmd_obj), GFP_KERNEL);
 	if (pcmd == NULL) {
 		res = _FAIL;
 		goto exit;
 	}
-	psetkeyparm = (struct setkey_parm *)rtw_zmalloc(sizeof(struct setkey_parm));
+	psetkeyparm = kzalloc(sizeof(struct setkey_parm), GFP_KERNEL);
 	if (psetkeyparm == NULL) {
 		kfree(pcmd);
 		res = _FAIL;
@@ -5672,12 +5672,12 @@ static int rtw_mp_efuse_get(struct net_device *dev,
 	pEfuseHal = &haldata->EfuseHal;
 
 	err = 0;
-	data = _rtw_zmalloc(EFUSE_BT_MAX_MAP_LEN);
+	data = kzalloc(EFUSE_BT_MAX_MAP_LEN, GFP_KERNEL);
 	if (data == NULL) {
 		err = -ENOMEM;
 		goto exit;
 	}
-	rawdata = _rtw_zmalloc(EFUSE_BT_MAX_MAP_LEN);
+	rawdata = kzalloc(EFUSE_BT_MAX_MAP_LEN, GFP_KERNEL);
 	if (rawdata == NULL) {
 		err = -ENOMEM;
 		goto exit;
@@ -5916,7 +5916,7 @@ static int rtw_mp_efuse_set(struct net_device *dev,
 	haldata = GET_HAL_DATA(padapter);
 	pEfuseHal = &haldata->EfuseHal;
 	err = 0;
-	setdata = _rtw_zmalloc(1024);
+	setdata = kzalloc(1024, GFP_KERNEL);
 	if (setdata == NULL) {
 		err = -ENOMEM;
 		goto exit;
@@ -7438,7 +7438,7 @@ static int rtw_test(
 	DBG_88E("+%s\n", __func__);
 	len = wrqu->data.length;
 
-	pbuf = (u8 *)rtw_zmalloc(len);
+	pbuf = kzalloc(len, GFP_KERNEL);
 	if (pbuf == NULL) {
 		DBG_88E("%s: no memory!\n", __func__);
 		return -ENOMEM;
@@ -7783,7 +7783,7 @@ static int rtw_ioctl_wext_private(struct net_device *dev, union iwreq_data *wrq_
 	memcpy(&wdata, wrq_data, sizeof(wdata));
 
 	input_len = wdata.data.length;
-	input = rtw_zmalloc(input_len);
+	input = kzalloc(input_len, GFP_KERNEL);
 	if (NULL == input)
 		return -ENOMEM;
 	if (copy_from_user(input, wdata.data.pointer, input_len)) {
@@ -7850,7 +7850,7 @@ static int rtw_ioctl_wext_private(struct net_device *dev, union iwreq_data *wrq_
 		k = j;
 	}
 
-	buffer = rtw_zmalloc(4096);
+	buffer = kzalloc(4096, GFP_KERNEL);
 	if (NULL == buffer) {
 		err = -ENOMEM;
 		goto exit;
@@ -7999,7 +7999,7 @@ static int rtw_ioctl_wext_private(struct net_device *dev, union iwreq_data *wrq_
 		else
 			n = wdata.data.length;
 
-		output = rtw_zmalloc(4096);
+		output = kzalloc(4096, GFP_KERNEL);
 		if (NULL == output) {
 			err =  -ENOMEM;
 			goto exit;
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index 2a4469d..fa31820 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -47,20 +47,11 @@ u8 *_rtw_malloc(u32 sz)
 	return pbuf;
 }
 
-u8 *_rtw_zmalloc(u32 sz)
-{
-	u8	*pbuf = _rtw_malloc(sz);
-
-	if (pbuf != NULL)
-		memset(pbuf, 0, sz);
-	return pbuf;
-}
-
 void *rtw_malloc2d(int h, int w, int size)
 {
 	int j;
 
-	void **a = (void **)rtw_zmalloc(h*sizeof(void *) + h*w*size);
+	void **a = (void **)kzalloc(h*sizeof(void *) + h*w*size, GFP_KERNEL);
 	if (a == NULL) {
 		pr_info("%s: alloc memory fail!\n", __func__);
 		return NULL;
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 714c14e..3c8720c 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -66,7 +66,7 @@ static struct dvobj_priv *usb_dvobj_init(struct usb_interface *usb_intf)
 	struct usb_device	*pusbd;
 
 
-	pdvobjpriv = (struct dvobj_priv *)rtw_zmalloc(sizeof(*pdvobjpriv));
+	pdvobjpriv = kzalloc(sizeof(*pdvobjpriv), GFP_KERNEL);
 	if (pdvobjpriv == NULL)
 		goto exit;
 
@@ -116,7 +116,7 @@ static struct dvobj_priv *usb_dvobj_init(struct usb_interface *usb_intf)
 		pdvobjpriv->ishighspeed = false;
 
 	mutex_init(&pdvobjpriv->usb_vendor_req_mutex);
-	pdvobjpriv->usb_vendor_req_buf = rtw_zmalloc(MAX_USB_IO_CTL_SIZE);
+	pdvobjpriv->usb_vendor_req_buf = kzalloc(MAX_USB_IO_CTL_SIZE, GFP_KERNEL);
 
 	if (!pdvobjpriv->usb_vendor_req_buf)
 		goto free_dvobj;
diff --git a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
index 5abd805..b5efa45 100644
--- a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
@@ -81,7 +81,7 @@ int rtw_os_xmit_resource_alloc(struct adapter *padapter, struct xmit_buf *pxmitb
 {
 	int i;
 
-	pxmitbuf->pallocated_buf = rtw_zmalloc(alloc_sz);
+	pxmitbuf->pallocated_buf = kzalloc(alloc_sz, GFP_KERNEL);
 	if (pxmitbuf->pallocated_buf == NULL)
 		return _FAIL;
 
-- 
1.7.10.4

