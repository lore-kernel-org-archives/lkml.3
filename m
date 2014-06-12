Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbaFLKDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:03:00 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46957 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932885AbaFLKC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:02:58 -0400
From: pramod.gurav.etc@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>, trivial@kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Marcus Gelderie <redmnic@gmail.com>,
        Pramod Gurav <pramod.gurav.etc@gmail.com>
Subject: [PATCH] alarmtimer: Export symbols of alarmtimer_get_rtcdev
Date: Thu, 12 Jun 2014 15:36:02 +0530
Message-Id: <1402567562-10634-1-git-send-email-pramod.gurav.etc@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pramod Gurav <pramod.gurav@smartplayin.com>

Export symbol of alarmtimer_get_rtcdev so that it is used by
any driver when built as module like,
drivers/staging/android/alarm-dev.c
This Export was missing in Marcus's below patch:

https://lkml.org/lkml/2013/6/1/144

CC: trivial@kernel.org
CC: John Stultz <john.stultz@linaro.org>
CC: Marcus Gelderie <redmnic@gmail.com>
Signed-off-by: Pramod Gurav <pramod.gurav.etc@gmail.com>
---
 kernel/time/alarmtimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 88c9c65..a53ba0b 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -71,7 +71,7 @@ struct rtc_device *alarmtimer_get_rtcdev(void)
 
 	return ret;
 }
-
+EXPORT_SYMBOL_GPL(alarmtimer_get_rtcdev);
 
 static int alarmtimer_rtc_add_device(struct device *dev,
 				struct class_interface *class_intf)
-- 
1.7.9.5

