Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbbAQEGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 23:06:04 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:56624 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbbAQEGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 23:06:01 -0500
MIME-Version: 1.0
X-Originating-IP: [130.216.30.134]
In-Reply-To: <CAF6AEGvCf=7bQWJMxXgzn6DKWPR6TKXJ3+06aRrCg9nV62J7cA@mail.gmail.com>
References: <1421187484-13875-1-git-send-email-sviau@codeaurora.org>
	<1421187484-13875-3-git-send-email-sviau@codeaurora.org>
	<CAKMK7uH0GUjkksG5RJ03qtf=bqdPvAK1PpayQ6Wz9dq2KMe9Tw@mail.gmail.com>
	<CAF6AEGvCf=7bQWJMxXgzn6DKWPR6TKXJ3+06aRrCg9nV62J7cA@mail.gmail.com>
Date: Sat, 17 Jan 2015 05:06:00 +0100
X-Google-Sender-Auth: xRCSetZhKlWAuDJplLJYoXp7CB0
Message-ID: <CAKMK7uFCO5ytkckRVtT66pqpwEa9jK=J2CJqjWRS7BuXoJkjig@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/msm/mdp5: Add hardware cursor support
From: Daniel Vetter <daniel@ffwll.ch>
To: Rob Clark <robdclark@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Stephane Viau <sviau@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Beeresh Gopal <gbeeresh@codeaurora.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 08:46:46AM -0500, Rob Clark wrote:
> On Wed, Jan 14, 2015 at 7:55 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> > On Tue, Jan 13, 2015 at 05:18:04PM -0500, Stephane Viau wrote:
> >> From: Beeresh Gopal <gbeeresh@codeaurora.org>
> >>
> >> This patch implements the hardware accelarated cursor
> >> support for MDP5 platforms.
> >>
> >> Signed-off-by: Beeresh Gopal <gbeeresh@codeaurora.org>
> >> Signed-off-by: Wentao Xu <wentaox@codeaurora.org>
> >> Signed-off-by: Stephane Viau <sviau@codeaurora.org>
> >
> > Imo implementing legacy cursor support instead of with universal planes
> > makes no sense. Especially since msm is converted to atomic already, and
> > you can't move the cursor with atomic when it's legacy only. See the
> > cursor argument for the drm_crtc_init_with_planes function and how it's
> > used in e.g. i915.
> >
>
> well, I'm still not 100% convinced about going through the whole
> atomic mechanism for cursors..  in particular stuff that tries to
> enable/disable the cursor at 1000fps, goes *really* badly when things
> start waiting for vsync.
>
> I'll probably try some experiments with it at some point, but at this
> point something that works with x11 is a lot more interesting for me
> (since every time I switch from mdp4 device to mdp5 device I forget to
> disable hw cursor the first time I start x)

Well for one this uses the legacy cursor callbacks directly, at least a
cursor plane is imo in order.

Otoh we just need to fix up the cursor atomic implementation to allow
drivers to do fully async updates which get merged down to one update.
Which Ville's original atomic stuff already had. So all recoverable by
adding a flag somewhere and setting that in the plane_update-on-atomic
function.

Merging legacy code just because the new stuff isn't 100% perfect yet imo
just doesn't make that much sense.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
