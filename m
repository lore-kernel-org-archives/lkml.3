Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaLPIPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:15:35 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:48793 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaLPIPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:15:33 -0500
Date: Tue, 16 Dec 2014 09:16:08 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm for 3.19-rc1
Message-ID: <20141216081608.GK2711@phenom.ffwll.local>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Airlie <airlied@linux.ie>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>
References: <alpine.DEB.2.00.1412150715300.27943@skynet.skynet.ie>
 <CA+55aFzBS4p6NZcaggPmgOuRqnny4q+FcH6RM-5swJCw205JgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzBS4p6NZcaggPmgOuRqnny4q+FcH6RM-5swJCw205JgA@mail.gmail.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 04:35:29PM -0800, Linus Torvalds wrote:
> On Sun, Dec 14, 2014 at 11:17 PM, Dave Airlie <airlied@linux.ie> wrote:
> >
> > i915:
> >         Initial Skylake (SKL) support
> >         gen3/4 reset work
> >         start of dri1/ums removal
> >         infoframe tracking
> >         fixes for lots of things.
> 
> So I'm not sure how happy I am about this. It seems to work, but on
> the very first boot I get this:
> 
>   ------------[ cut here ]------------
>   WARNING: CPU: 1 PID: 1292 at
> drivers/gpu/drm/i915/i915_gem_execbuffer.c:125
> eb_lookup_vmas.isra.18+0x333/0x3d0 [i915]()
>   GPU use of dumb buffer is illegal.
>   Modules linked in: ip6t_rpfilter bnep ip6t_REJECT nf_reject_ipv6
> bluetooth nf_conntrack_ipv6 ...
>    video
>   CPU: 1 PID: 1292 Comm: Xorg Not tainted 3.18.0-09423-g988adfdffdd4 #1
>   Hardware name:                  /DH87RL, BIOS
> RLH8710H.86A.0327.2014.0924.1645 09/24/2014
>   Call Trace:
>     dump_stack+0x45/0x57
>     warn_slowpath_common+0x80/0xc0
>     warn_slowpath_fmt+0x41/0x50
>     ? sg_kfree+0x30/0x30
>     eb_lookup_vmas.isra.18+0x333/0x3d0 [i915]
>     i915_gem_do_execbuffer.isra.25+0x50d/0xd80 [i915]
>     ? unlock_page+0x6d/0x80
>     i915_gem_execbuffer2+0xb1/0x2c0 [i915]
>     drm_ioctl+0x19c/0x630 [drm]
>     do_vfs_ioctl+0x2e0/0x4e0
>     ? file_has_perm+0x87/0xa0
>     ? __audit_syscall_entry+0xac/0x100
>     SyS_ioctl+0x81/0xa0
>     ? do_page_fault+0xc/0x10
>     system_call_fastpath+0x12/0x17
>   ---[ end trace cb3c78163212ca1d ]---
> 
> apparently Introduced by commit 355a70183848 ("drm/gem: Warn on
> illegal use of the dumb buffer interface v2")
> 
> The commit says "the next step is to fail".
> 
> And I want to make it painfully clear that if somebody breaks existing
> working setups, they don't get to work on the kernel.
> 
> So get rid of the warning. And get rid of the notion that you can just
> fail. You can try to fix Xorg, and then come back to this - in a
> couple of years - when it no longer happens.

Yeah this patch should have been merged ever, I guess Chris reply' in the
original was lost. Anyway the real fail here is that we didn't spot this
in time. Well QA reported a bug, but 2 weeks after the patch landed, not
marked as a regression, not handled by the bug team and no one else seems
to have noticed either. Like I've mentioned at KS we have a bit a problem
with this stuff in i915 land, I'll chase people some more. Maybe it helps.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
