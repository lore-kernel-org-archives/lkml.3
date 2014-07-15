Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680AbaGOVwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:52:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54899 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000AbaGOVih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 036/198] PM / OPP: fix incorrect OPP count handling in of_init_opp_table
Date: Tue, 15 Jul 2014 14:28:26 -0700
Message-Id: <1405459868-15089-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/base/power/opp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index fa41874..08d99ef 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -735,11 +735,9 @@ int of_init_opp_table(struct device *dev)
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
1.9.1

