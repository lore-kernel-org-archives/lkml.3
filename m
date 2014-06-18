Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbaFRXcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:32:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34040 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbaFRXcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:32:11 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Eduardo Valentin <edubezval@gmail.com>, Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH] thermal: Add braces around suspect code
Date: Wed, 18 Jun 2014 16:32:08 -0700
Message-Id: <1403134328-4668-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like this code is missing braces, otherwise the if
statement shouldn't have been indented. Fix it.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/thermal/of-thermal.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index 04b1be7fa018..a95ee2889b19 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -712,11 +712,12 @@ thermal_of_build_thermal_zone(struct device_node *np)
 	}
 
 	i = 0;
-	for_each_child_of_node(child, gchild)
+	for_each_child_of_node(child, gchild) {
 		ret = thermal_of_populate_bind_params(gchild, &tz->tbps[i++],
 						      tz->trips, tz->ntrips);
 		if (ret)
 			goto free_tbps;
+	}
 
 finish:
 	of_node_put(child);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

