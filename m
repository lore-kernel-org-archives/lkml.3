Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab3CRPkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:40:23 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:35479 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab3CRPkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:40:21 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CAKMK7uE9o7CT4Bn1SrPyCa+bGrHmj2-+cpDYP__gUU+BRiGH7A@mail.gmail.com>
References: <CAKMK7uE9o7CT4Bn1SrPyCa+bGrHmj2-+cpDYP__gUU+BRiGH7A@mail.gmail.com>
Date: Mon, 18 Mar 2013 16:40:20 +0100
Message-ID: <CAKMK7uF3z=9zjsKm_222BV3M-MSYtSWesbDHcUnMAq3oQp5sYQ@mail.gmail.com>
Subject: Re: Revert a bunch of patches in stable kernels
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: stable <stable@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 11:05 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> Hi Greg&all,
>
> So a recent stable backport to fix rc6 on ilk (which is disabled by
> default and with dubious power savings at best, unlike rc6 on snb and
> later) totally blew up all over the place:
> https://bugzilla.kernel.org/show_bug.cgi?id=55291
> https://lkml.org/lkml/2013/3/14/540

This likely also is the culprit behind the ghost vga issues reported
on gm45, e.g:

https://bugzilla.redhat.com/show_bug.cgi?id=922304

Again, fixed in 3.9-rc kernels by

commit 20afbda209d708be66944907966486d0c1331cb8
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Dec 11 14:05:07 2012 +0100

    drm/i915: Fixup hpd irq register setup ordering

Cheers, Daniel

> There might be more, I'm still recovering from mail floods due to
> traveling last week. I think the right course of action is to revert
> the offending patch (plus anything depending upon it) and give up on
> rc6 on ilk in 3.8 - too messy. All bug reports confirmed that 3.9-rc
> kernels work as expected. Upstream commits to revert:
>
> 15239099d7a7a9ecdc1ccb5b187ae4cda5488ff9 drm/i915: enable irqs earlier
> when resuming
> 52d7ecedac3f96fb562cb482c139015372728638 drm/i915: reorder setup
> sequence to have irqs for output setup
>
> Cheers, Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
