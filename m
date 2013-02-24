Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab3BXRJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 12:09:59 -0500
Received: from avas-mr14.fibertel.com.ar ([24.232.0.245]:55542 "EHLO
	avas-mr14.fibertel.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758625Ab3BXRJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 12:09:58 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Feb 2013 12:09:58 EST
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
To: rjw@sisk.pl, shawn.guo@linaro.org, mark.langsdorf@calxeda.com
Cc: <linux-arm-kernel@lists.infradead.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
Subject: [PATCH] cpufreq: highbank: do not initialize array with a loop
Date: Sun, 24 Feb 2013 14:01:17 -0300
Message-Id: <1361725277-5125-1-git-send-email-emilio@elopez.com.ar>
X-Mailer: git-send-email 1.8.2.rc0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Fib-Al-Info: Al
X-Fib-Al-MRId: 2213ec4be6a97ec6a50fde3c87c48f80
X-Fib-Al: noav
X-Fib-Al-SA: analyzed
X-Fib-Al-From: emilio@elopez.com.ar
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As uninitialized array members will be initialized to zero, we can
avoid using a for loop by setting a value to it.

Signed-off-by: Emilio López <emilio@elopez.com.ar>
---
Note that I don't own any device using this driver, it has only been compile
tested, but it shouldn't cause any issues.

 drivers/cpufreq/highbank-cpufreq.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
index 66e3a71..30d4ae1 100644
--- a/drivers/cpufreq/highbank-cpufreq.c
+++ b/drivers/cpufreq/highbank-cpufreq.c
@@ -28,13 +28,9 @@
 
 static int hb_voltage_change(unsigned int freq)
 {
-	int i;
-	u32 msg[HB_CPUFREQ_IPC_LEN];
+	u32 msg[HB_CPUFREQ_IPC_LEN] = {HB_CPUFREQ_CHANGE_NOTE};
 
-	msg[0] = HB_CPUFREQ_CHANGE_NOTE;
 	msg[1] = freq / 1000000;
-	for (i = 2; i < HB_CPUFREQ_IPC_LEN; i++)
-		msg[i] = 0;
 
 	return pl320_ipc_transmit(msg);
 }
-- 
1.8.2.rc0

