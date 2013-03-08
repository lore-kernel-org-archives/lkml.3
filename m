Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab3CHFyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:54:38 -0500
Received: from mga14.intel.com ([143.182.124.37]:18428 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab3CHFyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 00:54:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,806,1355126400"; 
   d="scan'208";a="266562052"
Subject: [PATCH 1/3] intel_idle: changing the continue to break in
 intel_idle_cpu_init()
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: lenb@kernel.org
Cc: daniel.lezcano@linaro.org, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1362754926.31506.42.camel@cliu38-desktop-build>
References: <1362674529.31506.17.camel@cliu38-desktop-build>
	 <1362754926.31506.42.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Mar 2013 23:03:44 +0800
Message-ID: <1362755024.31506.44.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


According to commit e022e7eb9, the .enter == NULL is the last one in
state_tables[].

So just like intel_idle_cpuidle_driver_init(), in case of .enter == NULL,
breaking the for(;;) loop directly.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/idle/intel_idle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 5d66750..17c9cf9 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -610,7 +610,7 @@ static int intel_idle_cpu_init(int cpu)
 		int num_substates, mwait_hint, mwait_cstate, mwait_substate;
 
 		if (cpuidle_state_table[cstate].enter == NULL)
-			continue;
+			break;
 
 		if (cstate + 1 > max_cstate) {
 			printk(PREFIX "max_cstate %d reached\n", max_cstate);
-- 
1.7.0.4



