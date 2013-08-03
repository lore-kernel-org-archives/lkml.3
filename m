Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab3HCJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 05:25:27 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:62453 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3HCJZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 05:25:25 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, pavel@ucw.cz
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] OPP: Export opp_add()
Date: Sat,  3 Aug 2013 14:55:06 +0530
Message-Id: <58acb4a8a4e98089078de3ed71999730b6d97b4b.1375521724.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export opp_add() so that modules can use it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/base/power/opp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index c8ec186..ef89897 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -460,6 +460,7 @@ int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
 	srcu_notifier_call_chain(&dev_opp->head, OPP_EVENT_ADD, new_opp);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(opp_add);
 
 /**
  * opp_set_availability() - helper to set the availability of an opp
-- 
1.7.12.rc2.18.g61b472e

