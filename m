Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030605AbaGROLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:11:38 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52300 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934609AbaGROLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:11:36 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: orjan.eide@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/2] PM / devfreq: Export helper functions for drivers
Date: Fri, 18 Jul 2014 15:09:53 +0100
Message-Id: <1405692594-19352-2-git-send-email-punit.agrawal@arm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405692594-19352-1-git-send-email-punit.agrawal@arm.com>
References: <1405692594-19352-1-git-send-email-punit.agrawal@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ørjan Eide <orjan.eide@arm.com>

These functions are indended for use by drivers and should be available
also when the driver is built as a module.

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Ørjan Eide <orjan.eide@arm.com>
---
 drivers/devfreq/devfreq.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 9f90369..30b538d8 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -1119,6 +1119,7 @@ struct dev_pm_opp *devfreq_recommended_opp(struct device *dev,
 
 	return opp;
 }
+EXPORT_SYMBOL(devfreq_recommended_opp);
 
 /**
  * devfreq_register_opp_notifier() - Helper function to get devfreq notified
@@ -1142,6 +1143,7 @@ int devfreq_register_opp_notifier(struct device *dev, struct devfreq *devfreq)
 
 	return ret;
 }
+EXPORT_SYMBOL(devfreq_register_opp_notifier);
 
 /**
  * devfreq_unregister_opp_notifier() - Helper function to stop getting devfreq
@@ -1168,6 +1170,7 @@ int devfreq_unregister_opp_notifier(struct device *dev, struct devfreq *devfreq)
 
 	return ret;
 }
+EXPORT_SYMBOL(devfreq_unregister_opp_notifier);
 
 static void devm_devfreq_opp_release(struct device *dev, void *res)
 {
-- 
1.7.10.4

