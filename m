Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934594Ab3DIOWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:22:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760271Ab3DIOWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:22:35 -0400
Date: Tue, 9 Apr 2013 10:22:30 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Jani Nikula <jani.nikula@intel.com>
Cc: gregkh@linuxfoundation.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.8.y] drm/i915: add quirk to invert brightness on
 eMachines e725
Message-ID: <20130409142230.GD32476@hansolo.jdub.homelinux.org>
References: <20130409123833.GC32476@hansolo.jdub.homelinux.org>
 <87y5crpzct.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5crpzct.fsf@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 05:12:18PM +0300, Jani Nikula wrote:
> On Tue, 09 Apr 2013, Josh Boyer <jwboyer@redhat.com> wrote:
> > Upstream commit 01e3a8feb40e54b962a20fa7eb595c5efef5e109
> 
> This patch seems to be the above commit and
> 
> commit 1ffff60320879830e469e26062c18f75236822ba
> Author: Jani Nikula <jani.nikula@intel.com>
> Date:   Tue Jan 22 12:50:34 2013 +0200
> 
>     drm/i915: add quirk to invert brightness on eMachines G725
> 
> squashed together. There's a separate bug for that too:
> https://bugs.freedesktop.org/show_bug.cgi?id=59628

Oh...  that actually does seem to be the case.  I did a cherry-pick
of just the commit I mentioned on top of 3.8.6 and it seems I resolved
the conflict by including in changes for both.  The conflict came up as:

<<<<<<< HEAD
        /* Acer Aspire 4736Z */
        { 0x2a42, 0x1025, 0x0260, quirk_invert_brightness },
=======
        /* Acer/eMachines G725 */
        { 0x2a42, 0x1025, 0x0210, quirk_invert_brightness },

        /* Acer/eMachines e725 */
        { 0x2a42, 0x1025, 0x0212, quirk_invert_brightness },
>>>>>>> 01e3a8f... drm/i915: add quirk to invert brightness on eMachines e725

Thanks for catching that.

> I think both are okay for stable, but by the stable rules you should
> probably split this up, with the appropriate upstream references in
> both. Or do whatever the stable team tells you to do. ;)

Yeah.  I'm happy to split them up and send them out separately.  Or if
Greg wants to just list both upstream commit IDs with a single backport,
that would also be fine.

josh
