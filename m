Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab3AOM5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:57:15 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:54925 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848Ab3AOM5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:57:09 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 25/26] mfd: ab8500-gpadc: Reduce conversion timeout
Date: Tue, 15 Jan 2013 12:56:05 +0000
Message-Id: <1358254566-12419-26-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Reduce the conversion timeout from 2s to 0.5s

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
---
 drivers/mfd/ab8500-gpadc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 1fd8f78..a7a6c77 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -86,6 +86,8 @@
 /* Time in ms before disabling regulator */
 #define GPADC_AUDOSUSPEND_DELAY		1
 
+#define CONVERSION_TIME			500 /* ms */
+
 enum cal_channels {
 	ADC_INPUT_VMAIN = 0,
 	ADC_INPUT_BTEMP,
@@ -372,7 +374,8 @@ int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel)
 		goto out;
 	}
 	/* wait for completion of conversion */
-	if (!wait_for_completion_timeout(&gpadc->ab8500_gpadc_complete, 2*HZ)) {
+	if (!wait_for_completion_timeout(&gpadc->ab8500_gpadc_complete,
+					 msecs_to_jiffies(CONVERSION_TIME))) {
 		dev_err(gpadc->dev,
 			"timeout: didn't receive GPADC conversion interrupt\n");
 		ret = -EINVAL;
@@ -598,8 +601,6 @@ static int ab8500_gpadc_runtime_resume(struct device *dev)
 
 static int ab8500_gpadc_runtime_idle(struct device *dev)
 {
-	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
-
 	pm_runtime_suspend(dev);
 	return 0;
 }
-- 
1.7.9.5

