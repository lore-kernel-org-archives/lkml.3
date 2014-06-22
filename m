Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaFVIWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:22:34 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:58493 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaFVIWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:22:23 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 08/42] staging: rtl8188eu: Remove function _rtw_memset()
Date: Sun, 22 Jun 2014 13:49:28 +0530
Message-Id: <1403425202-11942-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
References: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ap.c           |   12 +--
 drivers/staging/rtl8188eu/core/rtw_cmd.c          |    2 +-
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |   18 ++---
 drivers/staging/rtl8188eu/core/rtw_ieee80211.c    |   10 +--
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c    |   16 ++--
 drivers/staging/rtl8188eu/core/rtw_mlme.c         |   22 +++---
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c     |   74 ++++++++---------
 drivers/staging/rtl8188eu/core/rtw_mp.c           |   17 ++--
 drivers/staging/rtl8188eu/core/rtw_p2p.c          |   46 +++++------
 drivers/staging/rtl8188eu/core/rtw_recv.c         |    2 +-
 drivers/staging/rtl8188eu/core/rtw_security.c     |   28 +++----
 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c      |    2 +-
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c    |    6 +-
 drivers/staging/rtl8188eu/core/rtw_xmit.c         |    6 +-
 drivers/staging/rtl8188eu/hal/hal_com.c           |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c      |    4 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_dm.c       |    4 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_rxdesc.c   |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c    |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c    |    4 +-
 drivers/staging/rtl8188eu/include/osdep_service.h |    1 -
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |   88 ++++++++++-----------
 drivers/staging/rtl8188eu/os_dep/mlme_linux.c     |    8 +-
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |    5 --
 drivers/staging/rtl8188eu/os_dep/recv_linux.c     |    4 +-
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c  |    2 +-
 27 files changed, 191 insertions(+), 198 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ap.c b/drivers/staging/rtl8188eu/core/rtw_ap.c
index 85fda61..eb96c56 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ap.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ap.c
@@ -548,7 +548,7 @@ static void update_bmc_sta(struct adapter *padapter)
 
 		psta->ieee8021x_blocked = 0;
 
-		_rtw_memset((void *)&psta->sta_stats, 0, sizeof(struct stainfo_stats));
+		memset((void *)&psta->sta_stats, 0, sizeof(struct stainfo_stats));
 
 		/* prepare for add_RATid */
 		supportRateNum = rtw_get_rateset_len((u8 *)&pcur_network->SupportedRates);
@@ -671,7 +671,7 @@ void update_sta_info_apmode(struct adapter *padapter, struct sta_info *psta)
 
 	/* todo: init other variables */
 
-	_rtw_memset((void *)&psta->sta_stats, 0, sizeof(struct stainfo_stats));
+	memset((void *)&psta->sta_stats, 0, sizeof(struct stainfo_stats));
 
 	spin_lock_bh(&psta->lock);
 	psta->state |= _FW_LINKED;
@@ -886,7 +886,7 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 
 	pbss_network->IELength = len;
 
-	_rtw_memset(ie, 0, MAX_IE_SZ);
+	memset(ie, 0, MAX_IE_SZ);
 
 	memcpy(ie, pbuf, pbss_network->IELength);
 
@@ -908,7 +908,7 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 	/* SSID */
 	p = rtw_get_ie(ie + _BEACON_IE_OFFSET_, _SSID_IE_, &ie_len, (pbss_network->IELength - _BEACON_IE_OFFSET_));
 	if (p && ie_len > 0) {
-		_rtw_memset(&pbss_network->Ssid, 0, sizeof(struct ndis_802_11_ssid));
+		memset(&pbss_network->Ssid, 0, sizeof(struct ndis_802_11_ssid));
 		memcpy(pbss_network->Ssid.Ssid, (p + 2), ie_len);
 		pbss_network->Ssid.SsidLength = ie_len;
 	}
@@ -922,7 +922,7 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 
 	pbss_network->Configuration.DSConfig = channel;
 
-	_rtw_memset(supportRate, 0, NDIS_802_11_LENGTH_RATES_EX);
+	memset(supportRate, 0, NDIS_802_11_LENGTH_RATES_EX);
 	/*  get supported rates */
 	p = rtw_get_ie(ie + _BEACON_IE_OFFSET_, _SUPPORTEDRATES_IE_, &ie_len, (pbss_network->IELength - _BEACON_IE_OFFSET_));
 	if (p !=  NULL) {
@@ -1934,7 +1934,7 @@ void stop_ap_mode(struct adapter *padapter)
 	pmlmeext->bstart_bss = false;
 
 	/* reset and init security priv , this can refine with rtw_reset_securitypriv */
-	_rtw_memset((unsigned char *)&padapter->securitypriv, 0, sizeof(struct security_priv));
+	memset((unsigned char *)&padapter->securitypriv, 0, sizeof(struct security_priv));
 	padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeOpen;
 	padapter->securitypriv.ndisencryptstatus = Ndis802_11WEPDisabled;
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 2384695..c7b7f15 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -878,7 +878,7 @@ u8 rtw_joinbss_cmd(struct adapter  *padapter, struct wlan_network *pnetwork)
 		goto exit;
 	}
 
