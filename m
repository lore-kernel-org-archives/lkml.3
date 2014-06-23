Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaFWXHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 19:07:54 -0400
Received: from www17.your-server.de ([213.133.104.17]:54361 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaFWXHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 19:07:53 -0400
Message-ID: <1403564870.3091.6.camel@localhost.localdomain>
Subject: Re: Linux 3.16-rc2
From: Thomas Meyer <thomas@m3y3r.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 24 Jun 2014 01:07:50 +0200
In-Reply-To: <CA+55aFxdAhp-esuGiY4VEugiiwcMJgg1r6fPiR9Fb+HOz_5tLg@mail.gmail.com>
References: <CA+55aFxdAhp-esuGiY4VEugiiwcMJgg1r6fPiR9Fb+HOz_5tLg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 21.06.2014, 19:22 -1000 schrieb Linus Torvalds:
> It's a day early, but tomorrow ends up being inconvenient for me due
> to being on the road most of the day, so here you are. These days most
> people send me their pull requests and patches during the week, so
> it's not like I expect that a Sunday release would have made much of a
> difference. And it's also not like I didn't have enough changes for
> making a rc2 release.
> 
> Anyway, enough excuses. 3.16-rc2 is out, and contains the usual
> assortment of fixes all over the map. The most unusual part at this
> point is how the sparc changes stand out (at almost 40% of the patch
> by bulk), but they are basically all just sparse warning cleanups.
> 
> Similarly, some Nouveau drm changes standing out size-wise, but again
> those are largely due to small firmware fixes resulting in big
> generated changes. The actual real changes are fairly small.
> 
> Ignoring those two unusually large changes (in lines), everything else
> looks fairly normal. There are driver changes, some tooling updates
> (particularly perf), and various other arch updates (arm, s390,
> unicore32, x86..). And just misc random stuff all over the place -
> rtmutex, btrfs, yadda yadda.
> 
> The shortlog is not tiny, but small enough to include here, so you can
> see the details there if you care.
> 
> Please do go test it out,
> 

the i915 driver is still broken in 3.16-rc2. Resume from ram crashes the
X server.

First bad commit is:

# first bad commit: [78f2975eec9faff353a6194e854d3d39907bab68] drm/i915: Move all ring resets before setting the HWS page

commit 78f2975eec9faff353a6194e854d3d39907bab68
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Apr 2 16:36:07 2014 +0100

    drm/i915: Move all ring resets before setting the HWS page
    
    In commit a51435a3137ad8ae75c288c39bd2d8b2696bae8f
    Author: Naresh Kumar Kachhi <naresh.kumar.kachhi@intel.com>
    Date:   Wed Mar 12 16:39:40 2014 +0530
    
        drm/i915: disable rings before HW status page setup
    
    we reordered stopping the rings to do so before we set the HWS register.
    However, there is an extra workaround for g45 to reset the rings twice,
    and for consistency we should apply that workaround before setting the
    HWS to be sure that the rings are truly stopped.
    
    Reference: http://lkml.kernel.org/r/20140423202248.GA3621@amd.pavel.ucw.cz
    Tested-by: Pavel Machek <pavel@ucw.cz>
    Cc: Naresh Kumar Kachhi <naresh.kumar.kachhi@intel.com>
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Jani Nikula <jani.nikula@intel.com>

Above commit is not revertable anymore on 3.16-rc2 without conflict.



