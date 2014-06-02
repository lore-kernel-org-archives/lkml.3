Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaFBH3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:29:50 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:50310 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaFBH3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:29:47 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        edubezval@gmail.com, pavel@ucw.cz, lgirdwood@gmail.com,
        broonie@kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 2/3] regulators: Add definition of regulator_set_voltage_time() for !CONFIG_REGULATOR
Date: Mon,  2 Jun 2014 12:59:24 +0530
Message-Id: <bc48fa7971f874d77a304e86a72ff5cee6f29e7c.1401693980.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <788accde56086078d69d3eba0d913114315de43a.1401693980.git.viresh.kumar@linaro.org>
References: <788accde56086078d69d3eba0d913114315de43a.1401693980.git.viresh.kumar@linaro.org>
In-Reply-To: <788accde56086078d69d3eba0d913114315de43a.1401693980.git.viresh.kumar@linaro.org>
References: <788accde56086078d69d3eba0d913114315de43a.1401693980.git.viresh.kumar@linaro.org>
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
V1->V2: return -EINVAL instead of zero.

 include/linux/regulator/consumer.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 28fa089..7563f8b 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -397,6 +397,12 @@ static inline int regulator_set_voltage(struct regulator *regulator,
 	return -EINVAL;
 }
 
+static inline int regulator_set_voltage_time(struct regulator *regulator,
+					     int old_uV, int new_uV)
+{
+	return -EINVAL;
+}
+
 static inline int regulator_get_voltage(struct regulator *regulator)
 {
 	return -EINVAL;
-- 
2.0.0.rc2

