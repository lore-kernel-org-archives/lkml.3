Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbaFAMTj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:19:39 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:52088 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673AbaFAMTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:19:36 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 17/26] staging: rtl8188eu: Remove enum driver_state
Date: Sun,  1 Jun 2014 17:46:43 +0530
Message-Id: <1401625013-11208-17-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/drv_types.h |    6 ------
 drivers/staging/rtl8188eu/os_dep/usb_intf.c   |   10 ++++------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index 9195cf3..5fa2e17 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -187,12 +187,6 @@ static inline struct device *dvobj_to_dev(struct dvobj_priv *dvobj)
 	return &dvobj->pusbintf->dev;
 };
 
-enum driver_state {
-	DRIVER_NORMAL = 0,
-	DRIVER_DISAPPEAR = 1,
-	DRIVER_REPLACE_DONGLE = 2,
-};
-
 struct adapter {
 	int	DriverState;/* for disable driver using module, use dongle toi
 			     * replace module. */
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 1265a47..4ac67e2 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -606,12 +606,10 @@ static void rtw_usb_if1_deinit(struct adapter *if1)
 	free_mlme_ap_info(if1);
 #endif
 
-	if (if1->DriverState != DRIVER_DISAPPEAR) {
-		if (pnetdev) {
-			/* will call netdev_close() */
-			unregister_netdev(pnetdev);
-			rtw_proc_remove_one(pnetdev);
-		}
+	if (pnetdev) {
+		/* will call netdev_close() */
+		unregister_netdev(pnetdev);
+		rtw_proc_remove_one(pnetdev);
 	}
 	rtw_cancel_all_timer(if1);
 
-- 
1.7.10.4

