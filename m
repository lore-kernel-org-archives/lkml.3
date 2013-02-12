Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756Ab3BSRbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:31:10 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:53226 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758663Ab3BSRbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:31:08 -0500
From: Pawel Wieczorkiewicz <wpawel@gmail.com>
To: a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Pawel Wieczorkiewicz <wpawel@gmail.com>
Subject: [PATCH 1/1] rtc-proc: replace "rtcN" name creation with dev_name() call
Date: Tue, 12 Feb 2013 18:57:52 +0100
Message-Id: <1360691872-2848-1-git-send-email-wpawel@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pawel Wieczorkiewicz <wpawel@gmail.com>

Instead of creating rtc device name basing on rtc->id in
local array, make use of existing one using dev_name() call
to compare against CONFIG_RTC_HCTOSYS_DEVICE.

Signed-off-by: Pawel Wieczorkiewicz <wpawel@gmail.com>
---
 drivers/rtc/rtc-proc.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-proc.c b/drivers/rtc/rtc-proc.c
index e96236a..473d017 100644
--- a/drivers/rtc/rtc-proc.c
+++ b/drivers/rtc/rtc-proc.c
@@ -18,22 +18,13 @@
 
 #include "rtc-core.h"
 
-#define NAME_SIZE	10
-
 #if defined(CONFIG_RTC_HCTOSYS_DEVICE)
-static bool is_rtc_hctosys(struct rtc_device *rtc)
+static inline bool is_rtc_hctosys(struct rtc_device *rtc)
 {
-	int size;
-	char name[NAME_SIZE];
-
-	size = scnprintf(name, NAME_SIZE, "rtc%d", rtc->id);
-	if (size > NAME_SIZE)
-		return false;
-
-	return !strncmp(name, CONFIG_RTC_HCTOSYS_DEVICE, NAME_SIZE);
+	return !strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE);
 }
 #else
-static bool is_rtc_hctosys(struct rtc_device *rtc)
+static inline bool is_rtc_hctosys(struct rtc_device *rtc)
 {
 	return (rtc->id == 0);
 }
-- 
1.7.9.5

