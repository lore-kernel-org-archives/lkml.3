Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab3BOW6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:58:10 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:56930 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab3BOW6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:58:07 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 2/2] power: rx51_battery: Fix reporting correct values
Date: Fri, 15 Feb 2013 23:56:50 +0100
Message-Id: <1360969010-8571-2-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360969010-8571-1-git-send-email-pali.rohar@gmail.com>
References: <1360969010-8571-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tell twl4030_madc_conversion that this driver needs raw values.
Driver twl4030_madc has some hardcoded values and conversation
functions which are incorrect for Nokia RX-51 board. This driver
rx51_battery expects raw values which convert itself.

This patch fixing values reported by power supply interface.
Before this patch driver reported always incorrect values on
3.8 kernel (sometimes design capacity was negative).

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/power/rx51_battery.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/rx51_battery.c b/drivers/power/rx51_battery.c
index 527d256..d1e17b0 100644
--- a/drivers/power/rx51_battery.c
+++ b/drivers/power/rx51_battery.c
@@ -42,6 +42,7 @@ static int rx51_battery_read_adc(int channel)
 	req.method = TWL4030_MADC_SW1;
 	req.func_cb = NULL;
 	req.type = TWL4030_MADC_WAIT;
+	req.raw = true;
 
 	if (twl4030_madc_conversion(&req) <= 0)
 		return -ENODATA;
-- 
1.7.10.4

