Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbaA1G4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 01:56:13 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:48188 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaA1G4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 01:56:11 -0500
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Daniel Jeong <gshark.jeong@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>
Subject: [RFCv2,1/2] v4l2-controls.h: add addtional Flash fault bits 
Date: Tue, 28 Jan 2014 15:55:57 +0900
Message-Id: <1390892158-5646-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add additional FLASH Fault bits to dectect faults from chip.
Some Flash drivers support UVLO, IVFM, NTC Trip faults.
UVLO : 	Under Voltage Lock Out Threshold crossed
IVFM : 	IVFM block reported and/or adjusted LED current Input Voltage Flash Monitor trip threshold
NTC  : 	NTC Threshold crossed. Many Flash drivers have a pin and the fault bit to 
serves as a threshold detector for negative temperature coefficient (NTC) thermistors.

Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
---
 include/uapi/linux/v4l2-controls.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 1666aab..01d730c 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -803,6 +803,9 @@ enum v4l2_flash_strobe_source {
 #define V4L2_FLASH_FAULT_SHORT_CIRCUIT		(1 << 3)
 #define V4L2_FLASH_FAULT_OVER_CURRENT		(1 << 4)
 #define V4L2_FLASH_FAULT_INDICATOR		(1 << 5)
+#define V4L2_FLASH_FAULT_UVLO			(1 << 6)
+#define V4L2_FLASH_FAULT_IVFM			(1 << 7)
+#define V4L2_FLASH_FAULT_NTC_TRIP		(1 << 8)
 
 #define V4L2_CID_FLASH_CHARGE			(V4L2_CID_FLASH_CLASS_BASE + 11)
 #define V4L2_CID_FLASH_READY			(V4L2_CID_FLASH_CLASS_BASE + 12)
-- 
1.7.9.5

