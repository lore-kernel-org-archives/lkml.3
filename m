Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab3HNQTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:19:31 -0400
Received: from mx.mmd.net ([80.83.0.3]:57316 "EHLO mx.mmd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760038Ab3HNQRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:17:44 -0400
From: tuukka.tikkanen@linaro.org
To: rjw@sisk.pl, daniel.lezcano@linaro.org, linux-pm@vger.kernel.org
Cc: private-pmwg@linaro.org, linux-kernel@vger.kernel.org,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
Subject: [PATCH 4/8] Cpuidle: CodingStyle: Break up multiple assignments on single line
Date: Wed, 14 Aug 2013 19:02:37 +0300
Message-Id: <3708965718cc4397b9364dab26161192828c7a1e.1376493949.git.tuukka.tikkanen@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1376487596.git.tuukka.tikkanen@linaro.org>
References: <cover.1376487596.git.tuukka.tikkanen@linaro.org>
In-Reply-To: <cover.1376493949.git.tuukka.tikkanen@linaro.org>
References: <cover.1376493949.git.tuukka.tikkanen@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>

The function get_typical_interval() initializes a number of variables
that are immediately after declarations assigned constant values.
In addition, there are multiple assignments on a single line, which
is explicitly forbidden by Documentation/CodingStyle.

This patch removes redundant initial values for the variables and
breaks up the multiple assignment line.

Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
---
 drivers/cpuidle/governors/menu.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index c24b10b..fe2dd04 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -199,14 +199,17 @@ static u64 div_round64(u64 dividend, u32 divisor)
  */
 static void get_typical_interval(struct menu_device *data)
 {
-	int i = 0, divisor = 0;
-	uint64_t max = 0, avg = 0, stddev = 0;
+	int i, divisor;
+	uint64_t max, avg, stddev;
 	int64_t thresh = LLONG_MAX; /* Discard outliers above this value. */
 
 again:
 
 	/* first calculate average and standard deviation of the past */
-	max = avg = divisor = stddev = 0;
+	max = 0;
+	avg = 0;
+	divisor = 0;
+	stddev = 0;
 	for (i = 0; i < INTERVALS; i++) {
 		int64_t value = data->intervals[i];
 		if (value <= thresh) {
-- 
1.7.9.5

