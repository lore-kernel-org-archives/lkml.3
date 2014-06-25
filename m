Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbaFYInI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:43:08 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:58921 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106AbaFYInB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:43:01 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, sboyd@codeaurora.org, shawn.guo@linaro.org
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, spk.linux@gmail.com,
        thomas.ab@samsung.com, nm@ti.com, t.figa@samsung.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] cpufreq: Add support for per-policy driver data
Date: Wed, 25 Jun 2014 14:12:28 +0530
Message-Id: <28dc4ae67a7c3c712714abc14619b7c1d4bfb361.1403684824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1403684824.git.viresh.kumar@linaro.org>
References: <cover.1403684824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1403684824.git.viresh.kumar@linaro.org>
References: <cover.1403684824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers supporting multiple clusters or multiple 'struct cpufreq_policy'
instances may need to keep some per-policy data. If the core doesn't support
them, they might do it in the most unoptimized way: per-cpu data.

This patch adds another field in 'struct cpufreq_policy': driver_data. It isn't
accessed by core and is completely for driver's internal use.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/cpufreq.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index ec4112d..d4b1108 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -112,6 +112,9 @@ struct cpufreq_policy {
 	spinlock_t		transition_lock;
 	wait_queue_head_t	transition_wait;
 	struct task_struct	*transition_task; /* Task which is doing the transition */
+
+	/* For cpufreq driver's internal use */
+	void			*driver_data;
 };
 
 /* Only for ACPI */
-- 
2.0.0.rc2

