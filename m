Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaHJOrj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:47:39 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:42422 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaHJOrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:47:37 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 16/22] staging: rtl8188eu: Remove unused function rtw_IOL_cmd_tx_pkt_buf_dump()
Date: Sun, 10 Aug 2014 20:14:29 +0530
Message-Id: <1407681875-2611-16-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   32 ---------------------
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h  |    1 -
 2 files changed, 33 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index ac4bede..ea2ce8b 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -138,38 +138,6 @@ exit:
 	return ret;
 }
 
-void rtw_IOL_cmd_tx_pkt_buf_dump(struct adapter *Adapter, int data_len)
-{
-	u32 fifo_data, reg_140;
-	u32 addr, rstatus, loop = 0;
-	u16 data_cnts = (data_len/8)+1;
-	u8 *pbuf = vzalloc(data_len+10);
-	DBG_88E("###### %s ######\n", __func__);
-
-	usb_write8(Adapter, REG_PKT_BUFF_ACCESS_CTRL, TXPKT_BUF_SELECT);
-	if (pbuf) {
-		for (addr = 0; addr < data_cnts; addr++) {
-			usb_write32(Adapter, 0x140, addr);
-			msleep(1);
-			loop = 0;
-			do {
-				rstatus = (reg_140 = usb_read32(Adapter, REG_PKTBUF_DBG_CTRL)&BIT24);
-				if (rstatus) {
-					fifo_data = usb_read32(Adapter, REG_PKTBUF_DBG_DATA_L);
-					memcpy(pbuf+(addr*8), &fifo_data, 4);
-
-					fifo_data = usb_read32(Adapter, REG_PKTBUF_DBG_DATA_H);
-					memcpy(pbuf+(addr*8+4), &fifo_data, 4);
-				}
-				msleep(1);
-			} while (!rstatus && (loop++ < 10));
-		}
-		rtw_IOL_cmd_buf_dump(Adapter, data_len, pbuf);
-		vfree(pbuf);
-	}
-	DBG_88E("###### %s ######\n", __func__);
-}
-
 #define MAX_REG_BOLCK_SIZE	196
 
 void _8051Reset88E(struct adapter *padapter)
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
index 8b73c03..814ba1a 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
@@ -423,7 +423,6 @@ void SetBcnCtrlReg(struct adapter *padapter, u8 SetBits, u8 ClearBits);
 void rtl8188e_start_thread(struct adapter *padapter);
 void rtl8188e_stop_thread(struct adapter *padapter);
 
-void rtw_IOL_cmd_tx_pkt_buf_dump(struct adapter  *Adapter, int len);
 s32 iol_execute(struct adapter *padapter, u8 control);
 void iol_mode_enable(struct adapter *padapter, u8 enable);
 s32 rtl8188e_iol_efuse_patch(struct adapter *padapter);
-- 
1.7.10.4

