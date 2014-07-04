Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbaGDBXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 21:23:16 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57016 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaGDBXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 21:23:15 -0400
X-Original-SENDERIP: 165.186.175.61
X-Original-MAILFROM: hyogi.gim@lge.com
From: Hyogi Gim <hyogi.gim@lge.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Hyogi Gim <hyogi.gim@lge.com>
Subject: [PATCH] drivers/rtc/interface.c: check the error after __rtc_read_time()
Date: Fri,  4 Jul 2014 10:22:26 +0900
Message-Id: <1404436946-28354-1-git-send-email-hyogi.gim@lge.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __rtc_set_alarm(), the error after __rtc_read_time() is not checked.
If rtc device fail to read time, we cannot guarantee the following process.

Add the verification code for returned __rtc_read_time() error.

Signed-off-by: Hyogi Gim <hyogi.gim@lge.com>
---
 drivers/rtc/interface.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 5813fa5..5b2717f 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -348,6 +348,8 @@ static int __rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 
 	/* Make sure we're not setting alarms in the past */
 	err = __rtc_read_time(rtc, &tm);
+	if (err)
+		return err;
 	rtc_tm_to_time(&tm, &now);
 	if (scheduled <= now)
 		return -ETIME;
-- 
1.8.3.2

