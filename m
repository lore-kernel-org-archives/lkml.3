Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab3BZGkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 01:40:40 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:45008 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759110Ab3BZGjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 01:39:21 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: andrew.smirnov@gmail.com
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, sameo@linux.intel.com,
        perex@perex.cz, tiwai@suse.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 5/8] v4l2: Add standard controls for FM receivers
Date: Mon, 25 Feb 2013 22:38:51 -0800
Message-Id: <1361860734-21666-6-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361860734-21666-1-git-send-email-andrew.smirnov@gmail.com>
References: <1361860734-21666-1-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit introduces new class of standard controls
V4L2_CTRL_CLASS_FM_RX. This class is intended to all controls
pertaining to FM receiver chips. Also, two controls belonging to said
class are added as a part of this commit: V4L2_CID_TUNE_DEEMPHASIS and
V4L2_CID_RDS_RECEPTION.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |   14 +++++++++++---
 include/uapi/linux/v4l2-controls.h   |   13 ++++++++++++-
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 6b28b58..8b89fb8 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -297,8 +297,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Text",
 		NULL
 	};
-	static const char * const tune_preemphasis[] = {
-		"No Preemphasis",
+	static const char * const tune_emphasis[] = {
+		"None",
 		"50 Microseconds",
 		"75 Microseconds",
 		NULL,
@@ -508,7 +508,9 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 	case V4L2_CID_SCENE_MODE:
 		return scene_mode;
 	case V4L2_CID_TUNE_PREEMPHASIS:
-		return tune_preemphasis;
+		return tune_emphasis;
+	case V4L2_CID_TUNE_DEEMPHASIS:
+		return tune_emphasis;
 	case V4L2_CID_FLASH_LED_MODE:
 		return flash_led_mode;
 	case V4L2_CID_FLASH_STROBE_SOURCE:
@@ -799,6 +801,9 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_DV_RX_POWER_PRESENT:	return "Power Present";
 	case V4L2_CID_DV_RX_RGB_RANGE:		return "Rx RGB Quantization Range";
 
+	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Receiver Controls";
+	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
+	case V4L2_CID_RDS_RECEPTION:		return "RDS Reception";
 	default:
 		return NULL;
 	}
@@ -846,6 +851,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:
 	case V4L2_CID_IMAGE_STABILIZATION:
+	case V4L2_CID_RDS_RECEPTION:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
@@ -904,6 +910,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_DV_TX_RGB_RANGE:
 	case V4L2_CID_DV_RX_RGB_RANGE:
 	case V4L2_CID_TEST_PATTERN:
+	case V4L2_CID_TUNE_DEEMPHASIS:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_LINK_FREQ:
@@ -926,6 +933,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_IMAGE_SOURCE_CLASS:
 	case V4L2_CID_IMAGE_PROC_CLASS:
 	case V4L2_CID_DV_CLASS:
+	case V4L2_CID_FM_RX_CLASS:
 		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		/* You can neither read not write these */
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index dcd6374..296d20e 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -59,6 +59,7 @@
 #define V4L2_CTRL_CLASS_IMAGE_SOURCE	0x009e0000	/* Image source controls */
 #define V4L2_CTRL_CLASS_IMAGE_PROC	0x009f0000	/* Image processing controls */
 #define V4L2_CTRL_CLASS_DV		0x00a00000	/* Digital Video controls */
+#define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* Digital Video controls */
 
 /* User-class control IDs */
 
@@ -711,10 +712,14 @@ enum v4l2_auto_focus_range {
 #define V4L2_CID_PILOT_TONE_FREQUENCY		(V4L2_CID_FM_TX_CLASS_BASE + 98)
 
 #define V4L2_CID_TUNE_PREEMPHASIS		(V4L2_CID_FM_TX_CLASS_BASE + 112)
-enum v4l2_preemphasis {
+enum v4l2_xemphasis {
 	V4L2_PREEMPHASIS_DISABLED	= 0,
 	V4L2_PREEMPHASIS_50_uS		= 1,
 	V4L2_PREEMPHASIS_75_uS		= 2,
+	V4L2_DEEMPHASIS_DISABLED	= V4L2_PREEMPHASIS_DISABLED,
+	V4L2_DEEMPHASIS_50_uS		= V4L2_PREEMPHASIS_50_uS,
+	V4L2_DEEMPHASIS_75_uS		= V4L2_PREEMPHASIS_75_uS,
+
 };
 #define V4L2_CID_TUNE_POWER_LEVEL		(V4L2_CID_FM_TX_CLASS_BASE + 113)
 #define V4L2_CID_TUNE_ANTENNA_CAPACITOR		(V4L2_CID_FM_TX_CLASS_BASE + 114)
@@ -825,4 +830,10 @@ enum v4l2_dv_rgb_range {
 #define	V4L2_CID_DV_RX_POWER_PRESENT		(V4L2_CID_DV_CLASS_BASE + 100)
 #define V4L2_CID_DV_RX_RGB_RANGE		(V4L2_CID_DV_CLASS_BASE + 101)
 
+#define V4L2_CID_FM_RX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_RX | 0x900)
+#define V4L2_CID_FM_RX_CLASS			(V4L2_CTRL_CLASS_FM_RX | 1)
+
+#define V4L2_CID_TUNE_DEEMPHASIS		(V4L2_CID_FM_RX_CLASS_BASE + 1)
+#define V4L2_CID_RDS_RECEPTION			(V4L2_CID_FM_RX_CLASS_BASE + 2)
+
 #endif
-- 
1.7.10.4

