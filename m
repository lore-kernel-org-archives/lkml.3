Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaFVIWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:22:04 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37145 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbaFVIV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:21:58 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/42] staging: rtl8188eu: Remove dummy rtl8188eu_free_xmit_priv() and its wrapper
Date: Sun, 22 Jun 2014 13:49:27 +0530
Message-Id: <1403425202-11942-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
References: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_xmit.c         |    3 ---
 drivers/staging/rtl8188eu/hal/hal_intf.c          |    6 ------
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c    |    4 ----
 drivers/staging/rtl8188eu/hal/usb_halinit.c       |    1 -
 drivers/staging/rtl8188eu/include/hal_intf.h      |    2 --
 drivers/staging/rtl8188eu/include/rtl8188e_xmit.h |    1 -
 6 files changed, 17 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index eb938a5..3156067 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -233,9 +233,6 @@ void _rtw_free_xmit_priv (struct xmit_priv *pxmitpriv)
 	u32 max_xmit_extbuf_size = MAX_XMIT_EXTBUF_SZ;
 	u32 num_xmit_extbuf = NR_XMIT_EXTBUFF;
 
-
-	rtw_hal_free_xmit_priv(padapter);
-
 	if (pxmitpriv->pxmit_frame_buf == NULL)
 		return;
 
diff --git a/drivers/staging/rtl8188eu/hal/hal_intf.c b/drivers/staging/rtl8188eu/hal/hal_intf.c
index 799c314..f002c43 100644
--- a/drivers/staging/rtl8188eu/hal/hal_intf.c
+++ b/drivers/staging/rtl8188eu/hal/hal_intf.c
@@ -214,12 +214,6 @@ s32 rtw_hal_init_xmit_priv(struct adapter *adapt)
 	return _FAIL;
 }
 
-void rtw_hal_free_xmit_priv(struct adapter *adapt)
-{
-	if (adapt->HalFunc.free_xmit_priv != NULL)
-		adapt->HalFunc.free_xmit_priv(adapt);
-}
-
 s32 rtw_hal_init_recv_priv(struct adapter *adapt)
 {
 	if (adapt->HalFunc.init_recv_priv)
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
index 3112e6c..34bc660 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
@@ -35,10 +35,6 @@ s32	rtl8188eu_init_xmit_priv(struct adapter *adapt)
 	return _SUCCESS;
 }
 
-void	rtl8188eu_free_xmit_priv(struct adapter *adapt)
-{
-}
-
 static u8 urb_zero_packet_chk(struct adapter *adapt, int sz)
 {
 	u8 set_tx_desc_offset;
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 5096d4d..3a539e4 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -2223,7 +2223,6 @@ void rtl8188eu_set_hal_ops(struct adapter *adapt)
 	halfunc->inirp_deinit = &rtl8188eu_inirp_deinit;
 
 	halfunc->init_xmit_priv = &rtl8188eu_init_xmit_priv;
-	halfunc->free_xmit_priv = &rtl8188eu_free_xmit_priv;
 
 	halfunc->init_recv_priv = &rtl8188eu_init_recv_priv;
 	halfunc->free_recv_priv = &rtl8188eu_free_recv_priv;
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index 05e363e..fb797c7 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -157,7 +157,6 @@ struct hal_ops {
 	u32	(*inirp_deinit)(struct adapter *padapter);
 
 	s32	(*init_xmit_priv)(struct adapter *padapter);
-	void	(*free_xmit_priv)(struct adapter *padapter);
 
 	s32	(*init_recv_priv)(struct adapter *padapter);
 	void	(*free_recv_priv)(struct adapter *padapter);
@@ -302,7 +301,6 @@ s32	rtw_hal_mgnt_xmit(struct adapter *padapter,
 			  struct xmit_frame *pmgntframe);
 
 s32	rtw_hal_init_xmit_priv(struct adapter *padapter);
-void	rtw_hal_free_xmit_priv(struct adapter *padapter);
 
 s32	rtw_hal_init_recv_priv(struct adapter *padapter);
 void	rtw_hal_free_recv_priv(struct adapter *padapter);
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_xmit.h b/drivers/staging/rtl8188eu/include/rtl8188e_xmit.h
index cf7267a..0b96d42 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_xmit.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_xmit.h
@@ -159,7 +159,6 @@ struct txrpt_ccx_88e {
 void rtl8188e_fill_fake_txdesc(struct adapter *padapter, u8 *pDesc,
 			       u32 BufferLen, u8 IsPsPoll, u8 IsBTQosNull);
 s32 rtl8188eu_init_xmit_priv(struct adapter *padapter);
-void rtl8188eu_free_xmit_priv(struct adapter *padapter);
 s32 rtl8188eu_hal_xmit(struct adapter *padapter, struct xmit_frame *frame);
 s32 rtl8188eu_mgnt_xmit(struct adapter *padapter, struct xmit_frame *frame);
 s32 rtl8188eu_xmit_buf_handler(struct adapter *padapter);
-- 
1.7.10.4

