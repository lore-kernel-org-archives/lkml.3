Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab3HNQRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:17:46 -0400
Received: from mx.mmd.net ([80.83.0.3]:57314 "EHLO mx.mmd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759999Ab3HNQRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:17:42 -0400
From: tuukka.tikkanen@linaro.org
To: rjw@sisk.pl, daniel.lezcano@linaro.org, linux-pm@vger.kernel.org
Cc: private-pmwg@linaro.org, linux-kernel@vger.kernel.org,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
Subject: [PATCH 7/8] Cpuidle: Add a comment warning about possible overflow
Date: Wed, 14 Aug 2013 19:02:40 +0300
Message-Id: <d1fb1c549383befe9e1376d59c0d2ecde8e4ed7c.1376493949.git.tuukka.tikkanen@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1376487596.git.tuukka.tikkanen@linaro.org>
References: <cover.1376487596.git.tuukka.tikkanen@linaro.org>
In-Reply-To: <cover.1376493949.git.tuukka.tikkanen@linaro.org>
References: <cover.1376493949.git.tuukka.tikkanen@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>

The menu governor has a number of tunable constants that may be changed
in the source. If certain combination of values are chosen, an overflow
is possible when the correction_factor is being recalculated.

This patch adds a warning regarding this possibility and describes the
change needed for fixing the issue. The change should not be permanently
enabled, as it will hurt performance when it is not needed.

Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
---
 drivers/cpuidle/governors/menu.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 96fd10d..f277c13 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -21,6 +21,15 @@
 #include <linux/math64.h>
 #include <linux/module.h>
 
+/*
+ * Please note when changing the tuning values:
+ * If (MAX_INTERESTING-1) * RESOLUTION > ULONG_MAX, the result of
+ * a scaling operation multiplication may overflow on 32 bit platforms.
+ * In that case, #define RESOLUTION as ULL to get 64 bit result:
+ * #define RESOLUTION 1024ULL
+ *
+ * The default values do not overflow.
+ */
 #define BUCKETS 12
 #define INTERVALS 8
 #define RESOLUTION 1024
-- 
1.7.9.5

