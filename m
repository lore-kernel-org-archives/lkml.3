Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaEULKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:10:35 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:60002 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaEULKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:10:33 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, nm@ti.com, chander.kashyap@linaro.org,
        pavel@ucw.cz, len.brown@intel.com, sudeep.holla@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 2/7] opp: handle of_node_{get|put}() inside of_init_opp_table()
Date: Wed, 21 May 2014 16:40:00 +0530
Message-Id: <62e2dc5fd75e25ff85a6b09f35fbeb476e1c35db.1400670427.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1400670427.git.viresh.kumar@linaro.org>
References: <cover.1400670427.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1400670427.git.viresh.kumar@linaro.org>
References: <cover.1400670427.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All callers of of_init_opp_table() are required to call of_node_{get|put}()
before and after calling it. It would be better if this can be handled within
of_init_opp_table().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/base/power/opp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index faae9cf..2b615b9 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -622,6 +622,9 @@ int of_init_opp_table(struct device *dev)
 	const __be32 *val;
 	int nr;
 
+	if (!of_node_get(dev->of_node))
+		return -ENODEV;
+
 	prop = of_find_property(dev->of_node, "operating-points", NULL);
 	if (!prop)
 		return -ENODEV;
@@ -649,6 +652,7 @@ int of_init_opp_table(struct device *dev)
 		nr -= 2;
 	}
 
+	of_node_put(dev->of_node);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(of_init_opp_table);
-- 
2.0.0.rc2

