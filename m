Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab3AaAOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 19:14:07 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59523 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3AaAOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:14:05 -0500
Date: Thu, 31 Jan 2013 00:13:40 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Dave Airlie <airlied@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: BUG: circular locking dependency detected
Message-ID: <20130131001339.GC14801@flint.arm.linux.org.uk>
References: <20130130200648.GA13298@flint.arm.linux.org.uk> <20130130215211.GA28418@flint.arm.linux.org.uk> <CAKMK7uHEggaGfLTq4c3MfY7csQSFpb=kRwdbJUQMN9Cz9K=V4A@mail.gmail.com> <20130130221946.GA14801@flint.arm.linux.org.uk> <CA+55aFyRHK3dmwQf_mdfB18dmoaRZqBG9FvHRqTs7cqBjgUs+g@mail.gmail.com> <CAPM=9tz6YBh2o3T8Ogt4K=wxSrC3Jc4PCJMzfpbyY=B132fA5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tz6YBh2o3T8Ogt4K=wxSrC3Jc4PCJMzfpbyY=B132fA5g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 10:04:05AM +1000, Dave Airlie wrote:
> On Thu, Jan 31, 2013 at 9:52 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Thu, Jan 31, 2013 at 9:19 AM, Russell King <rmk@arm.linux.org.uk> wrote:
> >>
> >> So... what you seem to be telling me is that 3.9 is going to be a
> >> release which issues lockdep complaints when the console blanks, and
> >> you think that's acceptable?
> >>
> >> Adding Linus and Andrew so they're aware of this issue...
> >
> > Oh, we're extremely aware of it. And it's not a new issue, the locking
> > problem have apparently been around forever, although I'm not sure why
> > the lockdep splat itself started happening only recently.
> >
> > They'll make it into 3.9, it's 3.8 that won't have them. The patches
> > initially caused way *worse* behavior than just a lockdep splat - they
> > caused actual hard lockups (and that was *after* the initial series of
> > fixes). That got fixed (hopefully for the last case!) fairly recently,
> > and I'm not willing to take the scary patch-series that has had
> > several problem cases.
> 
> Well we didn't have any lock validation support before Daniel added it
> a couple of kernels back,
> so instead of hidden locking problems we've had from time began, we now have
> lockdep detectable locking problems.

Which may or may not be a good thing depending how you look at it; it
means that once your kernel blanks, you get a lockdep dump.  At that
point you lose lockdep checking for everything else because lockdep
disables itself after the first dump.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
