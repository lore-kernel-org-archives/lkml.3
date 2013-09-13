Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab3IMNNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:13:52 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:43946 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960Ab3IMNNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:13:47 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 091/228] cpufreq: acpi: don't initialize part of policy that is set by core too
Date: Fri, 13 Sep 2013 18:30:37 +0530
Message-Id: <be00fc29dbe59581f03969a3d75dce6011bf4e1b.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many common initializations of struct policy are moved to core now and hence
this driver doesn't need to do it. This patch removes such code.

Most recent of those changes is to call ->get() in the core after calling
->init().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/acpi-cpufreq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index d67023d..372febf 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -842,7 +842,6 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		break;
 	case ACPI_ADR_SPACE_FIXED_HARDWARE:
 		acpi_cpufreq_driver.get = get_cur_freq_on_cpu;
-		policy->cur = get_cur_freq_on_cpu(cpu);
 		break;
 	default:
 		break;
-- 
1.7.12.rc2.18.g61b472e

