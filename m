Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaH2Mzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 08:55:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:37587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbaH2Mzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 08:55:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,424,1406617200"; 
   d="scan'208";a="565353884"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] powercap/rapl: lower warning level for domain detection
Date: Thu, 28 Aug 2014 21:56:08 -0700
Message-Id: <1409288168-6537-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.0.0.5.gbce14aa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many CPUs do not support complete set of RAPL domains, as a
result this detection failed message is very misleading and
annoying. So lower the warning message to info and reword.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/powercap/intel_rapl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
index b1cda6f..0b282e7 100644
--- a/drivers/powercap/intel_rapl.c
+++ b/drivers/powercap/intel_rapl.c
@@ -1169,7 +1169,7 @@ static int rapl_detect_domains(struct rapl_package *rp, int cpu)
 		if (!rapl_check_domain(cpu, i))
 			rp->domain_map |= 1 << i;
 		else
-			pr_warn("RAPL domain %s detection failed\n",
+			pr_info("RAPL domain %s not supported\n",
 				rapl_domain_names[i]);
 	}
 	rp->nr_domains = bitmap_weight(&rp->domain_map,	RAPL_DOMAIN_MAX);
-- 
2.0.0.5.gbce14aa

