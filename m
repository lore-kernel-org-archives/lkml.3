Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaKGLVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:21:00 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55032 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaKGLU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:20:58 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: rtl8188eu: unneeded return variable
Date: Fri,  7 Nov 2014 16:50:45 +0530
Message-Id: <1415359246-18212-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a variable is declared and initialized and then never updated in the
function.This default value is then used as the return from the
function.
So removed that unneeded return variable and returning that default
initial value directly.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c  | 6 ++----
 drivers/staging/rtl8188eu/core/rtw_recv.c      | 6 ++----
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 4 ++--
 drivers/staging/rtl8188eu/os_dep/os_intfs.c    | 9 +++------
 4 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index b0e9237..990c168 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -371,7 +371,6 @@ static u8 init_channel_set(struct adapter *padapter, u8 ChannelPlan, struct rt_c
 
 int	init_mlme_ext_priv(struct adapter *padapter)
 {
-	int	res = _SUCCESS;
 	struct registry_priv *pregistrypriv = &padapter->registrypriv;
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
@@ -397,7 +396,7 @@ int	init_mlme_ext_priv(struct adapter *padapter)
 
 	pmlmeext->active_keep_alive_check = true;
 
-	return res;
+	return _SUCCESS;
 }
 
 void free_mlme_ext_priv(struct mlme_ext_priv *pmlmeext)
@@ -1554,7 +1553,6 @@ unsigned int OnAtim(struct adapter *padapter, struct recv_frame *precv_frame)
 
 unsigned int on_action_spct(struct adapter *padapter, struct recv_frame *precv_frame)
 {
-	unsigned int ret = _FAIL;
 	struct sta_info *psta = NULL;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	u8 *pframe = precv_frame->rx_data;
@@ -1587,7 +1585,7 @@ unsigned int on_action_spct(struct adapter *padapter, struct recv_frame *precv_f
 	}
 
 exit:
-	return ret;
+	return _FAIL;
 }
 
 unsigned int OnAction_qos(struct adapter *padapter, struct recv_frame *precv_frame)
diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index a1619b8..bd79e9e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -1373,7 +1373,6 @@ static int wlanhdr_to_ethhdr(struct recv_frame *precvframe)
 	u8	*psnap_type;
 	struct ieee80211_snap_hdr	*psnap;
 
-	int ret = _SUCCESS;
 	struct adapter		*adapter = precvframe->adapter;
 	struct mlme_priv	*pmlmepriv = &adapter->mlmepriv;
 	u8 *ptr = precvframe->rx_data;
@@ -1428,7 +1427,7 @@ static int wlanhdr_to_ethhdr(struct recv_frame *precvframe)
 		memcpy(ptr+12, &be_tmp, 2);
 	}
 
-	return ret;
+	return _SUCCESS;
 }
 
 /* perform defrag */
@@ -1624,7 +1623,6 @@ static int amsdu_to_msdu(struct adapter *padapter, struct recv_frame *prframe)
 	struct sk_buff *sub_skb, *subframes[MAX_SUBFRAME_COUNT];
 	struct recv_priv *precvpriv = &padapter->recvpriv;
 	struct __queue *pfree_recv_queue = &(precvpriv->free_recv_queue);
-	int	ret = _SUCCESS;
 	nr_subframes = 0;
 
 	pattrib = &prframe->attrib;
@@ -1728,7 +1726,7 @@ exit:
 	prframe->len = 0;
 	rtw_free_recvframe(prframe, pfree_recv_queue);/* free this recv_frame */
 
-	return ret;
+	return _SUCCESS;
 }
 
 static int check_indicate_seq(struct recv_reorder_ctrl *preorder_ctrl, u16 seq_num)
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index f34fb29..24a8f5a 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -1416,7 +1416,7 @@ static int rtw_wx_set_rate(struct net_device *dev,
 			      struct iw_request_info *a,
 			      union iwreq_data *wrqu, char *extra)
 {
-	int i, ret = 0;
+	int i;
 	u8 datarates[NumRates];
 	u32	target_rate = wrqu->bitrate.value;
 	u32	fixed = wrqu->bitrate.fixed;
@@ -1489,7 +1489,7 @@ set_rate:
 		RT_TRACE(_module_rtl871x_ioctl_os_c, _drv_info_, ("datarate_inx =%d\n", datarates[i]));
 	}
 
-	return ret;
+	return 0;
 }
 
 static int rtw_wx_get_rate(struct net_device *dev,
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index 0b488d2..88a909c 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -512,7 +512,6 @@ void rtw_proc_remove_one(struct net_device *dev)
 
 static uint loadparam(struct adapter *padapter,  struct  net_device *pnetdev)
 {
-	uint status = _SUCCESS;
 	struct registry_priv  *registry_par = &padapter->registrypriv;
 
 
@@ -582,7 +581,7 @@ static uint loadparam(struct adapter *padapter,  struct  net_device *pnetdev)
 	snprintf(registry_par->ifname, 16, "%s", ifname);
 	snprintf(registry_par->if2name, 16, "%s", if2name);
 	registry_par->notch_filter = (u8)rtw_notch_filter;
-	return status;
+	return _SUCCESS;
 }
 
 static int rtw_net_set_mac_address(struct net_device *pnetdev, void *p)
@@ -760,7 +759,6 @@ void rtw_stop_drv_threads(struct adapter *padapter)
 
 static u8 rtw_init_default_value(struct adapter *padapter)
 {
-	u8 ret  = _SUCCESS;
 	struct registry_priv *pregistrypriv = &padapter->registrypriv;
 	struct xmit_priv	*pxmitpriv = &padapter->xmitpriv;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
@@ -803,12 +801,11 @@ static u8 rtw_init_default_value(struct adapter *padapter)
 	padapter->bWritePortCancel = false;
 	padapter->bRxRSSIDisplay = 0;
 	padapter->bNotifyChannelChange = 0;
-	return ret;
+	return _SUCCESS;
 }
 
 u8 rtw_reset_drv_sw(struct adapter *padapter)
 {
-	u8	ret8 = _SUCCESS;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct pwrctrl_priv *pwrctrlpriv = &padapter->pwrctrlpriv;
 
@@ -833,7 +830,7 @@ u8 rtw_reset_drv_sw(struct adapter *padapter)
 
 	rtw_set_signal_stat_timer(&padapter->recvpriv);
 
-	return ret8;
+	return _SUCCESS;
 }
 
 u8 rtw_init_drv_sw(struct adapter *padapter)
-- 
1.8.1.2

