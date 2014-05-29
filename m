Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965315AbaE2RyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:54:11 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:42221 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933020AbaE2RyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:54:05 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 12/18] staging: rtl8188eu: Remove function rtl8188e_silentreset_for_specific_platform()
Date: Thu, 29 May 2014 23:20:52 +0530
Message-Id: <1401385858-28722-12-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
References: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove rtl8188e_silentreset_for_specific_platform() and function pointer
->silentreset pointing to it.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c   |    1 -
 drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c     |    3 ---
 drivers/staging/rtl8188eu/include/hal_intf.h        |    1 -
 drivers/staging/rtl8188eu/include/rtl8188e_sreset.h |    1 -
 4 files changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index a0f5172..6a9c8e2 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -1872,7 +1872,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	pHalFunc->Efuse_WordEnableDataWrite = &rtl8188e_Efuse_WordEnableDataWrite;
 
 	pHalFunc->sreset_init_value = &sreset_init_value;
-	pHalFunc->silentreset = &rtl8188e_silentreset_for_specific_platform;
 	pHalFunc->sreset_get_wifi_status  = &sreset_get_wifi_status;
 
 	pHalFunc->GetHalODMVarHandler = &rtl8188e_GetHalODMVar;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c b/drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c
index 7fb0f68..f907fe0 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c
@@ -22,7 +22,4 @@
 #include <rtl8188e_sreset.h>
 #include <rtl8188e_hal.h>
 
-void rtl8188e_silentreset_for_specific_platform(struct adapter *padapter)
-{
-}
 
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index bed9035..ca29676 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -252,7 +252,6 @@ struct hal_ops {
 					  u8 word_en, u8 *data, bool test);
 
 	void (*sreset_init_value)(struct adapter *padapter);
-	void (*silentreset)(struct adapter *padapter);
 	u8 (*sreset_get_wifi_status)(struct adapter *padapter);
 
 	int (*IOL_exec_cmds_sync)(struct adapter *padapter,
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_sreset.h b/drivers/staging/rtl8188eu/include/rtl8188e_sreset.h
index eb884b7..cade6d7 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_sreset.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_sreset.h
@@ -24,6 +24,5 @@
 #include <drv_types.h>
 #include <rtw_sreset.h>
 
-void rtl8188e_silentreset_for_specific_platform(struct adapter *padapter);
 
 #endif
-- 
1.7.10.4

