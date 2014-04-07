Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbaDGMEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 08:04:37 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52171 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbaDGMEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 08:04:35 -0400
Message-ID: <53429445.5000005@gmail.com>
Date: Mon, 07 Apr 2014 20:04:21 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>, rjw@rjwysocki.net,
        viresh.kumar@linaro.org
CC: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers:cpufreq:unicore32: fix typo issue for 'clk'
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need use 'clk' instead of 'mclk', which is the original removed local
variable.

The related original commit:

  "652ed95 cpufreq: introduce cpufreq_generic_get() routine"

The related error with allmodconfig for unicore32:

    CC      drivers/cpufreq/unicore2-cpufreq.o
  drivers/cpufreq/unicore2-cpufreq.c: In function ‘ucv2_target’:
  drivers/cpufreq/unicore2-cpufreq.c:48: error: ‘struct cpufreq_policy’ has no member named ‘mclk’
  make[2]: *** [drivers/cpufreq/unicore2-cpufreq.o] Error 1
  make[1]: *** [drivers/cpufreq] Error 2
  make: *** [drivers] Error 2


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/cpufreq/unicore2-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/unicore2-cpufreq.c b/drivers/cpufreq/unicore2-cpufreq.c
index 13be802..8d045af 100644
--- a/drivers/cpufreq/unicore2-cpufreq.c
+++ b/drivers/cpufreq/unicore2-cpufreq.c
@@ -45,7 +45,7 @@ static int ucv2_target(struct cpufreq_policy *policy,
 	freqs.new = target_freq;
 
 	cpufreq_freq_transition_begin(policy, &freqs);
-	ret = clk_set_rate(policy->mclk, target_freq * 1000);
+	ret = clk_set_rate(policy->clk, target_freq * 1000);
 	cpufreq_freq_transition_end(policy, &freqs, ret);
 
 	return ret;
-- 
1.7.9.5
