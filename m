Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaJBX31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 19:29:27 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:46490 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaJBX3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 19:29:25 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linux.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8723au: core: Fix "'foo * bar' should be 'foo *bar'" errors
Date: Thu,  2 Oct 2014 18:28:41 -0500
Message-Id: <1412292521-10215-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "'foo * bar' should be 'foo *bar'" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_ap.c        |  2 +-
 drivers/staging/rtl8723au/core/rtw_led.c       |  3 ++-
 drivers/staging/rtl8723au/core/rtw_mlme.c      |  2 +-
 drivers/staging/rtl8723au/core/rtw_security.c  | 27 +++++++++++++-------------
 drivers/staging/rtl8723au/core/rtw_wlan_util.c |  2 +-
 5 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
index 6b4092f..4c3d4c8 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -1819,7 +1819,7 @@ void rtw_ap_restore_network(struct rtw_adapter *padapter)
 {
 	struct mlme_priv *mlmepriv = &padapter->mlmepriv;
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
-	struct sta_priv * pstapriv = &padapter->stapriv;
+	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct sta_info *psta;
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
 	struct list_head *phead, *plist, *ptmp;
diff --git a/drivers/staging/rtl8723au/core/rtw_led.c b/drivers/staging/rtl8723au/core/rtw_led.c
index 989cda2..fa3dcff 100644
--- a/drivers/staging/rtl8723au/core/rtw_led.c
+++ b/drivers/staging/rtl8723au/core/rtw_led.c
@@ -51,7 +51,8 @@ void BlinkWorkItemCallback23a(struct work_struct *work)
 /*	Description: */
 /*		Reset status of led_8723a object. */
 /*  */
-void ResetLedStatus23a(struct led_8723a * pLed) {
+void ResetLedStatus23a(struct led_8723a *pLed)
+{
 
 	pLed->CurrLedState = RTW_LED_OFF; /*  Current LED state. */
 	pLed->bLedOn = false; /*  true if LED is ON, false if LED is OFF. */
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
index 1f60064..00e7ad0 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
@@ -1766,7 +1766,7 @@ exit:
 	return ret;
 }
 
-int rtw_set_auth23a(struct rtw_adapter * adapter,
+int rtw_set_auth23a(struct rtw_adapter *adapter,
 		    struct security_priv *psecuritypriv)
 {
 	struct cmd_obj *pcmd;
diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 76371ae..b488622 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -30,12 +30,12 @@ struct arc4context
 	u8 state[256];
 };
 
-static void arcfour_init(struct arc4context	*parc4ctx, u8 * key, u32	key_len)
+static void arcfour_init(struct arc4context *parc4ctx, u8 *key, u32 key_len)
 {
 	u32	t, u;
 	u32	keyindex;
 	u32	stateindex;
-	u8 * state;
+	u8 *state;
 	u32	counter;
 
 	state = parc4ctx->state;
@@ -62,7 +62,7 @@ static u32 arcfour_byte(	struct arc4context	*parc4ctx)
 	u32 x;
 	u32 y;
 	u32 sx, sy;
-	u8 * state;
+	u8 *state;
 
 	state = parc4ctx->state;
 	x = (parc4ctx->x + 1) & 0xff;
@@ -78,8 +78,8 @@ static u32 arcfour_byte(	struct arc4context	*parc4ctx)
 }
 
 static void arcfour_encrypt(	struct arc4context	*parc4ctx,
-	u8 * dest,
-	u8 * src,
+	u8 *dest,
+	u8 *src,
 	u32 len)
 {
 	u32	i;
@@ -221,7 +221,7 @@ void rtw_wep_decrypt23a(struct rtw_adapter *padapter,
 	u8 keyindex;
 	struct rx_pkt_attrib *prxattrib = &precvframe->attrib;
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
-	struct sk_buff * skb = precvframe->pkt;
+	struct sk_buff *skb = precvframe->pkt;
 
 	pframe = skb->data;
 
@@ -266,7 +266,7 @@ void rtw_wep_decrypt23a(struct rtw_adapter *padapter,
 
 /* 3		===== TKIP related ===== */
 
-static u32 secmicgetuint32(u8 * p)
+static u32 secmicgetuint32(u8 *p)
 /*  Convert from Byte[] to u32 in a portable way */
 {
 	s32 i;
@@ -280,7 +280,7 @@ static u32 secmicgetuint32(u8 * p)
 	return res;
 }
 
-static void secmicputuint32(u8 * p, u32 val)
+static void secmicputuint32(u8 *p, u32 val)
 /*  Convert from long to Byte[] in a portable way */
 {
 	long i;
@@ -304,7 +304,7 @@ static void secmicclear(struct mic_data *pmicdata)
 
 }
 
-void rtw_secmicsetkey23a(struct mic_data *pmicdata, u8 * key)
+void rtw_secmicsetkey23a(struct mic_data *pmicdata, u8 *key)
 {
 	/*  Set the key */
 
@@ -340,7 +340,7 @@ void rtw_secmicappend23abyte23a(struct mic_data *pmicdata, u8 b)
 
 }
 
-void rtw_secmicappend23a(struct mic_data *pmicdata, u8 * src, u32 nbytes)
+void rtw_secmicappend23a(struct mic_data *pmicdata, u8 *src, u32 nbytes)
 {
 
 	/*  This is simple */
@@ -352,7 +352,7 @@ void rtw_secmicappend23a(struct mic_data *pmicdata, u8 * src, u32 nbytes)
 
 }
 
-void rtw_secgetmic23a(struct mic_data *pmicdata, u8 * dst)
+void rtw_secgetmic23a(struct mic_data *pmicdata, u8 *dst)
 {
 
 	/*  Append the minimum padding */
@@ -374,7 +374,8 @@ void rtw_secgetmic23a(struct mic_data *pmicdata, u8 * dst)
 
 }
 
-void rtw_seccalctkipmic23a(u8 * key, u8 *header, u8 *data, u32 data_len, u8 *mic_code, u8 pri)
+void rtw_seccalctkipmic23a(u8 *key, u8 *header, u8 *data, u32 data_len,
+			   u8 *mic_code, u8 pri)
 {
 
 	struct mic_data	micdata;
@@ -728,7 +729,7 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 	struct	sta_info		*stainfo;
 	struct	rx_pkt_attrib *prxattrib = &precvframe->attrib;
 	struct	security_priv *psecuritypriv = &padapter->securitypriv;
-	struct sk_buff * skb = precvframe->pkt;
+	struct sk_buff *skb = precvframe->pkt;
 	int res = _SUCCESS;
 
 	pframe = skb->data;
diff --git a/drivers/staging/rtl8723au/core/rtw_wlan_util.c b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
index 09c44a5..5c4006a 100644
--- a/drivers/staging/rtl8723au/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
@@ -1080,7 +1080,7 @@ bool is_ap_in_tkip23a(struct rtw_adapter *padapter)
 		return false;
 }
 
-bool should_forbid_n_rate23a(struct rtw_adapter * padapter)
+bool should_forbid_n_rate23a(struct rtw_adapter *padapter)
 {
 	u32 i;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-- 
1.9.1

