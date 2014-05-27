Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaE0MH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 08:07:58 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36967 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbaE0MHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 08:07:53 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        edubezval@gmail.com, pavel@ucw.cz, lgirdwood@gmail.com,
        broonie@kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] regulators: Add definition of regulator_set_voltage_time() for !CONFIG_REGULATOR
Date: Tue, 27 May 2014 17:37:29 +0530
Message-Id: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have dummy implementation for most of the regulators APIs for
!CONFIG_REGULATOR case and were missing it for regulator_set_voltage_time().

Found this issue while compiling cpufreq-cpu0 driver without regulators support
in kernel.

drivers/cpufreq/cpufreq-cpu0.c: In function ‘cpu0_cpufreq_probe’:
drivers/cpufreq/cpufreq-cpu0.c:186:3: error: implicit declaration of function ‘regulator_set_voltage_time’ [-Werror=implicit-function-declaration]

Fix this by adding dummy definition for regulator_set_voltage_time().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Liam/Broonie: Please see if this can go through Rafael as 2nd patch is dependent
on it.

 include/linux/regulator/consumer.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 1a4a8c1..0cfc286 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -397,6 +397,12 @@ static inline int regulator_set_voltage(struct regulator *regulator,
 	return 0;
 }
 
+static inline int regulator_set_voltage_time(struct regulator *regulator,
+					     int old_uV, int new_uV)
+{
+	return 0;
+}
+
 static inline int regulator_get_voltage(struct regulator *regulator)
 {
 	return -EINVAL;
-- 
2.0.0.rc2

