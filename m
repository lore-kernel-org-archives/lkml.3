Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3FEHia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:38:30 -0400
Received: from ozlabs.org ([203.10.76.45]:54693 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370Ab3FEHi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:38:27 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <gregkh@linuxfoundation.org>,
        Joe Lawrence <joe.lawrence@stratus.com>
Cc: Ben Greear <greearb@candelatech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: Please add to stable:  module: don't unlink the module until we've removed all exposure.
In-Reply-To: <20130605050719.GC10475@kroah.com>
References: <51A8E884.1080009@candelatech.com> <87ehclumhr.fsf@rustcorp.com.au> <alpine.DEB.2.02.1306022212200.10003@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306030724230.19647@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306031012460.22652@jlaw-desktop.mno.stratus.com> <20130605050719.GC10475@kroah.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 05 Jun 2013 16:43:14 +0930
Message-ID: <87k3m9rpx1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:
> On Mon, Jun 03, 2013 at 10:17:17AM -0400, Joe Lawrence wrote:
>> [Cc: stable@vger.kernel.org]
>> 
>> Third time is a charm?  The stable address was incorrect from the first 
>> msg in this thread, but the relevant bits remain quoted below...
>
> Really?  I'm totally confused...
>
>> On Mon, 3 Jun 2013, Joe Lawrence wrote:
>> 
>> > [fixing Cc: stable@kernel.org address]
>> > 
>> > On Sun, 2 Jun 2013, Joe Lawrence wrote:
>> > 
>> > > On Sun, 2 Jun 2013, Rusty Russell wrote:
>> > > 
>> > > > Ben Greear <greearb@candelatech.com> writes:
>> > > > 
>> > > > > It turns out, the bug I spent yesterday chasing in various 3.9 kernels is apparently
>> > > > > fixed by the commit in the title (c9c390bb5535380d40614571894ef0c00bc026ff).
>> > > > 
>> > > > Apparently being the operative word.
>> > > > 
>> > > > This commit avoids the entire "module insert failed due to sysfs race"
>> > > > path in the common case, it doesn't fix any actual problem.
>> > > > 
>> > > > I think the real commit you want is Linus' kobject fix
>> > > > a49b7e82cab0f9b41f483359be83f44fbb6b4979 "kobject: fix kset_find_obj()
>> > > > race with concurrent last kobject_put()".
>> > > > 
>> > > > Or is that already in stable?
>> > > 
>> > > Hi Rusty,
>> > >  
>> > > I had pointed Ben (offlist) to that bugzilla entry without realizing
>> > > there were other earlier related fixes in this space.  Re-viewing bz-
>> > > 58011, it looks like it was opened against 3.8.12, while Ben and myself
>> > > had encountered module loading problems in versions 3.9 and
>> > > 3.9.[1-3].  I can update the bugzilla entry to add a comment noting commit
>> > > a49b7e82 "kobject: fix kset_find_obj() race with concurrent last
>> > > kobject_put()".
>> > > 
>> > > That said, it doesn't appear that commit 944a1fa "module: don't unlink the
>> > > module until we've removed all exposure" has not made it into any stable  
>> > > kernel.  On my system, applying this on top of 3.9 resolved a module
>> > > unload/load race that would occasionally occur on boot (two video adapters
>> > > of the same make, the module unloads for whatever reason and I see "module
>> > > is already loaded" and "sysfs: cannot create duplicate filename
>> > > '/module/mgag200'" messages every 5-10% instances.)  I have logs if you
>> > > were interested in these warnings/crashes.
>> > > 
>> > > Hope this clarifies things.
>
> After this whole thread, what should I be doing for the 3.9-stable tree?
> Add commit 944a1fa?  Or something else?

Yes.  It does fix an Oops unrelated to what it was intended to fix, so
it's the lowest pain path.

There may be other ways of triggering a similar oops, but do far the
obvious attempt has failed (holding a sysfs file open while a module
fails its init).  I might patch it anyway, because it makes me
uncomfortable, but that's separate.

Thanks,
Rusty.
