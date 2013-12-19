Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab3LSMD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:03:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45403 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab3LSMAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:00:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Pizunski <linus@narrativeteam.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 200/208] drivers/rtc/rtc-at91rm9200.c: correct alarm over day/month wrap
Date: Thu, 19 Dec 2013 11:54:58 +0000
Message-Id: <1387454106-19326-201-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Pizunski <linus@narrativeteam.com>

commit eb3c227289840eed95ddfb0516046f08d8993940 upstream.

Update month and day of month to the alarm month/day instead of current
day/month when setting the RTC alarm mask.

Signed-off-by: Linus Pizunski <linus@narrativeteam.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/rtc/rtc-at91rm9200.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 7418926..b86eec3 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -220,6 +220,8 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	at91_alarm_year = tm.tm_year;
 
+	tm.tm_mon = alrm->time.tm_mon;
+	tm.tm_mday = alrm->time.tm_mday;
 	tm.tm_hour = alrm->time.tm_hour;
 	tm.tm_min = alrm->time.tm_min;
 	tm.tm_sec = alrm->time.tm_sec;
-- 
1.8.3.2

