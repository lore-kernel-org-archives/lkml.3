Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbaFNPbH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 11:31:07 -0400
Received: from www17.your-server.de ([213.133.104.17]:34519 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbaFNPbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 11:31:03 -0400
Message-ID: <1402759854.2757.3.camel@localhost.localdomain>
Subject: Re: [Intel-gfx] 3.15-rc5: Regression in i915 driver?
From: Thomas Meyer <thomas@m3y3r.de>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Jun 2014 17:30:54 +0200
In-Reply-To: <20140519070705.GA8790@phenom.ffwll.local>
References: <1399796911.2442.7.camel@localhost.localdomain>
	 <CAPM=9tzwkwSTC2i=KWSxmHkG74fXyyh8JiTzEaDwNgg-J_G7cw@mail.gmail.com>
	 <CAKMK7uG4Gnn_sY44Ci8VbRhJQf8=5s_dod4tRX+PDYYs1EYFsQ@mail.gmail.com>
	 <20140512063355.GA3813@nuc-i3427.alporthouse.com>
	 <1400440120.3400.5.camel@localhost.localdomain>
	 <20140518191338.GA11754@nuc-i3427.alporthouse.com>
	 <20140519070705.GA8790@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 19.05.2014, 09:07 +0200 schrieb Daniel Vetter:
> On Sun, May 18, 2014 at 08:13:38PM +0100, Chris Wilson wrote:
> > On Sun, May 18, 2014 at 09:08:40PM +0200, Thomas Meyer wrote:
> > > Am Montag, den 12.05.2014, 07:33 +0100 schrieb Chris Wilson:
> > > > On Sun, May 11, 2014 at 07:40:57PM +0200, Daniel Vetter wrote:
> > > > > On Sun, May 11, 2014 at 11:02 AM, Dave Airlie <airlied@gmail.com> wrote:
> > > > > > On 11 May 2014 18:28, Thomas Meyer <thomas@m3y3r.de> wrote:
> > > > > >> Hi,
> > > > > >>
> > > > > >> 3.14.3 works as expected.
> > > > > >> 3.15-rc5 shows a strange behaviour: When resuming from ram the X server
> > > > > >> seems to be disfunctional.
> > > > > >>
> > > > > >> I see this WARNING in the kernel log before suspend to ram in the early
> > > > > >> boot process:
> > > > > 
> > > > > Doesn't ring a bell really.
> > > > 
> > > > Same symptoms as
> > > > https://bugs.freedesktop.org/show_bug.cgi?id=76554
> > > > -Chris
> > > > 
> > > 
> > > bisected this to:
> > > # first bad commit: [78f2975eec9faff353a6194e854d3d39907bab68] drm/i915: Move all ring resets before setting the HWS page
> > > 
> > > commit 78f2975eec9faff353a6194e854d3d39907bab68
> > > Author: Chris Wilson <chris@chris-wilson.co.uk>
> > > Date:   Wed Apr 2 16:36:07 2014 +0100
> > > 
> > >     drm/i915: Move all ring resets before setting the HWS page
> > >     
> > >     In commit a51435a3137ad8ae75c288c39bd2d8b2696bae8f
> > >     Author: Naresh Kumar Kachhi <naresh.kumar.kachhi@intel.com>
> > >     Date:   Wed Mar 12 16:39:40 2014 +0530
> > >     
> > >         drm/i915: disable rings before HW status page setup
> > >     
> > >     we reordered stopping the rings to do so before we set the HWS register.
> > >     However, there is an extra workaround for g45 to reset the rings twice,
> > >     and for consistency we should apply that workaround before setting the
> > >     HWS to be sure that the rings are truly stopped.
> > >     
> > >     Reference: http://lkml.kernel.org/r/20140423202248.GA3621@amd.pavel.ucw.cz
> > >     Tested-by: Pavel Machek <pavel@ucw.cz>
> > >     Cc: Naresh Kumar Kachhi <naresh.kumar.kachhi@intel.com>
> > >     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > >     Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > >     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > >     Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> > > 
> > > Reverting above commit from current linus' master tree makes the display server behave correctly after resume from ram.
> > 
> > Boot time regression trumps resume regression? Doubly-so as we have an
> > earlier resume regression with identical symptoms?
> 
> I'll check on my gm45 - that has has become much more crashy ime in 3.15
> somehow, with ring init failures.
> -Daniel

Hi,

any news on this?

I still need to revert above commit to have a workable config in 3.15.0

I just wanted to update to current linus' tree and got this:

Aktualisiere 5c02c39..6391f34
error: Your local changes to the following files would be overwritten by
merge:
	drivers/gpu/drm/i915/i915_reg.h
	drivers/gpu/drm/i915/intel_ringbuffer.c
	drivers/gpu/drm/i915/intel_ringbuffer.h
Please, commit your changes or stash them before you can merge.
Aborting

I looks like many commits happened here.

What should I do now? test the current tree?

with kind regards
thomas



