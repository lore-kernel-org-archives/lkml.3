Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab3DNGrM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 02:47:12 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:47151 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3DNGrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 02:47:11 -0400
Date: Sun, 14 Apr 2013 08:47:07 +0200
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Chris Wilson <chris@chris-wilson.co.uk>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, airlied@linux.ie, daniel.vetter@ffwll.ch
Subject: Re: drm: i915+fb: crtc->lock recursive locking deadlock on VT switch
 [>= 3.9-rc1 regresion]
Message-ID: <20130414064707.GA23354@shrek.podlesie.net>
References: <20130413154146.GA8136@shrek.podlesie.net>
 <20130413171040.GA24925@cantiga.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130413171040.GA24925@cantiga.alporthouse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 06:10:40PM +0100, Chris Wilson wrote:
> On Sat, Apr 13, 2013 at 05:41:46PM +0200, Krzysztof Mazur wrote:
> > Hi,
> > 
> > the drm_fb_helper_hotplug_event() locks all crtc->mutex locks by calling
> > drm_modeset_lock_all() and later calls drm_fb_helper_probe_connector_modes(),
> > which in case of i915 DRM driver effectively calls
> > intel_get_load_detect_pipe() that tries to lock crtc->mutex again.
> > This causes a deadlock, and can be in some cases triggered by VT
> > switch to framebuffer console on i915.
> > 
> > This bug is introduced in Linux 3.9-rc1 and still exists
> > in v3.9-rc6-183-gbf81710. Linux 3.8 is ok.
> 
> In Dave's drm-fixes branch:
> 
> commit 89ced125472b8551c65526934b7f6c733a6864fa
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Thu Apr 11 14:26:55 2013 +0000
> 
>     drm/fb-helper: Fix locking in drm_fb_helper_hotplug_event

Yes, this patch fixes the problem.

Thanks,
Krzysiek
