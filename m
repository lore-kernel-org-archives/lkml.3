Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaERTNt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 15:13:49 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:58104 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751766AbaERTNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 15:13:48 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Sun, 18 May 2014 20:13:38 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] 3.15-rc5: Regression in i915 driver?
Message-ID: <20140518191338.GA11754@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Thomas Meyer <thomas@m3y3r.de>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1399796911.2442.7.camel@localhost.localdomain>
 <CAPM=9tzwkwSTC2i=KWSxmHkG74fXyyh8JiTzEaDwNgg-J_G7cw@mail.gmail.com>
 <CAKMK7uG4Gnn_sY44Ci8VbRhJQf8=5s_dod4tRX+PDYYs1EYFsQ@mail.gmail.com>
 <20140512063355.GA3813@nuc-i3427.alporthouse.com>
 <1400440120.3400.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400440120.3400.5.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 09:08:40PM +0200, Thomas Meyer wrote:
> Am Montag, den 12.05.2014, 07:33 +0100 schrieb Chris Wilson:
> > On Sun, May 11, 2014 at 07:40:57PM +0200, Daniel Vetter wrote:
> > > On Sun, May 11, 2014 at 11:02 AM, Dave Airlie <airlied@gmail.com> wrote:
> > > > On 11 May 2014 18:28, Thomas Meyer <thomas@m3y3r.de> wrote:
> > > >> Hi,
> > > >>
> > > >> 3.14.3 works as expected.
> > > >> 3.15-rc5 shows a strange behaviour: When resuming from ram the X server
> > > >> seems to be disfunctional.
> > > >>
> > > >> I see this WARNING in the kernel log before suspend to ram in the early
> > > >> boot process:
> > > 
> > > Doesn't ring a bell really.
> > 
> > Same symptoms as
> > https://bugs.freedesktop.org/show_bug.cgi?id=76554
> > -Chris
> > 
> 
> bisected this to:
> # first bad commit: [78f2975eec9faff353a6194e854d3d39907bab68] drm/i915: Move all ring resets before setting the HWS page
> 
> commit 78f2975eec9faff353a6194e854d3d39907bab68
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Wed Apr 2 16:36:07 2014 +0100
> 
>     drm/i915: Move all ring resets before setting the HWS page
>     
>     In commit a51435a3137ad8ae75c288c39bd2d8b2696bae8f
>     Author: Naresh Kumar Kachhi <naresh.kumar.kachhi@intel.com>
>     Date:   Wed Mar 12 16:39:40 2014 +0530
>     
>         drm/i915: disable rings before HW status page setup
>     
>     we reordered stopping the rings to do so before we set the HWS register.
>     However, there is an extra workaround for g45 to reset the rings twice,
>     and for consistency we should apply that workaround before setting the
>     HWS to be sure that the rings are truly stopped.
>     
>     Reference: http://lkml.kernel.org/r/20140423202248.GA3621@amd.pavel.ucw.cz
>     Tested-by: Pavel Machek <pavel@ucw.cz>
>     Cc: Naresh Kumar Kachhi <naresh.kumar.kachhi@intel.com>
>     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>     Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>     Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> 
> Reverting above commit from current linus' master tree makes the display server behave correctly after resume from ram.

Boot time regression trumps resume regression? Doubly-so as we have an
earlier resume regression with identical symptoms?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
