Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbaITSIM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 14:08:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:46864 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794AbaITSIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 14:08:10 -0400
Date: Sat, 20 Sep 2014 20:08:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Joe Perches <joe@perches.com>, Jan Kara <jack@suse.cz>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140920180800.GS2832@worktop.localdomain>
References: <20140916173328.6306a5c2@gandalf.local.home>
 <20140917141816.GO2840@worktop.localdomain>
 <20140917102255.5cd03071@gandalf.local.home>
 <20140917223633.GE2848@worktop.localdomain>
 <20140917203135.6db2ee5e@gandalf.local.home>
 <20140918173414.GU2840@worktop.localdomain>
 <20140920051224.GA5573@quack.suse.cz>
 <20140920154733.GM2832@worktop.localdomain>
 <1411229447.24444.53.camel@joe-AO725>
 <20140920123001.4ac60dba@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140920123001.4ac60dba@gandalf.local.home>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 12:30:01PM -0400, Steven Rostedt wrote:
> On Sat, 20 Sep 2014 09:10:47 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > On Sat, 2014-09-20 at 17:47 +0200, Peter Zijlstra wrote:
> > > On a whole, printk() is entirely useless for debugging these days, its
> > > far too fragile/unreliable to be taken seriously so I really don't care
> > > on that point either.
> > 
> > That's unfortunate.
> > 
> > Care to enumerate the issues that you believe make
> > printk too fragile/unreliable for debugging?
> 
> I seldom use printk these days. It's far too limited in its uses. For
> one, most things worth debugging happen thousands of times a second,
> and printk will just slow things down to a crawl if it is used.
> Another, is that it can not be used in most critical sections (NMI
> handlers and anything that deals with the scheduler). Also, as it no
> longer blocks when another CPU is doing a printk, a bug can happen
> which crashes the system and the output of that bug will never get
> printed due to the delayed output from another CPU having the console
> lock.

If you're trying to debug a dying machine the early_serial_console which
basically only does a stream of OUTBs to the right port is the only
reliable thing. For anything else, trace_printk().

Now all I need to figure out is how to keep suspend from killing the
early_serial_console setup :-)
