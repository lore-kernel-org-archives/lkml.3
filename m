Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935048Ab3FSROI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:14:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20456 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935018Ab3FSRNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:13:38 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-71-51c1e6c14fe2
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocky" <rjw@sisk.pl>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH v4 7/7] thermal:boost: Disable boost when trip point is reached
Date: Wed, 19 Jun 2013 19:12:48 +0200
Message-id: <1371661969-7660-8-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jQd2Dzw4GGjxu5rf483Y5q8XTph/s
	FvM+y1qs2f+TyaLz7BNmi94FV9ks3jzitnjzcDOjxeVdc9gsPvceYbS43biCzaJ/YS+TxZOH
	fWwWHUe+MVts/OrhwO+xeM9LJo871/aweayb9pbZo2/LKkaPR4tbGD2O39jO5PF5k1wAexSX
	TUpqTmZZapG+XQJXxofH65kK5rJXPH9xirWBcRJbFyMnh4SAicSSsweYIGwxiQv31gPFuTiE
	BKYzSrw88ZwdJCEk0MUkcf1UPIjNJqAn8fnuU7AGEQFfiZ5lh5hAGpgF9rFITP3WwQqSEBbw
	l7i99QYLiM0ioCox8/ImMJtXwFWi5eFJFoht8hJP7/eBXcEp4CZx/FsX1OZGRom1Gx4wT2Dk
	XcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOGyfSe1gXNlgcYhRgINRiYdX4/LBQCHW
	xLLiytxDjBIczEoivEuPAoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1I
	LYLJMnFwSjUwMpzlnr1EavqvhZd2KlXtP2pz472S/4vAF0dEM9v701wPZ2eHv1PQ37VMPba4
	ROD/2f/TjR2mVMiHnfDJbdhQtHn1hiiTn3lZbVMs/vt3Ov1buYvvxvtUi85staXC4s8nfrjE
	cm7/Uun9j+p0haW6IoMqv6s4bn7teXX3L+d8lk0Tnx41kX0vq8RSnJFoqMVcVJwIAPpqEMpX	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides support for disabling cpufreq's boost
feature when thermal trip point is reached.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

Changes for v4:
- New patch
---
 drivers/thermal/cpu_cooling.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index c94bf2e..3bdd870 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -323,6 +323,9 @@ static int cpufreq_thermal_notifier(struct notifier_block *nb,
 	if (cpumask_test_cpu(policy->cpu, &notify_device->allowed_cpus))
 		max_freq = notify_device->cpufreq_val;
 
+	if (cpufreq_boost_supported())
+		cpufreq_boost_trigger_state(0);
+
 	/* Never exceed user_policy.max */
 	if (max_freq > policy->user_policy.max)
 		max_freq = policy->user_policy.max;
-- 
1.7.10.4

