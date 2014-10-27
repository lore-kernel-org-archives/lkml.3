Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaJ0OS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:18:58 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:47543 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbaJ0ORR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:17:17 -0400
From: Jan Kardell <jan.kardell@telliq.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 3/6] rtc: pcf8563 Fix wrong time from read_alarm
Date: Mon, 27 Oct 2014 15:16:58 +0100
Message-Id: <1414419421-11098-4-git-send-email-jan.kardell@telliq.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414419421-11098-1-git-send-email-jan.kardell@telliq.com>
References: <1414419421-11098-1-git-send-email-jan.kardell@telliq.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Incorrect mask was used for hour and monthday fields.

Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
---
 drivers/rtc/rtc-pcf8563.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 8c23606..78f76d9 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -336,8 +336,8 @@ static int pcf8563_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *tm)
 		__func__, buf[0], buf[1], buf[2], buf[3]);
 
 	tm->time.tm_min = bcd2bin(buf[0] & 0x7F);
-	tm->time.tm_hour = bcd2bin(buf[1] & 0x7F);
-	tm->time.tm_mday = bcd2bin(buf[2] & 0x1F);
+	tm->time.tm_hour = bcd2bin(buf[1] & 0x3F);
+	tm->time.tm_mday = bcd2bin(buf[2] & 0x3F);
 	tm->time.tm_wday = bcd2bin(buf[3] & 0x7);
 	tm->time.tm_mon = -1;
 	tm->time.tm_year = -1;
-- 
1.8.4.5

