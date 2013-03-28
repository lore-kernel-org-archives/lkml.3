Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab3C1Qna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:43:30 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:38553 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab3C1Qn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:43:28 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] power: rx51_battery: Fix reporting temperature
Date: Thu, 28 Mar 2013 17:42:23 +0100
Message-Id: <1364488943-6481-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130216213248.GC1741@lizard.sbx05280.losalca.wayport.net>
References: <20130216213248.GC1741@lizard.sbx05280.losalca.wayport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixing units (1/10 °C) in which is temperature reported.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/power/rx51_battery.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/rx51_battery.c b/drivers/power/rx51_battery.c
index 8208888..527d256 100644
--- a/drivers/power/rx51_battery.c
+++ b/drivers/power/rx51_battery.c
@@ -119,7 +119,7 @@ static int rx51_battery_read_temperature(struct rx51_device_info *di)
 
 	/* First check for temperature in first direct table */
 	if (raw < ARRAY_SIZE(rx51_temp_table1))
-		return rx51_temp_table1[raw] * 100;
+		return rx51_temp_table1[raw] * 10;
 
 	/* Binary search RAW value in second inverse table */
 	while (max - min > 1) {
@@ -132,7 +132,7 @@ static int rx51_battery_read_temperature(struct rx51_device_info *di)
 			break;
 	}
 
-	return (rx51_temp_table2_first - min) * 100;
+	return (rx51_temp_table2_first - min) * 10;
 }
 
 /*
-- 
1.7.10.4

