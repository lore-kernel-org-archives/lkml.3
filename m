Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3KHKSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:18:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756507Ab3KHKSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:18:06 -0500
Date: Fri, 8 Nov 2013 11:18:01 +0100
From: Jan Kara <jack@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 2/4] irq_work: Provide a irq work that can be processed
 on any cpu
Message-ID: <20131108101801.GA6343@quack.suse.cz>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
 <1383860919-1883-3-git-send-email-jack@suse.cz>
 <CAFTL4hxLXb3hZacx_EdHeKZVfrpuyGoNqpGbX997XJx0UJSwyg@mail.gmail.com>
 <20131107221904.GB2054@quack.suse.cz>
 <20131107222311.GA28130@localhost.localdomain>
 <20131107225034.GD2054@quack.suse.cz>
 <20131107225408.GD28130@localhost.localdomain>
 <20131107230111.GF2054@quack.suse.cz>
 <20131107183142.4ae4345e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107183142.4ae4345e@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 07-11-13 18:31:42, Steven Rostedt wrote:
> On Fri, 8 Nov 2013 00:01:11 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > On Thu 07-11-13 23:54:10, Frederic Weisbecker wrote:
> 
> > > So if the current CPU can handle it, what is the problem?
> >   I hope this gets cleared out in my other email. But to make sure: If
> > other CPUs are idle (i.e. not appending to the printk buffer), we can well
> > handle the printing on the current CPU (with some breaks to allow
> > interrupts to be served etc.). If other CPUs are also appending to printk
> > buffer, that's where we really want to push the work to other CPUs.
> 
> I guess the question is, how does it migrate? I guess that's not so
> clear. Or do you just hope that the timer tick on another CPU will come
> in first and finish the job for you? As the list is global and all CPUs
> get to see it.
  There are two possibilities how the migration can happen:
1) a tick happens first on some other cpu and thus it will pick up the work
2) a printk happens first on some other cpu and thus it will pick printing
   in its console_unlock() call.

  I agree in both cases we depend on statistics, there's no real guarantee
the migration happens. But in my testing this seems to be enough.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
