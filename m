Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbaITSCB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 14:02:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:46822 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153AbaITSCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 14:02:00 -0400
Date: Sat, 20 Sep 2014 20:01:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140920180148.GP2832@worktop.localdomain>
References: <20140916212250.GI1205@quack.suse.cz>
 <20140916173328.6306a5c2@gandalf.local.home>
 <20140917141816.GO2840@worktop.localdomain>
 <20140917102255.5cd03071@gandalf.local.home>
 <20140917223633.GE2848@worktop.localdomain>
 <20140917203135.6db2ee5e@gandalf.local.home>
 <20140918173414.GU2840@worktop.localdomain>
 <20140920051224.GA5573@quack.suse.cz>
 <20140920154733.GM2832@worktop.localdomain>
 <1411229447.24444.53.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411229447.24444.53.camel@joe-AO725>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 09:10:47AM -0700, Joe Perches wrote:
> On Sat, 2014-09-20 at 17:47 +0200, Peter Zijlstra wrote:
> > On a whole, printk() is entirely useless for debugging these days, its
> > far too fragile/unreliable to be taken seriously so I really don't care
> > on that point either.
> 
> That's unfortunate.
> 
> Care to enumerate the issues that you believe make
> printk too fragile/unreliable for debugging?

Look at what it takes to end up at console->write(), and then realize
that some console implementations require scheduling and other nonsense
to actually implement ->write().

The (only) reliable option is early_printk() with the
early_serial_console driver. The rest is useless crap these days.
