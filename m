Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbaHVKfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 06:35:07 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:59377 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbaHVKfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 06:35:05 -0400
From: Miguel Oliveira <cmroliv@gmail.com>
To: gregkh@linuxfoundation.org
Cc: navin.patidar@gmail.com, Larry.Finger@lwfinger.net, davem@davemloft.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        cmroliv@gmail.com
Subject: [PATCH 4/4] staging: rtl8188eu: rtw_debug.h
Date: Fri, 22 Aug 2014 11:33:52 +0100
Message-Id: <1408703632-32286-1-git-send-email-cmroliv@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408703558-32167-1-git-send-email-cmroliv@gmail.com>
References: <1408703558-32167-1-git-send-email-cmroliv@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all rtw_proc_xxx references to rtw_sys_xxx in file
include/rtw_debug.h

Signed-off-by: Miguel Oliveira <cmroliv@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_debug.h |  227 +++++++++++--------------
 1 file changed, 98 insertions(+), 129 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_debug.h b/drivers/staging/rtl8188eu/include/rtw_debug.h
index a38616e..aa0f46a 100644
--- a/drivers/staging/rtl8188eu/include/rtw_debug.h
+++ b/drivers/staging/rtl8188eu/include/rtw_debug.h
@@ -87,7 +87,7 @@ extern u32 GlobalDebugLevel;
 #define MSG_88E(...)							\
 	do {								\
 		if (_drv_err_ <= GlobalDebugLevel)			\
-			pr_info(DRIVER_PREFIX __VA_ARGS__);			\
+			pr_info(DRIVER_PREFIX __VA_ARGS__);		\
 	} while (0)
 
 #define RT_TRACE(_comp, _level, fmt)					\
@@ -106,7 +106,7 @@ extern u32 GlobalDebugLevel;
 			u8	*ptr = (u8 *)_hexdata;			\
 			pr_info("%s", DRIVER_PREFIX);			\
 			pr_info(_titlestring);				\
-			for (__i = 0; __i < (int)_hexdatalen; __i++ ) {	\
+			for (__i = 0; __i < (int)_hexdatalen; __i++) {	\
 				pr_info("%02X%s", ptr[__i],		\
 					 (((__i + 1) % 4) == 0) ?	\
 					 "  " : " ");	\
@@ -117,150 +117,119 @@ extern u32 GlobalDebugLevel;
 		}							\
 	} while (0)
 
