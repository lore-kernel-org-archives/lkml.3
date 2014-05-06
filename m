Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaEFRTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:19:08 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:14124 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbaEFRTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:19:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al4UAN0YaVNbtAAq/2dsb2JhbABZgwarbQQBAQEBAQEFAZoHAgKBHxd0gmYcIxiBAiQTiEUBzjeFVoh8hEYBA48bihsBiwCHe4M2Ow
Date: Tue, 6 May 2014 19:18:59 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/profile.c: convert printk to pr_foo()
Message-Id: <20140506191859.384548bac0bbee75a91f9ceb@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/profile.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index cb980f0..c1204e2 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -64,12 +64,10 @@ int profile_setup(char *str)
 			str += strlen(sleepstr) + 1;
 		if (get_option(&str, &par))
 			prof_shift = par;
-		printk(KERN_INFO
-			"kernel sleep profiling enabled (shift: %ld)\n",
+		pr_info("kernel sleep profiling enabled (shift: %ld)\n",
 			prof_shift);
 #else
-		printk(KERN_WARNING
-			"kernel sleep profiling requires CONFIG_SCHEDSTATS\n");
+		pr_warn("kernel sleep profiling requires CONFIG_SCHEDSTATS\n");
 #endif /* CONFIG_SCHEDSTATS */
 	} else if (!strncmp(str, schedstr, strlen(schedstr))) {
 		prof_on = SCHED_PROFILING;
@@ -77,8 +75,7 @@ int profile_setup(char *str)
 			str += strlen(schedstr) + 1;
 		if (get_option(&str, &par))
 			prof_shift = par;
-		printk(KERN_INFO
-			"kernel schedule profiling enabled (shift: %ld)\n",
+		pr_info("kernel schedule profiling enabled (shift: %ld)\n",
 			prof_shift);
 	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
 		prof_on = KVM_PROFILING;
@@ -86,13 +83,12 @@ int profile_setup(char *str)
 			str += strlen(kvmstr) + 1;
 		if (get_option(&str, &par))
 			prof_shift = par;
-		printk(KERN_INFO
-			"kernel KVM profiling enabled (shift: %ld)\n",
+		pr_info("kernel KVM profiling enabled (shift: %ld)\n",
 			prof_shift);
 	} else if (get_option(&str, &par)) {
 		prof_shift = par;
 		prof_on = CPU_PROFILING;
-		printk(KERN_INFO "kernel profiling enabled (shift: %ld)\n",
+		pr_info("kernel profiling enabled (shift: %ld)\n",
 			prof_shift);
 	}
 	return 1;
-- 
1.8.4.5

