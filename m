Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab3JJHzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:55:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab3JJHzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:55:04 -0400
Date: Thu, 10 Oct 2013 15:56:18 +0800
From: Dong Zhu <bluezhudong@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] timer stats: add a 'status' line to timer usage
 statistics
Message-ID: <20131010075618.GH2139@zhudong.nay.redhat.com>
References: <20131010025947.GD2139@zhudong.nay.redhat.com>
 <20131010043519.GB22519@gmail.com>
 <20131010061408.GF2139@zhudong.nay.redhat.com>
 <20131010061621.GA9853@gmail.com>
 <20131010065503.GG2139@zhudong.nay.redhat.com>
 <20131010072629.GA17990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010072629.GA17990@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I suspect we could do something like:
> > > 
> > > 	seq_printf("Status: collection %s\n", timer_stats_active ? "enabled" : "disabled");
> > > 
> > > and save a bit of kernel image size?
> > > 
> > > Also, please bump up the version to v0.3, to give parsers a chance.
> 
> I think you forgot about this suggestion of mine.
> 

Oh, oops, sorry about that.

I modified the patch again as below, hope it could be applied this time.

>From 92a67f74766e02b5f4702b1af2af9861bf70d60b Mon Sep 17 00:00:00 2001
From: Dong Zhu <bluezhudong@gmail.com> 
Date: Thu, 10 Oct 2013 15:48:29 +0800

We can enable|disable timer statistics collection (via echo [1|0] >
/proc/timers_stats), this patch adds a 'status' line to display the
current timer collection status. In the meantime I also bump up the
timer stats version to v0.3.

Signed-off-by: Dong Zhu <bluezhudong@gmail.com> 
---
 kernel/time/timer_stats.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index 0b537f2..7c31ab7 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -298,11 +298,13 @@ static int tstats_show(struct seq_file *m, void *v)
 	period = ktime_to_timespec(time);
 	ms = period.tv_nsec / 1000000;
 
-	seq_puts(m, "Timer Stats Version: v0.2\n");
+	seq_puts(m, "Timer Stats Version: v0.3\n");
 	seq_printf(m, "Sample period: %ld.%03ld s\n", period.tv_sec, ms);
 	if (atomic_read(&overflow_count))
 		seq_printf(m, "Overflow: %d entries\n",
 			atomic_read(&overflow_count));
+	seq_printf(m, "Status: collection %s\n",
+		timer_stats_active ? "enabled" : "disabled");
 
 	for (i = 0; i < nr_entries; i++) {
 		entry = entries + i;
-- 
1.7.11.7


-- 
Best Regards,
Dong Zhu
