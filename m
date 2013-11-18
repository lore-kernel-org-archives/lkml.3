Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3KRRVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 12:21:08 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:57894 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3KRRU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 12:20:57 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linus@narrativeteam.com>, Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtc: rtc-at91rm9200: Corrected alarm over day/month wrap:
Date: Mon, 18 Nov 2013 18:20:54 +0100
Message-ID: <1384795254-11996-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Pizunski <linus@narrativeteam.com>

Update month and day of month to the alarm month/day instead
of current day/month when setting the RTC alarm mask.

Signed-off-by: Linus Pizunski <linus@narrativeteam.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/rtc/rtc-at91rm9200.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 8b2cd8a5a2ff..0dc0809adbf2 100644
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
1.8.2.2

