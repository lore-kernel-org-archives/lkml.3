Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab3IVBVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 21:21:45 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48899 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3IVBVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 21:21:42 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 03/21] cpuidle: make __cpuidle_get_cpu_driver() inline
Date: Sun, 22 Sep 2013 06:50:55 +0530
Message-Id: <0868fef3eca7cc04dc879da73f06e29e322c695b.1379779777.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__cpuidle_get_cpu_driver() is a single line function and so deserves to be
marked inline.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpuidle/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index ced1df6..25455e8 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -29,7 +29,7 @@ static DEFINE_PER_CPU(struct cpuidle_driver *, cpuidle_drivers);
  * Returns a pointer to struct cpuidle_driver or NULL if no driver has been
  * registered for @cpu.
  */
-static struct cpuidle_driver *__cpuidle_get_cpu_driver(int cpu)
+static inline struct cpuidle_driver *__cpuidle_get_cpu_driver(int cpu)
 {
 	return per_cpu(cpuidle_drivers, cpu);
 }
-- 
1.7.12.rc2.18.g61b472e

