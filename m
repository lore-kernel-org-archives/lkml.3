Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaE0PhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:37:07 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:55885 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaE0PhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:37:02 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/15] staging: rtl8188eu:Drop rtw_handle_dualmac() function calls in rtw_usb_if1_init()
Date: Tue, 27 May 2014 21:05:47 +0530
Message-Id: <1401204955-4093-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
References: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_usb_if1_init() initializes pbuddy_padapter variable which is not
being used.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 1e62713..aa93cd0 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -542,12 +542,9 @@ static struct adapter *rtw_usb_if1_init(struct dvobj_priv *dvobj,
 	padapter->hw_init_mutex = &usb_drv->hw_init_mutex;
 	padapter->chip_type = RTL8188E;
 
-	if (rtw_handle_dualmac(padapter, 1) != _SUCCESS)
-		goto free_adapter;
-
 	pnetdev = rtw_init_netdev(padapter);
 	if (pnetdev == NULL)
-		goto handle_dualmac;
+		goto free_adapter;
 	SET_NETDEV_DEV(pnetdev, dvobj_to_dev(dvobj));
 	padapter = rtw_netdev_priv(pnetdev);
 
@@ -621,9 +618,6 @@ static struct adapter *rtw_usb_if1_init(struct dvobj_priv *dvobj,
 free_hal_data:
 	if (status != _SUCCESS)
 		kfree(padapter->HalData);
-handle_dualmac:
-	if (status != _SUCCESS)
-		rtw_handle_dualmac(padapter, 0);
 free_adapter:
 	if (status != _SUCCESS) {
 		if (pnetdev)
-- 
1.7.10.4

