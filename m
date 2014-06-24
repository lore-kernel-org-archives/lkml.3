Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaFXLGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:06:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:17579 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbaFXLGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:06:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,537,1400050800"; 
   d="scan'208";a="552486614"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Thomas Meyer <thomas@m3y3r.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "intel-gfx\@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>
Subject: Re: [Intel-gfx] Linux 3.16-rc2
In-Reply-To: <1403564870.3091.6.camel@localhost.localdomain>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <CA+55aFxdAhp-esuGiY4VEugiiwcMJgg1r6fPiR9Fb+HOz_5tLg@mail.gmail.com> <1403564870.3091.6.camel@localhost.localdomain>
User-Agent: Notmuch/0.18+25~gfdc3e52 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 24 Jun 2014 14:06:24 +0300
Message-ID: <871tuea7nz.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Thomas Meyer <thomas@m3y3r.de> wrote:
> the i915 driver is still broken in 3.16-rc2. Resume from ram crashes the
> X server.

This is not new to 3.16-rc2; apparently we've had it since v3.15-rc4
[1]. Also related [2].

Chris, any fresh ideas?

Thomas, please consider filing a bug against DRM/Intel at [3]. They will
have a better chance of not being forgotten as the mail thread goes
cold.

Thanks,
Jani.


[1] http://thread.gmane.org/gmane.linux.kernel/1700872
[2] https://bugs.freedesktop.org/show_bug.cgi?id=76554
[3] https://bugs.freedesktop.org/enter_bug.cgi?product=DRI


>
> First bad commit is:
>
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
> Above commit is not revertable anymore on 3.16-rc2 without conflict.
>
>
>
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Jani Nikula, Intel Open Source Technology Center
