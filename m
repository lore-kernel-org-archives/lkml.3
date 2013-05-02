Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426Ab3EBM1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:27:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35186 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab3EBM1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:27:49 -0400
Date: Thu, 2 May 2013 14:27:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Colin Cross <ccross@android.com>
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        Benoit Goby <benoit@android.com>, John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: Re: [RFC PATCH] power: Add option to log time spent in suspend
Message-ID: <20130502122747.GA22618@amd.pavel.ucw.cz>
References: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
 <1367360914-23389-2-git-send-email-zoran.markovic@linaro.org>
 <20130501002929.GA20042@amd.pavel.ucw.cz>
 <CAMbhsRRisa15fH9AodepfRJUv6t6dipqb6CMbOOrtzVsMUCoxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRRisa15fH9AodepfRJUv6t6dipqb6CMbOOrtzVsMUCoxQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> +#include <linux/debugfs.h>
> >> +#include <linux/err.h>
> >> +#include <linux/init.h>
> >> +#include <linux/kernel.h>
> >> +#include <linux/seq_file.h>
> >> +#include <linux/syscore_ops.h>
> >> +#include <linux/time.h>
> >> +
> >> +static struct timespec suspend_time_before;
> >> +static unsigned int time_in_suspend_bins[32];
> >> +
> >> +#ifdef CONFIG_DEBUG_FS
> >> +static int suspend_time_debug_show(struct seq_file *s, void *data)
> >> +{
> >> +     unsigned int bin;
> >> +     seq_printf(s, "      time (secs)        count\n");
> >> +     seq_printf(s, "------------------------------\n");
> >> +     for (bin = 0; bin < 32; bin++) {
> >> +             if (time_in_suspend_bins[bin] == 0)
> >> +                     continue;
> >> +             seq_printf(s, "%10u - %-10u %4u\n",
> >> +                     bin ? 1 << (bin - 1) : 0, 1 << bin,
> >> +                             time_in_suspend_bins[bin]);
> >> +     }
> >> +     return 0;
> >> +}
> >> +
> >> +static int suspend_time_debug_open(struct inode *inode, struct file *file)
> >> +{
> >> +     return single_open(file, suspend_time_debug_show, NULL);
> >> +}
> >
> > Ok, whole new driver to get timing info... As we already have times in
> > printk, can't existing printks() get the same info? Maybe
> > Documentation/ file describing how to get that info from dmesg would
> > be enough?
> 
> If this were to be merged I assume it would be rewritten directly into
> kernel/power/suspend.c instead of using syscore ops.  That was just
> done to ease future merges while it was out of tree.
> 
> dmesg is not the solution, it's not a stable api, it would require
> constant parsing to make sure you didn't miss data before it fell out
> of the ringbuffer, and sched_clock often does not (and should not)
> tick during suspend, so printk times don't show the time spent
> suspended.

If timing info printed is invalid, that should be fixed.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
