Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927AbaGVWzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:55:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44390 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269AbaGVWWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:22:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 020/116] PM / OPP: fix incorrect OPP count handling in of_init_opp_table
Date: Tue, 22 Jul 2014 15:20:31 -0700
Message-Id: <1406067727-19683-21-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/base/power/opp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 50b2831..7461649 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -728,11 +728,9 @@ int of_init_opp_table(struct device *dev)
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

