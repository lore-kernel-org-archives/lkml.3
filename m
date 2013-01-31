Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab3AaNAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 08:00:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:33356 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab3AaNAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 08:00:12 -0500
Date: Thu, 31 Jan 2013 14:02:06 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: BUG: circular locking dependency detected
Message-ID: <20130131130206.GB13352@kroah.com>
References: <CAKMK7uHEggaGfLTq4c3MfY7csQSFpb=kRwdbJUQMN9Cz9K=V4A@mail.gmail.com>
 <20130130221946.GA14801@flint.arm.linux.org.uk>
 <CA+55aFyRHK3dmwQf_mdfB18dmoaRZqBG9FvHRqTs7cqBjgUs+g@mail.gmail.com>
 <CAPM=9tz6YBh2o3T8Ogt4K=wxSrC3Jc4PCJMzfpbyY=B132fA5g@mail.gmail.com>
 <20130131001339.GC14801@flint.arm.linux.org.uk>
 <CA+55aFxfeXWAiXV18qGgOk9+2HHiD7LUuyk55brHFXd+_c6eZQ@mail.gmail.com>
 <20130131054002.GA3697@kroah.com>
 <CAKMK7uGUrvh2dXza_b288kVdztiLjSCNpH304oBQgg_ZonEnzw@mail.gmail.com>
 <20130131092146.GB3361@kroah.com>
 <CAPM=9tzZLPZ0EqEvEuZbimomSQv+xMnLpTq28z7=bKBF1w26TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tzZLPZ0EqEvEuZbimomSQv+xMnLpTq28z7=bKBF1w26TQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 10:51:27PM +1100, Dave Airlie wrote:
> On Thu, Jan 31, 2013 at 8:21 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Jan 31, 2013 at 09:21:16AM +0100, Daniel Vetter wrote:
> >> On Thu, Jan 31, 2013 at 6:40 AM, Greg Kroah-Hartman
> >> <gregkh@linuxfoundation.org> wrote:
> >> > On Thu, Jan 31, 2013 at 11:26:53AM +1100, Linus Torvalds wrote:
> >> >> On Thu, Jan 31, 2013 at 11:13 AM, Russell King <rmk@arm.linux.org.uk> wrote:
> >> >> >
> >> >> > Which may or may not be a good thing depending how you look at it; it
> >> >> > means that once your kernel blanks, you get a lockdep dump.  At that
> >> >> > point you lose lockdep checking for everything else because lockdep
> >> >> > disables itself after the first dump.
> >> >>
> >> >> Fair enough, we may want to revert the lockdep checking for
> >> >> console_lock, and make re-enabling it part of the patch-series that
> >> >> fixes the locking.
> >> >>
> >> >> Daniel/Dave? Does that sound reasonable?
> >>
> >> Yeah, sounds good.
> >>
> >> > Reverting the patch is fine with me.  Just let me know so I can queue it
> >> > up again for 3.9.
> >>
> >> Can you please also pick up the (currently) three locking fixups
> >> around fbcon? Just so that we don't repeat the same fun where people
> >> complain about lockdep splats, but the fixes are stuck somewhere. And
> >> I guess Dave would be happy to not end up as fbcon maintainer ;-) He
> >> has a git branch with them at
> >> http://cgit.freedesktop.org/~airlied/linux/log/?h=fbcon-locking-fixes
> >> though I have a small bikeshed on his last patch pending.
> >
> > Care to just send me the patches through email when you all get done
> > bikesheding?  And for some reason I thought Andrew was going to handle
> > these fbcon patches, but if not, I'll be glad to take them.
> 
> I'll ship them via my tree at this point I think, since I now need to
> queue a revert of the revert on top.
> 
> I have a few vgacon/fbcon fixes that I need to go in this cycle.

Ok, I'll gladly let you handle this :)

thanks,

greg k-h
