Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaBSTqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:46:24 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:47118 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaBSTqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:46:23 -0500
Date: Wed, 19 Feb 2014 20:43:55 +0100
From: Henrik Austad <henrik@austad.us>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Henrik Austad <haustad@cisco.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH Resend] Expose do_timer CPU via sysctl to userspace as R/W
Message-ID: <20140219194355.GA23228@austad.us>
References: <1392813178-25095-1-git-send-email-henrik@austad.us>
 <alpine.DEB.2.02.1402191730590.4468@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402191730590.4468@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 05:42:07PM +0100, Thomas Gleixner wrote:
> On Wed, 19 Feb 2014, henrik@austad.us wrote:
> > From: Henrik Austad <haustad@cisco.com>
> > 
> > Looks like this got dropped by vger a few days ago, resending.
> > 
> > This allows everybody in a system to read which core is currently
> > running do_timer() as well as letting root change this.
> > 
> > A few things to keep in mind
> > 
> > - This is intended as a debug-feature, except for testing whether or not
> >   the target CPU is present or not, the logic will not care -one- bit if
> >   moving the do_timer to that particular CPU is a good idea.
> 
> Well at least it must check that the cpu is online and neither in
> nohz idle nor nohz full mode.

The online-part should be taken care of by the cpu_present(), no?

But the nohz idle/nohz full should be checked, I agree.

> And we probably want to have that in sysfs with two files:
> 
>     timekeeping/current_cpu
>     timekeeping/forced_cpu

Fair enough, I can add that

> The latter contains -1 when the system boots and if you write to it,
> the duty gets hard assigned to that core, which in turn makes it
> blocked from NOHZ idle and NOHZ full modes. If the core goes offline,
> then the value must got back to -1. Writing -1 to it undoes the hard
> assignment.

Yeah, sounds like a good approach.

> > - It introduces more ifdeffery in the kernel.
> 
> There is no reason to do that.

probably not, as you can see, I wrapped everything in 
CONFIG_EXPOSE_TICK_CPU and added an option in Kconfig. Just drop all of 
that?

Thanks for the feedback! :)

-- 
Henrik Austad
