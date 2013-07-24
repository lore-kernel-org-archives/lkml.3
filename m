Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab3GXVXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 17:23:12 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:37998 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3GXVXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 17:23:11 -0400
Date: Wed, 24 Jul 2013 23:23:08 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 4/5] drm/i915: Add async page flip support for IVB
Message-ID: <20130724212308.GZ5939@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
	dri-devel@lists.freedesktop.org
References: <1374544202-15496-1-git-send-email-keithp@keithp.com>
 <1374544202-15496-5-git-send-email-keithp@keithp.com>
 <20130723052856.GD5939@phenom.ffwll.local>
 <86li4v3ds7.fsf@miki.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86li4v3ds7.fsf@miki.keithp.com>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 01:26:32PM -0700, Keith Packard wrote:
> Daniel Vetter <daniel@ffwll.ch> writes:
> 
> > Matching tiling modes is actually already a requirement on gen4+ (since
> > the tiling bit and the linear/tiled offset registers can't be changed with
> > a MI_DISPLAY_FLIP command).
> 
> Async flip has a harder requirement -- you must use X tiling, both
> before and after the flip. Oh, and async flips require a 32KB aligned
> buffer, which I'm not actually checking for. Not sure how to

We could just unconditionally increase the alignement in
intel_pin_and_fence_fb_obj - we already have more strict requirements due
to a bunch of w/a in other places. So shouldn't hurt at all really.

> > But atm we fail to check that in the common
> > code, so imo better to move that to there.
> >
> > We already check for matching strides in common code, so with the tile
> > check added we could drop this all here.
> 
> I don't see a requirement for matching stride and tile parameter in the
> MI_DISPLAY_FLIP docs for synchronous operations, at least on DevGT+. Is
> the common code too restrictive?

Hm right, I've mixed that. I guess we could be a bit more sloppy with
this, otoh no one yet seems to want it and Ville's pageflip stuff is
rather madly flexible.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
