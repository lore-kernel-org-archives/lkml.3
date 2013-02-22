Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab3BVEdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 23:33:55 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:60827 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab3BVEdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 23:33:51 -0500
MIME-Version: 1.0
Date: Fri, 22 Feb 2013 12:33:50 +0800
Message-ID: <CAPgLHd-xToKRxXtknB0O3DZnaqEAqJ4cXpV_HHnJNs0Gx9OVPA@mail.gmail.com>
Subject: [PATCH] PM / devfreq: fix missing unlock on error in exynos4_busfreq_pm_notifier_event()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, nm@ti.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function
exynos4_busfreq_pm_notifier_event() in the error
handling case.

This issue introduced by commit 8fa938
(PM / devfreq: exynos4_bus: honor RCU lock usage)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/devfreq/exynos4_bus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
index 46d94e9..6208a68 100644
--- a/drivers/devfreq/exynos4_bus.c
+++ b/drivers/devfreq/exynos4_bus.c
@@ -974,6 +974,7 @@ static int exynos4_busfreq_pm_notifier_event(struct notifier_block *this,
 			rcu_read_unlock();
 			dev_err(data->dev, "%s: unable to find a min freq\n",
 				__func__);
+			mutex_unlock(&data->lock);
 			return PTR_ERR(opp);
 		}
 		new_oppinfo.rate = opp_get_freq(opp);


