Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbaGBQtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:49:17 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34685 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407AbaGBQtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:49:14 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 03/48] staging: rtl8188eu: Remove unused function c2h_evt_read()
Date: Wed,  2 Jul 2014 22:16:59 +0530
Message-Id: <1404319664-8327-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/hal_com.c     |   49 ---------------------------
 drivers/staging/rtl8188eu/include/hal_com.h |    2 --
 2 files changed, 51 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/hal_com.c b/drivers/staging/rtl8188eu/hal/hal_com.c
index baefb46..c91a58c 100644
--- a/drivers/staging/rtl8188eu/hal/hal_com.c
+++ b/drivers/staging/rtl8188eu/hal/hal_com.c
@@ -330,52 +330,3 @@ void c2h_evt_clear(struct adapter *adapter)
 {
 	usb_write8(adapter, REG_C2HEVT_CLEAR, C2H_EVT_HOST_CLOSE);
 }
-
-s32 c2h_evt_read(struct adapter *adapter, u8 *buf)
-{
-	s32 ret = _FAIL;
-	struct c2h_evt_hdr *c2h_evt;
-	int i;
-	u8 trigger;
-
-	if (buf == NULL)
-		goto exit;
-
-	trigger = usb_read8(adapter, REG_C2HEVT_CLEAR);
-
-	if (trigger == C2H_EVT_HOST_CLOSE)
-		goto exit; /* Not ready */
-	else if (trigger != C2H_EVT_FW_CLOSE)
-		goto clear_evt; /* Not a valid value */
-
-	c2h_evt = (struct c2h_evt_hdr *)buf;
-
-	memset(c2h_evt, 0, 16);
-
-	*buf = usb_read8(adapter, REG_C2HEVT_MSG_NORMAL);
-	*(buf+1) = usb_read8(adapter, REG_C2HEVT_MSG_NORMAL + 1);
-
-	RT_PRINT_DATA(_module_hal_init_c_, _drv_info_, "c2h_evt_read(): ",
-		      &c2h_evt , sizeof(c2h_evt));
-
-	/* Read the content */
-	for (i = 0; i < c2h_evt->plen; i++)
-		c2h_evt->payload[i] = usb_read8(adapter, REG_C2HEVT_MSG_NORMAL +
-						sizeof(*c2h_evt) + i);
-
-	RT_PRINT_DATA(_module_hal_init_c_, _drv_info_,
-		      "c2h_evt_read(): Command Content:\n",
-		      c2h_evt->payload, c2h_evt->plen);
-
-	ret = _SUCCESS;
-
-clear_evt:
-	/*
-	* Clear event to notify FW we have read the command.
-	* If this field isn't clear, the FW won't update the next
-	* command message.
-	*/
-	c2h_evt_clear(adapter);
-exit:
-	return ret;
-}
diff --git a/drivers/staging/rtl8188eu/include/hal_com.h b/drivers/staging/rtl8188eu/include/hal_com.h
index 81c2709..1527efa 100644
--- a/drivers/staging/rtl8188eu/include/hal_com.h
+++ b/drivers/staging/rtl8188eu/include/hal_com.h
@@ -168,6 +168,4 @@ bool Hal_MappingOutPipe(struct adapter *pAdapter, u8 NumOutPipe);
 void hal_init_macaddr(struct adapter *adapter);
 
 void c2h_evt_clear(struct adapter *adapter);
-s32 c2h_evt_read(struct adapter *adapter, u8 *buf);
-
 #endif /* __HAL_COMMON_H__ */
-- 
1.7.10.4

