Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbaJZMdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 08:33:49 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64626 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaJZMdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 08:33:46 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8712: remove unused variables
Date: Sun, 26 Oct 2014 18:03:33 +0530
Message-Id: <1414326813-21444-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unused variables are removed. These variables were only assigned some
values and after that they were never being used. So they are safe to
be removed , and it has been build tested.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/rtl8712/hal_init.c            |  9 ++-------
 drivers/staging/rtl8712/ieee80211.c           |  3 +--
 drivers/staging/rtl8712/rtl8712_cmd.c         | 13 +------------
 drivers/staging/rtl8712/rtl8712_efuse.c       |  3 +--
 drivers/staging/rtl8712/rtl8712_recv.c        | 15 ++-------------
 drivers/staging/rtl8712/rtl871x_cmd.c         |  2 --
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c | 19 +++++--------------
 drivers/staging/rtl8712/rtl871x_ioctl_set.c   |  4 ----
 drivers/staging/rtl8712/rtl871x_mlme.c        | 23 +++++++----------------
 drivers/staging/rtl8712/rtl871x_mp_ioctl.c    |  3 ---
 drivers/staging/rtl8712/rtl871x_pwrctrl.c     |  4 +---
 drivers/staging/rtl8712/rtl871x_recv.c        | 19 +------------------
 drivers/staging/rtl8712/rtl871x_recv.h        |  3 ---
 drivers/staging/rtl8712/rtl871x_security.c    | 10 ++--------
 drivers/staging/rtl8712/rtl871x_sta_mgt.c     | 11 +----------
 drivers/staging/rtl8712/rtl871x_xmit.c        | 13 ++++---------
 drivers/staging/rtl8712/usb_intf.c            |  6 ------
 drivers/staging/rtl8712/usb_ops_linux.c       |  3 +--
 drivers/staging/rtl8712/xmit_linux.c          |  4 +---
 19 files changed, 30 insertions(+), 137 deletions(-)

diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
index 1d6ade0..fe28d35 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -136,15 +136,10 @@ static void update_fwhdr(struct fw_hdr	*pfwhdr, const u8 *pmappedfw)
 static u8 chk_fwhdr(struct fw_hdr *pfwhdr, u32 ulfilelength)
 {
 	u32	fwhdrsz, fw_sz;
-	u8 intf, rfconf;
 
 	/* check signature */
 	if ((pfwhdr->signature != 0x8712) && (pfwhdr->signature != 0x8192))
 		return _FAIL;
-	/* check interface */
-	intf = (u8)((pfwhdr->version&0x3000) >> 12);
-	/* check rf_conf */
-	rfconf = (u8)((pfwhdr->version&0xC000) >> 14);
 	/* check fw_priv_sze & sizeof(struct fw_priv) */
 	if (pfwhdr->fw_priv_sz != sizeof(struct fw_priv))
 		return _FAIL;
@@ -162,7 +157,7 @@ static u8 rtl8712_dl_fw(struct _adapter *padapter)
 	sint i;
 	u8 tmp8, tmp8_a;
 	u16 tmp16;
-	u32 maxlen = 0, tmp32; /* for compare usage */
+	u32 maxlen = 0; /* for compare usage */
 	uint dump_imem_sz, imem_sz, dump_emem_sz, emem_sz; /* max = 49152; */
 	struct fw_hdr fwhdr;
 	u32 ulfilelength;	/* FW file size */
@@ -262,7 +257,7 @@ static u8 rtl8712_dl_fw(struct _adapter *padapter)
 		if (tmp8_a != (tmp8|BIT(2)))
 			goto exit_fail;
 
-		tmp32 = r8712_read32(padapter, TCR);
+		r8712_read32(padapter, TCR);
 
 		/* 4.polling IMEM Ready */
 		i = 100;
diff --git a/drivers/staging/rtl8712/ieee80211.c b/drivers/staging/rtl8712/ieee80211.c
index eb23b08..5786808 100644
--- a/drivers/staging/rtl8712/ieee80211.c
+++ b/drivers/staging/rtl8712/ieee80211.c
@@ -368,13 +368,12 @@ int r8712_parse_wpa2_ie(u8 *rsn_ie, int rsn_ie_len, int *group_cipher,
 int r8712_get_sec_ie(u8 *in_ie, uint in_len, u8 *rsn_ie, u16 *rsn_len,
 	       u8 *wpa_ie, u16 *wpa_len)
 {
-	u8 authmode, sec_idx;
+	u8 authmode;
 	u8 wpa_oui[4] = {0x0, 0x50, 0xf2, 0x01};
 	uint cnt;
 
 	/*Search required WPA or WPA2 IE and copy to sec_ie[ ]*/
 	cnt = (_TIMESTAMP_ + _BEACON_ITERVAL_ + _CAPABILITY_);
-	sec_idx = 0;
 	while (cnt < in_len) {
 		authmode = in_ie[cnt];
 		if ((authmode == _WPA_IE_ID_) &&
diff --git a/drivers/staging/rtl8712/rtl8712_cmd.c b/drivers/staging/rtl8712/rtl8712_cmd.c
index 720e8a1..62e53cc 100644
--- a/drivers/staging/rtl8712/rtl8712_cmd.c
+++ b/drivers/staging/rtl8712/rtl8712_cmd.c
@@ -157,10 +157,8 @@ static u8 read_bbreg_hdl(struct _adapter *padapter, u8 *pbuf)
 {
 	u32 val;
 	void (*pcmd_callback)(struct _adapter *dev, struct cmd_obj	*pcmd);
-	struct readBB_parm *prdbbparm;
 	struct cmd_obj *pcmd  = (struct cmd_obj *)pbuf;
 
-	prdbbparm = (struct readBB_parm *)pcmd->parmbuf;
 	if (pcmd->rsp && pcmd->rspsz > 0)
 		memcpy(pcmd->rsp, (u8 *)&val, pcmd->rspsz);
 	pcmd_callback = cmd_callback[pcmd->cmdcode].callback;
@@ -174,10 +172,8 @@ static u8 read_bbreg_hdl(struct _adapter *padapter, u8 *pbuf)
 static u8 write_bbreg_hdl(struct _adapter *padapter, u8 *pbuf)
 {
 	void (*pcmd_callback)(struct _adapter *dev, struct cmd_obj *pcmd);
-	struct writeBB_parm *pwritebbparm;
 	struct cmd_obj *pcmd  = (struct cmd_obj *)pbuf;
 
-	pwritebbparm = (struct writeBB_parm *)pcmd->parmbuf;
 	pcmd_callback = cmd_callback[pcmd->cmdcode].callback;
 	if (pcmd_callback == NULL)
 		r8712_free_cmd_obj(pcmd);
@@ -190,10 +186,8 @@ static u8 read_rfreg_hdl(struct _adapter *padapter, u8 *pbuf)
 {
 	u32 val;
 	void (*pcmd_callback)(struct _adapter *dev, struct cmd_obj *pcmd);
-	struct readRF_parm *prdrfparm;
 	struct cmd_obj *pcmd  = (struct cmd_obj *)pbuf;
 
-	prdrfparm = (struct readRF_parm *)pcmd->parmbuf;
 	if (pcmd->rsp && pcmd->rspsz > 0)
 		memcpy(pcmd->rsp, (u8 *)&val, pcmd->rspsz);
 	pcmd_callback = cmd_callback[pcmd->cmdcode].callback;
@@ -207,10 +201,8 @@ static u8 read_rfreg_hdl(struct _adapter *padapter, u8 *pbuf)
 static u8 write_rfreg_hdl(struct _adapter *padapter, u8 *pbuf)
 {
 	void (*pcmd_callback)(struct _adapter *dev, struct cmd_obj *pcmd);
-	struct writeRF_parm *pwriterfparm;
 	struct cmd_obj *pcmd  = (struct cmd_obj *)pbuf;
 
-	pwriterfparm = (struct writeRF_parm *)pcmd->parmbuf;
 	pcmd_callback = cmd_callback[pcmd->cmdcode].callback;
 	if (pcmd_callback == NULL)
 		r8712_free_cmd_obj(pcmd);
@@ -222,9 +214,7 @@ static u8 write_rfreg_hdl(struct _adapter *padapter, u8 *pbuf)
 static u8 sys_suspend_hdl(struct _adapter *padapter, u8 *pbuf)
 {
 	struct cmd_obj *pcmd  = (struct cmd_obj *)pbuf;
-	struct usb_suspend_parm *psetusbsuspend;
 
-	psetusbsuspend = (struct usb_suspend_parm *)pcmd->parmbuf;
 	r8712_free_cmd_obj(pcmd);
 	return H2C_SUCCESS;
 }
@@ -320,7 +310,7 @@ void r8712_fw_cmd_data(struct _adapter *pAdapter, u32 *value, u8 flag)
 int r8712_cmd_thread(void *context)
 {
 	struct cmd_obj *pcmd;
-	unsigned int cmdsz, wr_sz, *pcmdbuf, *prspbuf;
+	unsigned int cmdsz, wr_sz, *pcmdbuf;
 	struct tx_desc *pdesc;
 	void (*pcmd_callback)(struct _adapter *dev, struct cmd_obj *pcmd);
 	struct _adapter *padapter = (struct _adapter *)context;
@@ -342,7 +332,6 @@ _next:
 			continue;
 		}
 		pcmdbuf = (unsigned int *)pcmdpriv->cmd_buf;
-		prspbuf = (unsigned int *)pcmdpriv->rsp_buf;
 		pdesc = (struct tx_desc *)pcmdbuf;
 		memset(pdesc, 0, TXDESC_SIZE);
 		pcmd = cmd_hdl_filter(padapter, pcmd);
diff --git a/drivers/staging/rtl8712/rtl8712_efuse.c b/drivers/staging/rtl8712/rtl8712_efuse.c
index 97b7839..d957169 100644
--- a/drivers/staging/rtl8712/rtl8712_efuse.c
+++ b/drivers/staging/rtl8712/rtl8712_efuse.c
@@ -219,13 +219,12 @@ u16 r8712_efuse_get_current_size(struct _adapter *padapter)
 {
 	int bContinual = true;
 	u16 efuse_addr = 0;
-	u8 hoffset = 0, hworden = 0;
+	u8 hworden = 0;
 	u8 efuse_data, word_cnts = 0;
 
 	while (bContinual && efuse_one_byte_read(padapter, efuse_addr,
 	       &efuse_data) && (efuse_addr < efuse_available_max_size)) {
 		if (efuse_data != 0xFF) {
-			hoffset = (efuse_data >> 4) & 0x0F;
 			hworden =  efuse_data & 0x0F;
 			word_cnts = calculate_word_cnts(hworden);
 			/* read next header */
diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index b278062..27f38ac 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -158,8 +158,6 @@ int r8712_free_recvframe(union recv_frame *precvframe,
 static void update_recvframe_attrib_from_recvstat(struct rx_pkt_attrib *pattrib,
 					   struct recv_stat *prxstat)
 {
-	u32 *pphy_info;
-	struct phy_stat *pphy_stat;
 	u16 drvinfo_sz = 0;
 
 	drvinfo_sz = (le32_to_cpu(prxstat->rxdw0)&0x000f0000)>>16;
@@ -189,10 +187,6 @@ static void update_recvframe_attrib_from_recvstat(struct rx_pkt_attrib *pattrib,
 	/*Offset 16*/
 	/*Offset 20*/
 	/*phy_info*/
-	if (drvinfo_sz) {
-		pphy_stat = (struct phy_stat *)(prxstat+1);
-		pphy_info = (u32 *)prxstat+1;
-	}
 }
 
 /*perform defrag*/
@@ -200,7 +194,7 @@ static union recv_frame *recvframe_defrag(struct _adapter *adapter,
 				   struct  __queue *defrag_q)
 {
 	struct list_head *plist, *phead;
-	u8	*data, wlanhdr_offset;
+	u8 wlanhdr_offset;
 	u8	curfragnum;
 	struct recv_frame_hdr *pfhdr, *pnfhdr;
 	union recv_frame *prframe, *pnextrframe;
@@ -223,7 +217,6 @@ static union recv_frame *recvframe_defrag(struct _adapter *adapter,
 	curfragnum++;
 	plist = &defrag_q->queue;
 	plist = plist->next;
-	data = get_recvframe_data(prframe);
 	while (end_of_queue_search(phead, plist) == false) {
 		pnextrframe = LIST_CONTAINOR(plist, union recv_frame, u);
 		pnfhdr = &pnextrframe->u.hdr;
@@ -436,13 +429,11 @@ void r8712_rxcmd_event_hdl(struct _adapter *padapter, void *prxcmdbuf)
 {
 	uint voffset;
 	u8 *poffset;
-	u16 pkt_len, cmd_len, drvinfo_sz;
-	u8 eid, cmd_seq;
+	u16 cmd_len, drvinfo_sz;
 	struct recv_stat *prxstat;
 
 	poffset = (u8 *)prxcmdbuf;
 	voffset = *(uint *)poffset;
-	pkt_len = le32_to_cpu(voffset) & 0x00003fff;
 	prxstat = (struct recv_stat *)prxcmdbuf;
 	drvinfo_sz = ((le32_to_cpu(prxstat->rxdw0) & 0x000f0000) >> 16);
 	drvinfo_sz = drvinfo_sz << 3;
@@ -450,8 +441,6 @@ void r8712_rxcmd_event_hdl(struct _adapter *padapter, void *prxcmdbuf)
 	do {
 		voffset  = *(uint *)poffset;
 		cmd_len = (u16)(le32_to_cpu(voffset) & 0xffff);
-		cmd_seq = (u8)((le32_to_cpu(voffset) >> 24) & 0x7f);
-		eid = (u8)((le32_to_cpu(voffset) >> 16) & 0xff);
 		r8712_event_handle(padapter, (uint *)poffset);
 		poffset += (cmd_len + 8);/*8 bytes alignment*/
 	} while (le32_to_cpu(voffset) & BIT(31));
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index 92101b9..fe5e315 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -470,7 +470,6 @@ u8 r8712_createbss_cmd(struct _adapter *padapter)
 
 u8 r8712_joinbss_cmd(struct _adapter  *padapter, struct wlan_network *pnetwork)
 {
-	u8 *auth;
 	uint t_len = 0;
 	struct ndis_wlan_bssid_ex *psecnetwork;
 	struct cmd_obj		*pcmd;
@@ -517,7 +516,6 @@ u8 r8712_joinbss_cmd(struct _adapter  *padapter, struct wlan_network *pnetwork)
 		return _FAIL;
 	}
 	memcpy(psecnetwork, &pnetwork->network, t_len);
-	auth = &psecuritypriv->authenticator_ie[0];
 	psecuritypriv->authenticator_ie[0] = (unsigned char)
 					     psecnetwork->IELength;
 	if ((psecnetwork->IELength-12) < (256 - 1))
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index b4ffc0e..73b7d86 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -170,7 +170,7 @@ static inline char *translate_scan(struct _adapter *padapter,
 	s8 *p;
 	u32 i = 0, ht_ielen = 0;
 	u16	cap, ht_cap = false, mcs_rate;
-	u8	rssi, bw_40MHz = 0, short_GI = 0;
+	u8 rssi;
 
 	if ((pnetwork->network.Configuration.DSConfig < 1) ||
 	    (pnetwork->network.Configuration.DSConfig > 14)) {
@@ -197,10 +197,6 @@ static inline char *translate_scan(struct _adapter *padapter,
 		ht_cap = true;
 		pht_capie = (struct ieee80211_ht_cap *)(p + 2);
 		memcpy(&mcs_rate , pht_capie->supp_mcs_set, 2);
-		bw_40MHz = (pht_capie->cap_info&IEEE80211_HT_CAP_SUP_WIDTH)
-			   ? 1 : 0;
-		short_GI = (pht_capie->cap_info&(IEEE80211_HT_CAP_SGI_20 |
-			    IEEE80211_HT_CAP_SGI_40)) ? 1 : 0;
 	}
 	/* Add the protocol name */
 	iwe.cmd = SIOCGIWNAME;
@@ -287,12 +283,10 @@ static inline char *translate_scan(struct _adapter *padapter,
 		u8 wpa_ie[255], rsn_ie[255];
 		u16 wpa_len = 0, rsn_len = 0;
 		int n;
-		sint out_len = 0;
 
-		out_len = r8712_get_sec_ie(pnetwork->network.IEs,
-					   pnetwork->network.
-					   IELength, rsn_ie, &rsn_len,
-					   wpa_ie, &wpa_len);
+		r8712_get_sec_ie(pnetwork->network.IEs,
+				 pnetwork->network.IELength, rsn_ie, &rsn_len,
+				 wpa_ie, &wpa_len);
 		if (wpa_len > 0) {
 			memset(buf, 0, MAX_WPA_IE_LEN);
 			n = sprintf(buf, "wpa_ie=");
@@ -512,7 +506,7 @@ exit:
 static int r871x_set_wpa_ie(struct _adapter *padapter, char *pie,
 			    unsigned short ielen)
 {
-	u8 *buf = NULL, *pos = NULL;
+	u8 *buf = NULL;
 	int group_cipher = 0, pairwise_cipher = 0;
 	int ret = 0;
 
@@ -522,7 +516,6 @@ static int r871x_set_wpa_ie(struct _adapter *padapter, char *pie,
 		buf = kmemdup(pie, ielen, GFP_ATOMIC);
 		if (buf == NULL)
 			return -ENOMEM;
-		pos = buf;
 		if (ielen < RSN_HEADER_LEN) {
 			ret  = -EINVAL;
 			goto exit;
@@ -1133,13 +1126,11 @@ static int r871x_wx_set_mlme(struct net_device *dev,
 			     union iwreq_data *wrqu, char *extra)
 {
 	int ret = 0;
-	u16 reason;
 	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	struct iw_mlme *mlme = (struct iw_mlme *) extra;
 
 	if (mlme == NULL)
 		return -1;
-	reason = cpu_to_le16(mlme->reason_code);
 	switch (mlme->cmd) {
 	case IW_MLME_DEAUTH:
 		if (!r8712_set_802_11_disassociate(padapter))
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_set.c b/drivers/staging/rtl8712/rtl871x_ioctl_set.c
index a240b63..6318a0e 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_set.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_set.c
@@ -343,13 +343,9 @@ u8 r8712_set_802_11_authentication_mode(struct _adapter *padapter,
 u8 r8712_set_802_11_add_wep(struct _adapter *padapter,
 			    struct NDIS_802_11_WEP *wep)
 {
-	u8	bdefaultkey;
-	u8	btransmitkey;
 	sint	keyid;
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
 
-	bdefaultkey = (wep->KeyIndex & 0x40000000) > 0 ? false : true;
-	btransmitkey = (wep->KeyIndex & 0x80000000) > 0 ? true : false;
 	keyid = wep->KeyIndex & 0x3fffffff;
 	if (keyid >= WEP_KEYS)
 		return false;
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index 4b602fe..b7462e8 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -1372,7 +1372,7 @@ static int SecIsInPMKIDList(struct _adapter *Adapter, u8 *bssid)
 sint r8712_restruct_sec_ie(struct _adapter *adapter, u8 *in_ie,
 		     u8 *out_ie, uint in_len)
 {
-	u8 authmode = 0, securitytype, match;
+	u8 authmode = 0, match;
 	u8 sec_ie[255], uncst_oui[4], bkup_ie[255];
 	u8 wpa_oui[4] = {0x0, 0x50, 0xf2, 0x01};
 	uint ielength, cnt, remove_cnt;
@@ -1399,21 +1399,17 @@ sint r8712_restruct_sec_ie(struct _adapter *adapter, u8 *in_ie,
 	switch (ndissecuritytype) {
 	case Ndis802_11Encryption1Enabled:
 	case Ndis802_11Encryption1KeyAbsent:
-		securitytype = _WEP40_;
 		uncst_oui[3] = 0x1;
 		break;
 	case Ndis802_11Encryption2Enabled:
 	case Ndis802_11Encryption2KeyAbsent:
-		securitytype = _TKIP_;
 		uncst_oui[3] = 0x2;
 		break;
 	case Ndis802_11Encryption3Enabled:
 	case Ndis802_11Encryption3KeyAbsent:
-		securitytype = _AES_;
 		uncst_oui[3] = 0x4;
 		break;
 	default:
-		securitytype = _NO_PRIVACY_;
 		break;
 	}
 	/*Search required WPA or WPA2 IE and copy to sec_ie[] */
@@ -1705,7 +1701,7 @@ unsigned int r8712_restructure_ht_ie(struct _adapter *padapter, u8 *in_ie,
 				     u8 *out_ie, uint in_len, uint *pout_len)
 {
 	u32 ielen, out_len;
-	unsigned char *p, *pframe;
+	unsigned char *p;
 	struct ieee80211_ht_cap ht_capie;
 	unsigned char WMM_IE[] = {0x00, 0x50, 0xf2, 0x02, 0x00, 0x01, 0x00};
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
@@ -1717,10 +1713,8 @@ unsigned int r8712_restructure_ht_ie(struct _adapter *padapter, u8 *in_ie,
 	if (p && (ielen > 0)) {
 		if (pqospriv->qos_option == 0) {
 			out_len = *pout_len;
-			pframe = r8712_set_ie(out_ie+out_len,
-					      _VENDOR_SPECIFIC_IE_,
-					      _WMM_IE_Length_,
-					       WMM_IE, pout_len);
+			r8712_set_ie(out_ie+out_len, _VENDOR_SPECIFIC_IE_,
+				     _WMM_IE_Length_, WMM_IE, pout_len);
 			pqospriv->qos_option = 1;
 		}
 		out_len = *pout_len;
@@ -1733,9 +1727,9 @@ unsigned int r8712_restructure_ht_ie(struct _adapter *padapter, u8 *in_ie,
 				    IEEE80211_HT_CAP_DSSSCCK40;
 		ht_capie.ampdu_params_info = (IEEE80211_HT_CAP_AMPDU_FACTOR &
 				0x03) | (IEEE80211_HT_CAP_AMPDU_DENSITY & 0x00);
-		pframe = r8712_set_ie(out_ie+out_len, _HT_CAPABILITY_IE_,
-				sizeof(struct ieee80211_ht_cap),
-				(unsigned char *)&ht_capie, pout_len);
+		r8712_set_ie(out_ie+out_len, _HT_CAPABILITY_IE_,
+			     sizeof(struct ieee80211_ht_cap),
+			     (unsigned char *)&ht_capie, pout_len);
 		phtpriv->ht_option = 1;
 	}
 	return phtpriv->ht_option;
@@ -1748,7 +1742,6 @@ static void update_ht_cap(struct _adapter *padapter, u8 *pie, uint ie_len)
 	int i, len;
 	struct sta_info *bmc_sta, *psta;
 	struct ieee80211_ht_cap *pht_capie;
-	struct ieee80211_ht_addt_info *pht_addtinfo;
 	struct recv_reorder_ctrl *preorder_ctrl;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct ht_priv *phtpriv = &pmlmepriv->htpriv;
@@ -1801,8 +1794,6 @@ static void update_ht_cap(struct _adapter *padapter, u8 *pie, uint ie_len)
 	p = r8712_get_ie(pie + sizeof(struct NDIS_802_11_FIXED_IEs),
 		   _HT_ADD_INFO_IE_, &len,
 		   ie_len-sizeof(struct NDIS_802_11_FIXED_IEs));
-	if (p && len > 0)
-		pht_addtinfo = (struct ieee80211_ht_addt_info *)(p + 2);
 }
 
 void r8712_issue_addbareq_cmd(struct _adapter *padapter, int priority)
diff --git a/drivers/staging/rtl8712/rtl871x_mp_ioctl.c b/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
index 9827ff8..a16f15e 100644
--- a/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
+++ b/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
@@ -1431,11 +1431,8 @@ unsigned int mp_ioctl_xmit_packet_hdl(struct oid_par_priv *poid_par_priv)
 /*-------------------------------------------------------------------------*/
 uint oid_rt_set_power_down_hdl(struct oid_par_priv *poid_par_priv)
 {
-	u8	bpwrup;
-
 	if (poid_par_priv->type_of_oid != SET_OID)
 		return RNDIS_STATUS_NOT_ACCEPTED;
-	bpwrup = *(u8 *)poid_par_priv->information_buf;
 	/*CALL  the power_down function*/
 	return RNDIS_STATUS_SUCCESS;
 }
diff --git a/drivers/staging/rtl8712/rtl871x_pwrctrl.c b/drivers/staging/rtl8712/rtl871x_pwrctrl.c
index 51dcf55..ed2844d 100644
--- a/drivers/staging/rtl8712/rtl871x_pwrctrl.c
+++ b/drivers/staging/rtl8712/rtl871x_pwrctrl.c
@@ -156,11 +156,9 @@ static void rpwm_workitem_callback(struct work_struct *work)
 				       struct pwrctrl_priv, rpwm_workitem);
 	struct _adapter *padapter = container_of(pwrpriv,
 				    struct _adapter, pwrctrlpriv);
-	u8 cpwm = pwrpriv->cpwm;
-
 	if (pwrpriv->cpwm != pwrpriv->rpwm) {
 		_enter_pwrlock(&pwrpriv->lock);
-		cpwm = r8712_read8(padapter, SDIO_HCPWM);
+		r8712_read8(padapter, SDIO_HCPWM);
 		pwrpriv->rpwm_retry = 1;
 		r8712_set_rpwm(padapter, pwrpriv->rpwm);
 		up(&pwrpriv->lock);
diff --git a/drivers/staging/rtl8712/rtl871x_recv.c b/drivers/staging/rtl8712/rtl871x_recv.c
index 9b99a71..06f15f8 100644
--- a/drivers/staging/rtl8712/rtl871x_recv.c
+++ b/drivers/staging/rtl8712/rtl871x_recv.c
@@ -601,7 +601,7 @@ sint r8712_wlanhdr_to_ethhdr(union recv_frame *precvframe)
 {
 	/*remove the wlanhdr and add the eth_hdr*/
 	sint	rmv_len;
-	u16	eth_type, len;
+	u16	len;
 	u8	bsnaphdr;
 	u8	*psnap_type;
 	struct ieee80211_snap_hdr *psnap;
@@ -635,7 +635,6 @@ sint r8712_wlanhdr_to_ethhdr(union recv_frame *precvframe)
 		ptr += rmv_len;
 		*ptr = 0x87;
 		*(ptr+1) = 0x12;
-		eth_type = 0x8712;
 		/* append rx status for mp test packets */
 		ptr = recvframe_pull(precvframe, (rmv_len -
 		      sizeof(struct ethhdr) + 2) - 24);
@@ -658,27 +657,11 @@ s32 r8712_recv_entry(union recv_frame *precvframe)
 {
 	struct _adapter *padapter;
 	struct recv_priv *precvpriv;
-	struct	mlme_priv *pmlmepriv;
-	struct recv_stat *prxstat;
-	struct dvobj_priv *pdev;
-	u8 *phead, *pdata, *ptail, *pend;
 
-	struct  __queue *pfree_recv_queue, *ppending_recv_queue;
 	s32 ret = _SUCCESS;
-	struct intf_hdl *pintfhdl;
 
 	padapter = precvframe->u.hdr.adapter;
-	pintfhdl = &padapter->pio_queue->intf;
-	pmlmepriv = &padapter->mlmepriv;
 	precvpriv = &(padapter->recvpriv);
-	pdev = &padapter->dvobjpriv;
-	pfree_recv_queue = &(precvpriv->free_recv_queue);
-	ppending_recv_queue = &(precvpriv->recv_pending_queue);
-	phead = precvframe->u.hdr.rx_head;
-	pdata = precvframe->u.hdr.rx_data;
-	ptail = precvframe->u.hdr.rx_tail;
-	pend = precvframe->u.hdr.rx_end;
-	prxstat = (struct recv_stat *)phead;
 
 	padapter->ledpriv.LedControlHandler(padapter, LED_CTL_RX);
 
diff --git a/drivers/staging/rtl8712/rtl871x_recv.h b/drivers/staging/rtl8712/rtl871x_recv.h
index 92ca899..77487bb 100644
--- a/drivers/staging/rtl8712/rtl871x_recv.h
+++ b/drivers/staging/rtl8712/rtl871x_recv.h
@@ -170,11 +170,8 @@ static inline u8 *recvframe_put(union recv_frame *precvframe, sint sz)
 	/* used for append sz bytes from ptr to rx_tail, update rx_tail and
 	 * return the updated rx_tail to the caller
 	 * after putting, rx_tail must be still larger than rx_end. */
-	unsigned char *prev_rx_tail;
-
 	if (precvframe == NULL)
 		return NULL;
-	prev_rx_tail = precvframe->u.hdr.rx_tail;
 	precvframe->u.hdr.rx_tail += sz;
 	if (precvframe->u.hdr.rx_tail > precvframe->u.hdr.rx_end) {
 		precvframe->u.hdr.rx_tail -= sz;
diff --git a/drivers/staging/rtl8712/rtl871x_security.c b/drivers/staging/rtl8712/rtl871x_security.c
index 8faf22b..c653ad6 100644
--- a/drivers/staging/rtl8712/rtl871x_security.c
+++ b/drivers/staging/rtl8712/rtl871x_security.c
@@ -578,7 +578,7 @@ u32 r8712_tkip_encrypt(struct _adapter *padapter, u8 *pxmitframe)
 	u8 ttkey[16];
 	u8 crc[4];
 	struct arc4context mycontext;
-	u32 curfragnum, length, prwskeylen;
+	u32 curfragnum, length;
 
 	u8 *pframe, *payload, *iv, *prwskey;
 	union pn48 txpn;
@@ -600,7 +600,6 @@ u32 r8712_tkip_encrypt(struct _adapter *padapter, u8 *pxmitframe)
 				  &pattrib->ra[0]);
 		if (stainfo != NULL) {
 			prwskey = &stainfo->x_UncstKey.skey[0];
-			prwskeylen = 16;
 			for (curfragnum = 0; curfragnum < pattrib->nr_frags;
 			     curfragnum++) {
 				iv = pframe + pattrib->hdrlen;
@@ -655,7 +654,7 @@ u32 r8712_tkip_decrypt(struct _adapter *padapter, u8 *precvframe)
 	u8 ttkey[16];
 	u8 crc[4];
 	struct arc4context mycontext;
-	u32 length, prwskeylen;
+	u32 length;
 	u8 *pframe, *payload, *iv, *prwskey, idx = 0;
 	union pn48 txpn;
 	struct	sta_info *stainfo;
@@ -683,7 +682,6 @@ u32 r8712_tkip_decrypt(struct _adapter *padapter, u8 *precvframe)
 					return _FAIL;
 			} else
 				prwskey = &stainfo->x_UncstKey.skey[0];
-			prwskeylen = 16;
 			GET_TKIP_PN(iv, txpn);
 			pnl = (u16)(txpn.val);
 			pnh = (u32)(txpn.val >> 16);
@@ -1154,7 +1152,6 @@ u32 r8712_aes_encrypt(struct _adapter *padapter, u8 *pxmitframe)
 {	/* exclude ICV */
 	/* Intermediate Buffers */
 	sint	curfragnum, length;
-	u32	prwskeylen;
 	u8	*pframe, *prwskey;
 	struct	sta_info *stainfo;
 	struct	pkt_attrib  *pattrib = &((struct xmit_frame *)
@@ -1174,7 +1171,6 @@ u32 r8712_aes_encrypt(struct _adapter *padapter, u8 *pxmitframe)
 				  &pattrib->ra[0]);
 		if (stainfo != NULL) {
 			prwskey = &stainfo->x_UncstKey.skey[0];
-			prwskeylen = 16;
 			for (curfragnum = 0; curfragnum < pattrib->nr_frags;
 			     curfragnum++) {
 				if ((curfragnum + 1) == pattrib->nr_frags) {
@@ -1363,7 +1359,6 @@ u32 r8712_aes_decrypt(struct _adapter *padapter, u8 *precvframe)
 {	/* exclude ICV */
 	/* Intermediate Buffers */
 	sint		length;
-	u32	prwskeylen;
 	u8	*pframe, *prwskey, *iv, idx;
 	struct	sta_info *stainfo;
 	struct	rx_pkt_attrib *prxattrib = &((union recv_frame *)
@@ -1387,7 +1382,6 @@ u32 r8712_aes_decrypt(struct _adapter *padapter, u8 *precvframe)
 
 			} else
 				prwskey = &stainfo->x_UncstKey.skey[0];
-			prwskeylen = 16;
 			length = ((union recv_frame *)precvframe)->
 				 u.hdr.len-prxattrib->hdrlen-prxattrib->iv_len;
 			aes_decipher(prwskey, prxattrib->hdrlen, pframe,
diff --git a/drivers/staging/rtl8712/rtl871x_sta_mgt.c b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
index e769bb5..4c9b98e 100644
--- a/drivers/staging/rtl8712/rtl871x_sta_mgt.c
+++ b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
@@ -79,13 +79,11 @@ static void mfree_all_stainfo(struct sta_priv *pstapriv)
 {
 	unsigned long irqL;
 	struct list_head *plist, *phead;
-	struct sta_info *psta = NULL;
 
 	spin_lock_irqsave(&pstapriv->sta_hash_lock, irqL);
 	phead = &pstapriv->free_sta_queue.queue;
 	plist = phead->next;
 	while ((end_of_queue_search(phead, plist)) == false) {
-		psta = LIST_CONTAINOR(plist, struct sta_info, list);
 		plist = plist->next;
 	}
 
@@ -109,7 +107,6 @@ u32 _r8712_free_sta_priv(struct sta_priv *pstapriv)
 
 struct sta_info *r8712_alloc_stainfo(struct sta_priv *pstapriv, u8 *hwaddr)
 {
-	uint tmp_aid;
 	s32	index;
 	struct list_head *phash_list;
 	struct sta_info	*psta;
@@ -127,7 +124,6 @@ struct sta_info *r8712_alloc_stainfo(struct sta_priv *pstapriv, u8 *hwaddr)
 		psta = LIST_CONTAINOR(pfree_sta_queue->queue.next,
 				      struct sta_info, list);
 		list_del_init(&(psta->list));
-		tmp_aid = psta->aid;
 		_init_stainfo(psta);
 		memcpy(psta->hwaddr, hwaddr, ETH_ALEN);
 		index = wifi_mac_hash(hwaddr);
@@ -267,15 +263,10 @@ struct sta_info *r8712_get_stainfo(struct sta_priv *pstapriv, u8 *hwaddr)
 
 void r8712_init_bcmc_stainfo(struct _adapter *padapter)
 {
-	struct sta_info	*psta;
-	struct tx_servq	*ptxservq;
 	unsigned char bcast_addr[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	struct	sta_priv *pstapriv = &padapter->stapriv;
 
-	psta = r8712_alloc_stainfo(pstapriv, bcast_addr);
-	if (psta == NULL)
-		return;
-	ptxservq = &(psta->sta_xmitpriv.be_q);
+	r8712_alloc_stainfo(pstapriv, bcast_addr);
 }
 
 struct sta_info *r8712_get_bcmc_stainfo(struct _adapter *padapter)
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.c b/drivers/staging/rtl8712/rtl871x_xmit.c
index 9d26fd2..62a377e 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.c
+++ b/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -184,7 +184,6 @@ void _free_xmit_priv(struct xmit_priv *pxmitpriv)
 sint r8712_update_attrib(struct _adapter *padapter, _pkt *pkt,
 		   struct pkt_attrib *pattrib)
 {
-	uint i;
 	struct pkt_file pktfile;
 	struct sta_info *psta = NULL;
 	struct ethhdr etherhdr;
@@ -199,7 +198,7 @@ sint r8712_update_attrib(struct _adapter *padapter, _pkt *pkt,
 
 	_r8712_open_pktfile(pkt, &pktfile);
 
-	i = _r8712_pktfile_read(&pktfile, (unsigned char *)&etherhdr, ETH_HLEN);
+	_r8712_pktfile_read(&pktfile, (unsigned char *)&etherhdr, ETH_HLEN);
 
 	pattrib->ether_type = ntohs(etherhdr.h_proto);
 
@@ -236,7 +235,7 @@ sint r8712_update_attrib(struct _adapter *padapter, _pkt *pkt,
 		/* for mp storing the txcmd per packet,
 		 * according to the info of txcmd to update pattrib */
 		/*get MP_TXDESC_SIZE bytes txcmd per packet*/
-		i = _r8712_pktfile_read(&pktfile, (u8 *)&txdesc, TXDESC_SIZE);
+		_r8712_pktfile_read(&pktfile, (u8 *)&txdesc, TXDESC_SIZE);
 		memcpy(pattrib->ra, pattrib->dst, ETH_ALEN);
 		memcpy(pattrib->ta, pattrib->src, ETH_ALEN);
 		pattrib->pctrl = 1;
@@ -347,7 +346,7 @@ sint r8712_update_attrib(struct _adapter *padapter, _pkt *pkt,
 static sint xmitframe_addmic(struct _adapter *padapter,
 			     struct xmit_frame *pxmitframe)
 {
-	u32	curfragnum, length, datalen;
+	u32	curfragnum, length;
 	u8	*pframe, *payload, mic[8];
 	struct	mic_data micdata;
 	struct	sta_info *stainfo;
@@ -369,7 +368,6 @@ static sint xmitframe_addmic(struct _adapter *padapter,
 			u8 null_key[16] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
 					   0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
 					   0x0, 0x0};
-			datalen = pattrib->pktlen - pattrib->hdrlen;
 			pframe = pxmitframe->buf_addr + TXDESC_OFFSET;
 			if (bmcst) {
 				if (!memcmp(psecuritypriv->XGrptxmickey
@@ -825,16 +823,13 @@ void r8712_free_xmitframe(struct xmit_priv *pxmitpriv,
 	unsigned long irqL;
 	struct  __queue *pfree_xmit_queue = &pxmitpriv->free_xmit_queue;
 	struct _adapter *padapter = pxmitpriv->adapter;
-	struct sk_buff *pndis_pkt = NULL;
 
 	if (pxmitframe == NULL)
 		return;
 	spin_lock_irqsave(&pfree_xmit_queue->lock, irqL);
 	list_del_init(&pxmitframe->list);
-	if (pxmitframe->pkt) {
-		pndis_pkt = pxmitframe->pkt;
+	if (pxmitframe->pkt)
 		pxmitframe->pkt = NULL;
-	}
 	list_add_tail(&pxmitframe->list, &pfree_xmit_queue->queue);
 	pxmitpriv->free_xmitframe_cnt++;
 	spin_unlock_irqrestore(&pfree_xmit_queue->lock, irqL);
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index da3856d..7d0d171 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -255,9 +255,6 @@ static struct drv_priv drvpriv = {
 static uint r8712_usb_dvobj_init(struct _adapter *padapter)
 {
 	uint	status = _SUCCESS;
-	struct	usb_device_descriptor		*pdev_desc;
-	struct	usb_host_config			*phost_conf;
-	struct	usb_config_descriptor		*pconf_desc;
 	struct	usb_host_interface		*phost_iface;
 	struct	usb_interface_descriptor	*piface_desc;
 	struct dvobj_priv *pdvobjpriv = &padapter->dvobjpriv;
@@ -265,9 +262,6 @@ static uint r8712_usb_dvobj_init(struct _adapter *padapter)
 
 	pdvobjpriv->padapter = padapter;
 	padapter->EepromAddressSize = 6;
-	pdev_desc = &pusbd->descriptor;
-	phost_conf = pusbd->actconfig;
-	pconf_desc = &phost_conf->desc;
 	phost_iface = &pintf->altsetting[0];
 	piface_desc = &phost_iface->desc;
 	pdvobjpriv->nr_endpoint = piface_desc->bNumEndpoints;
diff --git a/drivers/staging/rtl8712/usb_ops_linux.c b/drivers/staging/rtl8712/usb_ops_linux.c
index e0a155a..c3a4e3f 100644
--- a/drivers/staging/rtl8712/usb_ops_linux.c
+++ b/drivers/staging/rtl8712/usb_ops_linux.c
@@ -168,7 +168,6 @@ static void usb_write_mem_complete(struct urb *purb)
 void r8712_usb_write_mem(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *wmem)
 {
 	unsigned int pipe;
-	int status;
 	struct _adapter *padapter = (struct _adapter *)pintfhdl->adapter;
 	struct intf_priv *pintfpriv = pintfhdl->pintfpriv;
 	struct io_queue *pio_queue = (struct io_queue *)padapter->pio_queue;
@@ -186,7 +185,7 @@ void r8712_usb_write_mem(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *wmem)
 	usb_fill_bulk_urb(piorw_urb, pusbd, pipe,
 			  wmem, cnt, usb_write_mem_complete,
 			  pio_queue);
-	status = usb_submit_urb(piorw_urb, GFP_ATOMIC);
+	usb_submit_urb(piorw_urb, GFP_ATOMIC);
 	_down_sema(&pintfpriv->io_retevt);
 }
 
diff --git a/drivers/staging/rtl8712/xmit_linux.c b/drivers/staging/rtl8712/xmit_linux.c
index 0ac9130..039b598 100644
--- a/drivers/staging/rtl8712/xmit_linux.c
+++ b/drivers/staging/rtl8712/xmit_linux.c
@@ -79,7 +79,6 @@ sint r8712_endofpktfile(struct pkt_file *pfile)
 
 void r8712_set_qos(struct pkt_file *ppktfile, struct pkt_attrib *pattrib)
 {
-	int i;
 	struct ethhdr etherhdr;
 	struct iphdr ip_hdr;
 	u16 UserPriority = 0;
@@ -89,8 +88,7 @@ void r8712_set_qos(struct pkt_file *ppktfile, struct pkt_attrib *pattrib)
 
 	/* get UserPriority from IP hdr*/
 	if (pattrib->ether_type == 0x0800) {
-		i = _r8712_pktfile_read(ppktfile, (u8 *)&ip_hdr,
-					sizeof(ip_hdr));
+		_r8712_pktfile_read(ppktfile, (u8 *)&ip_hdr, sizeof(ip_hdr));
 		/*UserPriority = (ntohs(ip_hdr.tos) >> 5) & 0x3 ;*/
 		UserPriority = ip_hdr.tos >> 5;
 	} else {
-- 
1.8.1.2

