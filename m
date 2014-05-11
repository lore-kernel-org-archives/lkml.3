Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbaEKRC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 13:02:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46503 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaEKRC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 13:02:56 -0400
Date: Sun, 11 May 2014 19:02:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <mgalbraith@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] CPU hotplug: Slow down hotplug operations
Message-ID: <20140511170234.GA2681@xo-6d-61-c0.localdomain>
References: <1399492661-891-1-git-send-email-bp@alien8.de>
 <20140507130655.9f7c46de8cb39726079458fb@linux-foundation.org>
 <alpine.DEB.2.02.1405072214420.6261@ionos.tec.linutronix.de>
 <20140507202655.GI16722@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507202655.GI16722@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-05-07 22:26:55, Borislav Petkov wrote:
> On Wed, May 07, 2014 at 10:22:33PM +0200, Thomas Gleixner wrote:
> > On Wed, 7 May 2014, Andrew Morton wrote:
> > > On Wed,  7 May 2014 21:57:41 +0200 Borislav Petkov <bp@alien8.de> wrote:
> > > 
> > > > We have all those eager tester dudes which scratch up a dirty script to
> > > > pound on CPU hotplug senselessly and then report bugs they've managed to
> > > > trigger.
> > > > 
> > > > Well, first of all, most, if not all, bugs they trigger are CPU hotplug
> > > > related anyway. But we know hotplug is full of duct tape and brown
> > > > paper bags. So we end up clearly wasting too much time dealing with a
> > > > mechanism we know it is b0rked in the first place.
> > > > 
> > > > Oh, and I would understand if that pounding were close to some real
> > > > usage patterns but I've yet to receive a justification for toggling
> > > > cores on- and offline senselessly.
> > > > 
> > > > In any case, before this gets rewritten properly (I'm being told we
> > > > might get lucky after all) let's slow down hotplugging on purpose and
> > > > thus make it uninteresting, as a temporary brown paper bag solution
> > > > until the real thing gets done.
> > > > 
> > > > This way we'll save us a lot of time and efforts in chasing the wrong
> > > > bugs.
> > > 
> > > Well, I only yesterday merged Srivatsa's `CPU hotplug, stop-machine:
> > > plug race-window that leads to "IPI-to-offline-CPU"' bugfix.  That bug
> > > presumably wouldn't have been fixed if this patch was in place.
> > 
> > True.
> > 
> > OTOH, if people would have spent the same amount of time to rewrite
> > the hotplug mess, we would have a way bigger benefit. But no, we
> > prefer to add more layers of duct tape and bandaid hackery to it. 
> > 
> > I tried a redesign and run out of cycles, but the patches are out
> > there and none of the folks who promised to complete them ever
> > delivered. If nothing fundamental changes, I'm going to spend some
> > serious time on it in the next couple of month.
> 
> ... and in the interim, we could slow down the duct tape and bandaid
> hackery until it gets rewritten properly. The ever increasing in
> complexity bugfixes say exactly that - it needs a long hard look and a
> rewrite.

Well. If you add the delay, you'll mask real problems and cause regressions when
the delay is removed -- because fix-hotplug will probably take time to get right.

Bad idea, AFAICT.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
