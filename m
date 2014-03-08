Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaCHSCt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 13:02:49 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58982 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaCHSCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 13:02:48 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Bolle <pebolle@tiscali.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] events: Improve the "perf samples too long" warning
Date: Sat,  8 Mar 2014 10:02:33 -0800
Message-Id: <f385628fe8fbab4af39f6fe36728ce0e3611b616.1394301632.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The warning is not indicative of an actual problem, especially when
triggered by nmi_watchdog, so lower it to KERN_INFO.  While I'm at
it, clarify the message and reference the sysctl that controls it.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 kernel/events/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 56003c6..245bdc0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -263,9 +263,8 @@ void perf_sample_event_took(u64 sample_len_ns)
 	sysctl_perf_event_sample_rate = max_samples_per_tick * HZ;
 	perf_sample_period_ns = NSEC_PER_SEC / sysctl_perf_event_sample_rate;
 
-	printk_ratelimited(KERN_WARNING
-			"perf samples too long (%lld > %lld), lowering "
-			"kernel.perf_event_max_sample_rate to %d\n",
+	printk_ratelimited(KERN_INFO
+			"perf samples are too slow for kernel.perf_cpu_time_max_percent (%lldns > %lldns); lowering kernel.perf_event_max_sample_rate to %d\n",
 			avg_local_sample_len, allowed_ns,
 			sysctl_perf_event_sample_rate);
 
-- 
1.8.5.3

