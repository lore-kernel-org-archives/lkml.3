Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbaEPKv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:51:58 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39399 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034AbaEPKv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:51:56 -0400
From: Chander Kashyap <chander.kashyap@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: nm@ti.com, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Subject: [PATCH] PM / OPP: fix incorrect OPP count handling in of_init_opp_table
Date: Fri, 16 May 2014 16:21:17 +0530
Message-Id: <1400237477-24831-1-git-send-email-chander.kashyap@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In of_init_opp_table function, if a failure to add an OPP is
detected, the count of OPPs, yet to be added is not updated.
Fix this by decrementing this count on failure as well.

Signed-off-by: Chander Kashyap <k.chander@samsung.com>
Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
---
 drivers/base/power/opp.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index d9e376a..faae9cf 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -643,11 +643,9 @@ int of_init_opp_table(struct device *dev)
 		unsigned long freq = be32_to_cpup(val++) * 1000;
 		unsigned long volt = be32_to_cpup(val++);
 
-		if (dev_pm_opp_add(dev, freq, volt)) {
+		if (dev_pm_opp_add(dev, freq, volt))
 			dev_warn(dev, "%s: Failed to add OPP %ld\n",
 				 __func__, freq);
-			continue;
-		}
 		nr -= 2;
 	}
 
-- 
1.7.9.5

