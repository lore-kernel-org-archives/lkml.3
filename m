Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaE0PgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:36:25 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:52561 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbaE0PgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:36:21 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 01/15] staging: rtl8188eu:Remove function rtw_set_tx_chksum_offload()
Date: Tue, 27 May 2014 21:05:41 +0530
Message-Id: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_set_tx_chksum_offload() has empty defination.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_xmit.c      |    2 --
 drivers/staging/rtl8188eu/include/xmit_osdep.h |    2 --
 drivers/staging/rtl8188eu/os_dep/xmit_linux.c  |    4 ----
 3 files changed, 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index 8d4265f..1413ec8 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -621,8 +621,6 @@ static s32 update_attrib(struct adapter *padapter, struct sk_buff *pkt, struct p
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_, ("update_attrib: bswenc = false\n"));
 	}
 
-	rtw_set_tx_chksum_offload(pkt, pattrib);
-
 	update_attrib_phy_info(pattrib, psta);
 
 exit:
diff --git a/drivers/staging/rtl8188eu/include/xmit_osdep.h b/drivers/staging/rtl8188eu/include/xmit_osdep.h
index 48bc5fc..13965f2 100644
--- a/drivers/staging/rtl8188eu/include/xmit_osdep.h
+++ b/drivers/staging/rtl8188eu/include/xmit_osdep.h
@@ -49,8 +49,6 @@ int rtw_os_xmit_resource_alloc(struct adapter *padapter,
 void rtw_os_xmit_resource_free(struct adapter *padapter,
 			       struct xmit_buf *pxmitbuf, u32 free_sz);
 
-void rtw_set_tx_chksum_offload(struct sk_buff *pkt, struct pkt_attrib *pattrib);
-
 uint rtw_remainder_len(struct pkt_file *pfile);
 void _rtw_open_pktfile(struct sk_buff *pkt, struct pkt_file *pfile);
 uint _rtw_pktfile_read(struct pkt_file *pfile, u8 *rmem, uint rlen);
diff --git a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
index 2c8e3f7..6089bae 100644
--- a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
@@ -77,10 +77,6 @@ int rtw_endofpktfile(struct pkt_file *pfile)
 	return false;
 }
 
-void rtw_set_tx_chksum_offload(struct sk_buff *pkt, struct pkt_attrib *pattrib)
-{
-}
-
 int rtw_os_xmit_resource_alloc(struct adapter *padapter, struct xmit_buf *pxmitbuf, u32 alloc_sz)
 {
 	int i;
-- 
1.7.10.4

