Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaGGSkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:40:42 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:46403 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaGGSkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:40:40 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 01/13] staging: rtl8188eu: Remove unused function rtw_change_ifname()
Date: Tue,  8 Jul 2014 00:10:01 +0530
Message-Id: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_ioctl_set.h |    1 -
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |   55 ---------------------
 2 files changed, 56 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h b/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
index 187fe1f..005ec17 100644
--- a/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
+++ b/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
@@ -45,6 +45,5 @@ u16 rtw_get_cur_max_rate(struct adapter *adapter);
 int rtw_set_scan_mode(struct adapter *adapter, enum rt_scan_type scan_mode);
 int rtw_set_channel_plan(struct adapter *adapter, u8 channel_plan);
 int rtw_set_country(struct adapter *adapter, const char *country_code);
-int rtw_change_ifname(struct adapter *padapter, const char *ifname);
 
 #endif
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index de0efe2..76eddcd 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -153,61 +153,6 @@ RETURN:
 	return;
 }
 
-int rtw_change_ifname(struct adapter *padapter, const char *ifname)
-{
-	struct net_device *pnetdev;
-	struct net_device *cur_pnetdev;
-	struct rereg_nd_name_data *rereg_priv;
-	int ret;
-
-	if (!padapter)
-		goto error;
-
-	cur_pnetdev = padapter->pnetdev;
-	rereg_priv = &padapter->rereg_nd_name_priv;
-
-	/* free the old_pnetdev */
-	if (rereg_priv->old_pnetdev) {
-		free_netdev(rereg_priv->old_pnetdev);
-		rereg_priv->old_pnetdev = NULL;
-	}
-
-	if (!rtnl_is_locked())
-		unregister_netdev(cur_pnetdev);
-	else
-		unregister_netdevice(cur_pnetdev);
-
-	rtw_proc_remove_one(cur_pnetdev);
-
-	rereg_priv->old_pnetdev = cur_pnetdev;
-
-	pnetdev = rtw_init_netdev(padapter);
-	if (!pnetdev)  {
-		ret = -1;
-		goto error;
-	}
-
-	SET_NETDEV_DEV(pnetdev, dvobj_to_dev(adapter_to_dvobj(padapter)));
-
-	rtw_init_netdev_name(pnetdev, ifname);
-
-	memcpy(pnetdev->dev_addr, padapter->eeprompriv.mac_addr, ETH_ALEN);
-
-	if (!rtnl_is_locked())
-		ret = register_netdev(pnetdev);
-	else
-		ret = register_netdevice(pnetdev);
-	if (ret != 0) {
-		RT_TRACE(_module_hci_intfs_c_, _drv_err_,
-			 ("register_netdev() failed\n"));
-		goto error;
-	}
-	rtw_proc_init_one(pnetdev);
-	return 0;
-error:
-	return -1;
-}
-
 u64 rtw_modular64(u64 x, u64 y)
 {
 	return do_div(x, y);
-- 
1.7.10.4

