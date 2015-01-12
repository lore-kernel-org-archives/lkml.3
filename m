Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbbALVnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:43:46 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:44125 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbbALVnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:43:43 -0500
MIME-Version: 1.0
X-Originating-IP: [130.216.30.134]
In-Reply-To: <20150112174334.GI2455@charon>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
	<1418653622-21105-31-git-send-email-luis.henriques@canonical.com>
	<1421012945.19708.27.camel@decadent.org.uk>
	<CAKMK7uFDS339qaqaNeRJ-L+XXKBaS8CgDY1CzEB7ugDmOto+Dw@mail.gmail.com>
	<20150112174334.GI2455@charon>
Date: Mon, 12 Jan 2015 22:43:42 +0100
Message-ID: <CAKMK7uGXq2JBJqTPAmFfs7ZG1SLUs4KT4SC9+mrbWSb6RFcXjA@mail.gmail.com>
Subject: Re: [PATCH 3.16.y-ckt 030/168] drm/i915: Handle failure to kick out a
 conflicting fb driver
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, kernel-team@lists.ubuntu.com,
        "Nikula, Jani" <jani.nikula@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 6:43 PM, Luis Henriques
<luis.henriques@canonical.com> wrote:
> On Mon, Jan 12, 2015 at 06:20:22PM +0100, Daniel Vetter wrote:
>> On Sun, Jan 11, 2015 at 10:49 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
>> > On Mon, 2014-12-15 at 14:24 +0000, Luis Henriques wrote:
>> >> 3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.
>> >>
>> >> ------------------
>> >>
>> >> From: Chris Wilson <chris@chris-wilson.co.uk>
>> >>
>> >> commit f96de58fc7e7d3d717c7c63975c3b896c906b5e3 upstream.
>> >>
>> >> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>> >> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
>> >> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>> >> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
>> >
>> > Should this also be applied to any older stable branches?
>> >
>> > i915_kick_out_firmware_fb() was introduced in 3.6 and it has always been
>> > possible for the alloc_apertures() call to fail.
>> >
>> > remove_conflicting_framebuffers() has returned an error code since 3.14
>> > (but could silently fail before then!) so this should be applicable to
>> > the 3.14 stable branch too.
>>
>> tbh I don't know why this patch ended up in a stable kernel, at least
>> I didn't find anything where we (drm/i915 maintainers) marked it as
>> such. And there's no bugzilla references added either. Imo the patch
>> doesn't qualify for stable (it's not a real-world bug afaik).
>
> You're right, this patch was not tagged for stable.
>
> While applying 0485c9dc24ec ("drm/i915: Kick fbdev before vgacon") to
> the 3.16 kernel, I found that cherry-picking f96de58fc7e7 would make
> it apply cleanly and it didn't shock me to have it in a stable kernel.
> That's why I applied it for release 3.16.7-ckt3.  I guess I should
> have added a note in the commit text justifying its presence.

Ah makes sense. Usually we try to tag cc: stable patches with their
depencies (and I looked for that but didn't find anything). As a rule
I only scan stable patches from Greg's kernels since there's way too
much going on (and this time around too much vacation and conferences
on top).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
