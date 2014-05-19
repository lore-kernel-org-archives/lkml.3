Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbaESHHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 03:07:12 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:58255 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaESHHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 03:07:10 -0400
Date: Mon, 19 May 2014 09:07:05 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>, Thomas Meyer <thomas@m3y3r.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] 3.15-rc5: Regression in i915 driver?
Message-ID: <20140519070705.GA8790@phenom.ffwll.local>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Thomas Meyer <thomas@m3y3r.de>, Dave Airlie <airlied@gmail.com>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1399796911.2442.7.camel@localhost.localdomain>
 <CAPM=9tzwkwSTC2i=KWSxmHkG74fXyyh8JiTzEaDwNgg-J_G7cw@mail.gmail.com>
 <CAKMK7uG4Gnn_sY44Ci8VbRhJQf8=5s_dod4tRX+PDYYs1EYFsQ@mail.gmail.com>
 <20140512063355.GA3813@nuc-i3427.alporthouse.com>
 <1400440120.3400.5.camel@localhost.localdomain>
 <20140518191338.GA11754@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140518191338.GA11754@nuc-i3427.alporthouse.com>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 08:13:38PM +0100, Chris Wilson wrote:
> On Sun, May 18, 2014 at 09:08:40PM +0200, Thomas Meyer wrote:
> > Am Montag, den 12.05.2014, 07:33 +0100 schrieb Chris Wilson:
> > > On Sun, May 11, 2014 at 07:40:57PM +0200, Daniel Vetter wrote:
> > > > On Sun, May 11, 2014 at 11:02 AM, Dave Airlie <airlied@gmail.com> wrote:
> > > > > On 11 May 2014 18:28, Thomas Meyer <thomas@m3y3r.de> wrote:
> > > > >> Hi,
> > > > >>
> > > > >> 3.14.3 works as expected.
> > > > >> 3.15-rc5 shows a strange behaviour: When resuming from ram the X server
> > > > >> seems to be disfunctional.
> > > > >>
> > > > >> I see this WARNING in the kernel log before suspend to ram in the early
> > > > >> boot process:
> > > > 
> > > > Doesn't ring a bell really.
> > > 
> > > Same symptoms as
> > > https://bugs.freedesktop.org/show_bug.cgi?id=76554
> > > -Chris
> > > 
> > 
> > bisected this to:
> > # first bad commit: [78f2975eec9faff353a6194e854d3d39907bab68] drm/i915: Move all ring resets before setting the HWS page
> > 
> > commit 78f2975eec9faff353a6194e854d3d39907bab68
> > Author: Chris Wilson <chris@chris-wilson.co.uk>
> > Date:   Wed Apr 2 16:36:07 2014 +0100
> > 
> >     drm/i915: Move all ring resets before setting the HWS page
> >     
> >     In commit a51435a3137ad8ae75c288c39bd2d8b2696bae8f
> >     Author: Naresh Kumar Kachhi <naresh.kumar.kachhi@intel.com>
> >     Date:   Wed Mar 12 16:39:40 2014 +0530
> >     
> >         drm/i915: disable rings before HW status page setup
> >     
> >     we reordered stopping the rings to do so before we set the HWS register.
> >     However, there is an extra workaround for g45 to reset the rings twice,
> >     and for consistency we should apply that workaround before setting the
> >     HWS to be sure that the rings are truly stopped.
> >     
> >     Reference: http://lkml.kernel.org/r/20140423202248.GA3621@amd.pavel.ucw.cz
> >     Tested-by: Pavel Machek <pavel@ucw.cz>
> >     Cc: Naresh Kumar Kachhi <naresh.kumar.kachhi@intel.com>
> >     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> >     Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> >     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> >     Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> > 
> > Reverting above commit from current linus' master tree makes the display server behave correctly after resume from ram.
> 
> Boot time regression trumps resume regression? Doubly-so as we have an
> earlier resume regression with identical symptoms?

I'll check on my gm45 - that has has become much more crashy ime in 3.15
somehow, with ring init failures.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
