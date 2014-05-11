Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910AbaEKT0B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:26:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933865AbaEKTZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:25:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexandre Oliva <lxoliva@fsfla.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 77/83] cpufreq: loongson2_cpufreq: dont declare local variable as static
Date: Sun, 11 May 2014 21:20:18 +0200
Message-Id: <20140511191916.961821418@linuxfoundation.org>
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

commit 05ed672292dc9d37db4fafdd49baa782158cd795 upstream.

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
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/loongson2_cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -69,7 +69,7 @@ static int loongson2_cpufreq_target(stru
 
 static int loongson2_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
-	static struct clk *cpuclk;
+	struct clk *cpuclk;
 	int i;
 	unsigned long rate;
 	int ret;


