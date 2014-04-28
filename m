Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbaD1UNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:13:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756320AbaD1UNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:13:08 -0400
Date: Mon, 28 Apr 2014 22:13:05 +0200
From: Jan Kara <jack@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: lockdep warning after recent cleanup in console code
Message-ID: <20140428201305.GG9091@quack.suse.cz>
References: <1398702925.11914.292.camel@smile.fi.intel.com>
 <20140428134331.68771bf7@gandalf.local.home>
 <20140428175139.GD9091@quack.suse.cz>
 <20140428141439.3580dce9@gandalf.local.home>
 <20140428192416.GE9091@quack.suse.cz>
 <20140428153642.413ec8e8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428153642.413ec8e8@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-04-14 15:36:42, Steven Rostedt wrote:
> On Mon, 28 Apr 2014 21:24:16 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> 
> >   So I had a look and we are missing mutex_release() in
> > console_trylock_for_printk() if we don't have a console to print to.
> > Attached patch should fix the problem.
> > 
> 
> Note, your patch changes the logic a bit. It causes the
> mutex_acquire(&console_lock_dep_map) to happen on console_suspend,
> which the original code never did.
  Yes, I know. That's actually intentional and also fixes a lockdep warning
- there was a separate patch doing exactly that flying around because
otherwise when you suspend-resume & CPU hotplug, lockdep complains because
of some cpu hotplug locks. Maybe I should note that in a changelog.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
