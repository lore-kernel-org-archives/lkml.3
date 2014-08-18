Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaHRPbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:31:14 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:44787 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaHRPbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:31:10 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>, rabin@rab.in,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v7 3/8] cpufreq: kirkwood: Remove use of the clk provider API
Date: Mon, 18 Aug 2014 17:30:29 +0200
Message-Id: <1408375833-10703-4-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408375833-10703-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1408375833-10703-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/cpufreq/kirkwood-cpufreq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index 37a4806..f3d087f 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/clk.h>
-#include <linux/clk-provider.h>
 #include <linux/cpufreq.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
@@ -50,7 +49,7 @@ static struct cpufreq_frequency_table kirkwood_freq_table[] = {
 
 static unsigned int kirkwood_cpufreq_get_cpu_frequency(unsigned int cpu)
 {
-	if (__clk_is_enabled(priv.powersave_clk))
+	if (clk_is_enabled(priv.powersave_clk))
 		return kirkwood_freq_table[1].frequency;
 	return kirkwood_freq_table[0].frequency;
 }
-- 
1.9.3

