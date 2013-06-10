Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab3FJSh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 14:37:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388Ab3FJShX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 14:37:23 -0400
Date: Mon, 10 Jun 2013 20:33:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        John Stultz <johnstul@us.ibm.com>,
        Tomas Janousek <tjanouse@redhat.com>,
        Tomas Smetana <tsmetana@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] uptime_proc_show: use get_monotonic_boottime()
Message-ID: <20130610183320.GA14405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130610183300.GA14379@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change uptime_proc_show() to use get_monotonic_boottime() instead
of do_posix_clock_monotonic_gettime() + monotonic_to_bootbased().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/uptime.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 9610ac7..0618946 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -20,8 +20,7 @@ static int uptime_proc_show(struct seq_file *m, void *v)
 	for_each_possible_cpu(i)
 		idletime += (__force u64) kcpustat_cpu(i).cpustat[CPUTIME_IDLE];
 
-	do_posix_clock_monotonic_gettime(&uptime);
-	monotonic_to_bootbased(&uptime);
+	get_monotonic_boottime(&uptime);
 	nsec = cputime64_to_jiffies64(idletime) * TICK_NSEC;
 	idle.tv_sec = div_u64_rem(nsec, NSEC_PER_SEC, &rem);
 	idle.tv_nsec = rem;
-- 
1.5.5.1

