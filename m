Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbaF3KCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 06:02:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55430 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbaF3KCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:02:22 -0400
Date: Mon, 30 Jun 2014 12:02:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Chris Wilson <chris@chris-wilson.co.uk>, Thomas Meyer <thomas@m3y3r.de>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: jikos@suse.cz
Subject: Re: [Intel-gfx] Linux 3.16-rc2
Message-ID: <20140630100220.GA4934@xo-6d-61-c0.localdomain>
References: <CA+55aFxdAhp-esuGiY4VEugiiwcMJgg1r6fPiR9Fb+HOz_5tLg@mail.gmail.com>
 <1403564870.3091.6.camel@localhost.localdomain>
 <871tuea7nz.fsf@intel.com>
 <20140624115753.GD17674@nuc-i3427.alporthouse.com>
 <1403612670.3091.10.camel@localhost.localdomain>
 <20140624122737.GF17674@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140624122737.GF17674@nuc-i3427.alporthouse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-06-24 13:27:37, Chris Wilson wrote:
> On Tue, Jun 24, 2014 at 02:24:30PM +0200, Thomas Meyer wrote:
> > Am Dienstag, den 24.06.2014, 12:57 +0100 schrieb Chris Wilson:
> > > On Tue, Jun 24, 2014 at 02:06:24PM +0300, Jani Nikula wrote:
> > > > On Tue, 24 Jun 2014, Thomas Meyer <thomas@m3y3r.de> wrote:
> > > > > the i915 driver is still broken in 3.16-rc2. Resume from ram crashes the
> > > > > X server.
> > > > 
> > > > This is not new to 3.16-rc2; apparently we've had it since v3.15-rc4
> > > > [1]. Also related [2].
> > > > 
> > > > Chris, any fresh ideas?
> > > 
> > > Nope. The bug is https://bugs.freedesktop.org/show_bug.cgi?id=76554
> > > everything we know and have tried is there. Which is not much more than
> > > at time of the original incarnation:
> > > 
> > > commit 50aa253d820ad4577e2231202f2c8fd89f9dc4e6
> > > Author: Keith Packard <keithp@keithp.com>
> > > Date:   Tue Oct 14 17:20:35 2008 -0700
> > > 
> > >     i915: Fix up ring initialization to cover G45 oddities
> > >     
> > >     G45 appears quite sensitive to ring initialization register writes,
> > >     sometimes leaving the HEAD register with the START register contents. Check
> > >     to make sure HEAD is reset correctly when START is written, and fix it up,
> > >     screaming loudly.
> > > -Chris
> > > 
> > 
> > Hi,
> > 
> > so why not revert 78f2975eec9faff353a6194e854d3d39907bab68 (drm/i915:
> > Move all ring resets before setting the HWS page) ?
> 
> Because that patch was in response to a boot time regression.

It seems we are in a fairly ugly "fix one board, it breaks another" iterations, right?

(BTW, if you apply patch to fix this bug, could you Cc me? I have strange feeling
that it will break my setup... Actually, it probably makes sense to Cc all the people
who reported problems with ring initialization...

What patch caused the boot time regression you are talking about? We need to get 
list of commits involved in this, and revert the original one...

Jiri Kosina may have the same problem, right?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
