Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbaIWSY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:24:26 -0400
Received: from flmx07.ccur.com ([173.221.59.12]:1327 "EHLO flmx07.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307AbaIWSYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:24:24 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 14:24:23 EDT
Message-ID: <5421B992.6050500@ccur.com>
Date: Tue, 23 Sep 2014 13:18:58 -0500
From: John Blackwood <john.blackwood@ccur.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@linux.intel.com>
Subject: [ PATCH ] Remove numa_balancing sysctl dependence on CONFIG_SCHED_DEBUG
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


numa: numa_balancing sysctl scope change

Make the 'numa_balancing' sysctl parameter no longer dependent upon
CONFIG_SCHED_DEBUG so it can be used in non-debug kernels.

Signed-off-by: John Blackwood <john.blackwood@ccur.com>

Index: b/kernel/sysctl.c
===================================================================
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -389,6 +389,9 @@ static struct ctl_table kern_table[] = {
  		.mode		= 0644,
  		.proc_handler	= proc_dointvec,
  	},
+#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_SCHED_DEBUG */
+#ifdef CONFIG_NUMA_BALANCING
  	{
  		.procname	= "numa_balancing",
  		.data		= NULL, /* filled in by handler */
@@ -399,7 +402,6 @@ static struct ctl_table kern_table[] = {
  		.extra2		= &one,
  	},
  #endif /* CONFIG_NUMA_BALANCING */
-#endif /* CONFIG_SCHED_DEBUG */
  	{
  		.procname	= "sched_rt_period_us",
  		.data		= &sysctl_sched_rt_period,
