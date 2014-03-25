Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaCYSJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:09:58 -0400
Received: from mail0.toppoint.de ([217.70.197.20]:55483 "EHLO
	mail0.toppoint.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaCYSJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:09:56 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2014 14:09:56 EDT
Date: Tue, 25 Mar 2014 17:59:39 +0000
From: Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>
To: Larry.Finger@lwfinger.net
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8188eu: remove spaces, correct counts to unbreak
 P2P ioctls
Message-ID: <20140325175939.GC17209@kaos.lebenslange-mailadresse.de>
Mail-Followup-To: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

staging: rtl8188eu: remove spaces, correct counts to unbreak P2P ioctls

It looks like someone did a search-and-replace on that driver, putting
spaces before "=" characters, without checking this is OK everywhere.
Also, in some places, there's memcpm()s/strncmp()s checking for some
different length than the fixed string argument.

These things result in code not working as intended. Fix that.

Signed-off-by: Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>

---

diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 4ad80ae..aef393b 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -358,7 +358,7 @@ static char *translate_scan(struct adapter *padapter,
 		if (wpa_len > 0) {
 			p = buf;
 			_rtw_memset(buf, 0, MAX_WPA_IE_LEN);
-			p += sprintf(p, "wpa_ie =");
+			p += sprintf(p, "wpa_ie=");
 			for (i = 0; i < wpa_len; i++)
 				p += sprintf(p, "%02x", wpa_ie[i]);
 
@@ -375,7 +375,7 @@ static char *translate_scan(struct adapter *padapter,
 		if (rsn_len > 0) {
 			p = buf;
 			_rtw_memset(buf, 0, MAX_WPA_IE_LEN);
-			p += sprintf(p, "rsn_ie =");
+			p += sprintf(p, "rsn_ie=");
 			for (i = 0; i < rsn_len; i++)
 				p += sprintf(p, "%02x", rsn_ie[i]);
 			_rtw_memset(&iwe, 0, sizeof(iwe));
@@ -2948,7 +2948,7 @@ static int rtw_p2p_get_status(struct net_device *dev,
 	/*	Commented by Albert 2010/10/12 */
 	/*	Because of the output size limitation, I had removed the "Role" information. */
 	/*	About the "Role" information, we will use the new private IOCTL to get the "Role" information. */
-	sprintf(extra, "\n\nStatus =%.2d\n", rtw_p2p_state(pwdinfo));
+	sprintf(extra, "\n\nStatus=%.2d\n", rtw_p2p_state(pwdinfo));
 	wrqu->data.length = strlen(extra);
 
 	return ret;
@@ -2967,7 +2967,7 @@ static int rtw_p2p_get_req_cm(struct net_device *dev,
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
 
-	sprintf(extra, "\n\nCM =%s\n", pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req);
+	sprintf(extra, "\n\nCM=%s\n", pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req);
 	wrqu->data.length = strlen(extra);
 	return ret;
 }
@@ -2984,7 +2984,7 @@ static int rtw_p2p_get_role(struct net_device *dev,
 			pwdinfo->p2p_peer_interface_addr[0], pwdinfo->p2p_peer_interface_addr[1], pwdinfo->p2p_peer_interface_addr[2],
 			pwdinfo->p2p_peer_interface_addr[3], pwdinfo->p2p_peer_interface_addr[4], pwdinfo->p2p_peer_interface_addr[5]);
 
-	sprintf(extra, "\n\nRole =%.2d\n", rtw_p2p_role(pwdinfo));
+	sprintf(extra, "\n\nRole=%.2d\n", rtw_p2p_role(pwdinfo));
 	wrqu->data.length = strlen(extra);
 	return ret;
 }
@@ -3071,7 +3071,7 @@ static int rtw_p2p_get_op_ch(struct net_device *dev,
 
 	DBG_88E("[%s] Op_ch = %02x\n", __func__, pwdinfo->operating_channel);
 
-	sprintf(extra, "\n\nOp_ch =%.2d\n", pwdinfo->operating_channel);
+	sprintf(extra, "\n\nOp_ch=%.2d\n", pwdinfo->operating_channel);
 	wrqu->data.length = strlen(extra);
 	return ret;
 }
@@ -3092,7 +3092,7 @@ static int rtw_p2p_get_wps_configmethod(struct net_device *dev,
 	u8 blnMatch = 0;
 	u16	attr_content = 0;
 	uint attr_contentlen = 0;
-	/* 6 is the string "wpsCM =", 17 is the MAC addr, we have to clear it at wrqu->data.pointer */
+	/* 6 is the string "wpsCM=", 17 is the MAC addr, we have to clear it at wrqu->data.pointer */
 	u8 attr_content_str[6 + 17] = {0x00};
 
 	/*	Commented by Albert 20110727 */
@@ -3128,7 +3128,7 @@ static int rtw_p2p_get_wps_configmethod(struct net_device *dev,
 				rtw_get_wps_attr_content(wpsie, wpsie_len, WPS_ATTR_CONF_METHOD, (u8 *) &be_tmp, &attr_contentlen);
 				if (attr_contentlen) {
 					attr_content = be16_to_cpu(be_tmp);
-					sprintf(attr_content_str, "\n\nM =%.4d", attr_content);
+					sprintf(attr_content_str, "\n\nM=%.4d", attr_content);
 					blnMatch = 1;
 				}
 			}
@@ -3140,7 +3140,7 @@ static int rtw_p2p_get_wps_configmethod(struct net_device *dev,
 	spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
 
 	if (!blnMatch)
-		sprintf(attr_content_str, "\n\nM = 0000");
+		sprintf(attr_content_str, "\n\nM=0000");
 
 	if (copy_to_user(wrqu->data.pointer, attr_content_str, 6 + 17))
 		return -EFAULT;
@@ -3221,9 +3221,9 @@ static int rtw_p2p_get_go_device_address(struct net_device *dev,
 	spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
 
 	if (!blnMatch)
-		snprintf(go_devadd_str, sizeof(go_devadd_str), "\n\ndev_add = NULL");
+		snprintf(go_devadd_str, sizeof(go_devadd_str), "\n\ndev_add=NULL");
 	else
-		snprintf(go_devadd_str, sizeof(go_devadd_str), "\n\ndev_add =%.2X:%.2X:%.2X:%.2X:%.2X:%.2X",
+		snprintf(go_devadd_str, sizeof(go_devadd_str), "\n\ndev_add=%.2X:%.2X:%.2X:%.2X:%.2X:%.2X",
 			attr_content[0], attr_content[1], attr_content[2], attr_content[3], attr_content[4], attr_content[5]);
 
 	if (copy_to_user(wrqu->data.pointer, go_devadd_str, sizeof(go_devadd_str)))
@@ -3247,7 +3247,7 @@ static int rtw_p2p_get_device_type(struct net_device *dev,
 	u8 blnMatch = 0;
 	u8 dev_type[8] = {0x00};
 	uint dev_type_len = 0;
-	u8 dev_type_str[17 + 9] = {0x00};	/*  +9 is for the str "dev_type =", we have to clear it at wrqu->data.pointer */
+	u8 dev_type_str[17 + 9] = {0x00};	/*  +9 is for the str "dev_type=", we have to clear it at wrqu->data.pointer */
 
 	/*	Commented by Albert 20121209 */
 	/*	The input data is the MAC address which the application wants to know its device type. */
@@ -3288,7 +3288,7 @@ static int rtw_p2p_get_device_type(struct net_device *dev,
 
 					memcpy(&be_tmp, dev_type, 2);
 					type = be16_to_cpu(be_tmp);
-					sprintf(dev_type_str, "\n\nN =%.2d", type);
+					sprintf(dev_type_str, "\n\nN=%.2d", type);
 					blnMatch = 1;
 				}
 			}
@@ -3301,7 +3301,7 @@ static int rtw_p2p_get_device_type(struct net_device *dev,
 	spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
 
 	if (!blnMatch)
-		sprintf(dev_type_str, "\n\nN = 00");
+		sprintf(dev_type_str, "\n\nN=00");
 
 	if (copy_to_user(wrqu->data.pointer, dev_type_str, 9 + 17)) {
 		return -EFAULT;
@@ -3326,7 +3326,7 @@ static int rtw_p2p_get_device_name(struct net_device *dev,
 	u8 blnMatch = 0;
 	u8 dev_name[WPS_MAX_DEVICE_NAME_LEN] = {0x00};
 	uint dev_len = 0;
-	u8 dev_name_str[WPS_MAX_DEVICE_NAME_LEN + 5] = {0x00};	/*  +5 is for the str "devN =", we have to clear it at wrqu->data.pointer */
+	u8 dev_name_str[WPS_MAX_DEVICE_NAME_LEN + 5] = {0x00};	/*  +5 is for the str "devN=", we have to clear it at wrqu->data.pointer */
 
 	/*	Commented by Albert 20121225 */
 	/*	The input data is the MAC address which the application wants to know its device name. */
@@ -3359,7 +3359,7 @@ static int rtw_p2p_get_device_name(struct net_device *dev,
 			if (wpsie) {
 				rtw_get_wps_attr_content(wpsie, wpsie_len, WPS_ATTR_DEVICE_NAME, dev_name, &dev_len);
 				if (dev_len) {
-					sprintf(dev_name_str, "\n\nN =%s", dev_name);
+					sprintf(dev_name_str, "\n\nN=%s", dev_name);
 					blnMatch = 1;
 				}
 			}
@@ -3372,7 +3372,7 @@ static int rtw_p2p_get_device_name(struct net_device *dev,
 	spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
 
 	if (!blnMatch)
-		sprintf(dev_name_str, "\n\nN = 0000");
+		sprintf(dev_name_str, "\n\nN=0000");
 
 	if (copy_to_user(wrqu->data.pointer, dev_name_str, 5 + ((dev_len > 17) ? dev_len : 17)))
 		return -EFAULT;
@@ -3398,7 +3398,7 @@ static int rtw_p2p_get_invitation_procedure(struct net_device *dev,
 	u8 attr_content[2] = {0x00};
 
 	u8 inv_proc_str[17 + 8] = {0x00};
-	/*  +8 is for the str "InvProc =", we have to clear it at wrqu->data.pointer */
+	/*  +8 is for the str "InvProc=", we have to clear it at wrqu->data.pointer */
 
 	/*	Commented by Ouden 20121226 */
 	/*	The application wants to know P2P initiation procedure is supported or not. */
@@ -3446,12 +3446,12 @@ static int rtw_p2p_get_invitation_procedure(struct net_device *dev,
 	spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
 
 	if (!blnMatch) {
-		sprintf(inv_proc_str, "\nIP =-1");
+		sprintf(inv_proc_str, "\nIP=-1");
 	} else {
 		if (attr_content[0] & 0x20)
-			sprintf(inv_proc_str, "\nIP = 1");
+			sprintf(inv_proc_str, "\nIP=1");
 		else
-			sprintf(inv_proc_str, "\nIP = 0");
+			sprintf(inv_proc_str, "\nIP=0");
 	}
 	if (copy_to_user(wrqu->data.pointer, inv_proc_str, 8 + 17))
 		return -EFAULT;
@@ -3561,7 +3561,7 @@ static int rtw_p2p_invite_req(struct net_device *dev,
 	/*	The input data contains two informations. */
 	/*	1. First information is the P2P device address which you want to send to. */
 	/*	2. Second information is the group id which combines with GO's mac address, space and GO's ssid. */
-	/*	Command line sample: iwpriv wlan0 p2p_set invite ="00:11:22:33:44:55 00:E0:4C:00:00:05 DIRECT-xy" */
+	/*	Command line sample: iwpriv wlan0 p2p_set invite="00:11:22:33:44:55 00:E0:4C:00:00:05 DIRECT-xy" */
 	/*	Format: 00:11:22:33:44:55 00:E0:4C:00:00:05 DIRECT-xy */
 
 	DBG_88E("[%s] data = %s\n", __func__, extra);
@@ -3854,48 +3854,48 @@ static int rtw_p2p_set(struct net_device *dev,
 
 #ifdef CONFIG_88EU_P2P
 	DBG_88E("[%s] extra = %s\n", __func__, extra);
-	if (!memcmp(extra, "enable =", 7)) {
+	if (!memcmp(extra, "enable=", 7)) {
 		rtw_wext_p2p_enable(dev, info, wrqu, &extra[7]);
-	} else if (!memcmp(extra, "setDN =", 6)) {
+	} else if (!memcmp(extra, "setDN=", 6)) {
 		wrqu->data.length -= 6;
 		rtw_p2p_setDN(dev, info, wrqu, &extra[6]);
-	} else if (!memcmp(extra, "profilefound =", 13)) {
+	} else if (!memcmp(extra, "profilefound=", 13)) {
 		wrqu->data.length -= 13;
 		rtw_p2p_profilefound(dev, info, wrqu, &extra[13]);
-	} else if (!memcmp(extra, "prov_disc =", 10)) {
+	} else if (!memcmp(extra, "prov_disc=", 10)) {
 		wrqu->data.length -= 10;
 		rtw_p2p_prov_disc(dev, info, wrqu, &extra[10]);
-	} else if (!memcmp(extra, "nego =", 5)) {
+	} else if (!memcmp(extra, "nego=", 5)) {
 		wrqu->data.length -= 5;
 		rtw_p2p_connect(dev, info, wrqu, &extra[5]);
-	} else if (!memcmp(extra, "intent =", 7)) {
+	} else if (!memcmp(extra, "intent=", 7)) {
 		/*	Commented by Albert 2011/03/23 */
 		/*	The wrqu->data.length will include the null character */
 		/*	So, we will decrease 7 + 1 */
 		wrqu->data.length -= 8;
 		rtw_p2p_set_intent(dev, info, wrqu, &extra[7]);
-	} else if (!memcmp(extra, "ssid =", 5)) {
+	} else if (!memcmp(extra, "ssid=", 5)) {
 		wrqu->data.length -= 5;
 		rtw_p2p_set_go_nego_ssid(dev, info, wrqu, &extra[5]);
-	} else if (!memcmp(extra, "got_wpsinfo =", 12)) {
+	} else if (!memcmp(extra, "got_wpsinfo=", 12)) {
 		wrqu->data.length -= 12;
 		rtw_p2p_got_wpsinfo(dev, info, wrqu, &extra[12]);
-	} else if (!memcmp(extra, "listen_ch =", 10)) {
+	} else if (!memcmp(extra, "listen_ch=", 10)) {
 		/*	Commented by Albert 2011/05/24 */
 		/*	The wrqu->data.length will include the null character */
 		/*	So, we will decrease (10 + 1) */
 		wrqu->data.length -= 11;
 		rtw_p2p_set_listen_ch(dev, info, wrqu, &extra[10]);
-	} else if (!memcmp(extra, "op_ch =", 6)) {
+	} else if (!memcmp(extra, "op_ch=", 6)) {
 		/*	Commented by Albert 2011/05/24 */
 		/*	The wrqu->data.length will include the null character */
 		/*	So, we will decrease (6 + 1) */
 		wrqu->data.length -= 7;
 		rtw_p2p_set_op_ch(dev, info, wrqu, &extra[6]);
-	} else if (!memcmp(extra, "invite =", 7)) {
+	} else if (!memcmp(extra, "invite=", 7)) {
 		wrqu->data.length -= 8;
 		rtw_p2p_invite_req(dev, info, wrqu, &extra[7]);
-	} else if (!memcmp(extra, "persistent =", 11)) {
+	} else if (!memcmp(extra, "persistent=", 11)) {
 		wrqu->data.length -= 11;
 		rtw_p2p_set_persistent(dev, info, wrqu, &extra[11]);
 	}
@@ -3928,7 +3928,7 @@ static int rtw_p2p_get(struct net_device *dev,
 		rtw_p2p_get_peer_devaddr(dev, info, wrqu, extra);
 	} else if (!memcmp(wrqu->data.pointer, "group_id", 8)) {
 		rtw_p2p_get_groupid(dev, info, wrqu, extra);
-	} else if (!memcmp(wrqu->data.pointer, "peer_deva_inv", 9)) {
+	} else if (!memcmp(wrqu->data.pointer, "peer_deva_inv", 13)) {
 		/*	Get the P2P device address when receiving the P2P Invitation request frame. */
 		rtw_p2p_get_peer_devaddr_by_invitation(dev, info, wrqu, extra);
 	} else if (!memcmp(wrqu->data.pointer, "op_ch", 5)) {
@@ -3946,19 +3946,19 @@ static int rtw_p2p_get2(struct net_device *dev,
 
 #ifdef CONFIG_88EU_P2P
 	DBG_88E("[%s] extra = %s\n", __func__, (char *)wrqu->data.pointer);
-	if (!memcmp(extra, "wpsCM =", 6)) {
+	if (!memcmp(extra, "wpsCM=", 6)) {
 		wrqu->data.length -= 6;
 		rtw_p2p_get_wps_configmethod(dev, info, wrqu,  &extra[6]);
-	} else if (!memcmp(extra, "devN =", 5)) {
+	} else if (!memcmp(extra, "devN=", 5)) {
 		wrqu->data.length -= 5;
 		rtw_p2p_get_device_name(dev, info, wrqu, &extra[5]);
-	} else if (!memcmp(extra, "dev_type =", 9)) {
+	} else if (!memcmp(extra, "dev_type=", 9)) {
 		wrqu->data.length -= 9;
 		rtw_p2p_get_device_type(dev, info, wrqu, &extra[9]);
-	} else if (!memcmp(extra, "go_devadd =", 10)) {
+	} else if (!memcmp(extra, "go_devadd=", 10)) {
 		wrqu->data.length -= 10;
 		rtw_p2p_get_go_device_address(dev, info, wrqu, &extra[10]);
-	} else if (!memcmp(extra, "InvProc =", 8)) {
+	} else if (!memcmp(extra, "InvProc=", 8)) {
 		wrqu->data.length -= 8;
 		rtw_p2p_get_invitation_procedure(dev, info, wrqu, &extra[8]);
 	}
@@ -5708,10 +5708,10 @@ static int rtw_pm_set(struct net_device *dev,
 
 	DBG_88E("[%s] extra = %s\n", __func__, extra);
 
-	if (!memcmp(extra, "lps =", 4)) {
+	if (!memcmp(extra, "lps=", 4)) {
 		sscanf(extra+4, "%u", &mode);
 		ret = rtw_pm_set_lps(padapter, mode);
-	} else if (!memcmp(extra, "ips =", 4)) {
+	} else if (!memcmp(extra, "ips=", 4)) {
 		sscanf(extra+4, "%u", &mode);
 		ret = rtw_pm_set_ips(padapter, mode);
 	} else {
@@ -6946,7 +6946,7 @@ static int rtw_mp_ctx(struct net_device *dev,
 
 	DBG_88E("%s: in =%s\n", __func__, extra);
 
-	countPkTx = strncmp(extra, "count =", 5); /*  strncmp true is 0 */
+	countPkTx = strncmp(extra, "count=", 6); /*  strncmp true is 0 */
 	cotuTx = strncmp(extra, "background", 20);
 	CarrSprTx = strncmp(extra, "background, cs", 20);
 	scTx = strncmp(extra, "background, sc", 20);
@@ -7068,7 +7068,7 @@ static int rtw_mp_arx(struct net_device *dev,
 	DBG_88E("%s: %s\n", __func__, input);
 
 	bStartRx = (strncmp(input, "start", 5) == 0) ? 1 : 0; /*  strncmp true is 0 */
-	bStopRx = (strncmp(input, "stop", 5) == 0) ? 1 : 0; /*  strncmp true is 0 */
+	bStopRx = (strncmp(input, "stop", 4) == 0) ? 1 : 0; /*  strncmp true is 0 */
 	bQueryPhy = (strncmp(input, "phy", 3) == 0) ? 1 : 0; /*  strncmp true is 0 */
 
 	if (bStartRx) {

