Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaLTMPE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 07:15:04 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:40675 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaLTMPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 07:15:01 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8712: rtl871x_mp_ioctl.c:  Remove some unused functions
Date: Sat, 20 Dec 2014 13:17:46 +0100
Message-Id: <1419077866-30359-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
oid_rt_pro_h2c_get_rate_table_hdl() oid_rt_pro_h2c_set_rate_table_hdl()
oid_rt_pro_set_pwrstate_hdl() oid_rt_pro_qry_pwrstate_hdl()
oid_rt_pro_set_basic_rate_hdl() oid_rt_pro_set_power_tracking_hdl()
oid_rt_pro_set_data_rate_ex_hdl() oid_rt_pro_cfg_debug_message_hdl()
oid_rt_poll_rx_status_hdl() oid_rt_pro_set_rf_intfs_hdl()
oid_rt_wr_attrib_mem_hdl() oid_rt_rd_attrib_mem_hdl()
oid_rt_pro8711_pkt_loss_hdl() oid_rt_pro8711_wi_poll_hdl()
oid_rt_pro_write16_eeprom_hdl() oid_rt_pro_read16_eeprom_hdl()
oid_rt_pro_write_txcmd_hdl() oid_rt_pro_burst_write_register_hdl()
oid_rt_pro_burst_read_register_hdl() oid_rt_pro8711_join_bss_hdl()
oid_rt_pro_set_pkt_test_mode_hdl() oid_rt_pro_set_tx_agc_offset_hdl()
oid_rt_set_crystal_cap_hdl() oid_rt_pro_rw_efuse_pgpkt_hdl()
oid_rt_pro_rx_packet_type_hdl() oid_rt_pro_query_dr_variable_hdl()
oid_rt_pro_dele_sta_info_hdl() oid_rt_pro_add_sta_info_hdl()
oid_rt_pro_encryption_ctrl_hdl()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8712/rtl871x_mp_ioctl.c |  518 ----------------------------
 drivers/staging/rtl8712/rtl871x_mp_ioctl.h |   46 ---
 2 files changed, 564 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_mp_ioctl.c b/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
index 9827ff8..aea9a88 100644
--- a/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
+++ b/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
@@ -575,26 +575,6 @@ uint oid_rt_pro_set_single_tone_tx_hdl(struct oid_par_priv
 	return RNDIS_STATUS_SUCCESS;
 }
 
