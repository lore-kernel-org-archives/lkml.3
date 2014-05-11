Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929AbaEKT0I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:26:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933911AbaEKT0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:26:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 80/83] cpufreq: unicore32: fix typo issue for clk
Date: Sun, 11 May 2014 21:20:21 +0200
Message-Id: <20140511191917.372804782@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen.5i5j@gmail.com>

commit b4ddad95020e65cfbbf9aee63d3bcdf682794ade upstream.

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

Fixes: 652ed95d5fa6 (cpufreq: introduce cpufreq_generic_get() routine)
Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/cpufreq/unicore2-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/unicore2-cpufreq.c
+++ b/drivers/cpufreq/unicore2-cpufreq.c
@@ -45,7 +45,7 @@ static int ucv2_target(struct cpufreq_po
 	freqs.new = target_freq;
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-	ret = clk_set_rate(policy->mclk, target_freq * 1000);
+	ret = clk_set_rate(policy->clk, target_freq * 1000);
 	cpufreq_notify_post_transition(policy, &freqs, ret);
 
 	return ret;


