Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaHJOqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:46:51 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:45098 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaHJOqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:46:48 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 11/22] staging: rtl8188eu: Remove unused function rtw_IOL_accquire_xmit_frame()
Date: Sun, 10 Aug 2014 20:14:24 +0530
Message-Id: <1407681875-2611-11-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_iol.c    |   36 ---------------------------
 drivers/staging/rtl8188eu/include/rtw_iol.h |    1 -
 2 files changed, 37 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_iol.c b/drivers/staging/rtl8188eu/core/rtw_iol.c
index 7796287..5401f7a 100644
--- a/drivers/staging/rtl8188eu/core/rtw_iol.c
+++ b/drivers/staging/rtl8188eu/core/rtw_iol.c
@@ -20,42 +20,6 @@
 
 #include<rtw_iol.h>
 
-struct xmit_frame	*rtw_IOL_accquire_xmit_frame(struct adapter  *adapter)
-{
-	struct xmit_frame	*xmit_frame;
-	struct xmit_buf	*xmitbuf;
-	struct pkt_attrib	*pattrib;
-	struct xmit_priv	*pxmitpriv = &(adapter->xmitpriv);
-
-	xmit_frame = rtw_alloc_xmitframe(pxmitpriv);
-	if (xmit_frame == NULL) {
-		DBG_88E("%s rtw_alloc_xmitframe return null\n", __func__);
-		goto exit;
-	}
-
-	xmitbuf = rtw_alloc_xmitbuf(pxmitpriv);
-	if (xmitbuf == NULL) {
-		DBG_88E("%s rtw_alloc_xmitbuf return null\n", __func__);
-		rtw_free_xmitframe(pxmitpriv, xmit_frame);
-		xmit_frame = NULL;
-		goto exit;
-	}
-
-	xmit_frame->frame_tag = MGNT_FRAMETAG;
-	xmit_frame->pxmitbuf = xmitbuf;
-	xmit_frame->buf_addr = xmitbuf->pbuf;
-	xmitbuf->priv_data = xmit_frame;
-
-	pattrib = &xmit_frame->attrib;
-	update_mgntframe_attrib(adapter, pattrib);
-	pattrib->qsel = 0x10;/* Beacon */
-	pattrib->subtype = WIFI_BEACON;
-	pattrib->pktlen = 0;
-	pattrib->last_txcmdsz = 0;
-exit:
-	return xmit_frame;
-}
-
 int rtw_IOL_append_cmds(struct xmit_frame *xmit_frame, u8 *IOL_cmds, u32 cmd_len)
 {
 	struct pkt_attrib	*pattrib = &xmit_frame->attrib;
diff --git a/drivers/staging/rtl8188eu/include/rtw_iol.h b/drivers/staging/rtl8188eu/include/rtw_iol.h
index 80bfd06..bac4d7f 100644
--- a/drivers/staging/rtl8188eu/include/rtw_iol.h
+++ b/drivers/staging/rtl8188eu/include/rtw_iol.h
@@ -46,7 +46,6 @@ enum ioreg_cmd {
 	IOREG_CMD_END		= 0xFF,
 };
 
-struct xmit_frame *rtw_IOL_accquire_xmit_frame(struct adapter *adapter);
 int rtw_IOL_append_cmds(struct xmit_frame *xmit_frame, u8 *IOL_cmds,
 			u32 cmd_len);
 int rtw_IOL_append_LLT_cmd(struct xmit_frame *xmit_frame, u8 page_boundary);
-- 
1.7.10.4

