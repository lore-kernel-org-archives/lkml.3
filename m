Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965199Ab3DJXHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:07:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56256 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937348Ab3DJWrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [ 54/64] cpufreq: exynos: Get booting freq value in exynos_cpufreq_init
Date: Wed, 10 Apr 2013 15:46:51 -0700
Message-Id: <20130410224346.047988607@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonghwan Choi <jhbird.choi@samsung.com>

commit 6e45eb12fd1c741d556bf264ee98853b5f3104e5 upstream.

Boot_freq is for saving booting freq. But exynos_cpufreq_cpu_init
is called in hotplug. If boot_freq is existed in exynos_cpufreq_cpu_init,
boot_freq could be changed.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/exynos-cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -222,8 +222,6 @@ static int exynos_cpufreq_cpu_init(struc
 
 	cpufreq_frequency_table_get_attr(exynos_info->freq_table, policy->cpu);
 
-	locking_frequency = exynos_getspeed(0);
-
 	/* set the transition latency value */
 	policy->cpuinfo.transition_latency = 100000;
 
@@ -288,6 +286,8 @@ static int __init exynos_cpufreq_init(vo
 		goto err_vdd_arm;
 	}
 
+	locking_frequency = exynos_getspeed(0);
+
 	register_pm_notifier(&exynos_cpufreq_nb);
 
 	if (cpufreq_register_driver(&exynos_driver)) {


