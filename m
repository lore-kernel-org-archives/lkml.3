Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaL0Imx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 03:42:53 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:52822 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaL0Imv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 03:42:51 -0500
From: Matthew Emerson <emersonmde@gmail.com>
To: gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Matthew Emerson <emersonmde@gmail.com>
Subject: [PATCH] staging: rtl8723au: Fixed multiple space issues
Date: Sat, 27 Dec 2014 03:42:21 -0500
Message-Id: <1419669741-6048-1-git-send-email-emersonmde@gmail.com>
X-Mailer: git-send-email 2.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed multiple space issues found by checkpatch.pl in
drivers/staging/rtl8723au/core/rtw_ap.c

Signed-off-by: Matthew Emerson <emersonmde@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_ap.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
index e394d12c36b0..db8c55f6c6ed 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -897,7 +897,7 @@ int rtw_check_beacon_data23a(struct rtw_adapter *padapter,
 	pairwise_cipher = 0;
 	psecuritypriv->wpa_group_cipher = 0;
 	psecuritypriv->wpa_pairwise_cipher = 0;
-	for (p = ie; ;p += (ie_len + 2)) {
+	for (p = ie; ; p += (ie_len + 2)) {
 		p = rtw_get_ie23a(p, WLAN_EID_VENDOR_SPECIFIC, &ie_len,
 				  pbss_network->IELength - (ie_len + 2));
 		if ((p) && (!memcmp(p+2, RTW_WPA_OUI23A_TYPE, 4))) {
@@ -924,7 +924,7 @@ int rtw_check_beacon_data23a(struct rtw_adapter *padapter,
 	ie_len = 0;
 	pmlmepriv->qos_option = 0;
 	if (pregistrypriv->wmm_enable) {
-		for (p = ie; ;p += (ie_len + 2)) {
+		for (p = ie; ; p += (ie_len + 2)) {
 			p = rtw_get_ie23a(p, WLAN_EID_VENDOR_SPECIFIC, &ie_len,
 					  (pbss_network->IELength -
 					   (ie_len + 2)));
@@ -1204,7 +1204,7 @@ static void update_bcn_p2p_ie(struct rtw_adapter *padapter)
 {
 }
 
-static void update_bcn_vendor_spec_ie(struct rtw_adapter *padapter, u8*oui)
+static void update_bcn_vendor_spec_ie(struct rtw_adapter *padapter, u8 *oui)
 {
 	DBG_8723A("%s\n", __func__);
 
@@ -1642,7 +1642,7 @@ u8 ap_free_sta23a(struct rtw_adapter *padapter, struct sta_info *psta, bool acti
 	return beacon_updated;
 }
 
-int rtw_ap_inform_ch_switch23a (struct rtw_adapter *padapter, u8 new_ch, u8 ch_offset)
+int rtw_ap_inform_ch_switch23a(struct rtw_adapter *padapter, u8 new_ch, u8 ch_offset)
 {
 	struct list_head *phead, *plist;
 	struct sta_info *psta = NULL;
@@ -1663,12 +1663,12 @@ int rtw_ap_inform_ch_switch23a (struct rtw_adapter *padapter, u8 new_ch, u8 ch_o
 	list_for_each(plist, phead) {
 		psta = container_of(plist, struct sta_info, asoc_list);
 
-		issue_action_spct_ch_switch23a (padapter, psta->hwaddr, new_ch, ch_offset);
+		issue_action_spct_ch_switch23a(padapter, psta->hwaddr, new_ch, ch_offset);
 		psta->expire_to = ((pstapriv->expire_to * 2) > 5) ? 5 : (pstapriv->expire_to * 2);
 	}
 	spin_unlock_bh(&pstapriv->asoc_list_lock);
 
-	issue_action_spct_ch_switch23a (padapter, bc_addr, new_ch, ch_offset);
+	issue_action_spct_ch_switch23a(padapter, bc_addr, new_ch, ch_offset);
 
 	return 0;
 }
@@ -1871,7 +1871,7 @@ void stop_ap_mode23a(struct rtw_adapter *padapter)
 	pmlmeext->bstart_bss = false;
 
 	/* reset and init security priv , this can refine with rtw_reset_securitypriv23a */
-	memset((unsigned char *)&padapter->securitypriv, 0, sizeof (struct security_priv));
+	memset((unsigned char *)&padapter->securitypriv, 0, sizeof(struct security_priv));
 	padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeOpen;
 	padapter->securitypriv.ndisencryptstatus = Ndis802_11WEPDisabled;
 
-- 
2.0.5

