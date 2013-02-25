Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263Ab3BYLKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 06:10:08 -0500
Received: from avas-mr15.fibertel.com.ar ([24.232.0.247]:42213 "EHLO
	avas-mr15.fibertel.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3BYLKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 06:10:06 -0500
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
To: viresh.kumar@linaro.org, rjw@sisk.pl, shawn.guo@linaro.org,
        mark.langsdorf@calxeda.com
Cc: <linux-arm-kernel@lists.infradead.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
Subject: [PATCH v2] cpufreq: highbank: do not initialize array with a loop
Date: Mon, 25 Feb 2013 08:07:45 -0300
Message-Id: <1361790465-21760-1-git-send-email-emilio@elopez.com.ar>
X-Mailer: git-send-email 1.8.2.rc0
In-Reply-To: <1361725277-5125-1-git-send-email-emilio@elopez.com.ar>
References: <1361725277-5125-1-git-send-email-emilio@elopez.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Fib-Al-Info: Al
X-Fib-Al-MRId: de21b67557e51d44daf518eab26006de
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

Changes v1 -> v2:
  * Move freq / 1000000 to the array definition as suggested by Viresh Kumar

 drivers/cpufreq/highbank-cpufreq.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
index 66e3a71..b61b5a3 100644
--- a/drivers/cpufreq/highbank-cpufreq.c
+++ b/drivers/cpufreq/highbank-cpufreq.c
@@ -28,13 +28,7 @@
 
 static int hb_voltage_change(unsigned int freq)
 {
-	int i;
-	u32 msg[HB_CPUFREQ_IPC_LEN];
-
-	msg[0] = HB_CPUFREQ_CHANGE_NOTE;
-	msg[1] = freq / 1000000;
-	for (i = 2; i < HB_CPUFREQ_IPC_LEN; i++)
-		msg[i] = 0;
+	u32 msg[HB_CPUFREQ_IPC_LEN] = {HB_CPUFREQ_CHANGE_NOTE, freq / 1000000};
 
 	return pl320_ipc_transmit(msg);
 }
-- 
1.8.2.rc0

