Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3DJMEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:04:30 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:60568 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab3DJME2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:04:28 -0400
Date: Wed, 10 Apr 2013 14:07:24 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Tomas Melin <tomas.melin@iki.fi>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: don't check inconsistent modeset state when
 force-restoring
Message-ID: <20130410120724.GJ27612@phenom.ffwll.local>
Mail-Followup-To: Richard Cochran <richardcochran@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Dave Airlie <airlied@gmail.com>, Tomas Melin <tomas.melin@iki.fi>,
	Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
References: <20130409172820.GC27612@phenom.ffwll.local>
 <1365537090-11518-1-git-send-email-daniel.vetter@ffwll.ch>
 <20130410115901.GA4502@netboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410115901.GA4502@netboy>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 01:59:02PM +0200, Richard Cochran wrote:
> On Tue, Apr 09, 2013 at 09:51:30PM +0200, Daniel Vetter wrote:
> > It will be only consistent once we've restored all the crtcs. Since a
> > bunch of other callers also want to just restore a single crtc, add a
> > boolean to disable checking only where it doesn't make sense.
> > 
> > Note that intel_modeset_setup_hw_state already has a call to
> > intel_modeset_check_state at the end, so we don't reduce the amount of
> > checking.
> > 
> > v2: Try harder not to create a big patch (Chris).
> 
> To what does tree does this patch apply?
> 
> Tried v3.8.6 and master d02a9a89.

It's written against drm-intel-next-queued at

http://cgit.freedesktop.org/~danvet/drm-intel

I've thought that it should apply pretty cleanly against older kernels,
too. Apparently it conflicts a bit in intel_modeset_setup_hw_state, you
can just do the s/intel_crtc_restore_mode/__intel_set_mode/ change
manually.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
