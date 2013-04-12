Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab3DLFy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 01:54:26 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:46311 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab3DLFyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 01:54:25 -0400
Message-ID: <1365746058.4025.1.camel@phoenix>
Subject: [RESEND][PATCH 1/3] PM / devfreq: exynos4_bus: Fix missing
 mutex_unlock if opp_find_freq_floor fails
From: Axel Lin <axel.lin@ingics.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Apr 2013 13:54:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to call mutex_unlock() in the error path.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/devfreq/exynos4_bus.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
index 1deee09..54b9615 100644
--- a/drivers/devfreq/exynos4_bus.c
+++ b/drivers/devfreq/exynos4_bus.c
@@ -974,7 +974,8 @@ static int exynos4_busfreq_pm_notifier_event(struct notifier_block *this,
 			rcu_read_unlock();
 			dev_err(data->dev, "%s: unable to find a min freq\n",
 				__func__);
-			return PTR_ERR(opp);
+			err = PTR_ERR(opp);
+			goto unlock;
 		}
 		new_oppinfo.rate = opp_get_freq(opp);
 		new_oppinfo.volt = opp_get_voltage(opp);
-- 
1.7.9.5