-uint oid_rt_pro8711_join_bss_hdl(struct oid_par_priv *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-	uint status = RNDIS_STATUS_SUCCESS;
-	struct ndis_802_11_ssid *pssid;
-
-	if (poid_par_priv->type_of_oid != SET_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	*poid_par_priv->bytes_needed = (u32)sizeof(struct ndis_802_11_ssid);
-	*poid_par_priv->bytes_rw = 0;
-	if (poid_par_priv->information_buf_len < *poid_par_priv->bytes_needed)
-		return RNDIS_STATUS_INVALID_LENGTH;
-	pssid = (struct ndis_802_11_ssid *)poid_par_priv->information_buf;
-	if (mp_start_joinbss(Adapter, pssid) == _FAIL)
-		status = RNDIS_STATUS_NOT_ACCEPTED;
-	*poid_par_priv->bytes_rw = sizeof(struct ndis_802_11_ssid);
-	return status;
-}
-
 uint oid_rt_pro_read_register_hdl(struct oid_par_priv
 					 *poid_par_priv)
 {
@@ -696,172 +676,6 @@ uint oid_rt_pro_write_register_hdl(struct oid_par_priv *poid_par_priv)
 	return status;
 }
 
-uint oid_rt_pro_burst_read_register_hdl(struct oid_par_priv
-					       *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-	struct burst_rw_reg *pBstRwReg;
-
-	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	pBstRwReg = (struct burst_rw_reg *)poid_par_priv->information_buf;
-	r8712_read_mem(Adapter, pBstRwReg->offset, (u32)pBstRwReg->len,
-		 pBstRwReg->Data);
-	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return RNDIS_STATUS_SUCCESS;
-}
-
-uint oid_rt_pro_burst_write_register_hdl(struct oid_par_priv
-						*poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-	struct burst_rw_reg *pBstRwReg;
-
-	if (poid_par_priv->type_of_oid != SET_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	pBstRwReg = (struct burst_rw_reg *)poid_par_priv->information_buf;
-	r8712_write_mem(Adapter, pBstRwReg->offset, (u32)pBstRwReg->len,
-		  pBstRwReg->Data);
-	return RNDIS_STATUS_SUCCESS;
-}
-
-uint oid_rt_pro_write_txcmd_hdl(struct oid_par_priv *poid_par_priv)
-{
-	return RNDIS_STATUS_SUCCESS;
-}
-
-uint oid_rt_pro_read16_eeprom_hdl(struct oid_par_priv *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-	struct eeprom_rw_param *pEEPROM;
-
-	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	pEEPROM = (struct eeprom_rw_param *)poid_par_priv->information_buf;
-	pEEPROM->value = r8712_eeprom_read16(Adapter,
-					     (u16)(pEEPROM->offset >> 1));
-	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return RNDIS_STATUS_SUCCESS;
-}
-
-uint oid_rt_pro_write16_eeprom_hdl(struct oid_par_priv *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-	struct eeprom_rw_param *pEEPROM;
-
-	if (poid_par_priv->type_of_oid != SET_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	pEEPROM = (struct eeprom_rw_param *)poid_par_priv->information_buf;
-	r8712_eeprom_write16(Adapter, (u16)(pEEPROM->offset >> 1),
-			     pEEPROM->value);
-	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return RNDIS_STATUS_SUCCESS;
-}
-
-uint oid_rt_pro8711_wi_poll_hdl(struct oid_par_priv *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-	struct mp_wiparam *pwi_param;
-
-	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	if (poid_par_priv->information_buf_len < sizeof(struct mp_wiparam))
-		return RNDIS_STATUS_INVALID_LENGTH;
-	if (Adapter->mppriv.workparam.bcompleted == false)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	pwi_param = (struct mp_wiparam *)poid_par_priv->information_buf;
-	memcpy(pwi_param, &Adapter->mppriv.workparam,
-		sizeof(struct mp_wiparam));
-	Adapter->mppriv.act_in_progress = false;
-	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return RNDIS_STATUS_SUCCESS;
-}
-
-uint oid_rt_pro8711_pkt_loss_hdl(struct oid_par_priv *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-
-	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	if (poid_par_priv->information_buf_len < sizeof(uint) * 2)
-		return RNDIS_STATUS_INVALID_LENGTH;
-	if (*(uint *)poid_par_priv->information_buf == 1)
-		Adapter->mppriv.rx_pktloss = 0;
-	*((uint *)poid_par_priv->information_buf+1) =
-					 Adapter->mppriv.rx_pktloss;
-	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return RNDIS_STATUS_SUCCESS;
-}
-
-uint oid_rt_rd_attrib_mem_hdl(struct oid_par_priv *poid_par_priv)
-{
-	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	return RNDIS_STATUS_SUCCESS;
-}
-
-uint oid_rt_wr_attrib_mem_hdl(struct oid_par_priv *poid_par_priv)
-{
-	if (poid_par_priv->type_of_oid != SET_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	return RNDIS_STATUS_SUCCESS;
-}
-
-uint oid_rt_pro_set_rf_intfs_hdl(struct oid_par_priv *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-	uint status = RNDIS_STATUS_SUCCESS;
-
-	if (poid_par_priv->type_of_oid != SET_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	if (r8712_setrfintfs_cmd(Adapter, *(unsigned char *)
-	    poid_par_priv->information_buf) == _FAIL)
-		status = RNDIS_STATUS_NOT_ACCEPTED;
-	return status;
-}
-
-uint oid_rt_poll_rx_status_hdl(struct oid_par_priv *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-
-	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	memcpy(poid_par_priv->information_buf,
-		(unsigned char *)&Adapter->mppriv.rxstat,
-		sizeof(struct recv_stat));
-	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return RNDIS_STATUS_SUCCESS;
-}
-
-uint oid_rt_pro_cfg_debug_message_hdl(struct oid_par_priv
-					     *poid_par_priv)
-{
-	return RNDIS_STATUS_SUCCESS;
-}
-
-uint oid_rt_pro_set_data_rate_ex_hdl(struct oid_par_priv
-					    *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-	uint status = RNDIS_STATUS_SUCCESS;
-
-	if (poid_par_priv->type_of_oid != SET_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	if (r8712_setdatarate_cmd(Adapter,
-	    poid_par_priv->information_buf) != _SUCCESS)
-		status = RNDIS_STATUS_NOT_ACCEPTED;
-	return status;
-}
-
 uint oid_rt_get_thermal_meter_hdl(struct oid_par_priv *poid_par_priv)
 {
 	struct _adapter *Adapter = (struct _adapter *)
@@ -890,250 +704,12 @@ uint oid_rt_get_thermal_meter_hdl(struct oid_par_priv *poid_par_priv)
 	return RNDIS_STATUS_SUCCESS;
 }
 
-uint oid_rt_pro_set_power_tracking_hdl(struct oid_par_priv
-					      *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-	uint status = RNDIS_STATUS_SUCCESS;
-
-	if (poid_par_priv->type_of_oid != SET_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	if (poid_par_priv->information_buf_len < sizeof(u8))
-		return RNDIS_STATUS_INVALID_LENGTH;
-	if (!r8712_setptm_cmd(Adapter, *((u8 *)poid_par_priv->information_buf)))
-		status = RNDIS_STATUS_NOT_ACCEPTED;
-	return status;
-}
-
-uint oid_rt_pro_set_basic_rate_hdl(struct oid_par_priv *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-	u8 mpdatarate[NumRates] = {11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 0xff};
-	uint status = RNDIS_STATUS_SUCCESS;
-	u32 ratevalue;
-	u8 datarates[NumRates];
-	int i;
-
-	if (poid_par_priv->type_of_oid != SET_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	ratevalue = *((u32 *)poid_par_priv->information_buf);
-	for (i = 0; i < NumRates; i++) {
-		if (ratevalue == mpdatarate[i])
-			datarates[i] = mpdatarate[i];
-		else
-			datarates[i] = 0xff;
-	}
-	if (r8712_setbasicrate_cmd(Adapter, datarates) != _SUCCESS)
-		status = RNDIS_STATUS_NOT_ACCEPTED;
-	return status;
-}
-
-uint oid_rt_pro_qry_pwrstate_hdl(struct oid_par_priv *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-
-	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	if (poid_par_priv->information_buf_len < 8)
-		return RNDIS_STATUS_INVALID_LENGTH;
-	*poid_par_priv->bytes_rw = 8;
-	memcpy(poid_par_priv->information_buf,
-		&(Adapter->pwrctrlpriv.pwr_mode), 8);
-	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return RNDIS_STATUS_SUCCESS;
-}
-
-uint oid_rt_pro_set_pwrstate_hdl(struct oid_par_priv *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-	uint pwr_mode, smart_ps;
-
-	if (poid_par_priv->type_of_oid != SET_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	*poid_par_priv->bytes_rw = 0;
-	*poid_par_priv->bytes_needed = 8;
-	if (poid_par_priv->information_buf_len < 8)
-		return RNDIS_STATUS_INVALID_LENGTH;
-	pwr_mode = *(uint *)(poid_par_priv->information_buf);
-	smart_ps = *(uint *)((addr_t)poid_par_priv->information_buf + 4);
-	if (pwr_mode != Adapter->pwrctrlpriv.pwr_mode || smart_ps !=
-			Adapter->pwrctrlpriv.smart_ps)
-		r8712_set_ps_mode(Adapter, pwr_mode, smart_ps);
-	*poid_par_priv->bytes_rw = 8;
-	return RNDIS_STATUS_SUCCESS;
-}
-
-uint oid_rt_pro_h2c_set_rate_table_hdl(struct oid_par_priv
-					      *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-	uint status = RNDIS_STATUS_SUCCESS;
-	struct setratable_parm *prate_table;
-	u8 res;
-
-	if (poid_par_priv->type_of_oid != SET_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	*poid_par_priv->bytes_needed  = sizeof(struct setratable_parm);
-	if (poid_par_priv->information_buf_len <
-	    sizeof(struct setratable_parm))
-		return RNDIS_STATUS_INVALID_LENGTH;
-	prate_table = (struct setratable_parm *)poid_par_priv->information_buf;
-	res = r8712_setrttbl_cmd(Adapter, prate_table);
-	if (res == _FAIL)
-		status = RNDIS_STATUS_FAILURE;
-	return status;
-}
-
-uint oid_rt_pro_h2c_get_rate_table_hdl(struct oid_par_priv
-					      *poid_par_priv)
-{
-	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	return RNDIS_STATUS_SUCCESS;
-}
-
-uint oid_rt_pro_encryption_ctrl_hdl(struct oid_par_priv
-					   *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-	struct security_priv *psecuritypriv = &Adapter->securitypriv;
-	enum ENCRY_CTRL_STATE encry_mode = 0;
-
-	*poid_par_priv->bytes_needed = sizeof(u8);
-	if (poid_par_priv->information_buf_len < *poid_par_priv->bytes_needed)
-		return RNDIS_STATUS_INVALID_LENGTH;
-
-	if (poid_par_priv->type_of_oid == SET_OID) {
-		encry_mode = *((u8 *)poid_par_priv->information_buf);
-		switch (encry_mode) {
-		case HW_CONTROL:
-			psecuritypriv->sw_decrypt = false;
-			psecuritypriv->sw_encrypt = false;
-			break;
-		case SW_CONTROL:
-			psecuritypriv->sw_decrypt = true;
-			psecuritypriv->sw_encrypt = true;
-			break;
-		case HW_ENCRY_SW_DECRY:
-			psecuritypriv->sw_decrypt = true;
-			psecuritypriv->sw_encrypt = false;
-			break;
-		case SW_ENCRY_HW_DECRY:
-			psecuritypriv->sw_decrypt = false;
-			psecuritypriv->sw_encrypt = true;
-			break;
-		}
-	} else {
-		if ((psecuritypriv->sw_encrypt == false) &&
-		    (psecuritypriv->sw_decrypt == false))
-			encry_mode = HW_CONTROL;
-		else if ((psecuritypriv->sw_encrypt == false) &&
-			 (psecuritypriv->sw_decrypt == true))
-			encry_mode = HW_ENCRY_SW_DECRY;
-		else if ((psecuritypriv->sw_encrypt == true) &&
-			 (psecuritypriv->sw_decrypt == false))
-			encry_mode = SW_ENCRY_HW_DECRY;
-		else if ((psecuritypriv->sw_encrypt == true) &&
-			 (psecuritypriv->sw_decrypt == true))
-			encry_mode = SW_CONTROL;
-		*(u8 *)poid_par_priv->information_buf =  encry_mode;
-		*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	}
-	return RNDIS_STATUS_SUCCESS;
-}
-/*----------------------------------------------------------------------*/
-uint oid_rt_pro_add_sta_info_hdl(struct oid_par_priv *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-
-	uint status = RNDIS_STATUS_SUCCESS;
-
-	struct sta_info	*psta = NULL;
-	u8	*macaddr;
-
-
-	if (poid_par_priv->type_of_oid != SET_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-
-	*poid_par_priv->bytes_needed = ETH_ALEN;
-	if (poid_par_priv->information_buf_len < *poid_par_priv->bytes_needed)
-		return RNDIS_STATUS_INVALID_LENGTH;
-	macaddr = (u8 *) poid_par_priv->information_buf;
-	psta = r8712_get_stainfo(&Adapter->stapriv, macaddr);
-	if (psta == NULL) { /* the sta in sta_info_queue => do nothing*/
-		psta = r8712_alloc_stainfo(&Adapter->stapriv, macaddr);
-		if (psta == NULL)
-			status = RNDIS_STATUS_FAILURE;
-	}
-	return status;
-}
-/*-------------------------------------------------------------------------*/
-uint oid_rt_pro_dele_sta_info_hdl(struct oid_par_priv *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-
-	unsigned long			irqL;
-
-	struct sta_info		*psta = NULL;
-	u8			*macaddr;
-
-
-	if (poid_par_priv->type_of_oid != SET_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-
-	*poid_par_priv->bytes_needed = ETH_ALEN;
-	if (poid_par_priv->information_buf_len < *poid_par_priv->bytes_needed)
-		return RNDIS_STATUS_INVALID_LENGTH;
-
-	macaddr = (u8 *)poid_par_priv->information_buf;
-
-	psta = r8712_get_stainfo(&Adapter->stapriv, macaddr);
-	if (psta != NULL) {
-		spin_lock_irqsave(&(Adapter->stapriv.sta_hash_lock), irqL);
-		r8712_free_stainfo(Adapter, psta);
-		spin_unlock_irqrestore(&(Adapter->stapriv.sta_hash_lock), irqL);
-	}
-
-	return RNDIS_STATUS_SUCCESS;
-}
 /*--------------------------------------------------------------------------*/
 static u32 mp_query_drv_var(struct _adapter *padapter, u8 offset, u32 var)
 {
 	return var;
 }
 
-uint oid_rt_pro_query_dr_variable_hdl(struct oid_par_priv *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-
-	struct DR_VARIABLE_STRUCT *pdrv_var;
-
-	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	*poid_par_priv->bytes_needed = sizeof(struct DR_VARIABLE_STRUCT);
-	if (poid_par_priv->information_buf_len < *poid_par_priv->bytes_needed)
-		return RNDIS_STATUS_INVALID_LENGTH;
-	pdrv_var = (struct DR_VARIABLE_STRUCT *)poid_par_priv->information_buf;
-	pdrv_var->variable = mp_query_drv_var(Adapter, pdrv_var->offset,
-					      pdrv_var->variable);
-	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return RNDIS_STATUS_SUCCESS;
-}
-
-/*--------------------------------------------------------------------------*/
-uint oid_rt_pro_rx_packet_type_hdl(struct oid_par_priv *poid_par_priv)
-{
-	return RNDIS_STATUS_SUCCESS;
-}
 /*------------------------------------------------------------------------*/
 uint oid_rt_pro_read_efuse_hdl(struct oid_par_priv *poid_par_priv)
 {
@@ -1192,38 +768,6 @@ uint oid_rt_pro_write_efuse_hdl(struct oid_par_priv *poid_par_priv)
 	return status;
 }
 /*----------------------------------------------------------------------*/
-uint oid_rt_pro_rw_efuse_pgpkt_hdl(struct oid_par_priv *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-	uint status = RNDIS_STATUS_SUCCESS;
-	struct PGPKT_STRUCT	*ppgpkt;
-
-	*poid_par_priv->bytes_rw = 0;
-	if (poid_par_priv->information_buf_len < sizeof(struct PGPKT_STRUCT))
-		return RNDIS_STATUS_INVALID_LENGTH;
-	ppgpkt = (struct PGPKT_STRUCT *)poid_par_priv->information_buf;
-	if (poid_par_priv->type_of_oid == QUERY_OID) {
-		if (r8712_efuse_pg_packet_read(Adapter, ppgpkt->offset,
-		    ppgpkt->data) == true)
-			*poid_par_priv->bytes_rw =
-				 poid_par_priv->information_buf_len;
-		else
-			status = RNDIS_STATUS_FAILURE;
-	} else {
-		if (r8712_efuse_reg_init(Adapter) == true) {
-			if (r8712_efuse_pg_packet_write(Adapter, ppgpkt->offset,
-			    ppgpkt->word_en, ppgpkt->data) == true)
-				*poid_par_priv->bytes_rw =
-					 poid_par_priv->information_buf_len;
-			else
-				status = RNDIS_STATUS_FAILURE;
-			r8712_efuse_reg_uninit(Adapter);
-		} else
-			status = RNDIS_STATUS_FAILURE;
-	}
-	return status;
-}
 
 uint oid_rt_get_efuse_current_size_hdl(struct oid_par_priv
 					      *poid_par_priv)
@@ -1319,24 +863,6 @@ uint oid_rt_set_bandwidth_hdl(struct oid_par_priv *poid_par_priv)
 	return RNDIS_STATUS_SUCCESS;
 }
 
-uint oid_rt_set_crystal_cap_hdl(struct oid_par_priv *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-	u32		crystal_cap = 0;
-
-	if (poid_par_priv->type_of_oid != SET_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	if (poid_par_priv->information_buf_len < sizeof(u32))
-		return RNDIS_STATUS_INVALID_LENGTH;
-	crystal_cap = *((u32 *)poid_par_priv->information_buf);/*4*/
-	if (crystal_cap > 0xf)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	Adapter->mppriv.curr_crystalcap = crystal_cap;
-	r8712_SetCrystalCap(Adapter);
-	return RNDIS_STATUS_SUCCESS;
-}
-
 uint oid_rt_set_rx_packet_type_hdl(struct oid_par_priv
 					   *poid_par_priv)
 {
@@ -1378,50 +904,6 @@ uint oid_rt_set_rx_packet_type_hdl(struct oid_par_priv
 	return RNDIS_STATUS_SUCCESS;
 }
 
-uint oid_rt_pro_set_tx_agc_offset_hdl(struct oid_par_priv
-					     *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-	u32 txagc;
-
-	if (poid_par_priv->type_of_oid != SET_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-	if (poid_par_priv->information_buf_len < sizeof(u32))
-		return RNDIS_STATUS_INVALID_LENGTH;
-	txagc = *(u32 *)poid_par_priv->information_buf;
-	r8712_SetTxAGCOffset(Adapter, txagc);
-	return RNDIS_STATUS_SUCCESS;
-}
-
-uint oid_rt_pro_set_pkt_test_mode_hdl(struct oid_par_priv
-					     *poid_par_priv)
-{
-	struct _adapter *Adapter = (struct _adapter *)
-				   (poid_par_priv->adapter_context);
-	uint status = RNDIS_STATUS_SUCCESS;
-	struct mlme_priv	*pmlmepriv = &Adapter->mlmepriv;
-	struct mp_priv		*pmppriv = &Adapter->mppriv;
-	u32			type;
-
-	if (poid_par_priv->type_of_oid != SET_OID)
-		return RNDIS_STATUS_NOT_ACCEPTED;
-
-	if (poid_par_priv->information_buf_len < sizeof(u32))
-		return RNDIS_STATUS_INVALID_LENGTH;
-
-	type = *(u32 *)poid_par_priv->information_buf;
-
-	if (_LOOPBOOK_MODE_ == type) {
-		pmppriv->mode = type;
-		set_fwstate(pmlmepriv, WIFI_MP_LPBK_STATE); /*append txdesc*/
-	} else if (_2MAC_MODE_ == type) {
-		pmppriv->mode = type;
-		_clr_fwstate_(pmlmepriv, WIFI_MP_LPBK_STATE);
-	} else
-		status = RNDIS_STATUS_NOT_ACCEPTED;
-	return status;
-}
 /*--------------------------------------------------------------------------*/
 /*Linux*/
 unsigned int mp_ioctl_xmit_packet_hdl(struct oid_par_priv *poid_par_priv)
diff --git a/drivers/staging/rtl8712/rtl871x_mp_ioctl.h b/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
index 850143d..8e7c7f8 100644
--- a/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
+++ b/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
@@ -86,41 +86,8 @@ struct DR_VARIABLE_STRUCT {
 int mp_start_joinbss(struct _adapter *padapter, struct ndis_802_11_ssid *pssid);
 
 /* oid_rtl_seg_87_11_00 */
-uint oid_rt_pro8711_join_bss_hdl(struct oid_par_priv *poid_par_priv);
 uint oid_rt_pro_read_register_hdl(struct oid_par_priv *poid_par_priv);
 uint oid_rt_pro_write_register_hdl(struct oid_par_priv *poid_par_priv);
-uint oid_rt_pro_burst_read_register_hdl(struct oid_par_priv*
-					       poid_par_priv);
-uint oid_rt_pro_burst_write_register_hdl(struct oid_par_priv*
-						poid_par_priv);
-uint oid_rt_pro_write_txcmd_hdl(struct oid_par_priv *poid_par_priv);
-uint oid_rt_pro_read16_eeprom_hdl(struct oid_par_priv *poid_par_priv);
-uint oid_rt_pro_write16_eeprom_hdl(struct oid_par_priv *poid_par_priv);
-uint oid_rt_pro8711_wi_poll_hdl(struct oid_par_priv *poid_par_priv);
-uint oid_rt_pro8711_pkt_loss_hdl(struct oid_par_priv *poid_par_priv);
-uint oid_rt_rd_attrib_mem_hdl(struct oid_par_priv *poid_par_priv);
-uint oid_rt_wr_attrib_mem_hdl(struct oid_par_priv *poid_par_priv);
-uint  oid_rt_pro_set_rf_intfs_hdl(struct oid_par_priv *poid_par_priv);
-uint oid_rt_poll_rx_status_hdl(struct oid_par_priv *poid_par_priv);
-/* oid_rtl_seg_87_11_20 */
-uint oid_rt_pro_cfg_debug_message_hdl(
-				struct oid_par_priv *poid_par_priv);
-uint oid_rt_pro_set_data_rate_ex_hdl(
-				struct oid_par_priv *poid_par_priv);
-uint oid_rt_pro_set_basic_rate_hdl(
-				struct oid_par_priv *poid_par_priv);
-uint oid_rt_pro_set_power_tracking_hdl(
-				struct oid_par_priv *poid_par_priv);
-/* oid_rtl_seg_87_11_50 */
-uint oid_rt_pro_qry_pwrstate_hdl(
-				struct oid_par_priv *poid_par_priv);
-uint oid_rt_pro_set_pwrstate_hdl(
-				struct oid_par_priv *poid_par_priv);
-/* oid_rtl_seg_87_11_F0 */
-uint oid_rt_pro_h2c_set_rate_table_hdl(
-				struct oid_par_priv *poid_par_priv);
-uint oid_rt_pro_h2c_get_rate_table_hdl(
-				struct oid_par_priv *poid_par_priv);
 /* oid_rtl_seg_81_80_00 */
 uint oid_rt_pro_set_data_rate_hdl(
 				struct oid_par_priv *poid_par_priv);
@@ -159,28 +126,15 @@ uint oid_rt_pro_write_rf_reg_hdl(struct oid_par_priv *poid_par_priv);
 uint oid_rt_pro_read_rf_reg_hdl(struct oid_par_priv *poid_par_priv);
 /* oid_rtl_seg_81_85 */
 uint oid_rt_wireless_mode_hdl(struct oid_par_priv *poid_par_priv);
-/* oid_rtl_seg_87_12_00 */
-uint oid_rt_pro_encryption_ctrl_hdl(struct oid_par_priv *poid_par_priv);
-uint oid_rt_pro_add_sta_info_hdl(struct oid_par_priv *poid_par_priv);
-uint oid_rt_pro_dele_sta_info_hdl(struct oid_par_priv *poid_par_priv);
-uint oid_rt_pro_query_dr_variable_hdl(
-				struct oid_par_priv *poid_par_priv);
-uint oid_rt_pro_rx_packet_type_hdl(struct oid_par_priv *poid_par_priv);
 uint oid_rt_pro_read_efuse_hdl(struct oid_par_priv *poid_par_priv);
 uint oid_rt_pro_write_efuse_hdl(struct oid_par_priv *poid_par_priv);
-uint oid_rt_pro_rw_efuse_pgpkt_hdl(struct oid_par_priv *poid_par_priv);
 uint oid_rt_get_efuse_current_size_hdl(
 				struct oid_par_priv *poid_par_priv);
 uint oid_rt_pro_efuse_hdl(struct oid_par_priv *poid_par_priv);
 uint oid_rt_pro_efuse_map_hdl(struct oid_par_priv *poid_par_priv);
 uint oid_rt_set_bandwidth_hdl(struct oid_par_priv *poid_par_priv);
-uint oid_rt_set_crystal_cap_hdl(struct oid_par_priv *poid_par_priv);
 uint oid_rt_set_rx_packet_type_hdl(struct oid_par_priv *poid_par_priv);
 uint oid_rt_get_efuse_max_size_hdl(struct oid_par_priv *poid_par_priv);
-uint oid_rt_pro_set_tx_agc_offset_hdl(
-				struct oid_par_priv *poid_par_priv);
-uint oid_rt_pro_set_pkt_test_mode_hdl(
-				struct oid_par_priv *poid_par_priv);
 uint oid_rt_get_thermal_meter_hdl(
 				struct oid_par_priv *poid_par_priv);
 uint oid_rt_reset_phy_rx_packet_count_hdl(
-- 
1.7.10.4

