Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbaHVKeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 06:34:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65179 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbaHVKet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 06:34:49 -0400
From: Miguel Oliveira <cmroliv@gmail.com>
To: gregkh@linuxfoundation.org
Cc: navin.patidar@gmail.com, Larry.Finger@lwfinger.net, davem@davemloft.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        cmroliv@gmail.com
Subject: [PATCH 3/4] staging: rtl8188eu: osdep_intf.h and usb_intf.c
Date: Fri, 22 Aug 2014 11:33:37 +0100
Message-Id: <1408703617-32248-1-git-send-email-cmroliv@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408703558-32167-1-git-send-email-cmroliv@gmail.com>
References: <1408703558-32167-1-git-send-email-cmroliv@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all rtw_proc_xxx references to rtw_sys_xxx in files
include/osdep_intf.h and os_dep/usb_intf.c

Signed-off-by: Miguel Oliveira <cmroliv@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_intf.h |    4 ++--
 drivers/staging/rtl8188eu/os_dep/usb_intf.c    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_intf.h b/drivers/staging/rtl8188eu/include/osdep_intf.h
index efa7868..3f10c3a 100644
--- a/drivers/staging/rtl8188eu/include/osdep_intf.h
+++ b/drivers/staging/rtl8188eu/include/osdep_intf.h
@@ -40,8 +40,8 @@ int rtw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 int rtw_init_netdev_name(struct net_device *pnetdev, const char *ifname);
 struct net_device *rtw_init_netdev(struct adapter *padapter);
 u16 rtw_recv_select_queue(struct sk_buff *skb);
-void rtw_proc_init_one(struct net_device *dev);
-void rtw_proc_remove_one(struct net_device *dev);
+void rtw_sys_init_one(struct net_device *dev);
+void rtw_sys_remove_one(struct net_device *dev);
 
 int pm_netdev_open(struct net_device *pnetdev, u8 bnormal);
 void rtw_ips_dev_unload(struct adapter *padapter);
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index b8676ac..80707e8 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -477,7 +477,7 @@ static void rtw_usb_if1_deinit(struct adapter *if1)
 	if (pnetdev) {
 		/* will call netdev_close() */
 		unregister_netdev(pnetdev);
-		rtw_proc_remove_one(pnetdev);
+		rtw_sys_remove_one(pnetdev);
 	}
 	rtw_cancel_all_timer(if1);
 
-- 
1.7.10.4

