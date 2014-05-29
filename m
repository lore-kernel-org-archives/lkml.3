Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965360AbaE2Ryf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:54:35 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54016 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965348AbaE2Rya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:54:30 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 15/18] staging: rtl8188eu: Remove "last_tx_complete_time" from struct sreset_priv
Date: Thu, 29 May 2014 23:20:55 +0530
Message-Id: <1401385858-28722-15-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
References: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

value stored in variable last_tx_complete_time isn't being used
by driver.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_sreset.c      |    1 -
 drivers/staging/rtl8188eu/include/rtw_sreset.h   |    1 -
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c |    5 -----
 3 files changed, 7 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_sreset.c b/drivers/staging/rtl8188eu/core/rtw_sreset.c
index cc21f3d..3b846d3 100644
--- a/drivers/staging/rtl8188eu/core/rtw_sreset.c
+++ b/drivers/staging/rtl8188eu/core/rtw_sreset.c
@@ -26,7 +26,6 @@ void sreset_init_value(struct adapter *padapter)
 	struct sreset_priv *psrtpriv = &pHalData->srestpriv;
 
 	psrtpriv->Wifi_Error_Status = WIFI_STATUS_SUCCESS;
-	psrtpriv->last_tx_complete_time = 0;
 }
 
 u8 sreset_get_wifi_status(struct adapter *padapter)
diff --git a/drivers/staging/rtl8188eu/include/rtw_sreset.h b/drivers/staging/rtl8188eu/include/rtw_sreset.h
index 6cf792f..580e850 100644
--- a/drivers/staging/rtl8188eu/include/rtw_sreset.h
+++ b/drivers/staging/rtl8188eu/include/rtw_sreset.h
@@ -25,7 +25,6 @@
 
 struct sreset_priv {
 	u8	Wifi_Error_Status;
-	unsigned long last_tx_complete_time;
 };
 
 #include <rtl8188e_hal.h>
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
index 4622efa..0b5fbb9 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
@@ -71,8 +71,6 @@ static void usb_write_port_complete(struct urb *purb, struct pt_regs *regs)
 	struct xmit_buf *pxmitbuf = (struct xmit_buf *)purb->context;
 	struct adapter	*padapter = pxmitbuf->padapter;
 	struct xmit_priv	*pxmitpriv = &padapter->xmitpriv;
-	struct hal_data_8188e	*haldata;
-
 
 	switch (pxmitbuf->flags) {
 	case VO_QUEUE_INX:
@@ -137,9 +135,6 @@ static void usb_write_port_complete(struct urb *purb, struct pt_regs *regs)
 		}
 	}
 
-	haldata = GET_HAL_DATA(padapter);
-	haldata->srestpriv.last_tx_complete_time = jiffies;
-
 check_completion:
 	rtw_sctx_done_err(&pxmitbuf->sctx,
 			  purb->status ? RTW_SCTX_DONE_WRITE_PORT_ERR :
-- 
1.7.10.4

