Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbbAVPPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:15:39 -0500
Received: from smtprelay0130.hostedemail.com ([216.40.44.130]:44411 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752209AbbAVPPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:15:34 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2693:2898:2901:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4362:5007:6119:6261:7807:7875:7903:10004:10400:10848:10967:11232:11658:11914:12296:12485:12517:12519:12663:12740:13618:14040:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: river91_6a8825b65b53a
X-Filterd-Recvd-Size: 3681
Date: Thu, 22 Jan 2015 10:15:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] tracing: Add new file system tracefs
Message-ID: <20150122101530.2175cf2b@gandalf.local.home>
In-Reply-To: <20150122145547.GB4507@htj.dyndns.org>
References: <20150121171953.823177070@goodmis.org>
	<20150121230007.GA10389@kroah.com>
	<20150121204725.71933044@grimm.local.home>
	<20150121220701.22231849@grimm.local.home>
	<20150122031819.GA16561@kroah.com>
	<20150121225109.6b27b555@grimm.local.home>
	<20150122123212.GB25645@htj.dyndns.org>
	<20150122093249.6f4041a8@gandalf.local.home>
	<20150122145547.GB4507@htj.dyndns.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015 09:55:47 -0500
Tejun Heo <tj@kernel.org> wrote:

> kernfs provides two sets of file operations.  One is seq_file based
> and the other is direct read/write.  In both cases, bouncing data
> between userland and kernel is handled by kernfs.  If you already have
> existing read write ops implemented doing custom buffer handling and
> direct userland memory access, it'll take some adaptation but for a
> lot of cases this would consolidate duplicate code paths.

Does it also handle splice? That's a key part of the tracing code.

Almost every tracing file is somewhat unique. When things can be
shared, they are, but there's not much generic code that can be shared.

> 
> > I created tracefs with 700 lines of code and two files (inode.c and
> > tracefs.h), and for the users of tracefs, I just did
> > s/debugfs/tracefs/. If I can't make that substitution for the users,
> > that is a show stopper.
> > 
> > I don't see how I can use kernfs without it causing a lot of invasive
> > changes to the ftrace subsystem.
> 
> Converting an existing vfs based pseudo fs implementation over to
> kernfs isn't trivial.  I mean, if that were trivial, why would kernfs
> even exist?  kernfs is a layer which abstracts a large part of pseudo
> filesystem which provides extra features like significantly lower
> memory footprint with large number of nodes and revocation support in
> a way that its users, for the most part, hopefully, only have to worry
> about the content to provide to userland.

Sounds like some of the tracing files could benefit from this. But I'm
not sure kernfs has all the necessary features I need.

> 
> I frankly have no idea whether tracefs would be a good candidate for
> kernfs usage but if you're looking for a mechanical one-to-one
> conversion from vfs based implementation, that's not gonna work.

OK, thanks. Perhaps if tracing was still new I could have tried to go
with kernfs. But as debugfs was such a simple to use interface, it let
me concentrate more on the complexities of tracing itself instead of
spending time coming up with a complex interface.

If a one to one conversion to vfs is not gonna work, I'm going to be
interested in seeing how debugfs will be converted.

Anyway, I think I'm convinced that kernfs is not yet the way to go. I'm
going to continue on with my current path.

Thanks,

-- Steve
