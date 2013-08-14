Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab3HNQSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:18:50 -0400
Received: from mx.mmd.net ([80.83.0.3]:57318 "EHLO mx.mmd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760042Ab3HNQRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:17:44 -0400
From: tuukka.tikkanen@linaro.org
To: rjw@sisk.pl, daniel.lezcano@linaro.org, linux-pm@vger.kernel.org
Cc: private-pmwg@linaro.org, linux-kernel@vger.kernel.org,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
Subject: [PATCH 2/8] Cpuidle: Rearrange code and comments in get_typical_interval()
Date: Wed, 14 Aug 2013 19:02:35 +0300
Message-Id: <859fb6805a5d7364c179be3b9180a58b7d8a51e0.1376493949.git.tuukka.tikkanen@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1376487596.git.tuukka.tikkanen@linaro.org>
References: <cover.1376487596.git.tuukka.tikkanen@linaro.org>
In-Reply-To: <cover.1376493949.git.tuukka.tikkanen@linaro.org>
References: <cover.1376493949.git.tuukka.tikkanen@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>

This patch rearranges a if-return-elsif-goto-fi-return sequence into
if-return-fi-if-return-fi-goto sequence. The functionality remains the
same. Also, a lengthy comment that did not describe the functionality
in the order it occurs is split into half and top half is moved closer
to actual implementation it describes.

Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
---
 drivers/cpuidle/governors/menu.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index c8ab1c5..b13d57c 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -228,14 +228,6 @@ again:
 	do_div(stddev, divisor);
 	stddev = int_sqrt(stddev);
 	/*
-	 * If we have outliers to the upside in our distribution, discard
-	 * those by setting the threshold to exclude these outliers, then
-	 * calculate the average and standard deviation again. Once we get
-	 * down to the bottom 3/4 of our samples, stop excluding samples.
-	 *
-	 * This can deal with workloads that have long pauses interspersed
-	 * with sporadic activity with a bunch of short pauses.
-	 *
 	 * The typical interval is obtained when standard deviation is small
 	 * or standard deviation is small compared to the average interval.
 	 *
@@ -246,12 +238,22 @@ again:
 		if (data->expected_us > avg)
 			data->predicted_us = avg;
 		return;
-
-	} else if ((divisor * 4) > INTERVALS * 3) {
-		/* Exclude the max interval */
-		thresh = max - 1;
-		goto again;
 	}
+
+	/*
+	 * If we have outliers to the upside in our distribution, discard
+	 * those by setting the threshold to exclude these outliers, then
+	 * calculate the average and standard deviation again. Once we get
+	 * down to the bottom 3/4 of our samples, stop excluding samples.
+	 *
+	 * This can deal with workloads that have long pauses interspersed
+	 * with sporadic activity with a bunch of short pauses.
+	 */
+	if ((divisor * 4) <= INTERVALS * 3)
+		return;
+
+	thresh = max - 1;
+	goto again;
 }
 
 /**
-- 
1.7.9.5

