Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3LBMMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:12:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:25573 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab3LBMMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:12:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,810,1378882800"; 
   d="scan'208";a="417897544"
Date: Mon, 2 Dec 2013 14:12:19 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: Take modeset locks around
 intel_modeset_setup_hw_state()
Message-ID: <20131202121219.GN10036@intel.com>
References: <CAKMK7uE_L8cqyYk6mQ4paXeh2m7tmoMXRv_KxoAeBq9MEAnFqw@mail.gmail.com>
 <1385975286-25392-1-git-send-email-ville.syrjala@linux.intel.com>
 <1385978429.2972.8.camel@x41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385978429.2972.8.camel@x41.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 11:00:29AM +0100, Paul Bolle wrote:
> On Mon, 2013-12-02 at 11:08 +0200, ville.syrjala@linux.intel.com wrote:
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > 
> > Some lower level things get angry if we don't have modeset locks
> > during intel_modeset_setup_hw_state(). Actually the resume and
> > lid_notify codepaths alreday hold the locks, but the init codepath
> > doesn't, so fix that.
> > 
> > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > ---
> > Totally untested, but looks correct to me.
> 
> I assume I need to test this, on top of 7c063c725987 ("drm/i915: take
> mode config lock around crtc disable at suspend"), to see if this makes
> the WARNING that I currently see at boot go away?

Yeah that would be nice.

> Paul Bolle
> 
> >  drivers/gpu/drm/i915/intel_display.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> > index 080f6fd..114db51 100644
> > --- a/drivers/gpu/drm/i915/intel_display.c
> > +++ b/drivers/gpu/drm/i915/intel_display.c
> > @@ -11046,7 +11046,9 @@ void intel_modeset_gem_init(struct drm_device *dev)
> >  
> >  	intel_setup_overlay(dev);
> >  
> > +	drm_modeset_lock_all(dev);
> >  	intel_modeset_setup_hw_state(dev, false);
> > +	drm_modeset_unlock_all(dev);
> >  }
> >  
> >  void intel_modeset_cleanup(struct drm_device *dev)

-- 
Ville Syrjälä
Intel OTC
