Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3JJGxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:53:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab3JJGxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:53:44 -0400
Date: Thu, 10 Oct 2013 14:55:03 +0800
From: Dong Zhu <bluezhudong@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v0.3] timer stats: add a 'status' line to timer usage
 statistics
Message-ID: <20131010065503.GG2139@zhudong.nay.redhat.com>
References: <20131010025947.GD2139@zhudong.nay.redhat.com>
 <20131010043519.GB22519@gmail.com>
 <20131010061408.GF2139@zhudong.nay.redhat.com>
 <20131010061621.GA9853@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010061621.GA9853@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Agree, I modified this patch and resubmited it again, Could you help
> > reviewing it again ? Thanks !
> > 
> > From 263c40abea8011c82582b2d671ae783b26f44bd5 Mon Sep 17 00:00:00 2001
> > From: Dong Zhu <bluezhudong@gmail.com> 
> > Date: Thu, 10 Oct 2013 13:46:08 +0800
> > 
> > We can enable|disable timer statistics collection (via echo [1|0] >
> > /proc/timers_stats), this patch adds a 'status' line to display the
> > current timer collection status.
> > 
> > Signed-off-by: Dong Zhu <bluezhudong@gmail.com>
> > ---
> >  kernel/time/timer_stats.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
> > index 0b537f2..bac5e91 100644
> > --- a/kernel/time/timer_stats.c
> > +++ b/kernel/time/timer_stats.c
> > @@ -303,6 +303,10 @@ static int tstats_show(struct seq_file *m, void *v)
> >  	if (atomic_read(&overflow_count))
> >  		seq_printf(m, "Overflow: %d entries\n",
> >  			atomic_read(&overflow_count));
> > +	if (timer_stats_active)
> > +		seq_puts(m, "Status: collection active\n");
> > +	else
> > +		seq_puts(m, "Status: collection disabled\n");
> 
> I suspect we could do something like:
> 
> 	seq_printf("Status: collection %s\n", timer_stats_active ? "enabled" : "disabled");
> 
> and save a bit of kernel image size?
> 
> Also, please bump up the version to v0.3, to give parsers a chance.
> 
> Otherwise it looks good to me.
> 
Thanks for your comments, I refined this patch as below: 
>From 1035e4e2b7ff28b1b2fccd407929179b5de8fbd4 Mon Sep 17 00:00:00 2001
From: Dong Zhu <bluezhudong@gmail.com> 
Date: Thu, 10 Oct 2013 14:48:24 +0800

We can enable|disable timer statistics collection (via echo [1|0] >
/proc/timers_stats), this patch adds a 'status' line to display the
current timer collection status.

Signed-off-by: Dong Zhu <bluezhudong@gmail.com>
---
 kernel/time/timer_stats.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index 0b537f2..5236b45 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -303,6 +303,8 @@ static int tstats_show(struct seq_file *m, void *v)
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
