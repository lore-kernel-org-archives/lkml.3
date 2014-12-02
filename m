Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbaLBWax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 17:30:53 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59286 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550AbaLBWaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 17:30:52 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        navin patidar <navin.patidar@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8188eu: hal: hal_intf.c:  Cleaning up functions that are not used anywhere
Date: Tue,  2 Dec 2014 23:33:29 +0100
Message-Id: <1417559609-26920-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere.
rtw_hal_interrupt_handler() rtw_hal_sreset_get_wifi_status()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8188eu/hal/hal_intf.c     |   16 ----------------
 drivers/staging/rtl8188eu/include/hal_intf.h |    3 ---
 2 files changed, 19 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/hal_intf.c b/drivers/staging/rtl8188eu/hal/hal_intf.c
index 538a0f6..4bdbed2 100644
--- a/drivers/staging/rtl8188eu/hal/hal_intf.c
+++ b/drivers/staging/rtl8188eu/hal/hal_intf.c
@@ -275,13 +275,6 @@ void rtw_hal_write_rfreg(struct adapter *adapt, enum rf_radio_path rfpath,
 					      bitmask, data);
 }
 
-s32 rtw_hal_interrupt_handler(struct adapter *adapt)
-{
-	if (adapt->HalFunc.interrupt_handler)
-		return adapt->HalFunc.interrupt_handler(adapt);
-	return _FAIL;
-}
-
 void rtw_hal_set_bwmode(struct adapter *adapt,
 			enum ht_channel_width bandwidth, u8 offset)
 {
@@ -329,15 +322,6 @@ void rtw_hal_sreset_init(struct adapter *adapt)
 		adapt->HalFunc.sreset_init_value(adapt);
 }
 
-u8   rtw_hal_sreset_get_wifi_status(struct adapter *adapt)
-{
-	u8 status = 0;
-
-	if (adapt->HalFunc.sreset_get_wifi_status)
-		status = adapt->HalFunc.sreset_get_wifi_status(adapt);
-	return status;
-}
-
 void rtw_hal_notch_filter(struct adapter *adapter, bool enable)
 {
 	if (adapter->HalFunc.hal_notch_filter)
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index 9191993..3b476d8 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -304,8 +304,6 @@ void	rtw_hal_write_rfreg(struct adapter *padapter,
 			    enum rf_radio_path eRFPath, u32 RegAddr,
 			    u32 BitMask, u32 Data);
 
-s32	rtw_hal_interrupt_handler(struct adapter *padapter);
-
 void	rtw_hal_set_bwmode(struct adapter *padapter,
 			   enum ht_channel_width Bandwidth, u8 Offset);
 void	rtw_hal_set_chan(struct adapter *padapter, u8 channel);
@@ -317,7 +315,6 @@ void	rtw_hal_antdiv_rssi_compared(struct adapter *padapter,
 				     struct wlan_bssid_ex *src);
 
 void rtw_hal_sreset_init(struct adapter *padapter);
-u8   rtw_hal_sreset_get_wifi_status(struct adapter *padapter);
 
 void rtw_hal_notch_filter(struct adapter *adapter, bool enable);
 void rtw_hal_reset_security_engine(struct adapter *adapter);
-- 
1.7.10.4