-	_rtw_memset(psecnetwork, 0, t_len);
+	memset(psecnetwork, 0, t_len);
 
 	memcpy(psecnetwork, &pnetwork->network, get_wlan_bssid_ex_sz(&pnetwork->network));
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 672bfed..d18bdda 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -304,7 +304,7 @@ static s32 iol_read_efuse(struct adapter *padapter, u8 txpktbuf_bndy, u16 offset
 	u16 size = 512;
 
 	usb_write8(padapter, REG_TDECTRL+1, txpktbuf_bndy);
-	_rtw_memset(physical_map, 0xFF, 512);
+	memset(physical_map, 0xFF, 512);
 	usb_write8(padapter, REG_PKT_BUFF_ACCESS_CTRL, TXPKT_BUF_SELECT);
 	status = iol_execute(padapter, CMD_READ_EFUSE_MAP);
 	if (status == _SUCCESS)
@@ -395,7 +395,7 @@ u8 Efuse_WordEnableDataWrite(struct adapter *pAdapter, u16 efuse_addr, u8 word_e
 	u8 badworden = 0x0F;
 	u8 tmpdata[8];
 
-	_rtw_memset((void *)tmpdata, 0xff, PGPKT_DATA_SIZE);
+	memset((void *)tmpdata, 0xff, PGPKT_DATA_SIZE);
 
 	if (!(word_en&BIT0)) {
 		tmpaddr = start_addr;
@@ -501,8 +501,8 @@ int Efuse_PgPacketRead(struct adapter *pAdapter, u8 offset, u8 *data)
 	if (offset > max_section)
 		return false;
 
-	_rtw_memset((void *)data, 0xff, sizeof(u8)*PGPKT_DATA_SIZE);
-	_rtw_memset((void *)tmpdata, 0xff, sizeof(u8)*PGPKT_DATA_SIZE);
+	memset((void *)data, 0xff, sizeof(u8)*PGPKT_DATA_SIZE);
+	memset((void *)tmpdata, 0xff, sizeof(u8)*PGPKT_DATA_SIZE);
 
 	/*  <Roger_TODO> Efuse has been pre-programmed dummy 5Bytes at the end of Efuse by CP. */
 	/*  Skip dummy parts to prevent unexpected data read from Efuse. */
@@ -573,7 +573,7 @@ static bool hal_EfuseFixHeaderProcess(struct adapter *pAdapter, u8 efuseType, st
 	u16	efuse_addr = *pAddr;
 	u32	PgWriteSuccess = 0;
 
-	_rtw_memset((void *)originaldata, 0xff, 8);
+	memset((void *)originaldata, 0xff, 8);
 
 	if (Efuse_PgPacketRead(pAdapter, pFixPkt->offset, originaldata)) {
 		/* check if data exist */
@@ -868,7 +868,7 @@ hal_EfusePgCheckAvailableAddr(
 
 static void hal_EfuseConstructPGPkt(u8 offset, u8 word_en, u8 *pData, struct pgpkt *pTargetPkt)
 {
-	_rtw_memset((void *)pTargetPkt->data, 0xFF, sizeof(u8)*8);
+	memset((void *)pTargetPkt->data, 0xFF, sizeof(u8)*8);
 	pTargetPkt->offset = offset;
 	pTargetPkt->word_en = word_en;
 	efuse_WordEnableDataRead(word_en, pData, pTargetPkt->data);
@@ -1095,7 +1095,7 @@ u8 rtw_efuse_map_write(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
 
 	offset = (addr >> 3);
 	word_en = 0xF;
-	_rtw_memset(newdata, 0xFF, PGPKT_DATA_SIZE + 1);
+	memset(newdata, 0xFF, PGPKT_DATA_SIZE + 1);
 	i = addr & 0x7;	/*  index of one package */
 	idx = 0;	/*  data index */
 
@@ -1151,7 +1151,7 @@ u8 rtw_efuse_map_write(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
 		offset++;
 		i = 0;
 		word_en = 0xF;
-		_rtw_memset(newdata, 0xFF, PGPKT_DATA_SIZE);
+		memset(newdata, 0xFF, PGPKT_DATA_SIZE);
 	} while (1);
 
 	Efuse_PowerSwitch(padapter, true, false);
@@ -1236,7 +1236,7 @@ void EFUSE_ShadowMapUpdate(
 	EFUSE_GetEfuseDefinition(pAdapter, efuseType, TYPE_EFUSE_MAP_LEN, (void *)&mapLen);
 
 	if (pEEPROM->bautoload_fail_flag)
-		_rtw_memset(pEEPROM->efuse_eeprom_data, 0xFF, mapLen);
+		memset(pEEPROM->efuse_eeprom_data, 0xFF, mapLen);
 	else
 		Efuse_ReadAllMap(pAdapter, efuseType, pEEPROM->efuse_eeprom_data);
 }
diff --git a/drivers/staging/rtl8188eu/core/rtw_ieee80211.c b/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
index 0552019..ae8895e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
@@ -334,7 +334,7 @@ exit:
 void rtw_set_supported_rate(u8 *SupportedRates, uint mode)
 {
 
-	_rtw_memset(SupportedRates, 0, NDIS_802_11_LENGTH_RATES_EX);
+	memset(SupportedRates, 0, NDIS_802_11_LENGTH_RATES_EX);
 
 	switch (mode) {
 	case WIRELESS_11B:
@@ -957,7 +957,7 @@ enum parse_res rtw_ieee802_11_parse_elems(u8 *start, uint len,
 	u8 *pos = start;
 	int unknown = 0;
 
-	_rtw_memset(elems, 0, sizeof(*elems));
+	memset(elems, 0, sizeof(*elems));
 
 	while (left >= 2) {
 		u8 id, elen;
@@ -1333,9 +1333,9 @@ static uint rtw_p2p_attr_remove(u8 *ie, uint ielen_ori, u8 attr_id)
 			u8 *next_attr = target_attr+target_attr_len;
 			uint remain_len = ielen-(next_attr-ie);
 
-			_rtw_memset(target_attr, 0, target_attr_len);
+			memset(target_attr, 0, target_attr_len);
 			memcpy(target_attr, next_attr, remain_len);
-			_rtw_memset(target_attr+remain_len, 0, target_attr_len);
+			memset(target_attr+remain_len, 0, target_attr_len);
 			*(ie+1) -= target_attr_len;
 			ielen -= target_attr_len;
 		} else {
@@ -1359,7 +1359,7 @@ void rtw_wlan_bssid_ex_remove_p2p_attr(struct wlan_bssid_ex *bss_ex, u8 attr_id)
 			uint remain_len = bss_ex->IELength-(next_ie_ori-bss_ex->IEs);
 
 			memcpy(next_ie, next_ie_ori, remain_len);
-			_rtw_memset(next_ie+remain_len, 0, p2p_ielen_ori-p2p_ielen);
+			memset(next_ie+remain_len, 0, p2p_ielen_ori-p2p_ielen);
 			bss_ex->IELength -= p2p_ielen_ori-p2p_ielen;
 		}
 	}
diff --git a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
index 3dea17f..7426d00 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
@@ -126,7 +126,7 @@ u8 rtw_do_join(struct adapter *padapter)
 
 				pibss = padapter->registrypriv.dev_network.MacAddress;
 
-				_rtw_memset(&pdev_network->Ssid, 0, sizeof(struct ndis_802_11_ssid));
+				memset(&pdev_network->Ssid, 0, sizeof(struct ndis_802_11_ssid));
 				memcpy(&pdev_network->Ssid, &pmlmepriv->assoc_ssid, sizeof(struct ndis_802_11_ssid));
 
 				rtw_update_registrypriv_dev_network(padapter);
@@ -605,7 +605,7 @@ u8 rtw_set_802_11_remove_wep(struct adapter *padapter, u32 keyindex)
 		int res;
 		struct security_priv *psecuritypriv = &(padapter->securitypriv);
 		if (keyindex < 4) {
-			_rtw_memset(&psecuritypriv->dot11DefKey[keyindex], 0, 16);
+			memset(&psecuritypriv->dot11DefKey[keyindex], 0, 16);
 			res = rtw_set_key(padapter, psecuritypriv, keyindex, 0);
 			psecuritypriv->dot11DefKeylen[keyindex] = 0;
 			if (res == _FAIL)
@@ -869,9 +869,9 @@ u8 rtw_set_802_11_add_key(struct adapter *padapter, struct ndis_802_11_key *key)
 			ret = _FAIL;
 			goto exit;
 		}
-		_rtw_memset(&padapter->securitypriv.dot118021XGrpKey[(u8)((key->KeyIndex) & 0x03)], 0, 16);
-		_rtw_memset(&padapter->securitypriv.dot118021XGrptxmickey[(u8)((key->KeyIndex) & 0x03)], 0, 16);
-		_rtw_memset(&padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex) & 0x03)], 0, 16);
+		memset(&padapter->securitypriv.dot118021XGrpKey[(u8)((key->KeyIndex) & 0x03)], 0, 16);
+		memset(&padapter->securitypriv.dot118021XGrptxmickey[(u8)((key->KeyIndex) & 0x03)], 0, 16);
+		memset(&padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex) & 0x03)], 0, 16);
 
 		if ((key->KeyIndex & 0x10000000)) {
 			memcpy(&padapter->securitypriv.dot118021XGrptxmickey[(u8)((key->KeyIndex) & 0x03)], key->KeyMaterial + 16, 8);
@@ -931,7 +931,7 @@ u8 rtw_set_802_11_add_key(struct adapter *padapter, struct ndis_802_11_key *key)
 		stainfo = rtw_get_stainfo(&padapter->stapriv, pbssid);
 
 		if (stainfo != NULL) {
-			_rtw_memset(&stainfo->dot118021x_UncstKey, 0, 16);/*  clear keybuffer */
+			memset(&stainfo->dot118021x_UncstKey, 0, 16);/*  clear keybuffer */
 
 			memcpy(&stainfo->dot118021x_UncstKey, key->KeyMaterial, 16);
 
@@ -988,7 +988,7 @@ u8 rtw_set_802_11_remove_key(struct adapter *padapter, struct ndis_802_11_remove
 	if (bgroup) {
 		/*  clear group key by index */
 
-		_rtw_memset(&padapter->securitypriv.dot118021XGrpKey[keyIndex], 0, 16);
+		memset(&padapter->securitypriv.dot118021XGrpKey[keyIndex], 0, 16);
 
 		/*  \todo Send a H2C Command to Firmware for removing this Key in CAM Entry. */
 	} else {
@@ -996,7 +996,7 @@ u8 rtw_set_802_11_remove_key(struct adapter *padapter, struct ndis_802_11_remove
 		stainfo = rtw_get_stainfo(&padapter->stapriv, pbssid);
 		if (stainfo) {
 			/*  clear key by BSSID */
-			_rtw_memset(&stainfo->dot118021x_UncstKey, 0, 16);
+			memset(&stainfo->dot118021x_UncstKey, 0, 16);
 
 			/*  \todo Send a H2C Command to Firmware for disable this Key in CAM Entry. */
 		} else {
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index e73a784..1a39b67 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -59,7 +59,7 @@ int _rtw_init_mlme_priv(struct adapter *padapter)
 
 	set_scanned_network_val(pmlmepriv, 0);
 
-	_rtw_memset(&pmlmepriv->assoc_ssid, 0, sizeof(struct ndis_802_11_ssid));
+	memset(&pmlmepriv->assoc_ssid, 0, sizeof(struct ndis_802_11_ssid));
 
 	pbuf = vzalloc(MAX_BSS_CNT * (sizeof(struct wlan_network)));
 
@@ -754,7 +754,7 @@ void rtw_surveydone_event_callback(struct adapter	*adapter, u8 *pbuf)
 
 					RT_TRACE(_module_rtl871x_mlme_c_, _drv_err_, ("switching to adhoc master\n"));
 
-					_rtw_memset(&pdev_network->Ssid, 0, sizeof(struct ndis_802_11_ssid));
+					memset(&pdev_network->Ssid, 0, sizeof(struct ndis_802_11_ssid));
 					memcpy(&pdev_network->Ssid, &pmlmepriv->assoc_ssid, sizeof(struct ndis_802_11_ssid));
 
 					rtw_update_registrypriv_dev_network(adapter);
@@ -1000,11 +1000,11 @@ static struct sta_info *rtw_joinbss_update_stainfo(struct adapter *padapter, str
 			padapter->securitypriv.bgrpkey_handshake = false;
 			psta->ieee8021x_blocked = true;
 			psta->dot118021XPrivacy = padapter->securitypriv.dot11PrivacyAlgrthm;
-			_rtw_memset((u8 *)&psta->dot118021x_UncstKey, 0, sizeof(union Keytype));
-			_rtw_memset((u8 *)&psta->dot11tkiprxmickey, 0, sizeof(union Keytype));
-			_rtw_memset((u8 *)&psta->dot11tkiptxmickey, 0, sizeof(union Keytype));
-			_rtw_memset((u8 *)&psta->dot11txpn, 0, sizeof(union pn48));
-			_rtw_memset((u8 *)&psta->dot11rxpn, 0, sizeof(union pn48));
+			memset((u8 *)&psta->dot118021x_UncstKey, 0, sizeof(union Keytype));
+			memset((u8 *)&psta->dot11tkiprxmickey, 0, sizeof(union Keytype));
+			memset((u8 *)&psta->dot11tkiptxmickey, 0, sizeof(union Keytype));
+			memset((u8 *)&psta->dot11txpn, 0, sizeof(union pn48));
+			memset((u8 *)&psta->dot11rxpn, 0, sizeof(union pn48));
 		}
 		/*
 		 * Commented by Albert 2012/07/21
@@ -1419,7 +1419,7 @@ void rtw_stadel_event_callback(struct adapter *adapter, u8 *pbuf)
 
 			memcpy(pdev_network, &tgt_network->network, get_wlan_bssid_ex_sz(&tgt_network->network));
 
-			_rtw_memset(&pdev_network->Ssid, 0, sizeof(struct ndis_802_11_ssid));
+			memset(&pdev_network->Ssid, 0, sizeof(struct ndis_802_11_ssid));
 			memcpy(&pdev_network->Ssid, &pmlmepriv->assoc_ssid, sizeof(struct ndis_802_11_ssid));
 
 			rtw_update_registrypriv_dev_network(adapter);
@@ -1681,7 +1681,7 @@ int rtw_set_auth(struct adapter *adapter, struct security_priv *psecuritypriv)
 		res = _FAIL;
 		goto exit;
 	}
-	_rtw_memset(psetauthparm, 0, sizeof(struct setauth_parm));
+	memset(psetauthparm, 0, sizeof(struct setauth_parm));
 	psetauthparm->mode = (unsigned char)psecuritypriv->dot11AuthAlgrthm;
 	pcmd->cmdcode = _SetAuth_CMD_;
 	pcmd->parmbuf = (unsigned char *)psetauthparm;
@@ -1716,7 +1716,7 @@ int rtw_set_key(struct adapter *adapter, struct security_priv *psecuritypriv, in
 		goto err_free_cmd;
 	}
 
-	_rtw_memset(psetkeyparm, 0, sizeof(struct setkey_parm));
+	memset(psetkeyparm, 0, sizeof(struct setkey_parm));
 
 	if (psecuritypriv->dot11AuthAlgrthm == dot11AuthAlgrthm_8021X) {
 		psetkeyparm->algorithm = (unsigned char)psecuritypriv->dot118021XGrpPrivacy;
@@ -2050,7 +2050,7 @@ unsigned int rtw_restructure_ht_ie(struct adapter *padapter, u8 *in_ie, u8 *out_
 
 		out_len = *pout_len;
 
-		_rtw_memset(&ht_capie, 0, sizeof(struct rtw_ieee80211_ht_cap));
+		memset(&ht_capie, 0, sizeof(struct rtw_ieee80211_ht_cap));
 
 		ht_capie.cap_info = IEEE80211_HT_CAP_SUP_WIDTH |
 				    IEEE80211_HT_CAP_SGI_20 |
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index b2a1251..01cc80a 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -256,7 +256,7 @@ static void init_mlme_ext_priv_value(struct adapter *padapter)
 	pmlmeinfo->enc_algo = _NO_PRIVACY_;
 	pmlmeinfo->authModeToggle = 0;
 
-	_rtw_memset(pmlmeinfo->chg_txt, 0, 128);
+	memset(pmlmeinfo->chg_txt, 0, 128);
 
 	pmlmeinfo->slotTime = SHORT_SLOT_TIME;
 	pmlmeinfo->preamble_mode = PREAMBLE_AUTO;
@@ -328,7 +328,7 @@ static u8 init_channel_set(struct adapter *padapter, u8 ChannelPlan, struct rt_c
 	u8 b2_4GBand = false;
 	u8 Index2G = 0;
 
-	_rtw_memset(channel_set, 0, sizeof(struct rt_channel_info) * MAX_CHANNEL_NUM);
+	memset(channel_set, 0, sizeof(struct rt_channel_info) * MAX_CHANNEL_NUM);
 
 	if (ChannelPlan >= RT_CHANNEL_DOMAIN_MAX && ChannelPlan != RT_CHANNEL_DOMAIN_REALTEK_DEFINE) {
 		DBG_88E("ChannelPlan ID %x error !!!!!\n", ChannelPlan);
@@ -914,7 +914,7 @@ auth_fail:
 		rtw_free_stainfo(padapter , pstat);
 
 	pstat = &stat;
-	_rtw_memset((char *)pstat, '\0', sizeof(stat));
+	memset((char *)pstat, '\0', sizeof(stat));
 	pstat->auth_seq = 2;
 	memcpy(pstat->hwaddr, sa, 6);
 
@@ -1146,7 +1146,7 @@ unsigned int OnAssocReq(struct adapter *padapter, struct recv_frame *precv_frame
 	pstat->wpa2_group_cipher = 0;
 	pstat->wpa_pairwise_cipher = 0;
 	pstat->wpa2_pairwise_cipher = 0;
-	_rtw_memset(pstat->wpa_ie, 0, sizeof(pstat->wpa_ie));
+	memset(pstat->wpa_ie, 0, sizeof(pstat->wpa_ie));
 	if ((psecuritypriv->wpa_psk & BIT(1)) && elems.rsn_ie) {
 		int group_cipher = 0, pairwise_cipher = 0;
 
@@ -1314,7 +1314,7 @@ unsigned int OnAssocReq(struct adapter *padapter, struct recv_frame *precv_frame
 	}
 
 	/* save HT capabilities in the sta object */
-	_rtw_memset(&pstat->htpriv.ht_cap, 0, sizeof(struct rtw_ieee80211_ht_cap));
+	memset(&pstat->htpriv.ht_cap, 0, sizeof(struct rtw_ieee80211_ht_cap));
 	if (elems.ht_capabilities && elems.ht_capabilities_len >= sizeof(struct rtw_ieee80211_ht_cap)) {
 		pstat->flags |= WLAN_STA_HT;
 
@@ -1861,7 +1861,7 @@ void issue_p2p_GO_request(struct adapter *padapter, u8 *raddr)
 	pattrib = &pmgntframe->attrib;
 	update_mgntframe_attrib(padapter, pattrib);
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -2208,7 +2208,7 @@ static void issue_p2p_GO_response(struct adapter *padapter, u8 *raddr, u8 *frame
 	pattrib = &pmgntframe->attrib;
 	update_mgntframe_attrib(padapter, pattrib);
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -2241,7 +2241,7 @@ static void issue_p2p_GO_response(struct adapter *padapter, u8 *raddr, u8 *frame
 	rtw_get_wps_attr_content(wpsie, wpsielen, WPS_ATTR_DEVICE_PWID, (u8 *)&be_tmp, &wps_devicepassword_id_len);
 	wps_devicepassword_id = be16_to_cpu(be_tmp);
 
-	_rtw_memset(wpsie, 0x00, 255);
+	memset(wpsie, 0x00, 255);
 	wpsielen = 0;
 
 	/*	WPS Section */
@@ -2570,7 +2570,7 @@ static void issue_p2p_GO_confirm(struct adapter *padapter, u8 *raddr, u8 result)
 	pattrib = &pmgntframe->attrib;
 	update_mgntframe_attrib(padapter, pattrib);
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -2737,7 +2737,7 @@ void issue_p2p_invitation_request(struct adapter *padapter, u8 *raddr)
 	pattrib = &pmgntframe->attrib;
 	update_mgntframe_attrib(padapter, pattrib);
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -2990,7 +2990,7 @@ void issue_p2p_invitation_response(struct adapter *padapter, u8 *raddr, u8 dialo
 	pattrib = &pmgntframe->attrib;
 	update_mgntframe_attrib(padapter, pattrib);
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -3185,7 +3185,7 @@ void issue_p2p_provision_request(struct adapter *padapter, u8 *pssid, u8 ussidle
 	pattrib = &pmgntframe->attrib;
 	update_mgntframe_attrib(padapter, pattrib);
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -3297,7 +3297,7 @@ void issue_probersp_p2p(struct adapter *padapter, unsigned char *da)
 	pattrib = &pmgntframe->attrib;
 	update_mgntframe_attrib(padapter, pattrib);
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -3549,7 +3549,7 @@ static int _issue_probereq_p2p(struct adapter *padapter, u8 *da, int wait_ack)
 	update_mgntframe_attrib(padapter, pattrib);
 
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -3922,7 +3922,7 @@ static unsigned int on_action_public_p2p(struct recv_frame *precv_frame)
 	switch (frame_body[6]) { /* OUI Subtype */
 	case P2P_GO_NEGO_REQ:
 		DBG_88E("[%s] Got GO Nego Req Frame\n", __func__);
-		_rtw_memset(&pwdinfo->groupid_info, 0x00, sizeof(struct group_id_info));
+		memset(&pwdinfo->groupid_info, 0x00, sizeof(struct group_id_info));
 
 		if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_RX_PROVISION_DIS_REQ))
 			rtw_p2p_set_state(pwdinfo, rtw_p2p_pre_state(pwdinfo));
@@ -4023,7 +4023,7 @@ static unsigned int on_action_public_p2p(struct recv_frame *precv_frame)
 				if (invitation_flag & P2P_INVITATION_FLAGS_PERSISTENT) {
 					/*	Re-invoke the persistent group. */
 
-					_rtw_memset(&group_id, 0x00, sizeof(struct group_id_info));
+					memset(&group_id, 0x00, sizeof(struct group_id_info));
 					rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_GROUP_ID, (u8 *)&group_id, &attr_contentlen);
 					if (attr_contentlen) {
 						if (!memcmp(group_id.go_device_addr, myid(&padapter->eeprompriv), ETH_ALEN)) {
@@ -4071,7 +4071,7 @@ static unsigned int on_action_public_p2p(struct recv_frame *precv_frame)
 				} else {
 					/*	Received the invitation to join a P2P group. */
 
-					_rtw_memset(&group_id, 0x00, sizeof(struct group_id_info));
+					memset(&group_id, 0x00, sizeof(struct group_id_info));
 					rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_GROUP_ID, (u8 *)&group_id, &attr_contentlen);
 					if (attr_contentlen) {
 						if (!memcmp(group_id.go_device_addr, myid(&padapter->eeprompriv), ETH_ALEN)) {
@@ -4361,7 +4361,7 @@ void update_mgntframe_attrib(struct adapter *padapter, struct pkt_attrib *pattri
 {
 	struct mlme_ext_priv	*pmlmeext = &(padapter->mlmeextpriv);
 
-	_rtw_memset((u8 *)(pattrib), 0, sizeof(struct pkt_attrib));
+	memset((u8 *)(pattrib), 0, sizeof(struct pkt_attrib));
 
 	pattrib->hdrlen = 24;
 	pattrib->nr_frags = 1;
@@ -4464,7 +4464,7 @@ static int update_hidden_ssid(u8 *ies, u32 ies_len, u8 hidden_ssid_mode)
 			break;
 		}
 		case 2:
-			_rtw_memset(&ssid_ie[2], 0, ssid_len_ori);
+			memset(&ssid_ie[2], 0, ssid_len_ori);
 			break;
 		default:
 			break;
@@ -4506,7 +4506,7 @@ void issue_beacon(struct adapter *padapter, int timeout_ms)
 	update_mgntframe_attrib(padapter, pattrib);
 	pattrib->qsel = 0x10;
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -4732,7 +4732,7 @@ void issue_probersp(struct adapter *padapter, unsigned char *da, u8 is_valid_p2p
 	pattrib = &pmgntframe->attrib;
 	update_mgntframe_attrib(padapter, pattrib);
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -4889,7 +4889,7 @@ static int _issue_probereq(struct adapter *padapter, struct ndis_802_11_ssid *ps
 	update_mgntframe_attrib(padapter, pattrib);
 
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -5025,7 +5025,7 @@ void issue_auth(struct adapter *padapter, struct sta_info *psta, unsigned short
 	pattrib = &pmgntframe->attrib;
 	update_mgntframe_attrib(padapter, pattrib);
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -5169,7 +5169,7 @@ void issue_asocrsp(struct adapter *padapter, unsigned short status, struct sta_i
 	update_mgntframe_attrib(padapter, pattrib);
 
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -5308,7 +5308,7 @@ void issue_assocreq(struct adapter *padapter)
 	pattrib = &pmgntframe->attrib;
 	update_mgntframe_attrib(padapter, pattrib);
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
 
@@ -5639,7 +5639,7 @@ static int _issue_nulldata(struct adapter *padapter, unsigned char *da, unsigned
 	update_mgntframe_attrib(padapter, pattrib);
 	pattrib->retry_ctrl = false;
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -5755,7 +5755,7 @@ static int _issue_qos_nulldata(struct adapter *padapter, unsigned char *da, u16
 	pattrib->ack_policy = 0;
 	pattrib->mdata = 0;
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -5880,7 +5880,7 @@ static int _issue_deauth(struct adapter *padapter, unsigned char *da, unsigned s
 	update_mgntframe_attrib(padapter, pattrib);
 	pattrib->retry_ctrl = false;
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -5982,7 +5982,7 @@ void issue_action_spct_ch_switch (struct adapter *padapter, u8 *ra, u8 new_ch, u
 	pattrib = &pmgntframe->attrib;
 	update_mgntframe_attrib(padapter, pattrib);
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -6052,7 +6052,7 @@ void issue_action_BA(struct adapter *padapter, unsigned char *raddr, unsigned ch
 	pattrib = &pmgntframe->attrib;
 	update_mgntframe_attrib(padapter, pattrib);
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -6194,7 +6194,7 @@ static void issue_action_BSSCoexistPacket(struct adapter *padapter)
 	pattrib = &pmgntframe->attrib;
 	update_mgntframe_attrib(padapter, pattrib);
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -6228,7 +6228,7 @@ static void issue_action_BSSCoexistPacket(struct adapter *padapter)
 
 
 	/*  */
-	_rtw_memset(ICS, 0, sizeof(ICS));
+	memset(ICS, 0, sizeof(ICS));
 	if (pmlmepriv->num_sta_no_ht > 0) {
 		int i;
 
@@ -6557,7 +6557,7 @@ u8 collect_bss_info(struct adapter *padapter, struct recv_frame *precv_frame, st
 	if (len > MAX_IE_SZ)
 		return _FAIL;
 
-	_rtw_memset(bssid, 0, sizeof(struct wlan_bssid_ex));
+	memset(bssid, 0, sizeof(struct wlan_bssid_ex));
 
 	subtype = GetFrameSubType(pframe);
 
@@ -6608,7 +6608,7 @@ u8 collect_bss_info(struct adapter *padapter, struct recv_frame *precv_frame, st
 		bssid->Ssid.SsidLength = 0;
 	}
 
-	_rtw_memset(bssid->SupportedRates, 0, NDIS_802_11_LENGTH_RATES_EX);
+	memset(bssid->SupportedRates, 0, NDIS_802_11_LENGTH_RATES_EX);
 
 	/* checking rate info... */
 	i = 0;
@@ -6912,7 +6912,7 @@ static void process_80211d(struct adapter *padapter, struct wlan_bssid_ex *bssid
 		p = ie;
 		ie += len;
 
-		_rtw_memset(country, 0, 4);
+		memset(country, 0, 4);
 		memcpy(country, p, 3);
 		p += 3;
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_notice_,
@@ -6937,7 +6937,7 @@ static void process_80211d(struct adapter *padapter, struct wlan_bssid_ex *bssid
 
 		memcpy(chplan_sta, pmlmeext->channel_set, sizeof(chplan_sta));
 
-		_rtw_memset(pmlmeext->channel_set, 0, sizeof(pmlmeext->channel_set));
+		memset(pmlmeext->channel_set, 0, sizeof(pmlmeext->channel_set));
 		chplan_new = pmlmeext->channel_set;
 
 		i = 0;
@@ -8017,7 +8017,7 @@ static int rtw_scan_ch_decision(struct adapter *padapter, struct rtw_ieee80211_c
 	struct mlme_ext_priv	*pmlmeext = &padapter->mlmeextpriv;
 
 	/* clear out first */
-	_rtw_memset(out, 0, sizeof(struct rtw_ieee80211_channel)*out_num);
+	memset(out, 0, sizeof(struct rtw_ieee80211_channel)*out_num);
 
 	/* acquire channels from in */
 	j = 0;
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp.c b/drivers/staging/rtl8188eu/core/rtw_mp.c
index 43765f8..25d2bc8 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp.c
@@ -97,7 +97,7 @@ static void _init_mp_priv_(struct mp_priv *pmp_priv)
 {
 	struct wlan_bssid_ex *pnetwork;
 
-	_rtw_memset(pmp_priv, 0, sizeof(struct mp_priv));
+	memset(pmp_priv, 0, sizeof(struct mp_priv));
 
 	pmp_priv->mode = MP_OFF;
 
@@ -138,12 +138,12 @@ static void mp_init_xmit_attrib(struct mp_tx *pmptx, struct adapter *padapter)
 
 	/*  init xmitframe attribute */
 	pattrib = &pmptx->attrib;
-	_rtw_memset(pattrib, 0, sizeof(struct pkt_attrib));
+	memset(pattrib, 0, sizeof(struct pkt_attrib));
 	desc = &pmptx->desc;
-	_rtw_memset(desc, 0, TXDESC_SIZE);
+	memset(desc, 0, TXDESC_SIZE);
 
 	pattrib->ether_type = 0x8712;
-	_rtw_memset(pattrib->dst, 0xFF, ETH_ALEN);
+	memset(pattrib->dst, 0xFF, ETH_ALEN);
 	pattrib->ack_policy = 0;
 	pattrib->hdrlen = WLAN_HDR_A3_LEN;
 	pattrib->subtype = WIFI_DATA;
@@ -362,7 +362,6 @@ s32 mp_start_test(struct adapter *padapter)
 	mpt_ProStartTest(padapter);
 
 	/* 3 1. initialize a new struct wlan_bssid_ex */
-/*	_rtw_memset(&bssid, 0, sizeof(struct wlan_bssid_ex)); */
 	memcpy(bssid.MacAddress, pmppriv->network_macaddr, ETH_ALEN);
 	bssid.Ssid.SsidLength = strlen("mp_pseudo_adhoc");
 	memcpy(bssid.Ssid.Ssid, (u8 *)"mp_pseudo_adhoc", bssid.Ssid.SsidLength);
@@ -454,7 +453,7 @@ void mp_stop_test(struct adapter *padapter)
 		pmlmepriv->fw_state = pmppriv->prev_fw_state; /*  WIFI_STATION_STATE; */
 
 		/* flush the cur_network */
-		_rtw_memset(tgt_network, 0, sizeof(struct wlan_network));
+		memset(tgt_network, 0, sizeof(struct wlan_network));
 
 		_clr_fwstate_(pmlmepriv, WIFI_MP_STATE);
 
@@ -697,7 +696,7 @@ void SetPacketTx(struct adapter *padapter)
 	ptr = pmp_priv->tx.buf;
 
 	desc = &(pmp_priv->tx.desc);
-	_rtw_memset(desc, 0, TXDESC_SIZE);
+	memset(desc, 0, TXDESC_SIZE);
 	pkt_start = ptr;
 	pkt_end = pkt_start + pkt_size;
 
@@ -770,7 +769,7 @@ void SetPacketTx(struct adapter *padapter)
 		break;
 	}
 
-	_rtw_memset(ptr, payload, pkt_end - ptr);
+	memset(ptr, payload, pkt_end - ptr);
 
 	/* 3 6. start thread */
 	pmp_priv->tx.PktTxThread = kthread_run(mp_xmit_packet_thread, pmp_priv, "RTW_MP_THREAD");
@@ -905,7 +904,7 @@ u32 mp_query_psd(struct adapter *pAdapter, u8 *data)
 			return 0;
 	}
 
-	_rtw_memset(data, '\0', sizeof(*data));
+	memset(data, '\0', sizeof(*data));
 
 	i = psd_start;
 	while (i < psd_stop) {
diff --git a/drivers/staging/rtl8188eu/core/rtw_p2p.c b/drivers/staging/rtl8188eu/core/rtw_p2p.c
index 0a15f8c..82c52ed 100644
--- a/drivers/staging/rtl8188eu/core/rtw_p2p.c
+++ b/drivers/staging/rtl8188eu/core/rtw_p2p.c
@@ -153,7 +153,7 @@ static void issue_group_disc_req(struct wifidirect_info *pwdinfo, u8 *da)
 	pattrib = &pmgntframe->attrib;
 	update_mgntframe_attrib(padapter, pattrib);
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -212,7 +212,7 @@ static void issue_p2p_devdisc_resp(struct wifidirect_info *pwdinfo, u8 *da, u8 s
 	pattrib = &pmgntframe->attrib;
 	update_mgntframe_attrib(padapter, pattrib);
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -283,7 +283,7 @@ static void issue_p2p_provision_resp(struct wifidirect_info *pwdinfo, u8 *raddr,
 	pattrib = &pmgntframe->attrib;
 	update_mgntframe_attrib(padapter, pattrib);
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -362,7 +362,7 @@ static void issue_p2p_presence_resp(struct wifidirect_info *pwdinfo, u8 *da, u8
 	pattrib = &pmgntframe->attrib;
 	update_mgntframe_attrib(padapter, pattrib);
 
-	_rtw_memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
+	memset(pmgntframe->buf_addr, 0, WLANHDR_OFFSET + TXDESC_OFFSET);
 
 	pframe = (u8 *)(pmgntframe->buf_addr) + TXDESC_OFFSET;
 	pwlanhdr = (struct rtw_ieee80211_hdr *)pframe;
@@ -1197,7 +1197,7 @@ u8 process_p2p_group_negotation_req(struct wifidirect_info *pwdinfo, u8 *pframe,
 		attr_contentlen = 0;
 		if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_INTENTED_IF_ADDR, pwdinfo->p2p_peer_interface_addr, &attr_contentlen)) {
 			if (attr_contentlen != ETH_ALEN)
-				_rtw_memset(pwdinfo->p2p_peer_interface_addr, 0x00, ETH_ALEN);
+				memset(pwdinfo->p2p_peer_interface_addr, 0x00, ETH_ALEN);
 		}
 
 		if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_CH_LIST, ch_content, &ch_cnt)) {
@@ -1300,7 +1300,7 @@ u8 process_p2p_group_negotation_resp(struct wifidirect_info *pwdinfo, u8 *pframe
 			attr_contentlen = 0;
 			if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_INTENTED_IF_ADDR, pwdinfo->p2p_peer_interface_addr, &attr_contentlen)) {
 				if (attr_contentlen != ETH_ALEN)
-					_rtw_memset(pwdinfo->p2p_peer_interface_addr, 0x00, ETH_ALEN);
+					memset(pwdinfo->p2p_peer_interface_addr, 0x00, ETH_ALEN);
 			}
 
 			/*	Try to get the peer's intent and tie breaker value. */
@@ -1392,7 +1392,7 @@ u8 process_p2p_group_negotation_resp(struct wifidirect_info *pwdinfo, u8 *pframe
 
 			/*	Try to get the group id information if peer is GO */
 			attr_contentlen = 0;
-			_rtw_memset(groupid, 0x00, 38);
+			memset(groupid, 0x00, 38);
 			if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_GROUP_ID, groupid, &attr_contentlen)) {
 				memcpy(pwdinfo->groupid_info.go_device_addr, &groupid[0], ETH_ALEN);
 				memcpy(pwdinfo->groupid_info.ssid, &groupid[6], attr_contentlen - ETH_ALEN);
@@ -1456,7 +1456,7 @@ u8 process_p2p_group_negotation_confirm(struct wifidirect_info *pwdinfo, u8 *pfr
 
 		/*	Try to get the group id information */
 		attr_contentlen = 0;
-		_rtw_memset(groupid, 0x00, 38);
+		memset(groupid, 0x00, 38);
 		if (rtw_get_p2p_attr_content(p2p_ie, p2p_ielen, P2P_ATTR_GROUP_ID, groupid, &attr_contentlen)) {
 			DBG_88E("[%s] Ssid = %s, ssidlen = %zu\n", __func__, &groupid[ETH_ALEN], strlen(&groupid[ETH_ALEN]));
 			memcpy(pwdinfo->groupid_info.go_device_addr, &groupid[0], ETH_ALEN);
@@ -1499,7 +1499,7 @@ static void find_phase_handler(struct adapter *padapter)
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 
 
-	_rtw_memset((unsigned char *)&ssid, 0, sizeof(struct ndis_802_11_ssid));
+	memset((unsigned char *)&ssid, 0, sizeof(struct ndis_802_11_ssid));
 	memcpy(ssid.Ssid, pwdinfo->p2p_wildcard_ssid, P2P_WILDCARD_SSID_LEN);
 	ssid.SsidLength = P2P_WILDCARD_SSID_LEN;
 
@@ -1930,44 +1930,44 @@ void init_wifidirect_info(struct adapter *padapter, enum P2P_ROLE role)
 
 	memcpy(pwdinfo->p2p_wildcard_ssid, "DIRECT-", 7);
 
-	_rtw_memset(pwdinfo->device_name, 0x00, WPS_MAX_DEVICE_NAME_LEN);
+	memset(pwdinfo->device_name, 0x00, WPS_MAX_DEVICE_NAME_LEN);
 	pwdinfo->device_name_len = 0;
 
-	_rtw_memset(&pwdinfo->invitereq_info, 0x00, sizeof(struct tx_invite_req_info));
+	memset(&pwdinfo->invitereq_info, 0x00, sizeof(struct tx_invite_req_info));
 	pwdinfo->invitereq_info.token = 3;	/*	Token used for P2P invitation request frame. */
 
-	_rtw_memset(&pwdinfo->inviteresp_info, 0x00, sizeof(struct tx_invite_resp_info));
+	memset(&pwdinfo->inviteresp_info, 0x00, sizeof(struct tx_invite_resp_info));
 	pwdinfo->inviteresp_info.token = 0;
 
 	pwdinfo->profileindex = 0;
-	_rtw_memset(&pwdinfo->profileinfo[0], 0x00, sizeof(struct profile_info) * P2P_MAX_PERSISTENT_GROUP_NUM);
+	memset(&pwdinfo->profileinfo[0], 0x00, sizeof(struct profile_info) * P2P_MAX_PERSISTENT_GROUP_NUM);
 
 	rtw_p2p_findphase_ex_set(pwdinfo, P2P_FINDPHASE_EX_NONE);
 
 	pwdinfo->listen_dwell = (u8) ((jiffies % 3) + 1);
 
-	_rtw_memset(&pwdinfo->tx_prov_disc_info, 0x00, sizeof(struct tx_provdisc_req_info));
+	memset(&pwdinfo->tx_prov_disc_info, 0x00, sizeof(struct tx_provdisc_req_info));
 	pwdinfo->tx_prov_disc_info.wps_config_method_request = WPS_CM_NONE;
 
-	_rtw_memset(&pwdinfo->nego_req_info, 0x00, sizeof(struct tx_nego_req_info));
+	memset(&pwdinfo->nego_req_info, 0x00, sizeof(struct tx_nego_req_info));
 
 	pwdinfo->device_password_id_for_nego = WPS_DPID_PBC;
 	pwdinfo->negotiation_dialog_token = 1;
 
-	_rtw_memset(pwdinfo->nego_ssid, 0x00, WLAN_SSID_MAXLEN);
+	memset(pwdinfo->nego_ssid, 0x00, WLAN_SSID_MAXLEN);
 	pwdinfo->nego_ssidlen = 0;
 
 	pwdinfo->ui_got_wps_info = P2P_NO_WPSINFO;
 	pwdinfo->supported_wps_cm = WPS_CONFIG_METHOD_DISPLAY | WPS_CONFIG_METHOD_PBC | WPS_CONFIG_METHOD_KEYPAD;
 	pwdinfo->channel_list_attr_len = 0;
-	_rtw_memset(pwdinfo->channel_list_attr, 0x00, 100);
+	memset(pwdinfo->channel_list_attr, 0x00, 100);
 
-	_rtw_memset(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, 0x00, 4);
-	_rtw_memset(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, '0', 3);
-	_rtw_memset(&pwdinfo->groupid_info, 0x00, sizeof(struct group_id_info));
+	memset(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, 0x00, 4);
+	memset(pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req, '0', 3);
+	memset(&pwdinfo->groupid_info, 0x00, sizeof(struct group_id_info));
 	pwdinfo->wfd_tdls_enable = 0;
-	_rtw_memset(pwdinfo->p2p_peer_interface_addr, 0x00, ETH_ALEN);
-	_rtw_memset(pwdinfo->p2p_peer_device_addr, 0x00, ETH_ALEN);
+	memset(pwdinfo->p2p_peer_interface_addr, 0x00, ETH_ALEN);
+	memset(pwdinfo->p2p_peer_device_addr, 0x00, ETH_ALEN);
 
 	pwdinfo->rx_invitereq_info.operation_ch[0] = 0;
 	pwdinfo->rx_invitereq_info.operation_ch[1] = 0;	/*	Used to indicate the scan end in site survey function */
@@ -2015,7 +2015,7 @@ int rtw_p2p_enable(struct adapter *padapter, enum P2P_ROLE role)
 			reset_ch_sitesurvey_timer_process2(padapter);
 			rtw_p2p_set_state(pwdinfo, P2P_STATE_NONE);
 			rtw_p2p_set_role(pwdinfo, P2P_ROLE_DISABLE);
-			_rtw_memset(&pwdinfo->rx_prov_disc_info, 0x00, sizeof(struct rx_provdisc_req_info));
+			memset(&pwdinfo->rx_prov_disc_info, 0x00, sizeof(struct rx_provdisc_req_info));
 		}
 
 		rtw_hal_set_odm_var(padapter, HAL_ODM_P2P_STATE, NULL, false);
diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index eaf43f2..9e063d0 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -46,7 +46,7 @@ void rtw_signal_stat_timer_hdl(RTW_TIMER_HDL_ARGS);
 void _rtw_init_sta_recv_priv(struct sta_recv_priv *psta_recvpriv)
 {
 
-	_rtw_memset((u8 *)psta_recvpriv, 0, sizeof (struct sta_recv_priv));
+	memset((u8 *)psta_recvpriv, 0, sizeof (struct sta_recv_priv));
 
 	spin_lock_init(&psta_recvpriv->lock);
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_security.c b/drivers/staging/rtl8188eu/core/rtw_security.c
index 0533595..1b64cb6 100644
--- a/drivers/staging/rtl8188eu/core/rtw_security.c
+++ b/drivers/staging/rtl8188eu/core/rtw_security.c
@@ -1081,13 +1081,13 @@ static int aes_cipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 
 	frsubtype = frsubtype>>4;
 
-	_rtw_memset((void *)mic_iv, 0, 16);
-	_rtw_memset((void *)mic_header1, 0, 16);
-	_rtw_memset((void *)mic_header2, 0, 16);
-	_rtw_memset((void *)ctr_preload, 0, 16);
-	_rtw_memset((void *)chain_buffer, 0, 16);
-	_rtw_memset((void *)aes_out, 0, 16);
-	_rtw_memset((void *)padded_buffer, 0, 16);
+	memset((void *)mic_iv, 0, 16);
+	memset((void *)mic_header1, 0, 16);
+	memset((void *)mic_header2, 0, 16);
+	memset((void *)ctr_preload, 0, 16);
+	memset((void *)chain_buffer, 0, 16);
+	memset((void *)aes_out, 0, 16);
+	memset((void *)padded_buffer, 0, 16);
 
 	if ((hdrlen == WLAN_HDR_A3_LEN) || (hdrlen ==  WLAN_HDR_A3_QOS_LEN))
 		a4_exists = 0;
@@ -1279,13 +1279,13 @@ static int aes_decipher(u8 *key, uint	hdrlen,
 	uint	frsubtype  = GetFrameSubType(pframe);
 	frsubtype = frsubtype>>4;
 
-	_rtw_memset((void *)mic_iv, 0, 16);
-	_rtw_memset((void *)mic_header1, 0, 16);
-	_rtw_memset((void *)mic_header2, 0, 16);
-	_rtw_memset((void *)ctr_preload, 0, 16);
-	_rtw_memset((void *)chain_buffer, 0, 16);
-	_rtw_memset((void *)aes_out, 0, 16);
-	_rtw_memset((void *)padded_buffer, 0, 16);
+	memset((void *)mic_iv, 0, 16);
+	memset((void *)mic_header1, 0, 16);
+	memset((void *)mic_header2, 0, 16);
+	memset((void *)ctr_preload, 0, 16);
+	memset((void *)chain_buffer, 0, 16);
+	memset((void *)aes_out, 0, 16);
+	memset((void *)padded_buffer, 0, 16);
 
 	/* start to decrypt the payload */
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
index 2d0b606..341a6d1 100644
--- a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
@@ -29,7 +29,7 @@
 
 static void _rtw_init_stainfo(struct sta_info *psta)
 {
-	_rtw_memset((u8 *)psta, 0, sizeof (struct sta_info));
+	memset((u8 *)psta, 0, sizeof (struct sta_info));
 
 	 spin_lock_init(&psta->lock);
 	_rtw_init_listhead(&psta->list);
diff --git a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
index 6fb8caa..a0b1576 100644
--- a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
@@ -239,7 +239,7 @@ void get_rate_set(struct adapter *padapter, unsigned char *pbssrate, int *bssrat
 {
 	unsigned char supportedrates[NumRates];
 
-	_rtw_memset(supportedrates, 0, NumRates);
+	memset(supportedrates, 0, NumRates);
 	*bssrate_len = ratetbl2rateset(padapter, supportedrates);
 	memcpy(pbssrate, supportedrates, *bssrate_len);
 }
@@ -541,7 +541,7 @@ void flush_all_cam_entry(struct adapter *padapter)
 
 	rtw_hal_set_hwreg(padapter, HW_VAR_CAM_INVALID_ALL, NULL);
 
-	_rtw_memset((u8 *)(pmlmeinfo->FW_sta_info), 0, sizeof(pmlmeinfo->FW_sta_info));
+	memset((u8 *)(pmlmeinfo->FW_sta_info), 0, sizeof(pmlmeinfo->FW_sta_info));
 }
 
 int WMM_param_handler(struct adapter *padapter, struct ndis_802_11_var_ie *pIE)
@@ -1366,7 +1366,7 @@ void update_tx_basic_rate(struct adapter *padapter, u8 wirelessmode)
 	if (!rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE))
 		return;
 #endif /* CONFIG_88EU_P2P */
-	_rtw_memset(supported_rates, 0, NDIS_802_11_LENGTH_RATES_EX);
+	memset(supported_rates, 0, NDIS_802_11_LENGTH_RATES_EX);
 
 	if ((wirelessmode & WIRELESS_11B) && (wirelessmode == WIRELESS_11B))
 		memcpy(supported_rates, rtw_basic_rate_cck, 4);
diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index 3156067..1d83037 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -38,7 +38,7 @@ static void _init_txservq(struct tx_servq *ptxservq)
 
 void	_rtw_init_sta_xmit_priv(struct sta_xmit_priv *psta_xmitpriv)
 {
-	_rtw_memset((unsigned char *)psta_xmitpriv, 0, sizeof (struct sta_xmit_priv));
+	memset((unsigned char *)psta_xmitpriv, 0, sizeof (struct sta_xmit_priv));
 	spin_lock_init(&psta_xmitpriv->lock);
 	_init_txservq(&psta_xmitpriv->be_q);
 	_init_txservq(&psta_xmitpriv->bk_q);
@@ -800,7 +800,7 @@ s32 rtw_make_wlanhdr (struct adapter *padapter , u8 *hdr, struct pkt_attrib *pat
 		}
 	}
 
-	_rtw_memset(hdr, 0, WLANHDR_OFFSET);
+	memset(hdr, 0, WLANHDR_OFFSET);
 
 	SetFrameSubType(fctrl, pattrib->subtype);
 
@@ -1390,7 +1390,7 @@ struct xmit_frame *rtw_alloc_xmitframe(struct xmit_priv *pxmitpriv)/* _queue *pf
 		pxframe->buf_addr = NULL;
 		pxframe->pxmitbuf = NULL;
 
-		_rtw_memset(&pxframe->attrib, 0, sizeof(struct pkt_attrib));
+		memset(&pxframe->attrib, 0, sizeof(struct pkt_attrib));
 		/* pxframe->attrib.psta = NULL; */
 
 		pxframe->frame_tag = DATA_FRAMETAG;
diff --git a/drivers/staging/rtl8188eu/hal/hal_com.c b/drivers/staging/rtl8188eu/hal/hal_com.c
index 429de69..baefb46 100644
--- a/drivers/staging/rtl8188eu/hal/hal_com.c
+++ b/drivers/staging/rtl8188eu/hal/hal_com.c
@@ -350,7 +350,7 @@ s32 c2h_evt_read(struct adapter *adapter, u8 *buf)
 
 	c2h_evt = (struct c2h_evt_hdr *)buf;
 
-	_rtw_memset(c2h_evt, 0, 16);
+	memset(c2h_evt, 0, 16);
 
 	*buf = usb_read8(adapter, REG_C2HEVT_MSG_NORMAL);
 	*(buf+1) = usb_read8(adapter, REG_C2HEVT_MSG_NORMAL + 1);
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
index fe8ba7e..2ab1c80 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
@@ -153,7 +153,7 @@ u8 rtl8188e_set_raid_cmd(struct adapter *adapt, u32 mask)
 	if (haldata->fw_ractrl) {
 		__le32 lmask;
 
-		_rtw_memset(buf, 0, 3);
+		memset(buf, 0, 3);
 		lmask = cpu_to_le32(mask);
 		memcpy(buf, &lmask, 3);
 
@@ -700,7 +700,7 @@ void rtl8188e_set_p2p_ps_offload_cmd(struct adapter *adapt, u8 p2p_ps_state)
 	switch (p2p_ps_state) {
 	case P2P_PS_DISABLE:
 		DBG_88E("P2P_PS_DISABLE\n");
-		_rtw_memset(p2p_ps_offload, 0, 1);
+		memset(p2p_ps_offload, 0, 1);
 		break;
 	case P2P_PS_ENABLE:
 		DBG_88E("P2P_PS_ENABLE\n");
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c b/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
index 917c60e..dab4c33 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_dm.c
@@ -53,7 +53,7 @@ static void Init_ODM_ComInfo_88E(struct adapter *Adapter)
 	u8 cut_ver, fab_ver;
 
 	/*  Init Value */
-	_rtw_memset(dm_odm, 0, sizeof(*dm_odm));
+	memset(dm_odm, 0, sizeof(*dm_odm));
 
 	dm_odm->Adapter = Adapter;
 
@@ -198,7 +198,7 @@ void rtl8188e_init_dm_priv(struct adapter *Adapter)
 	struct dm_priv	*pdmpriv = &hal_data->dmpriv;
 	struct odm_dm_struct *podmpriv = &hal_data->odmpriv;
 
-	_rtw_memset(pdmpriv, 0, sizeof(struct dm_priv));
+	memset(pdmpriv, 0, sizeof(struct dm_priv));
 	Init_ODM_ComInfo_88E(Adapter);
 	ODM_InitDebugSetting(podmpriv);
 }
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 0094d21..1abf974 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -741,7 +741,7 @@ static void Hal_ReadPowerValueFromPROM_8188E(struct txpowerinfo24g *pwrInfo24G,
 {
 	u32 rfPath, eeAddr = EEPROM_TX_PWR_INX_88E, group, TxCount = 0;
 
-	_rtw_memset(pwrInfo24G, 0, sizeof(struct txpowerinfo24g));
+	memset(pwrInfo24G, 0, sizeof(struct txpowerinfo24g));
 
 	if (AutoLoadFail) {
 		for (rfPath = 0; rfPath < MAX_RF_PATH; rfPath++) {
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_rxdesc.c b/drivers/staging/rtl8188eu/hal/rtl8188e_rxdesc.c
index 43eb960..53cf3ba 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_rxdesc.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_rxdesc.c
@@ -86,7 +86,7 @@ void update_recvframe_attrib_88e(struct recv_frame *precvframe,
 	report.rxdw5 = prxstat->rxdw5;
 
 	pattrib = &precvframe->attrib;
-	_rtw_memset(pattrib, 0, sizeof(struct rx_pkt_attrib));
+	memset(pattrib, 0, sizeof(struct rx_pkt_attrib));
 
 	pattrib->crc_err = (u8)((le32_to_cpu(report.rxdw0) >> 14) & 0x1);/* u8)prxreport->crc32; */
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index 32e59c5..ad966e5 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -47,7 +47,7 @@ int	rtl8188eu_init_recv_priv(struct adapter *padapter)
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_, ("alloc recv_buf fail!\n"));
 		goto exit;
 	}
-	_rtw_memset(precvpriv->pallocated_recv_buf, 0, NR_RECVBUFF * sizeof(struct recv_buf) + 4);
+	memset(precvpriv->pallocated_recv_buf, 0, NR_RECVBUFF * sizeof(struct recv_buf) + 4);
 
 	precvpriv->precv_buf = (u8 *)N_BYTE_ALIGMENT((size_t)(precvpriv->pallocated_recv_buf), 4);
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
index 34bc660..5e4be7e 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
@@ -68,7 +68,7 @@ void rtl8188e_fill_fake_txdesc(struct adapter *adapt, u8 *desc, u32 BufferLen, u
 
 	/*  Clear all status */
 	ptxdesc = (struct tx_desc *)desc;
-	_rtw_memset(desc, 0, TXDESC_SIZE);
+	memset(desc, 0, TXDESC_SIZE);
 
 	/* offset 0 */
 	ptxdesc->txdw0 |= cpu_to_le32(OWN | FSG | LSG); /* own, bFirstSeg, bLastSeg; */
@@ -192,7 +192,7 @@ static s32 update_txdesc(struct xmit_frame *pxmitframe, u8 *pmem, s32 sz, u8 bag
 		}
 	}
 
-	_rtw_memset(ptxdesc, 0, sizeof(struct tx_desc));
+	memset(ptxdesc, 0, sizeof(struct tx_desc));
 
 	/* 4 offset 0 */
 	ptxdesc->txdw0 |= cpu_to_le32(OWN | FSG | LSG);
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 3859acd..2cd9e26 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -199,7 +199,6 @@ void *rtw_malloc2d(int h, int w, int size);
 void rtw_mfree2d(void *pbuf, int h, int w, int size);
 
 void _rtw_memcpy(void *dec, void *sour, u32 sz);
-void _rtw_memset(void *pbuf, int c, u32 sz);
 
 void _rtw_init_listhead(struct list_head *list);
 u32  rtw_is_list_empty(struct list_head *phead);
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 9b5c549..8ddeaac 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -147,7 +147,7 @@ void indicate_wx_scan_complete_event(struct adapter *padapter)
 {
 	union iwreq_data wrqu;
 
-	_rtw_memset(&wrqu, 0, sizeof(union iwreq_data));
+	memset(&wrqu, 0, sizeof(union iwreq_data));
 	wireless_send_event(padapter->pnetdev, SIOCGIWSCAN, &wrqu, NULL);
 }
 
@@ -156,7 +156,7 @@ void rtw_indicate_wx_assoc_event(struct adapter *padapter)
 	union iwreq_data wrqu;
 	struct	mlme_priv *pmlmepriv = &padapter->mlmepriv;
 
-	_rtw_memset(&wrqu, 0, sizeof(union iwreq_data));
+	memset(&wrqu, 0, sizeof(union iwreq_data));
 
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 
@@ -170,10 +170,10 @@ void rtw_indicate_wx_disassoc_event(struct adapter *padapter)
 {
 	union iwreq_data wrqu;
 
-	_rtw_memset(&wrqu, 0, sizeof(union iwreq_data));
+	memset(&wrqu, 0, sizeof(union iwreq_data));
 
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	_rtw_memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
+	memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
 
 	DBG_88E_LEVEL(_drv_always_, "indicate disassoc\n");
 	wireless_send_event(padapter->pnetdev, SIOCGIWAP, &wrqu, NULL);
@@ -356,33 +356,33 @@ static char *translate_scan(struct adapter *padapter,
 
 		if (wpa_len > 0) {
 			p = buf;
-			_rtw_memset(buf, 0, MAX_WPA_IE_LEN);
+			memset(buf, 0, MAX_WPA_IE_LEN);
 			p += sprintf(p, "wpa_ie=");
 			for (i = 0; i < wpa_len; i++)
 				p += sprintf(p, "%02x", wpa_ie[i]);
 
-			_rtw_memset(&iwe, 0, sizeof(iwe));
+			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = IWEVCUSTOM;
 			iwe.u.data.length = strlen(buf);
 			start = iwe_stream_add_point(info, start, stop, &iwe, buf);
 
-			_rtw_memset(&iwe, 0, sizeof(iwe));
+			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = IWEVGENIE;
 			iwe.u.data.length = wpa_len;
 			start = iwe_stream_add_point(info, start, stop, &iwe, wpa_ie);
 		}
 		if (rsn_len > 0) {
 			p = buf;
-			_rtw_memset(buf, 0, MAX_WPA_IE_LEN);
+			memset(buf, 0, MAX_WPA_IE_LEN);
 			p += sprintf(p, "rsn_ie=");
 			for (i = 0; i < rsn_len; i++)
 				p += sprintf(p, "%02x", rsn_ie[i]);
-			_rtw_memset(&iwe, 0, sizeof(iwe));
+			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = IWEVCUSTOM;
 			iwe.u.data.length = strlen(buf);
 			start = iwe_stream_add_point(info, start, stop, &iwe, buf);
 
-			_rtw_memset(&iwe, 0, sizeof(iwe));
+			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = IWEVGENIE;
 			iwe.u.data.length = rsn_len;
 			start = iwe_stream_add_point(info, start, stop, &iwe, rsn_ie);
@@ -518,7 +518,7 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 				RT_TRACE(_module_rtl871x_ioctl_os_c, _drv_err_, (" wpa_set_encryption: pwep allocate fail !!!\n"));
 				goto exit;
 			}
-			_rtw_memset(pwep, 0, wep_total_len);
+			memset(pwep, 0, wep_total_len);
 			pwep->KeyLength = wep_key_len;
 			pwep->Length = wep_total_len;
 			if (wep_key_len == 13) {
@@ -953,14 +953,14 @@ static int rtw_wx_set_pmkid(struct net_device *dev,
 		for (j = 0; j < NUM_PMKID_CACHE; j++) {
 			if (!memcmp(psecuritypriv->PMKIDList[j].Bssid, strIssueBssid, ETH_ALEN)) {
 				/*  BSSID is matched, the same AP => Remove this PMKID information and reset it. */
-				_rtw_memset(psecuritypriv->PMKIDList[j].Bssid, 0x00, ETH_ALEN);
+				memset(psecuritypriv->PMKIDList[j].Bssid, 0x00, ETH_ALEN);
 				psecuritypriv->PMKIDList[j].bUsed = false;
 				break;
 			}
 	       }
 	} else if (pPMK->cmd == IW_PMKSA_FLUSH) {
 		DBG_88E("[rtw_wx_set_pmkid] IW_PMKSA_FLUSH!\n");
-		_rtw_memset(&psecuritypriv->PMKIDList[0], 0x00, sizeof(struct rt_pmkid_list) * NUM_PMKID_CACHE);
+		memset(&psecuritypriv->PMKIDList[0], 0x00, sizeof(struct rt_pmkid_list) * NUM_PMKID_CACHE);
 		psecuritypriv->PMKIDIndex = 0;
 		ret = true;
 	}
@@ -991,7 +991,7 @@ static int rtw_wx_get_range(struct net_device *dev,
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_, ("rtw_wx_get_range. cmd_code =%x\n", info->cmd));
 
 	wrqu->data.length = sizeof(*range);
-	_rtw_memset(range, 0, sizeof(*range));
+	memset(range, 0, sizeof(*range));
 
 	/* Let's try to keep this struct in the same order as in
 	 * linux/include/wireless.h
@@ -1157,7 +1157,7 @@ static int rtw_wx_get_wap(struct net_device *dev,
 
 	wrqu->ap_addr.sa_family = ARPHRD_ETHER;
 
-	_rtw_memset(wrqu->ap_addr.sa_data, 0, ETH_ALEN);
+	memset(wrqu->ap_addr.sa_data, 0, ETH_ALEN);
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_, ("rtw_wx_get_wap\n"));
 
@@ -1166,7 +1166,7 @@ static int rtw_wx_get_wap(struct net_device *dev,
 	    ((check_fwstate(pmlmepriv, WIFI_AP_STATE)) == true))
 		memcpy(wrqu->ap_addr.sa_data, pcur_bss->MacAddress, ETH_ALEN);
 	else
-		_rtw_memset(wrqu->ap_addr.sa_data, 0, ETH_ALEN);
+		memset(wrqu->ap_addr.sa_data, 0, ETH_ALEN);
 	return 0;
 }
 
@@ -1269,7 +1269,7 @@ static int rtw_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 	}
 #endif /* CONFIG_88EU_P2P */
 
-	_rtw_memset(ssid, 0, sizeof(struct ndis_802_11_ssid)*RTW_SSID_SCAN_AMOUNT);
+	memset(ssid, 0, sizeof(struct ndis_802_11_ssid)*RTW_SSID_SCAN_AMOUNT);
 
 	if (wrqu->data.length == sizeof(struct iw_scan_req)) {
 		struct iw_scan_req *req = (struct iw_scan_req *)extra;
@@ -1480,7 +1480,7 @@ static int rtw_wx_set_essid(struct net_device *dev,
 		if (wrqu->essid.length != 33)
 			DBG_88E("ssid =%s, len =%d\n", extra, wrqu->essid.length);
 
-		_rtw_memset(&ndis_ssid, 0, sizeof(struct ndis_802_11_ssid));
+		memset(&ndis_ssid, 0, sizeof(struct ndis_802_11_ssid));
 		ndis_ssid.SsidLength = len;
 		memcpy(ndis_ssid.Ssid, extra, len);
 		src_ssid = ndis_ssid.Ssid;
@@ -1785,7 +1785,7 @@ static int rtw_wx_set_enc(struct net_device *dev,
 	struct pwrctrl_priv *pwrpriv = &padapter->pwrctrlpriv;
 	DBG_88E("+rtw_wx_set_enc, flags = 0x%x\n", erq->flags);
 
-	_rtw_memset(&wep, 0, sizeof(struct ndis_802_11_wep));
+	memset(&wep, 0, sizeof(struct ndis_802_11_wep));
 
 	key = erq->flags & IW_ENCODE_INDEX;
 
@@ -2074,10 +2074,10 @@ static int rtw_wx_set_enc_ext(struct net_device *dev,
 	if (param == NULL)
 		return -1;
 
-	_rtw_memset(param, 0, param_len);
+	memset(param, 0, param_len);
 
 	param->cmd = IEEE_CMD_SET_ENCRYPTION;
-	_rtw_memset(param->sta_addr, 0xff, ETH_ALEN);
+	memset(param->sta_addr, 0xff, ETH_ALEN);
 
 	switch (pext->alg) {
 	case IW_ENCODE_ALG_NONE:
@@ -2847,7 +2847,7 @@ static int rtw_p2p_profilefound(struct net_device *dev,
 		if (!rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE)) {
 			if (extra[0] == '0') {
 			/*	Remove all the profile information of wifidirect_info structure. */
-			_rtw_memset(&pwdinfo->profileinfo[0], 0x00, sizeof(struct profile_info) * P2P_MAX_PERSISTENT_GROUP_NUM);
+			memset(&pwdinfo->profileinfo[0], 0x00, sizeof(struct profile_info) * P2P_MAX_PERSISTENT_GROUP_NUM);
 			pwdinfo->profileindex = 0;
 		} else {
 			if (pwdinfo->profileindex >= P2P_MAX_PERSISTENT_GROUP_NUM) {
@@ -2879,7 +2879,7 @@ static int rtw_p2p_setDN(struct net_device *dev,
 	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
 
 	DBG_88E("[%s] %s %d\n", __func__, extra, wrqu->data.length - 1);
-	_rtw_memset(pwdinfo->device_name, 0x00, WPS_MAX_DEVICE_NAME_LEN);
+	memset(pwdinfo->device_name, 0x00, WPS_MAX_DEVICE_NAME_LEN);
 	memcpy(pwdinfo->device_name, extra, wrqu->data.length - 1);
 	pwdinfo->device_name_len = wrqu->data.length - 1;
 
@@ -3152,7 +3152,7 @@ static int rtw_p2p_get_go_device_address(struct net_device *dev,
 					/*	The P2P Device ID attribute is included in the Beacon frame. */
 					/*	The P2P Device Info attribute is included in the probe response frame. */
 
-					_rtw_memset(attr_content, 0x00, 100);
+					memset(attr_content, 0x00, 100);
 					if (rtw_get_p2p_attr_content(p2pie, p2pielen, P2P_ATTR_DEVICE_ID, attr_content, &attr_contentlen)) {
 						/*	Handle the P2P Device ID attribute of Beacon first */
 						blnMatch = 1;
@@ -3468,8 +3468,8 @@ static int rtw_p2p_connect(struct net_device *dev,
 	spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
 
 	if (uintPeerChannel) {
-		_rtw_memset(&pwdinfo->nego_req_info, 0x00, sizeof(struct tx_nego_req_info));
-		_rtw_memset(&pwdinfo->groupid_info, 0x00, sizeof(struct group_id_info));
+		memset(&pwdinfo->nego_req_info, 0x00, sizeof(struct tx_nego_req_info));
+		memset(&pwdinfo->groupid_info, 0x00, sizeof(struct group_id_info));
 
 		pwdinfo->nego_req_info.peer_channel_num[0] = uintPeerChannel;
 		memcpy(pwdinfo->nego_req_info.peerDevAddr, pnetwork->network.MacAddress, ETH_ALEN);
@@ -3531,11 +3531,11 @@ static int rtw_p2p_invite_req(struct net_device *dev,
 	} else {
 		/*	Reset the content of struct tx_invite_req_info */
 		pinvite_req_info->benable = false;
-		_rtw_memset(pinvite_req_info->go_bssid, 0x00, ETH_ALEN);
-		_rtw_memset(pinvite_req_info->go_ssid, 0x00, WLAN_SSID_MAXLEN);
+		memset(pinvite_req_info->go_bssid, 0x00, ETH_ALEN);
+		memset(pinvite_req_info->go_ssid, 0x00, WLAN_SSID_MAXLEN);
 		pinvite_req_info->ssidlen = 0x00;
 		pinvite_req_info->operating_ch = pwdinfo->operating_channel;
-		_rtw_memset(pinvite_req_info->peer_macaddr, 0x00, ETH_ALEN);
+		memset(pinvite_req_info->peer_macaddr, 0x00, ETH_ALEN);
 		pinvite_req_info->token = 3;
 	}
 
@@ -3668,9 +3668,9 @@ static int rtw_p2p_prov_disc(struct net_device *dev,
 		return ret;
 	} else {
 		/*	Reset the content of struct tx_provdisc_req_info excluded the wps_config_method_request. */
-		_rtw_memset(pwdinfo->tx_prov_disc_info.peerDevAddr, 0x00, ETH_ALEN);
-		_rtw_memset(pwdinfo->tx_prov_disc_info.peerIFAddr, 0x00, ETH_ALEN);
-		_rtw_memset(&pwdinfo->tx_prov_disc_info.ssid, 0x00, sizeof(struct ndis_802_11_ssid));
+		memset(pwdinfo->tx_prov_disc_info.peerDevAddr, 0x00, ETH_ALEN);
+		memset(pwdinfo->tx_prov_disc_info.peerIFAddr, 0x00, ETH_ALEN);
+		memset(&pwdinfo->tx_prov_disc_info.ssid, 0x00, sizeof(struct ndis_802_11_ssid));
 		pwdinfo->tx_prov_disc_info.peer_channel_num[0] = 0;
 		pwdinfo->tx_prov_disc_info.peer_channel_num[1] = 0;
 		pwdinfo->tx_prov_disc_info.benable = false;
@@ -4810,7 +4810,7 @@ static int set_group_key(struct adapter *padapter, u8 *key, u8 alg, int keyid)
 		goto exit;
 	}
 
-	_rtw_memset(psetkeyparm, 0, sizeof(struct setkey_parm));
+	memset(psetkeyparm, 0, sizeof(struct setkey_parm));
 
 	psetkeyparm->keyid = (u8)keyid;
 
@@ -4925,7 +4925,7 @@ static int rtw_set_encryption(struct net_device *dev, struct ieee_param *param,
 				goto exit;
 			}
 
-			_rtw_memset(pwep, 0, wep_total_len);
+			memset(pwep, 0, wep_total_len);
 
 			pwep->KeyLength = wep_key_len;
 			pwep->Length = wep_total_len;
@@ -6377,9 +6377,9 @@ static int rtw_mp_read_reg(struct net_device *dev,
 		kfree(input);
 		return -EFAULT;
 	}
-	_rtw_memset(data, 0, 20);
-	_rtw_memset(tmp, 0, 20);
-	_rtw_memset(extra, 0, wrqu->length);
+	memset(data, 0, 20);
+	memset(tmp, 0, 20);
+	memset(extra, 0, wrqu->length);
 
 	pch = input;
 	pnext = strpbrk(pch, ",.-");
@@ -6505,7 +6505,7 @@ static int rtw_mp_read_reg(struct net_device *dev,
 	if (data > 0xFFFFF)
 		return -EINVAL;
 
-	_rtw_memset(extra, 0, wrqu->length);
+	memset(extra, 0, wrqu->length);
 
 	write_rfreg(padapter, path, addr, data);
 
@@ -6550,7 +6550,7 @@ static int rtw_mp_read_rf(struct net_device *dev,
 	if (addr > 0xFF)
 		return -EINVAL;
 
-	_rtw_memset(extra, 0, wrqu->length);
+	memset(extra, 0, wrqu->length);
 
 	sprintf(data, "%08x", read_rfreg(padapter, path, addr));
 	/* add read data format blank */
@@ -6789,7 +6789,7 @@ static int rtw_mp_ant_rx(struct net_device *dev,
 		kfree(input);
 		return -EFAULT;
 	}
-	_rtw_memset(extra, 0, wrqu->length);
+	memset(extra, 0, wrqu->length);
 
 	sprintf(extra, "switch Rx antenna to %s", input);
 
@@ -6842,7 +6842,7 @@ static int rtw_mp_ctx(struct net_device *dev,
 	if (rv != 2)
 		return -EINVAL;
 
-	_rtw_memset(extra, '\0', sizeof(*extra));
+	memset(extra, '\0', sizeof(*extra));
 
 	if (stop == 0) {
 		bStartTest = 0; /*  To set Stop */
@@ -6882,7 +6882,7 @@ static int rtw_mp_ctx(struct net_device *dev,
 			pmp_priv->tx.payload = 2;
 			pattrib = &pmp_priv->tx.attrib;
 			pattrib->pktlen = 1500;
-			_rtw_memset(pattrib->dst, 0xFF, ETH_ALEN);
+			memset(pattrib->dst, 0xFF, ETH_ALEN);
 			SetPacketTx(padapter);
 		} else {
 			return -EFAULT;
@@ -7010,7 +7010,7 @@ static int rtw_mp_trx_query(struct net_device *dev,
 	rxok = padapter->mppriv.rx_pktcount;
 	rxfail = padapter->mppriv.rx_crcerrpktcount;
 
-	_rtw_memset(extra, '\0', 128);
+	memset(extra, '\0', 128);
 
 	sprintf(extra, "Tx OK:%d, Tx Fail:%d, Rx OK:%d, CRC error:%d ", txok, txfail, rxok, rxfail);
 
@@ -7035,7 +7035,7 @@ static int rtw_mp_pwrtrk(struct net_device *dev,
 		ret = -EFAULT;
 		goto exit;
 	}
-	_rtw_memset(extra, 0, wrqu->length);
+	memset(extra, 0, wrqu->length);
 
 	enable = 1;
 	if (wrqu->length > 1) {/*  not empty string */
diff --git a/drivers/staging/rtl8188eu/os_dep/mlme_linux.c b/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
index 0624378..737677c 100644
--- a/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
@@ -85,12 +85,12 @@ void rtw_reset_securitypriv(struct adapter *adapter)
 		/*  We have to backup the PMK information for WiFi PMK Caching test item. */
 		/*  Backup the btkip_countermeasure information. */
 		/*  When the countermeasure is trigger, the driver have to disconnect with AP for 60 seconds. */
-		_rtw_memset(&backup_pmkid[0], 0x00, sizeof(struct rt_pmkid_list) * NUM_PMKID_CACHE);
+		memset(&backup_pmkid[0], 0x00, sizeof(struct rt_pmkid_list) * NUM_PMKID_CACHE);
 		memcpy(&backup_pmkid[0], &adapter->securitypriv.PMKIDList[0], sizeof(struct rt_pmkid_list) * NUM_PMKID_CACHE);
 		backup_index = adapter->securitypriv.PMKIDIndex;
 		backup_counter = adapter->securitypriv.btkip_countermeasure;
 		backup_time = adapter->securitypriv.btkip_countermeasure_time;
-		_rtw_memset((unsigned char *)&adapter->securitypriv, 0, sizeof(struct security_priv));
+		memset((unsigned char *)&adapter->securitypriv, 0, sizeof(struct security_priv));
 
 		/*  Restore the PMK information to securitypriv structure for the following connection. */
 		memcpy(&adapter->securitypriv.PMKIDList[0],
@@ -137,7 +137,7 @@ void rtw_report_sec_ie(struct adapter *adapter, u8 authmode, u8 *sec_ie)
 		buff = rtw_malloc(IW_CUSTOM_MAX);
 		if (!buff)
 			return;
-		_rtw_memset(buff, 0, IW_CUSTOM_MAX);
+		memset(buff, 0, IW_CUSTOM_MAX);
 		p = buff;
 		p += sprintf(p, "ASSOCINFO(ReqIEs =");
 		len = sec_ie[1]+2;
@@ -145,7 +145,7 @@ void rtw_report_sec_ie(struct adapter *adapter, u8 authmode, u8 *sec_ie)
 		for (i = 0; i < len; i++)
 			p += sprintf(p, "%02x", sec_ie[i]);
 		p += sprintf(p, ")");
-		_rtw_memset(&wrqu, 0, sizeof(wrqu));
+		memset(&wrqu, 0, sizeof(wrqu));
 		wrqu.data.length = p-buff;
 		wrqu.data.length = (wrqu.data.length < IW_CUSTOM_MAX) ?
 				   wrqu.data.length : IW_CUSTOM_MAX;
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index 9b76e08..02144a4 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -94,11 +94,6 @@ void rtw_mfree2d(void *pbuf, int h, int w, int size)
 	kfree(pbuf);
 }
 
-void _rtw_memset(void *pbuf, int c, u32 sz)
-{
-	memset(pbuf, c, sz);
-}
-
 void _rtw_init_listhead(struct list_head *list)
 {
 	INIT_LIST_HEAD(list);
diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index 632ed82..f8ac996 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -73,7 +73,7 @@ void rtw_handle_tkip_mic_err(struct adapter *padapter, u8 bgroup)
 		}
 	}
 
-	_rtw_memset(&ev, 0x00, sizeof(ev));
+	memset(&ev, 0x00, sizeof(ev));
 	if (bgroup)
 		ev.flags |= IW_MICFAILURE_GROUP;
 	else
@@ -81,7 +81,7 @@ void rtw_handle_tkip_mic_err(struct adapter *padapter, u8 bgroup)
 
 	ev.src_addr.sa_family = ARPHRD_ETHER;
 	memcpy(ev.src_addr.sa_data, &pmlmepriv->assoc_bssid[0], ETH_ALEN);
-	_rtw_memset(&wrqu, 0x00, sizeof(wrqu));
+	memset(&wrqu, 0x00, sizeof(wrqu));
 	wrqu.data.length = sizeof(ev);
 	wireless_send_event(padapter->pnetdev, IWEVMICHAELMICFAILURE,
 			    &wrqu, (char *)&ev);
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
index 9e8b8c1..db8aab3 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
@@ -261,7 +261,7 @@ static int usbctrl_vendorreq(struct adapter *adapt, u8 request, u16 value, u16 i
 	}
 
 	while (++vendorreq_times <= MAX_USBCTRL_VENDORREQ_TIMES) {
-		_rtw_memset(pIo_buf, 0, len);
+		memset(pIo_buf, 0, len);
 
 		if (requesttype == 0x01) {
 			pipe = usb_rcvctrlpipe(udev, 0);/* read_in */
-- 
1.7.10.4

