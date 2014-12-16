Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaLPAfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:35:31 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:58215 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaLPAfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:35:30 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1412150715300.27943@skynet.skynet.ie>
References: <alpine.DEB.2.00.1412150715300.27943@skynet.skynet.ie>
Date: Mon, 15 Dec 2014 16:35:29 -0800
X-Google-Sender-Auth: BpmolmJOf_DRDTW4wB4r3APOxE0
Message-ID: <CA+55aFzBS4p6NZcaggPmgOuRqnny4q+FcH6RM-5swJCw205JgA@mail.gmail.com>
Subject: Re: [git pull] drm for 3.19-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Alex Deucher <alexander.deucher@amd.com>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 11:17 PM, Dave Airlie <airlied@linux.ie> wrote:
>
> i915:
>         Initial Skylake (SKL) support
>         gen3/4 reset work
>         start of dri1/ums removal
>         infoframe tracking
>         fixes for lots of things.

So I'm not sure how happy I am about this. It seems to work, but on
the very first boot I get this:

  ------------[ cut here ]------------
  WARNING: CPU: 1 PID: 1292 at
drivers/gpu/drm/i915/i915_gem_execbuffer.c:125
eb_lookup_vmas.isra.18+0x333/0x3d0 [i915]()
  GPU use of dumb buffer is illegal.
  Modules linked in: ip6t_rpfilter bnep ip6t_REJECT nf_reject_ipv6
bluetooth nf_conntrack_ipv6 ...
   video
  CPU: 1 PID: 1292 Comm: Xorg Not tainted 3.18.0-09423-g988adfdffdd4 #1
  Hardware name:                  /DH87RL, BIOS
RLH8710H.86A.0327.2014.0924.1645 09/24/2014
  Call Trace:
    dump_stack+0x45/0x57
    warn_slowpath_common+0x80/0xc0
    warn_slowpath_fmt+0x41/0x50
    ? sg_kfree+0x30/0x30
    eb_lookup_vmas.isra.18+0x333/0x3d0 [i915]
    i915_gem_do_execbuffer.isra.25+0x50d/0xd80 [i915]
    ? unlock_page+0x6d/0x80
    i915_gem_execbuffer2+0xb1/0x2c0 [i915]
    drm_ioctl+0x19c/0x630 [drm]
    do_vfs_ioctl+0x2e0/0x4e0
    ? file_has_perm+0x87/0xa0
    ? __audit_syscall_entry+0xac/0x100
    SyS_ioctl+0x81/0xa0
    ? do_page_fault+0xc/0x10
    system_call_fastpath+0x12/0x17
  ---[ end trace cb3c78163212ca1d ]---

apparently Introduced by commit 355a70183848 ("drm/gem: Warn on
illegal use of the dumb buffer interface v2")

The commit says "the next step is to fail".

And I want to make it painfully clear that if somebody breaks existing
working setups, they don't get to work on the kernel.

So get rid of the warning. And get rid of the notion that you can just
fail. You can try to fix Xorg, and then come back to this - in a
couple of years - when it no longer happens.

                      Linus
