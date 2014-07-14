Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaGNHSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:18:21 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64234 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaGNHSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:18:14 -0400
Date: Mon, 14 Jul 2014 09:18:23 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Daniel Vetter <daniel@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: drm: i915: "plane B assertion failure, should be off on pipe B
 but is still active"
Message-ID: <20140714071823.GE15237@phenom.ffwll.local>
Mail-Followup-To: Paul Bolle <pebolle@tiscali.nl>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1404140703.2978.13.camel@x41>
 <87egy5h1yz.fsf@intel.com>
 <1404291203.12021.18.camel@x220>
 <1405283561.2103.9.camel@x41>
 <20140714065610.GA15237@phenom.ffwll.local>
 <1405322020.19403.0.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405322020.19403.0.camel@x220>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 09:13:40AM +0200, Paul Bolle wrote:
> On Mon, 2014-07-14 at 08:56 +0200, Daniel Vetter wrote:
> > Please test the below patch, thanks.
> > -Daniel
> > 
> > diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> > index 82e7d57f0a8a..f0be855ddf45 100644
> > --- a/drivers/gpu/drm/i915/intel_display.c
> > +++ b/drivers/gpu/drm/i915/intel_display.c
> > @@ -11914,6 +11914,7 @@ static void intel_sanitize_crtc(struct intel_crtc *crtc)
> >  		 * ...  */
> >  		plane = crtc->plane;
> >  		crtc->plane = !plane;
> > +		crtc->primary_enabled = true;
> >  		dev_priv->display.crtc_disable(&crtc->base);
> >  		crtc->plane = plane;
> >  
> 
> Instead of the revert or on top of the revert?

Instead of the revert as an attempt at a proper bugfix. If it doesn't work
my theory about what's going on on your machine is all wrong ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
