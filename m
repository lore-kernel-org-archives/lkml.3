Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3CREkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:40:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33618 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109Ab3CREa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:56 -0400
Message-Id: <20130318042148.418945193@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:27 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        guifang tang <guifang.tang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 43/82] Fix memory leak in cpufreq stats.
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Tu, Xiaobing" <xiaobing.tu@intel.com>

commit e37736777254ce1abc85493a5cacbefe5983b896 upstream.

When system enters sleep, non-boot CPUs will be disabled.
Cpufreq stats sysfs is created when the CPU is up, but it is not
freed when the CPU is going down. This will cause memory leak.

Signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
Signed-off-by: guifang tang <guifang.tang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/cpufreq/cpufreq_stats.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -330,6 +330,7 @@ static int __cpuinit cpufreq_stat_cpu_ca
 		cpufreq_update_policy(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		cpufreq_stats_free_sysfs(cpu);
 		break;
 	case CPU_DEAD:


