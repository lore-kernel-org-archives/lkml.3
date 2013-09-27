Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117Ab3I0E6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 00:58:05 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49285 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3I0E6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 00:58:04 -0400
X-AuditID: 9c930197-b7b7aae000005bd9-dc-524510593df5
From: Chanho Min <chanho.min@lge.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: HyoJun Im <hyojun.im@lge.com>, Chanho Min <chanho.min@lge.com>
Subject: [PATCH] [media] uvcvideo: fix data type for pan/tilt control
Date: Fri, 27 Sep 2013 13:57:40 +0900
Message-Id: <1380257860-14075-1-git-send-email-chanho.min@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pan/tilt absolute control value is signed value. If minimum value
is minus, It will be changed to plus by clamp_t() as commit 64ae9958a62.
([media] uvcvideo: Fix control value clamping for unsigned integer controls).

It leads to wrong setting of the control values. For example,
when min and max are -36000 and 36000, the setting value between of this range
is always 36000. So, Its data type should be changed to signed.

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index a2f4501..0eb82106 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -664,7 +664,7 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.size		= 32,
 		.offset		= 0,
 		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
-		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
+		.data_type	= UVC_CTRL_DATA_TYPE_SIGNED,
 	},
 	{
 		.id		= V4L2_CID_TILT_ABSOLUTE,
@@ -674,7 +674,7 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.size		= 32,
 		.offset		= 32,
 		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
-		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
+		.data_type	= UVC_CTRL_DATA_TYPE_SIGNED,
 	},
 	{
 		.id		= V4L2_CID_PRIVACY,
-- 
1.7.9.5

