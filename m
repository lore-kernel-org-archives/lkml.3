Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbaITPrm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 11:47:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44223 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaITPrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 11:47:41 -0400
Date: Sat, 20 Sep 2014 17:47:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140920154733.GM2832@worktop.localdomain>
References: <20140916203510.GF1205@quack.suse.cz>
 <20140916170709.73ef2993@gandalf.local.home>
 <20140916212250.GI1205@quack.suse.cz>
 <20140916173328.6306a5c2@gandalf.local.home>
 <20140917141816.GO2840@worktop.localdomain>
 <20140917102255.5cd03071@gandalf.local.home>
 <20140917223633.GE2848@worktop.localdomain>
 <20140917203135.6db2ee5e@gandalf.local.home>
 <20140918173414.GU2840@worktop.localdomain>
 <20140920051224.GA5573@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140920051224.GA5573@quack.suse.cz>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 07:12:24AM +0200, Jan Kara wrote:
> On Thu 18-09-14 19:34:14, Peter Zijlstra wrote:
> > On Wed, Sep 17, 2014 at 08:31:35PM -0400, Steven Rostedt wrote:
> > > I totally didn't get what you wrote.
> > 
> > :-)
> > 
> > > We don't want to know if it got delayed, then the patch to remove that
> > > print seems correct.
> > 
> > Why would you not want to know that? Also was that the actual argument?
> > Lemme go check the earlier emails -- I cannot find that argument in the
> > first few emails.
>   Well, so what gets delayed is printing from kernel buffer to console.
> So this is the same as when you do printk() when console lock is taken by
> someone else. So it seems a bit strange to prepend [delayed] in some cases
> and not in others.

The difference is that when someone else has the console lock, he
guarantees it gets out. Whereas with the delayed thing it can take a
virtual forever to get out.

> Another question is what the [delayed] prefix would be useful for? If the
> message eventually gets printed to console I don't see why you would care
> it was printed few ms after it entered the kernel buffer (after all the
> time stamp before the line will be the time when it entered the kernel
> buffer). And if the kernel crashes in such a way that the message doesn't
> get printed, then bad luck but prefix in the kernel log buffer isn't going
> to make that any better :)
> 
> This all feels like bikeshedding, I don't deeply care what gets done but I
> wanted to point out I don't really see a use for [delayed]...

Sure, I was just pointing out that those arguments had not been made. I
think you're right, if you see the msg it obviously made it out. If you
don't see it, you don't know either way.

But a patch removing it _must_ make those arguments, it did not.

On a whole, printk() is entirely useless for debugging these days, its
far too fragile/unreliable to be taken seriously so I really don't care
on that point either.
