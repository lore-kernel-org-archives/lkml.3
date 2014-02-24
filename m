Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaBXINH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:13:07 -0500
Received: from mx.mmd.net ([80.83.0.3]:55414 "EHLO mx.mmd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbaBXIND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:13:03 -0500
From: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
To: linux-pm@vger.kernel.org, rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, tuukka.tikkanen@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] Cpuidle: poll state can measure residency
Date: Mon, 24 Feb 2014 08:29:37 +0200
Message-Id: <1393223377-5744-8-git-send-email-tuukka.tikkanen@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org>
References: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some platforms, a poll state is inserted in the cpuidle driver states.
The flags for the state do not indicate that timekeeping is not affected.
As the state does not do anything apart from calling cpu_relax(), the
times returned by ktime_get should remain valid. Add the missing flag.

Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
---
 drivers/cpuidle/driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index 06dbe7c..136d6a2 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -209,7 +209,7 @@ static void poll_idle_init(struct cpuidle_driver *drv)
 	state->exit_latency = 0;
 	state->target_residency = 0;
 	state->power_usage = -1;
-	state->flags = 0;
+	state->flags = CPUIDLE_FLAG_TIME_VALID;
 	state->enter = poll_idle;
 	state->disabled = false;
 }
-- 
1.7.9.5

