Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbaITFMa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 01:12:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbaITFM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 01:12:29 -0400
Date: Sat, 20 Sep 2014 07:12:24 +0200
From: Jan Kara <jack@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jan Kara <jack@suse.cz>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140920051224.GA5573@quack.suse.cz>
References: <20140916111331.14303381@gandalf.local.home>
 <20140916203510.GF1205@quack.suse.cz>
 <20140916170709.73ef2993@gandalf.local.home>
 <20140916212250.GI1205@quack.suse.cz>
 <20140916173328.6306a5c2@gandalf.local.home>
 <20140917141816.GO2840@worktop.localdomain>
 <20140917102255.5cd03071@gandalf.local.home>
 <20140917223633.GE2848@worktop.localdomain>
 <20140917203135.6db2ee5e@gandalf.local.home>
 <20140918173414.GU2840@worktop.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918173414.GU2840@worktop.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 18-09-14 19:34:14, Peter Zijlstra wrote:
> On Wed, Sep 17, 2014 at 08:31:35PM -0400, Steven Rostedt wrote:
> > I totally didn't get what you wrote.
> 
> :-)
> 
> > We don't want to know if it got delayed, then the patch to remove that
> > print seems correct.
> 
> Why would you not want to know that? Also was that the actual argument?
> Lemme go check the earlier emails -- I cannot find that argument in the
> first few emails.
  Well, so what gets delayed is printing from kernel buffer to console.
So this is the same as when you do printk() when console lock is taken by
someone else. So it seems a bit strange to prepend [delayed] in some cases
and not in others.

Another question is what the [delayed] prefix would be useful for? If the
message eventually gets printed to console I don't see why you would care
it was printed few ms after it entered the kernel buffer (after all the
time stamp before the line will be the time when it entered the kernel
buffer). And if the kernel crashes in such a way that the message doesn't
get printed, then bad luck but prefix in the kernel log buffer isn't going
to make that any better :)

This all feels like bikeshedding, I don't deeply care what gets done but I
wanted to point out I don't really see a use for [delayed]...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
