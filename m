Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099AbaGCKRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:17:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51522 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274AbaGCJV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 027/198] PM / OPP: fix incorrect OPP count handling in of_init_opp_table
Date: Thu,  3 Jul 2014 10:17:50 +0100
Message-Id: <1404379241-8590-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chander Kashyap <chander.kashyap@linaro.org>

commit 086abb58590a4df73e8a6ed71fd418826937cd46 upstream.

In of_init_opp_table function, if a failure to add an OPP is
detected, the count of OPPs, yet to be added is not updated.
Fix this by decrementing this count on failure as well.

Signed-off-by: Chander Kashyap <k.chander@samsung.com>
Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/base/power/opp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index c8ec186303db..a5d4de1b9d42 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -731,11 +731,9 @@ int of_init_opp_table(struct device *dev)
 		unsigned long freq = be32_to_cpup(val++) * 1000;
 		unsigned long volt = be32_to_cpup(val++);
 
-		if (opp_add(dev, freq, volt)) {
+		if (opp_add(dev, freq, volt))
 			dev_warn(dev, "%s: Failed to add OPP %ld\n",
 				 __func__, freq);
-			continue;
-		}
 		nr -= 2;
 	}
 
-- 
1.9.1

