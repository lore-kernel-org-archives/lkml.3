Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab3LTSud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:50:33 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52459 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3LTSsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:48:03 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-92-52b490e171c7
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, lenb@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Subject: [PATCH v2 2/9] POWERPC: pseries: cpuidle: remove superfluous
 dev->state_count initialization
Date: Fri, 20 Dec 2013 19:47:24 +0100
Message-id: <1387565251-7051-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
References: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t9jQd1HE7YEGSycxGqxccZ6Vot5n2Ut
	1jfmW5xtesNusfPhWzaLy7vmsFl87j3CaDHj/D4mi9/f/7FanDl9idWBy2PTqk42jzvX9rB5
	PDi0mcXj/IyFjB5brrazePRtWcXo8XmTXAB7FJdNSmpOZllqkb5dAldG44W5LAWnuCq6t3xn
	amCcxtnFyMkhIWAi8XPFWzYIW0ziwr31QDYXh5DAdEaJaw1L2SGcLiaJq5O2g1WxCVhJTGxf
	xQhiiwiISlzePYEFpIhZYCKTxJb1E5lAEsIC6RIdL7awgNgsAqoSn3pWg9m8Au4SzXvnMEOs
	U5TofjYBbCingIfE7FfLwXqFgGpOdP1mnsDIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+
	7iZGcBg+k97BuKrB4hCjAAejEg+vROSWICHWxLLiytxDjBIczEoivDfbgEK8KYmVValF+fFF
	pTmpxYcYpTlYlMR5D7ZaBwoJpCeWpGanphakFsFkmTg4pRoYje6IVd52e3NOreLUyU37mLWY
	76V63fHYxy26cluw5O7Ea+yffy58Izxz9tnGlP9OPodlK5hDXHpT6n60X9uzb1rIYy41t6pj
	PetetW5Z+ffGtxafgDihlxqyfcZe1yKdXkuc3P+1N+j5QrY7D0Rcjz0+9eQlJ2+NoKvUlbCi
	D7auFaFh5oblSizFGYmGWsxFxYkA5SNjqT8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pseries cpuidle driver sets dev->state_count to drv->state_count so
the default dev->state_count initialization in cpuidle_enable_device()
(called from cpuidle_register_device()) can be used instead.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/processor_idle.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
index a166e38..8aa8c40 100644
--- a/arch/powerpc/platforms/pseries/processor_idle.c
+++ b/arch/powerpc/platforms/pseries/processor_idle.c
@@ -271,7 +271,6 @@ static void pseries_idle_devices_uninit(void)
 static int pseries_idle_devices_init(void)
 {
 	int i;
-	struct cpuidle_driver *drv = &pseries_idle_driver;
 	struct cpuidle_device *dev;
 
 	pseries_cpuidle_devices = alloc_percpu(struct cpuidle_device);
@@ -280,7 +279,6 @@ static int pseries_idle_devices_init(void)
 
 	for_each_possible_cpu(i) {
 		dev = per_cpu_ptr(pseries_cpuidle_devices, i);
-		dev->state_count = drv->state_count;
 		dev->cpu = i;
 		if (cpuidle_register_device(dev)) {
 			printk(KERN_DEBUG \
-- 
1.8.2.3