-int proc_get_drv_version(char *page, char **start,
-			 off_t offset, int count,
-			 int *eof, void *data);
-
-int proc_get_write_reg(char *page, char **start,
-		       off_t offset, int count,
-		       int *eof, void *data);
-
-int proc_set_write_reg(struct file *file, const char __user *buffer,
-		       unsigned long count, void *data);
-int proc_get_read_reg(char *page, char **start,
-		      off_t offset, int count,
-		      int *eof, void *data);
-
-int proc_set_read_reg(struct file *file, const char __user *buffer,
-		      unsigned long count, void *data);
-
-int proc_get_fwstate(char *page, char **start,
-		     off_t offset, int count,
-		     int *eof, void *data);
-int proc_get_sec_info(char *page, char **start,
-		      off_t offset, int count,
-		      int *eof, void *data);
-int proc_get_mlmext_state(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data);
-
-int proc_get_qos_option(char *page, char **start,
-			off_t offset, int count,
-			int *eof, void *data);
-int proc_get_ht_option(char *page, char **start,
-		       off_t offset, int count,
-		       int *eof, void *data);
-int proc_get_rf_info(char *page, char **start,
-		     off_t offset, int count,
-		     int *eof, void *data);
-int proc_get_ap_info(char *page, char **start,
-		     off_t offset, int count,
-		     int *eof, void *data);
-
-int proc_get_adapter_state(char *page, char **start,
-			   off_t offset, int count,
-			   int *eof, void *data);
-
-int proc_get_trx_info(char *page, char **start,
-		      off_t offset, int count,
-		      int *eof, void *data);
-
-int proc_get_mac_reg_dump1(char *page, char **start,
-			   off_t offset, int count,
-			   int *eof, void *data);
-
-int proc_get_mac_reg_dump2(char *page, char **start,
-			   off_t offset, int count,
-			   int *eof, void *data);
-
-int proc_get_mac_reg_dump3(char *page, char **start,
-			   off_t offset, int count,
-			   int *eof, void *data);
-
-int proc_get_bb_reg_dump1(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data);
-
-int proc_get_bb_reg_dump2(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data);
-
-int proc_get_bb_reg_dump3(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data);
-
-int proc_get_rf_reg_dump1(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data);
-
-int proc_get_rf_reg_dump2(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data);
-
-int proc_get_rf_reg_dump3(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data);
-
-int proc_get_rf_reg_dump4(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data);
+ssize_t sys_get_drv_version(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_set_write_reg(struct file *file, const char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_read_reg(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_set_read_reg(struct file *file, const char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_fwstate(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_sec_info(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_mlmext_state(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_qos_option(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_ht_option(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_rf_info(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_ap_info(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_adapter_state(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_trx_info(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_mac_reg_dump1(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_mac_reg_dump2(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_mac_reg_dump3(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_bb_reg_dump1(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_bb_reg_dump2(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_bb_reg_dump3(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_rf_reg_dump1(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_rf_reg_dump2(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_rf_reg_dump3(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
+
+ssize_t sys_get_rf_reg_dump4(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
 
 #ifdef CONFIG_88EU_AP_MODE
 
-int proc_get_all_sta_info(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data);
+ssize_t sys_get_all_sta_info(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
 
 #endif
 
-int proc_get_best_channel(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data);
-
-int proc_get_rx_signal(char *page, char **start,
-		       off_t offset, int count,
-		       int *eof, void *data);
+ssize_t sys_get_best_channel(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
 
-int proc_set_rx_signal(struct file *file, const char __user *buffer,
-		       unsigned long count, void *data);
+ssize_t sys_get_rx_signal(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
 
-int proc_get_ht_enable(char *page, char **start,
-		       off_t offset, int count,
-		       int *eof, void *data);
+ssize_t sys_set_rx_signal(struct file *file, const char __user *buffer,
+				size_t count, loff_t *offset);
 
-int proc_set_ht_enable(struct file *file, const char __user *buffer,
-		       unsigned long count, void *data);
+ssize_t sys_get_ht_enable(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
 
-int proc_get_cbw40_enable(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data);
+ssize_t sys_set_ht_enable(struct file *file, const char __user *buffer,
+				size_t count, loff_t *offset);
 
-int proc_set_cbw40_enable(struct file *file, const char __user *buffer,
-			  unsigned long count, void *data);
+ssize_t sys_get_cbw40_enable(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
 
-int proc_get_ampdu_enable(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data);
+ssize_t sys_set_cbw40_enable(struct file *file, const char __user *buffer,
+				size_t count, loff_t *offset);
 
-int proc_set_ampdu_enable(struct file *file, const char __user *buffer,
-			  unsigned long count, void *data);
+ssize_t sys_get_ampdu_enable(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
 
-int proc_get_rx_stbc(char *page, char **start,
-		     off_t offset, int count,
-		     int *eof, void *data);
+ssize_t sys_set_ampdu_enable(struct file *file, const char __user *buffer,
+				size_t count, loff_t *offset);
 
-int proc_set_rx_stbc(struct file *file, const char __user *buffer,
-		     unsigned long count, void *data);
+ssize_t sys_get_rx_stbc(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
 
-int proc_get_two_path_rssi(char *page, char **start,
-			   off_t offset, int count,
-			   int *eof, void *data);
+ssize_t sys_set_rx_stbc(struct file *file, const char __user *buffer,
+				size_t count, loff_t *offset);
 
-int proc_get_rssi_disp(char *page, char **start,
-		       off_t offset, int count,
-		       int *eof, void *data);
+ssize_t sys_get_two_path_rssi(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset);
 
-int proc_set_rssi_disp(struct file *file, const char __user *buffer,
-		       unsigned long count, void *data);
+ssize_t sys_set_rssi_disp(struct file *file, const char __user *buffer,
+				size_t count, loff_t *offset);
 
 #endif	/* __RTW_DEBUG_H__ */
-- 
1.7.10.4

