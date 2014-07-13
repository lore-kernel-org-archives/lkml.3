Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbaGMQg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 12:36:28 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:47150 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbaGMQgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 12:36:20 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH] staging: vt6556: Cleanup coding style issues
Date: Sun, 13 Jul 2014 18:36:09 +0200
Message-Id: <1405269369-16236-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleanup coding style issues reported by checkpatch.

This patch change the following enums:
 - typedef enum __device_msg_level
 - typedef enum __DEVICE_NDIS_STATUS

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Made against latest staging-next.
 drivers/staging/vt6656/channel.c |  5 +++--
 drivers/staging/vt6656/device.h  | 27 +++++++++++++--------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index fb1838e..4a53f1a 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -28,8 +28,9 @@
  *
  *
  * Revision History:
- *      01-18-2005      RobertYu:  remove the for loop searching in ChannelValid,
- *                                 change ChannelRuleTab to lookup-type, reorder table items.
+ *	01-18-2005	RobertYu:	remove the for loop searching in
+ *					ChannelValid, change ChannelRuleTab
+ *					to lookup-type, reorder table items.
  *
  *
  */
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 789c55d..e3acf2f 100644
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
@@ -443,11 +442,11 @@ struct vnt_private {
 	struct ieee80211_low_level_stats low_stats;
 };
 
-#define ADD_ONE_WITH_WRAP_AROUND(uVar, uModulo) {   \
-    if ((uVar) >= ((uModulo) - 1))                  \
-        (uVar) = 0;                                 \
-    else                                            \
-        (uVar)++;                                   \
+#define ADD_ONE_WITH_WRAP_AROUND(uVar, uModulo) {	\
+	if ((uVar) >= ((uModulo) - 1))			\
+		(uVar) = 0;				\
+	else						\
+		(uVar)++;				\
 }
 
 #define fMP_DISCONNECTED                    0x00000002
-- 
1.9.3

