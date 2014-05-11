Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934350AbaEKTgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:36:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933877AbaEKTZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:25:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexandre Oliva <lxoliva@fsfla.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 78/83] cpufreq: at32ap: dont declare local variable as static
Date: Sun, 11 May 2014 21:20:19 +0200
Message-Id: <20140511191917.098505699@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 0ca97886fece9e1acd71ade4ca3a250945c8fc8b upstream.

Earlier commit:
	commit 652ed95d5fa6074b3c4ea245deb0691f1acb6656
	Author: Viresh Kumar <viresh.kumar@linaro.org>
	Date:   Thu Jan 9 20:38:43 2014 +0530

	    cpufreq: introduce cpufreq_generic_get() routine

did some changes to driver and by mistake made cpuclk as a 'static' local
variable, which wasn't actually required. Fix it.

Fixes: 652ed95d5fa6 (cpufreq: introduce cpufreq_generic_get() routine)
Reported-by: Alexandre Oliva <lxoliva@fsfla.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/at32ap-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/at32ap-cpufreq.c
+++ b/drivers/cpufreq/at32ap-cpufreq.c
@@ -52,7 +52,7 @@ static int at32_set_target(struct cpufre
 static int at32_cpufreq_driver_init(struct cpufreq_policy *policy)
 {
 	unsigned int frequency, rate, min_freq;
-	static struct clk *cpuclk;
+	struct clk *cpuclk;
 	int retval, steps, i;
 
 	if (policy->cpu != 0)


