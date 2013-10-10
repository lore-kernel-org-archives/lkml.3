Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3JJH0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:26:34 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:54267 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3JJH0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:26:32 -0400
Date: Thu, 10 Oct 2013 09:26:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dong Zhu <bluezhudong@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v0.3] timer stats: add a 'status' line to timer usage
 statistics
Message-ID: <20131010072629.GA17990@gmail.com>
References: <20131010025947.GD2139@zhudong.nay.redhat.com>
 <20131010043519.GB22519@gmail.com>
 <20131010061408.GF2139@zhudong.nay.redhat.com>
 <20131010061621.GA9853@gmail.com>
 <20131010065503.GG2139@zhudong.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010065503.GG2139@zhudong.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dong Zhu <bluezhudong@gmail.com> wrote:

> > > Agree, I modified this patch and resubmited it again, Could you help
> > > reviewing it again ? Thanks !
> > > 
> > > From 263c40abea8011c82582b2d671ae783b26f44bd5 Mon Sep 17 00:00:00 2001
> > > From: Dong Zhu <bluezhudong@gmail.com> 
> > > Date: Thu, 10 Oct 2013 13:46:08 +0800
> > > 
> > > We can enable|disable timer statistics collection (via echo [1|0] >
> > > /proc/timers_stats), this patch adds a 'status' line to display the
> > > current timer collection status.
> > > 
> > > Signed-off-by: Dong Zhu <bluezhudong@gmail.com>
> > > ---
> > >  kernel/time/timer_stats.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
> > > index 0b537f2..bac5e91 100644
> > > --- a/kernel/time/timer_stats.c
> > > +++ b/kernel/time/timer_stats.c
> > > @@ -303,6 +303,10 @@ static int tstats_show(struct seq_file *m, void *v)
> > >  	if (atomic_read(&overflow_count))
> > >  		seq_printf(m, "Overflow: %d entries\n",
> > >  			atomic_read(&overflow_count));
> > > +	if (timer_stats_active)
> > > +		seq_puts(m, "Status: collection active\n");
> > > +	else
> > > +		seq_puts(m, "Status: collection disabled\n");
> > 
> > I suspect we could do something like:
> > 
> > 	seq_printf("Status: collection %s\n", timer_stats_active ? "enabled" : "disabled");
> > 
> > and save a bit of kernel image size?
> > 
> > Also, please bump up the version to v0.3, to give parsers a chance.

I think you forgot about this suggestion of mine.

Thanks,

	Ingo
