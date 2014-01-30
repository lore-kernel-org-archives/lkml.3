Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaA3PXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:23:06 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44925 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaA3PXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:23:04 -0500
Date: Thu, 30 Jan 2014 16:22:58 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] Excessive WARN()s in Intel 915 driver
Message-ID: <20140130152258.GS17001@phenom.ffwll.local>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <20140128194214.GH7444@phenom.ffwll.local>
 <Pine.LNX.4.44L0.1401300950420.1208-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401300950420.1208-100000@iolanthe.rowland.org>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 09:53:54AM -0500, Alan Stern wrote:
> On Tue, 28 Jan 2014, Daniel Vetter wrote:
> 
> > I think I need a bit more debug output first. Can you please apply the
> > below patch to drm-intel-nightly and then grab a drm.debug=0xe dmesg from
> > boot?
> 
> The dmesg output is below.  Since you didn't say whether this should go
> on top of the previous patch or in place of it, I put this in place of
> the first one.
> 
> BTW, I had to fix a bug in the patch:
> 
> > @@ -9171,6 +9181,11 @@ intel_modeset_affected_pipes(struct drm_crtc *crtc, unsigned *modeset_pipes,
> >  			*disable_pipes |= 1 << intel_crtc->pipe;
> >  		else
> >  			*prepare_pipes |= 1 << intel_crtc->pipe;
> > +
> > +		DRM_DEBUG_KMS("[CRTC:%d:%s]: prepare_pipes %u\n",
> > +			intel_crtc->base.base.id,
> > +			pipe_name(intel_crtc->pipe),
> > +			*prepare_pipes);
> >  	}
> 
> pipe_name() returns char, not char *.  I changed the output format 
> specifier from %s to %c.

Ok, I seem to have been truly blind all the time. This seems to have been
fallout from

commit b6c5164d7bf624f3e1b750787ddb983150c5117c
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri Apr 12 18:48:43 2013 +0200

    drm/i915: Fixup Oops in the pipe config computation

Meanwhile we've moved the overall infrastructure ahead again quite a bit,
so I think it's time to give the full atomic modeset paths another shot.
But I'll be travelling to fosdem the next few days, so this will take a
bit of time.

As long as there's not real bad side-effects I guess we simply need to
live with the WARN for a tad longer.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
