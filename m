Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbaFBHAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:00:44 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:50404 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaFBHAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:00:43 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, nm@ti.com, chander.kashyap@linaro.org,
        pavel@ucw.cz, len.brown@intel.com, sudeep.holla@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V5 3/8] opp: Enhance debug messages in of_init_opp_table()
Date: Mon,  2 Jun 2014 12:30:33 +0530
Message-Id: <7373788d1dd01bd99cd22fbfaf94327d42e58935.1401691974.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <2a9d8e2954166e47d7cdcf9c540dea572b080e7b.1401191054.git.viresh.kumar@linaro.org>
References: <2a9d8e2954166e47d7cdcf9c540dea572b080e7b.1401191054.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance print messages for debugging purposes. Add a dev_err() whenever we fail
to initialize OPP table due to some error in the table present in dts and add a
dev_dbg() for success case.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V4->V5: Fix rebase conflict as 2/8 has changed a bit

 drivers/base/power/opp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 28696af..ba20510 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -655,6 +655,8 @@ int of_init_opp_table(struct device *dev)
 	}
 
 	if (!prop->value) {
+		dev_err(dev, "%s: failed to init OPP: prop->value is NULL\n",
+			__func__);
 		ret = -ENODATA;
 		goto out;
 	}
@@ -681,6 +683,8 @@ int of_init_opp_table(struct device *dev)
 		nr -= 2;
 	}
 
+	dev_dbg(dev, "%s: successfully created OPP table\n", __func__);
+
 out:
 	of_node_put(dev->of_node);
 	return 0;
-- 
2.0.0.rc2

