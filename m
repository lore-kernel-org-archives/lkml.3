Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964927Ab3CLWo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:44:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964887Ab3CLWoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:44:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        xiaobing tu <xiaobing.tu@intel.com>,
        guifang tang <guifang.tang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Colin Cross <ccross@google.com>
Subject: [ 18/21] Fix memory leak in cpufreq stats.
Date: Tue, 12 Mar 2013 15:44:20 -0700
Message-Id: <20130312223247.204701025@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223245.109098379@linuxfoundation.org>
References: <20130312223245.109098379@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Tu, Xiaobing" <xiaobing.tu@intel.com>

commit e37736777254ce1abc85493a5cacbefe5983b896 upstream.

When system enters sleep, non-boot CPUs will be disabled.
Cpufreq stats sysfs is created when the CPU is up, but it is not
freed when the CPU is going down. This will cause memory leak.

Signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
Signed-off-by: guifang tang <guifang.tang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Colin Cross <ccross@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq_stats.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -329,6 +329,7 @@ static int __cpuinit cpufreq_stat_cpu_ca
 		cpufreq_update_policy(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		cpufreq_stats_free_sysfs(cpu);
 		break;
 	case CPU_DEAD:


