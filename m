Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab3BAHHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 02:07:53 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:44407 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3BAHHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 02:07:49 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, fabio.porcedda@gmail.com,
        JM.Lin@atmel.com, wenyou.yang@atmel.com, wim@iguana.be,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/8] watchdog: add the function watchdog_is_open
Date: Fri,  1 Feb 2013 15:06:19 +0800
Message-Id: <1359702386-21284-2-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359702386-21284-1-git-send-email-wenyou.yang@atmel.com>
References: <1359702386-21284-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 01 Feb 2013 07:07:21.0216 (UTC) FILETIME=[C7555000:01CE004A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the function watchdog_is_open to check whether or not
the /dev/watchdog? is opened

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/watchdog.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index e40cc2b..7ea4465 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -111,6 +111,14 @@ static inline bool watchdog_active(struct watchdog_device *wdd)
 	return test_bit(WDOG_ACTIVE, &wdd->status);
 }
 
+/* Use the following function to check whether or not
+ * the /dev/watchdog? is opened
+ */
+static inline bool watchdog_is_open(struct watchdog_device *wddev)
+{
+	return test_bit(WDOG_DEV_OPEN, &wddev->status);
+}
+
 /* Use the following function to set the nowayout feature */
 static inline void watchdog_set_nowayout(struct watchdog_device *wdd, bool nowayout)
 {
-- 
1.7.9.5

