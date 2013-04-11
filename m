Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab3DKTZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:25:28 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:32846 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3DKTZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:25:26 -0400
Date: Thu, 11 Apr 2013 21:28:24 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Tomas Melin <tomas.melin@iki.fi>,
        Richard Cochran <richardcochran@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: don't check inconsistent modeset state when
 force-restoring
Message-ID: <20130411192824.GS27612@phenom.ffwll.local>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Dave Airlie <airlied@gmail.com>, Tomas Melin <tomas.melin@iki.fi>,
	Richard Cochran <richardcochran@gmail.com>, stable@vger.kernel.org
References: <1365537090-11518-1-git-send-email-daniel.vetter@ffwll.ch>
 <1365704571-17122-1-git-send-email-daniel.vetter@ffwll.ch>
 <20130411191742.GA8251@cantiga.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411191742.GA8251@cantiga.alporthouse.com>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 08:17:42PM +0100, Chris Wilson wrote:
> On Thu, Apr 11, 2013 at 08:22:50PM +0200, Daniel Vetter wrote:
> > It will be only consistent once we've restored all the crtcs. Since a
> > bunch of other callers also want to just restore a single crtc, add a
> > boolean to disable checking only where it doesn't make sense.
> > 
> > Note that intel_modeset_setup_hw_state already has a call to
> > intel_modeset_check_state at the end, so we don't reduce the amount of
> > checking.
> > 
> > v2: Try harder not to create a big patch (Chris).
> > 
> > v3: Even smaller (still Chris). Also fix a trailing space.
> > 
> > References: https://lkml.org/lkml/2013/3/16/60
> > Cc: Tomas Melin <tomas.melin@iki.fi>
> > Cc: Richard Cochran <richardcochran@gmail.com>
> > Cc: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> I'm happy that you are not touching any paths other than mentioned in
> the changelog, and that I think being quiet on the modeset is a good use
> of the 'force' semantics, so
> 
> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Queued for -next, thanks for the review.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
