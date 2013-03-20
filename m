Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933959Ab3CTI3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 04:29:03 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:62195 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3CTI3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 04:29:01 -0400
Message-ID: <1363768134.3758.6.camel@phoenix>
Subject: [PATCH] PM / devfreq: exynos4_bus: Fix missing mutex_unlock if
 opp_find_freq_floor fails
From: Axel Lin <axel.lin@ingics.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 16:28:54 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
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



