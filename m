Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965345AbaE2RyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:54:25 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:62995 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993AbaE2RyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:54:21 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 14/18] staging: rtl8188eu: Remove "last_tx_time" from struct sreset_priv
Date: Thu, 29 May 2014 23:20:54 +0530
Message-Id: <1401385858-28722-14-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
References: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

value stored in variable last_tx_time isn't being used
by driver.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_sreset.c      |    1 -
 drivers/staging/rtl8188eu/include/rtw_sreset.h   |    1 -
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c |    6 +-----
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_sreset.c b/drivers/staging/rtl8188eu/core/rtw_sreset.c
index 5bc8fe0..cc21f3d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_sreset.c
+++ b/drivers/staging/rtl8188eu/core/rtw_sreset.c
@@ -26,7 +26,6 @@ void sreset_init_value(struct adapter *padapter)
 	struct sreset_priv *psrtpriv = &pHalData->srestpriv;
 
 	psrtpriv->Wifi_Error_Status = WIFI_STATUS_SUCCESS;
-	psrtpriv->last_tx_time = 0;
 	psrtpriv->last_tx_complete_time = 0;
 }
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_sreset.h b/drivers/staging/rtl8188eu/include/rtw_sreset.h
index af01972..6cf792f 100644
--- a/drivers/staging/rtl8188eu/include/rtw_sreset.h
+++ b/drivers/staging/rtl8188eu/include/rtw_sreset.h
@@ -25,7 +25,6 @@
 
 struct sreset_priv {
 	u8	Wifi_Error_Status;
-	unsigned long last_tx_time;
 	unsigned long last_tx_complete_time;
 };
 
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
index ba2a8ab..4622efa 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
@@ -216,11 +216,7 @@ u32 usb_write_port(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *wmem)
 			  pxmitbuf);/* context is pxmitbuf */
 
 	status = usb_submit_urb(purb, GFP_ATOMIC);
-	if (!status) {
-		struct hal_data_8188e	*haldata = GET_HAL_DATA(padapter);
-
-		haldata->srestpriv.last_tx_time = jiffies;
-	} else {
+	if (status) {
 		rtw_sctx_done_err(&pxmitbuf->sctx, RTW_SCTX_DONE_WRITE_PORT_ERR);
 		DBG_88E("usb_write_port, status =%d\n", status);
 		RT_TRACE(_module_hci_ops_os_c_, _drv_err_, ("usb_write_port(): usb_submit_urb, status =%x\n", status));
-- 
1.7.10.4

