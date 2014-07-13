Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaGMOa4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:30:56 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49858 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaGMOap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:30:45 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 05/16] staging: rtl8188eu: Remove unused function rtw_set_802_11_add_key()
Date: Sun, 13 Jul 2014 19:59:27 +0530
Message-Id: <1405261778-7653-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
References: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c    |  352 ---------------------
 drivers/staging/rtl8188eu/include/rtw_ioctl_set.h |    1 -
 2 files changed, 353 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
index 95c6539..8c107f8 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
@@ -591,358 +591,6 @@ exit:
 	return ret;
 }
 
-u8 rtw_set_802_11_add_key(struct adapter *padapter, struct ndis_802_11_key *key)
-{
-	uint	encryptionalgo;
-	u8 *pbssid;
-	struct sta_info *stainfo;
-	u8	bgroup = false;
-	u8	bgrouptkey = false;/* can be removed later */
-	u8	ret = _SUCCESS;
-
-
-	if (((key->KeyIndex & 0x80000000) == 0) && ((key->KeyIndex & 0x40000000) > 0)) {
-		/*  It is invalid to clear bit 31 and set bit 30. If the miniport driver encounters this combination, */
-		/*  it must fail the request and return NDIS_STATUS_INVALID_DATA. */
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_info_,
-			 ("rtw_set_802_11_add_key: ((key->KeyIndex & 0x80000000)==0)[=%d]",
-			 (int)(key->KeyIndex & 0x80000000) == 0));
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_info_,
-			 ("rtw_set_802_11_add_key:((key->KeyIndex & 0x40000000)>0)[=%d]",
-			 (int)(key->KeyIndex & 0x40000000) > 0));
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_info_,
-			 ("rtw_set_802_11_add_key: key->KeyIndex=%d\n",
-			 (int)key->KeyIndex));
-		ret = _FAIL;
-		goto exit;
-	}
-
-	if (key->KeyIndex & 0x40000000) {
-		/*  Pairwise key */
-
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("OID_802_11_ADD_KEY: +++++ Pairwise key +++++\n"));
-
-		pbssid = get_bssid(&padapter->mlmepriv);
-		stainfo = rtw_get_stainfo(&padapter->stapriv, pbssid);
-
-		if ((stainfo != NULL) && (padapter->securitypriv.dot11AuthAlgrthm == dot11AuthAlgrthm_8021X)) {
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-				 ("OID_802_11_ADD_KEY:(stainfo!=NULL)&&(Adapter->securitypriv.dot11AuthAlgrthm==dot11AuthAlgrthm_8021X)\n"));
-			encryptionalgo = stainfo->dot118021XPrivacy;
-		} else {
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("OID_802_11_ADD_KEY: stainfo == NULL)||(Adapter->securitypriv.dot11AuthAlgrthm!= dot11AuthAlgrthm_8021X)\n"));
-			encryptionalgo = padapter->securitypriv.dot11PrivacyAlgrthm;
-		}
-
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-			 ("rtw_set_802_11_add_key: (encryptionalgo==%d)!\n",
-			 encryptionalgo));
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-			 ("rtw_set_802_11_add_key: (Adapter->securitypriv.dot11PrivacyAlgrthm==%d)!\n",
-			 padapter->securitypriv.dot11PrivacyAlgrthm));
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-			 ("rtw_set_802_11_add_key: (Adapter->securitypriv.dot11AuthAlgrthm==%d)!\n",
-			 padapter->securitypriv.dot11AuthAlgrthm));
-
-		if ((stainfo != NULL))
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-				 ("rtw_set_802_11_add_key: (stainfo->dot118021XPrivacy==%d)!\n",
-				 stainfo->dot118021XPrivacy));
-
-		if (key->KeyIndex & 0x000000FF) {
-			/*  The key index is specified in the lower 8 bits by values of zero to 255. */
-			/*  The key index should be set to zero for a Pairwise key, and the driver should fail with */
-			/*  NDIS_STATUS_INVALID_DATA if the lower 8 bits is not zero */
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, (" key->KeyIndex & 0x000000FF.\n"));
-			ret = _FAIL;
-			goto exit;
-		}
-
-		/*  check BSSID */
-		if (IS_MAC_ADDRESS_BROADCAST(key->BSSID) == true) {
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("MacAddr_isBcst(key->BSSID)\n"));
-			ret = false;
-			goto exit;
-		}
-
-		/*  Check key length for TKIP. */
-		if ((encryptionalgo == _TKIP_) && (key->KeyLength != 32)) {
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("TKIP KeyLength:0x%x != 32\n", key->KeyLength));
-			ret = _FAIL;
-			goto exit;
-		}
-
-		/*  Check key length for AES. */
-		if ((encryptionalgo == _AES_) && (key->KeyLength != 16)) {
-			/*  For our supplicant, EAPPkt9x.vxd, cannot differentiate TKIP and AES case. */
-			if (key->KeyLength == 32) {
-				key->KeyLength = 16;
-			} else {
-				ret = _FAIL;
-				goto exit;
-			}
-		}
-
-		/*  Check key length for WEP. For NDTEST, 2005.01.27, by rcnjko. */
-		if ((encryptionalgo == _WEP40_ || encryptionalgo == _WEP104_) &&
-		    (key->KeyLength != 5 && key->KeyLength != 13)) {
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("WEP KeyLength:0x%x != 5 or 13\n", key->KeyLength));
-			ret = _FAIL;
-			goto exit;
-		}
-
-		bgroup = false;
-
-		/*  Check the pairwise key. Added by Annie, 2005-07-06. */
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("------------------------------------------\n"));
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("[Pairwise Key set]\n"));
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("------------------------------------------\n"));
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("key index: 0x%8x(0x%8x)\n", key->KeyIndex, (key->KeyIndex&0x3)));
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("key Length: %d\n", key->KeyLength));
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("------------------------------------------\n"));
-
-	} else {
-		/*  Group key - KeyIndex(BIT30 == 0) */
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("OID_802_11_ADD_KEY: +++++ Group key +++++\n"));
-
-
-		/*  when add wep key through add key and didn't assigned encryption type before */
-		if ((padapter->securitypriv.ndisauthtype <= 3) &&
-		    (padapter->securitypriv.dot118021XGrpPrivacy == 0)) {
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-				 ("keylen =%d(Adapter->securitypriv.dot11PrivacyAlgrthm=%x )padapter->securitypriv.dot118021XGrpPrivacy(%x)\n",
-				 key->KeyLength, padapter->securitypriv.dot11PrivacyAlgrthm,
-				 padapter->securitypriv.dot118021XGrpPrivacy));
-			switch (key->KeyLength) {
-			case 5:
-				padapter->securitypriv.dot11PrivacyAlgrthm = _WEP40_;
-				RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-					 ("Adapter->securitypriv.dot11PrivacyAlgrthm=%x key->KeyLength=%u\n",
-					 padapter->securitypriv.dot11PrivacyAlgrthm, key->KeyLength));
-				break;
-			case 13:
-				padapter->securitypriv.dot11PrivacyAlgrthm = _WEP104_;
-				RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-					 ("Adapter->securitypriv.dot11PrivacyAlgrthm=%x key->KeyLength=%u\n",
-					 padapter->securitypriv.dot11PrivacyAlgrthm, key->KeyLength));
-				break;
-			default:
-				padapter->securitypriv.dot11PrivacyAlgrthm = _NO_PRIVACY_;
-				RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-					 ("Adapter->securitypriv.dot11PrivacyAlgrthm=%x key->KeyLength=%u\n",
-					 padapter->securitypriv.dot11PrivacyAlgrthm, key->KeyLength));
-				break;
-			}
-
-			encryptionalgo = padapter->securitypriv.dot11PrivacyAlgrthm;
-
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-				 (" Adapter->securitypriv.dot11PrivacyAlgrthm=%x\n",
-				 padapter->securitypriv.dot11PrivacyAlgrthm));
-
-		} else {
-			encryptionalgo = padapter->securitypriv.dot118021XGrpPrivacy;
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-				 ("(Adapter->securitypriv.dot11PrivacyAlgrthm=%x)encryptionalgo(%x)=padapter->securitypriv.dot118021XGrpPrivacy(%x)keylen=%d\n",
-				 padapter->securitypriv.dot11PrivacyAlgrthm, encryptionalgo,
-				 padapter->securitypriv.dot118021XGrpPrivacy, key->KeyLength));
-		}
-
-		if ((check_fwstate(&padapter->mlmepriv, WIFI_ADHOC_STATE) == true) && (IS_MAC_ADDRESS_BROADCAST(key->BSSID) == false)) {
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-				 (" IBSS but BSSID is not Broadcast Address.\n"));
-			ret = _FAIL;
-			goto exit;
-		}
-
-		/*  Check key length for TKIP */
-		if ((encryptionalgo == _TKIP_) && (key->KeyLength != 32)) {
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-				 (" TKIP GTK KeyLength:%u != 32\n", key->KeyLength));
-			ret = _FAIL;
-			goto exit;
-		} else if (encryptionalgo == _AES_ && (key->KeyLength != 16 && key->KeyLength != 32)) {
-			/*  Check key length for AES */
-			/*  For NDTEST, we allow keylen = 32 in this case. 2005.01.27, by rcnjko. */
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-				 ("<=== SetInfo, OID_802_11_ADD_KEY: AES GTK KeyLength:%u != 16 or 32\n",
-				 key->KeyLength));
-			ret = _FAIL;
-			goto exit;
-		}
-
-		/*  Change the key length for EAPPkt9x.vxd. Added by Annie, 2005-11-03. */
-		if ((encryptionalgo ==  _AES_) && (key->KeyLength == 32)) {
-			key->KeyLength = 16;
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("AES key length changed: %u\n", key->KeyLength));
-		}
-
-		if (key->KeyIndex & 0x8000000) {/* error ??? 0x8000_0000 */
-			bgrouptkey = true;
-		}
-
-		if ((check_fwstate(&padapter->mlmepriv, WIFI_ADHOC_STATE)) &&
-		    (check_fwstate(&padapter->mlmepriv, _FW_LINKED)))
-			bgrouptkey = true;
-		bgroup = true;
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("------------------------------------------\n"));
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("[Group Key set]\n"));
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("------------------------------------------\n")) ;
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("key index: 0x%8x(0x%8x)\n", key->KeyIndex, (key->KeyIndex&0x3)));
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("key Length: %d\n", key->KeyLength)) ;
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("------------------------------------------\n"));
-	}
-
-	/*  If WEP encryption algorithm, just call rtw_set_802_11_add_wep(). */
-	if ((padapter->securitypriv.dot11AuthAlgrthm != dot11AuthAlgrthm_8021X) &&
-	    (encryptionalgo == _WEP40_ || encryptionalgo == _WEP104_)) {
-		u32 keyindex;
-		u32 len = FIELD_OFFSET(struct ndis_802_11_key, KeyMaterial) + key->KeyLength;
-		struct ndis_802_11_wep *wep = &padapter->securitypriv.ndiswep;
-
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("OID_802_11_ADD_KEY: +++++ WEP key +++++\n"));
-
-		wep->Length = len;
-		keyindex = key->KeyIndex&0x7fffffff;
-		wep->KeyIndex = keyindex ;
-		wep->KeyLength = key->KeyLength;
-
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("OID_802_11_ADD_KEY:Before memcpy\n"));
-
-		memcpy(wep->KeyMaterial, key->KeyMaterial, key->KeyLength);
-		memcpy(&(padapter->securitypriv.dot11DefKey[keyindex].skey[0]), key->KeyMaterial, key->KeyLength);
-
-		padapter->securitypriv.dot11DefKeylen[keyindex] = key->KeyLength;
-		padapter->securitypriv.dot11PrivacyKeyIndex = keyindex;
-
-		ret = rtw_set_802_11_add_wep(padapter, wep);
-		goto exit;
-	}
-	if (key->KeyIndex & 0x20000000) {
-		/*  SetRSC */
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("OID_802_11_ADD_KEY: +++++ SetRSC+++++\n"));
-		if (bgroup) {
-			unsigned long long keysrc = key->KeyRSC & 0x00FFFFFFFFFFFFULL;
-			memcpy(&padapter->securitypriv.dot11Grprxpn, &keysrc, 8);
-		} else {
-			unsigned long long keysrc = key->KeyRSC & 0x00FFFFFFFFFFFFULL;
-			memcpy(&padapter->securitypriv.dot11Grptxpn, &keysrc, 8);
-		}
-	}
-
-	/*  Indicate this key idx is used for TX */
-	/*  Save the key in KeyMaterial */
-	if (bgroup) { /*  Group transmit key */
-		int res;
-
-		if (bgrouptkey)
-			padapter->securitypriv.dot118021XGrpKeyid = (u8)key->KeyIndex;
-		if ((key->KeyIndex&0x3) == 0) {
-			ret = _FAIL;
-			goto exit;
-		}
-		memset(&padapter->securitypriv.dot118021XGrpKey[(u8)((key->KeyIndex) & 0x03)], 0, 16);
-		memset(&padapter->securitypriv.dot118021XGrptxmickey[(u8)((key->KeyIndex) & 0x03)], 0, 16);
-		memset(&padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex) & 0x03)], 0, 16);
-
-		if ((key->KeyIndex & 0x10000000)) {
-			memcpy(&padapter->securitypriv.dot118021XGrptxmickey[(u8)((key->KeyIndex) & 0x03)], key->KeyMaterial + 16, 8);
-			memcpy(&padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex) & 0x03)], key->KeyMaterial + 24, 8);
-
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-				 ("\n rtw_set_802_11_add_key:rx mic :0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x\n",
-				 padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex) & 0x03)].skey[0],
-				 padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex-1) & 0x03)].skey[1],
-				 padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex) & 0x03)].skey[2],
-				 padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex-1) & 0x03)].skey[3],
-				 padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex) & 0x03)].skey[4],
-				 padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex-1) & 0x03)].skey[5],
-				 padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex) & 0x03)].skey[6],
-				 padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex-1) & 0x03)].skey[7]));
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("\n rtw_set_802_11_add_key:set Group mic key!!!!!!!!\n"));
-		} else {
-			memcpy(&padapter->securitypriv.dot118021XGrptxmickey[(u8)((key->KeyIndex) & 0x03)], key->KeyMaterial + 24, 8);
-			memcpy(&padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex) & 0x03)], key->KeyMaterial + 16, 8);
-
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-				 ("\n rtw_set_802_11_add_key:rx mic :0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x:0x%02x\n",
-				 padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex) & 0x03)].skey[0],
-				 padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex-1) & 0x03)].skey[1],
-				 padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex) & 0x03)].skey[2],
-				 padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex-1) & 0x03)].skey[3],
-				 padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex) & 0x03)].skey[4],
-				 padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex-1) & 0x03)].skey[5],
-				 padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex) & 0x03)].skey[6],
-				 padapter->securitypriv.dot118021XGrprxmickey[(u8)((key->KeyIndex-1) & 0x03)].skey[7]));
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_,
-				 ("\n rtw_set_802_11_add_key:set Group mic key!!!!!!!!\n"));
-		}
-
-		/* set group key by index */
-		memcpy(&padapter->securitypriv.dot118021XGrpKey[(u8)((key->KeyIndex) & 0x03)], key->KeyMaterial, key->KeyLength);
-
-		key->KeyIndex = key->KeyIndex & 0x03;
-
-		padapter->securitypriv.binstallGrpkey = true;
-
-		padapter->securitypriv.bcheck_grpkey = false;
-
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("reset group key"));
-
-		res = rtw_set_key(padapter, &padapter->securitypriv, key->KeyIndex, 1);
-
-		if (res == _FAIL)
-			ret = _FAIL;
-
-		goto exit;
-
-	} else { /*  Pairwise Key */
-		u8 res;
-
-		pbssid = get_bssid(&padapter->mlmepriv);
-		stainfo = rtw_get_stainfo(&padapter->stapriv, pbssid);
-
-		if (stainfo != NULL) {
-			memset(&stainfo->dot118021x_UncstKey, 0, 16);/*  clear keybuffer */
-
-			memcpy(&stainfo->dot118021x_UncstKey, key->KeyMaterial, 16);
-
-			if (encryptionalgo == _TKIP_) {
-				padapter->securitypriv.busetkipkey = false;
-
-				/* _set_timer(&padapter->securitypriv.tkip_timer, 50); */
-
-				RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("\n========== _set_timer\n"));
-
-				/*  if TKIP, save the Receive/Transmit MIC key in KeyMaterial[128-255] */
-				if ((key->KeyIndex & 0x10000000)) {
-					memcpy(&stainfo->dot11tkiptxmickey, key->KeyMaterial + 16, 8);
-					memcpy(&stainfo->dot11tkiprxmickey, key->KeyMaterial + 24, 8);
-
-				} else {
-					memcpy(&stainfo->dot11tkiptxmickey, key->KeyMaterial + 24, 8);
-					memcpy(&stainfo->dot11tkiprxmickey, key->KeyMaterial + 16, 8);
-				}
-			}
-
-
-			/* Set key to CAM through H2C command */
-			if (bgrouptkey) { /* never go to here */
-				res = rtw_setstakey_cmd(padapter, (unsigned char *)stainfo, false);
-				RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("\n rtw_set_802_11_add_key:rtw_setstakey_cmd(group)\n"));
-			} else {
-				res = rtw_setstakey_cmd(padapter, (unsigned char *)stainfo, true);
-				RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("\n rtw_set_802_11_add_key:rtw_setstakey_cmd(unicast)\n"));
-			}
-			if (!res)
-				ret = _FAIL;
-		}
-	}
-exit:
-
-	return ret;
-}
-
 u8 rtw_set_802_11_remove_key(struct adapter *padapter, struct ndis_802_11_remove_key *key)
 {
 	u8 *pbssid;
diff --git a/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h b/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
index 11791cb..9ec6456 100644
--- a/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
+++ b/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
@@ -25,7 +25,6 @@
 
 typedef u8 NDIS_802_11_PMKID_VALUE[16];
 
-u8 rtw_set_802_11_add_key(struct adapter *adapt, struct ndis_802_11_key *key);
 u8 rtw_set_802_11_authentication_mode(struct adapter *adapt,
 				      enum ndis_802_11_auth_mode authmode);
 u8 rtw_set_802_11_bssid(struct adapter *adapter, u8 *bssid);
-- 
1.7.10.4

