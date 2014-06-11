Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbaFKRYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:24:32 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52936 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaFKRY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:24:28 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 21/22] staging: rtl8188eu: Move usb_[read,write]() declarations to usb_ops_linux.h
Date: Wed, 11 Jun 2014 22:51:40 +0530
Message-Id: <1402507301-3722-21-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_debug.c        |    1 +
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |    3 +--
 drivers/staging/rtl8188eu/core/rtw_mp.c           |    2 +-
 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c     |    2 +-
 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c      |    1 +
 drivers/staging/rtl8188eu/core/rtw_sreset.c       |    1 +
 drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c      |    1 +
 drivers/staging/rtl8188eu/hal/rtl8188eu_led.c     |    1 +
 drivers/staging/rtl8188eu/include/odm_precomp.h   |    1 +
 drivers/staging/rtl8188eu/include/rtw_io.h        |   14 --------------
 drivers/staging/rtl8188eu/include/usb_ops_linux.h |   16 +++++++++++++---
 11 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_debug.c b/drivers/staging/rtl8188eu/core/rtw_debug.c
index acd6d45..dd15163 100644
--- a/drivers/staging/rtl8188eu/core/rtw_debug.c
+++ b/drivers/staging/rtl8188eu/core/rtw_debug.c
@@ -20,6 +20,7 @@
 #define _RTW_DEBUG_C_
 
 #include <rtw_debug.h>
+#include <usb_ops_linux.h>
 
 int proc_get_drv_version(char *page, char **start,
 			  off_t offset, int count,
diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 1da9d1e..31507e7 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -22,8 +22,7 @@
 #include <osdep_service.h>
 #include <drv_types.h>
 #include <rtw_efuse.h>
-
-
+#include <usb_ops_linux.h>
 
 /*------------------------Define local variable------------------------------*/
 u8 fakeEfuseBank;
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp.c b/drivers/staging/rtl8188eu/core/rtw_mp.c
index fa8704d..43765f8 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp.c
@@ -20,7 +20,7 @@
 #define _RTW_MP_C_
 
 #include <drv_types.h>
-
+#include <usb_ops_linux.h>
 #include "rtl8188e_hal.h"
 #include <linux/vmalloc.h>
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
index c06cd82..ad55994 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
@@ -22,7 +22,7 @@
 #include <osdep_service.h>
 #include <drv_types.h>
 #include <mlme_osdep.h>
-
+#include <usb_ops_linux.h>
 /* include <rtw_mp.h> */
 #include <rtw_mp_ioctl.h>
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
index 51b2468..9b80c8a 100644
--- a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
@@ -22,6 +22,7 @@
 #include <osdep_service.h>
 #include <drv_types.h>
 #include <osdep_intf.h>
+#include <usb_ops_linux.h>
 #include <linux/usb.h>
 #include <usb_osintf.h>
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_sreset.c b/drivers/staging/rtl8188eu/core/rtw_sreset.c
index 22a3512..cd4e344 100644
--- a/drivers/staging/rtl8188eu/core/rtw_sreset.c
+++ b/drivers/staging/rtl8188eu/core/rtw_sreset.c
@@ -19,6 +19,7 @@
  ******************************************************************************/
 
 #include <rtw_sreset.h>
+#include <usb_ops_linux.h>
 
 void sreset_init_value(struct adapter *padapter)
 {
diff --git a/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c b/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c
index 1808d35..caca535 100644
--- a/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c
+++ b/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c
@@ -35,6 +35,7 @@ Major Change History:
 --*/
 
 #include <HalPwrSeqCmd.h>
+#include <usb_ops_linux.h>
 
 /*	Description: */
 /*		This routine deals with the Power Configuration CMDs parsing
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
index ab07a6c..81d691d 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_led.c
@@ -22,6 +22,7 @@
 #include <drv_types.h>
 #include <rtl8188e_hal.h>
 #include <rtl8188e_led.h>
+#include <usb_ops_linux.h>
 
 /*  LED object. */
 
diff --git a/drivers/staging/rtl8188eu/include/odm_precomp.h b/drivers/staging/rtl8188eu/include/odm_precomp.h
index 3839463..df61892 100644
--- a/drivers/staging/rtl8188eu/include/odm_precomp.h
+++ b/drivers/staging/rtl8188eu/include/odm_precomp.h
@@ -30,6 +30,7 @@
 #include <osdep_service.h>
 #include <drv_types.h>
 #include <hal_intf.h>
+#include <usb_ops_linux.h>
 
 /* 2 OutSrc Header Files */
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index 41e3dd8..a9a6d19 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -33,18 +33,4 @@
 #include <linux/usb.h>
 #include <linux/usb/ch9.h>
 
-u8 usb_read8(struct adapter *adapter, u32 addr);
-u16 usb_read16(struct adapter *adapter, u32 addr);
-u32 usb_read32(struct adapter *adapter, u32 addr);
-u32 usb_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
-void usb_read_port_cancel(struct adapter *adapter);
-
-int usb_write8(struct adapter *adapter, u32 addr, u8 val);
-int usb_write16(struct adapter *adapter, u32 addr, u16 val);
-int usb_write32(struct adapter *adapter, u32 addr, u32 val);
-int usb_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata);
-
-u32 usb_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
-void usb_write_port_cancel(struct adapter *adapter);
-
 #endif	/* _RTL8711_IO_H_ */
diff --git a/drivers/staging/rtl8188eu/include/usb_ops_linux.h b/drivers/staging/rtl8188eu/include/usb_ops_linux.h
index 0a6e5d0..5fc4247 100644
--- a/drivers/staging/rtl8188eu/include/usb_ops_linux.h
+++ b/drivers/staging/rtl8188eu/include/usb_ops_linux.h
@@ -44,9 +44,19 @@
 
 unsigned int ffaddr2pipehdl(struct dvobj_priv *pdvobj, u32 addr);
 
-void usb_read_port_cancel(struct adapter *padapter);
+u8 usb_read8(struct adapter *adapter, u32 addr);
+u16 usb_read16(struct adapter *adapter, u32 addr);
+u32 usb_read32(struct adapter *adapter, u32 addr);
 
-u32 usb_write_port(struct adapter *padapter, u32 addr, u32 cnt, u8 *wmem);
-void usb_write_port_cancel(struct adapter *padapter);
+u32 usb_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
+void usb_read_port_cancel(struct adapter *adapter);
+
+int usb_write8(struct adapter *adapter, u32 addr, u8 val);
+int usb_write16(struct adapter *adapter, u32 addr, u16 val);
+int usb_write32(struct adapter *adapter, u32 addr, u32 val);
+int usb_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata);
+
+u32 usb_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
+void usb_write_port_cancel(struct adapter *adapter);
 
 #endif
-- 
1.7.10.4

