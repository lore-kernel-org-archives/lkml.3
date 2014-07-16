Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965508AbaGPQN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:13:56 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:51456 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934672AbaGPQNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:13:52 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V5 4/6] staging: vt6556: Remove typedefs
Date: Wed, 16 Jul 2014 18:13:43 +0200
Message-Id: <1405527223-8959-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes uneeded typedefs reported by chackpatch and removes
one enum that is not in use. As checkpatch complained about the typedef
and the enum is not being used, this patch removes both typedef and enum.
The removed enum from card.h:

typedef enum _CARD_PHY_TYPE {
    PHY_TYPE_AUTO = 0,
    PHY_TYPE_11B,
    PHY_TYPE_11G,
    PHY_TYPE_11A
} CARD_PHY_TYPE, *PCARD_PHY_TYPE;

The following typedefs were removed, but enums were kept at device.h:

 typedef enum __device_msg_level
 typedef enum __DEVICE_NDIS_STATUS

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Cahnges from V4:
 - Updated commit message

 drivers/staging/vt6656/card.h   |  7 -------
 drivers/staging/vt6656/device.h | 17 ++++++++---------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 80fcd53..03fc167 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -32,13 +32,6 @@
 
 /* init card type */
 
-typedef enum _CARD_PHY_TYPE {
-    PHY_TYPE_AUTO = 0,
-    PHY_TYPE_11B,
-    PHY_TYPE_11G,
-    PHY_TYPE_11A
-} CARD_PHY_TYPE, *PCARD_PHY_TYPE;
-
 #define CB_MAX_CHANNEL_24G	14
 #define CB_MAX_CHANNEL_5G	42 /* add channel9(5045MHz), 41==>42 */
 #define CB_MAX_CHANNEL		(CB_MAX_CHANNEL_24G + CB_MAX_CHANNEL_5G)
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 50a6749..e3acf2f 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -187,13 +187,13 @@
 
 #define DBG_PRT(l, p, args...) { if (l <= msglevel) printk(p, ##args); }
 
-typedef enum __device_msg_level {
+enum {
 	MSG_LEVEL_ERR = 0,            /* Errors causing abnormal operation */
 	MSG_LEVEL_NOTICE = 1,         /* Errors needing user notification */
 	MSG_LEVEL_INFO = 2,           /* Normal message. */
 	MSG_LEVEL_VERBOSE = 3,        /* Will report all trival errors. */
 	MSG_LEVEL_DEBUG = 4           /* Only for debug purpose. */
-} DEVICE_MSG_LEVEL, *PDEVICE_MSG_LEVEL;
+};
 
 #define DEVICE_INIT_COLD	0x0 /* cold init */
 #define DEVICE_INIT_RESET	0x1 /* reset init or Dx to D0 power remain */
@@ -268,13 +268,12 @@ struct vnt_interrupt_buffer {
 
 /*++ NDIS related */
 
-typedef enum __DEVICE_NDIS_STATUS {
-    STATUS_SUCCESS = 0,
-    STATUS_FAILURE,
-    STATUS_RESOURCES,
-    STATUS_PENDING,
-} DEVICE_NDIS_STATUS, *PDEVICE_NDIS_STATUS;
-
+enum {
+	STATUS_SUCCESS = 0,
+	STATUS_FAILURE,
+	STATUS_RESOURCES,
+	STATUS_PENDING,
+};
 
 /* flags for options */
 #define     DEVICE_FLAGS_UNPLUG          0x00000001UL
-- 
1.9.3

