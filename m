Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaEHHDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:03:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbaEHHDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:03:34 -0400
From: Ales Novak <alnovak@suse.cz>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, John Stultz <john.stultz@linaro.org>,
        Ales Novak <alnovak@suse.cz>
Subject: [PATCH] drivers/rtc/interface.c: fix for fix of alarm initialization
Date: Thu,  8 May 2014 07:56:15 +0200
Message-Id: <1399528575-32195-1-git-send-email-alnovak@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396911282-4410-1-git-send-email-alnovak@suse.cz>
References: <1396911282-4410-1-git-send-email-alnovak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems the previous patch "fix infinite loop in initializing the alarm"
did break the infinite loop in alarm initialization, but not in the right
way. The loop indeed should walk through the not-leap years and stop on
the leap one.

This patch does apply on top of the previous one.

Signed-off-by: Ales Novak <alnovak@suse.cz>
---
Fix for patch drivers-rtc-interfacec-fix-infinite-loop-in-initializing-the-alarm

 drivers/rtc/interface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index a2df283..bd6314a 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -292,8 +292,7 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "year");
 		do {
 			alarm->time.tm_year++;
-		} while (alarm->time.tm_mon == 1
-			&& is_leap_year(alarm->time.tm_year + 1900)
+		} while (!is_leap_year(alarm->time.tm_year + 1900)
 			&& rtc_valid_tm(&alarm->time) != 0);
 		break;
 
-- 
1.8.1.4

