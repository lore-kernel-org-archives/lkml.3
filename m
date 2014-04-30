Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbaD3INB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:13:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:54030 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbaD3IM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:12:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,956,1389772800"; 
   d="scan'208";a="425791455"
Message-ID: <1398845573.23470.3.camel@smile.fi.intel.com>
Subject: Re: lockdep warning after recent cleanup in console code
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Wed, 30 Apr 2014 11:12:53 +0300
In-Reply-To: <20140429210750.GE29634@quack.suse.cz>
References: <1398702925.11914.292.camel@smile.fi.intel.com>
	 <20140428134331.68771bf7@gandalf.local.home>
	 <20140428175139.GD9091@quack.suse.cz>
	 <20140428141439.3580dce9@gandalf.local.home>
	 <20140428192416.GE9091@quack.suse.cz>
	 <1398760684.23470.1.camel@smile.fi.intel.com>
	 <20140429210750.GE29634@quack.suse.cz>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-29 at 23:07 +0200, Jan Kara wrote:
> On Tue 29-04-14 11:38:04, Andy Shevchenko wrote:
> > On Mon, 2014-04-28 at 21:24 +0200, Jan Kara wrote:
> > > On Mon 28-04-14 14:14:39, Steven Rostedt wrote:
> > > > On Mon, 28 Apr 2014 19:51:39 +0200
> > > > Jan Kara <jack@suse.cz> wrote:
> > > > 
> > > > > On Mon 28-04-14 13:43:31, Steven Rostedt wrote:
> > > > > > Things have changed with regard to printk() in linux-next. Now it
> > > > > > appears that lockdep is going haywire over it. I don't understand the
> > > > > > exact reason for the lockdep_off() and lockdep_on() logic that is in
> > > > > > printk(), but it obviously seems to be causing issues with the new
> > > > > > changes.
> > > > > > 
> > > > > > Care to take a look?
> > > > >   The obvious cause is that I moved lockdep_on() somewhat earlier in
> > > > > vprintk_emit() so lockdep now covers more of printk code. And apparently
> > > > > something is wrong there...
> > > > > 
> > > > 
> > > > Exactly, and I rather know *exactly* what is wrong before we just start
> > > > throwing patches at the problem and hope it goes away. That's not how
> > > > to solve a software bug.
> > >   So I had a look and we are missing mutex_release() in
> > > console_trylock_for_printk() if we don't have a console to print to.
> > > Attached patch should fix the problem.
> > 
> > Besides it doesn't apply clearly on top of today's linux-next, it
> > doesn't fix the issue, but modifies it a bit.
>   Sorry, I was too tired and missed conversion of one place. Attached is a
> new version of the patch which also applies cleanly against linux-next.

Either you decide to revert, not apply or leave as is that patch that
prevents to apply clearly, this one seems good.

Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

