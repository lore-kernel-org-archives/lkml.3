Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaFBH3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:29:42 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:36136 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaFBH3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:29:40 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        edubezval@gmail.com, pavel@ucw.cz, lgirdwood@gmail.com,
        broonie@kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 1/3] regulator: return -EINVAL from regulator_set_voltage() for !CONFIG_REGULATOR
Date: Mon,  2 Jun 2014 12:59:23 +0530
Message-Id: <788accde56086078d69d3eba0d913114315de43a.1401693980.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently regulator_set_voltage() returns zero when support for regulators isn't
present in kernel, i.e. CONFIG_REGULATOR=n.

Make it return -EINVAL to propagate error instead of success here.
Audit of all users of this routine is done to make sure nothing breaks due to
this change.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V1->V2: - New patch as suggested by Mark.

 include/linux/regulator/consumer.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 1a4a8c1..28fa089 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -394,7 +394,7 @@ static inline void regulator_bulk_free(int num_consumers,
 static inline int regulator_set_voltage(struct regulator *regulator,
 					int min_uV, int max_uV)
 {
-	return 0;
+	return -EINVAL;
 }
 
 static inline int regulator_get_voltage(struct regulator *regulator)
-- 
2.0.0.rc2

