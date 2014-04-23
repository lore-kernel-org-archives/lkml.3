Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbaDWIlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:41:10 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49256 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbaDWIlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:41:03 -0400
Date: Wed, 23 Apr 2014 10:40:57 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [RFC 4/5] drm: Introduce drm_set_unique()
Message-ID: <20140423084057.GY10722@phenom.ffwll.local>
Mail-Followup-To: Thierry Reding <thierry.reding@gmail.com>,
	dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org,
	Russell King <rmk+kernel@arm.linux.org.uk>
References: <1398179373-29966-1-git-send-email-thierry.reding@gmail.com>
 <1398179373-29966-5-git-send-email-thierry.reding@gmail.com>
 <20140422154807.GT10722@phenom.ffwll.local>
 <20140423071714.GB31226@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423071714.GB31226@ulmo>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 09:17:16AM +0200, Thierry Reding wrote:
> On Tue, Apr 22, 2014 at 05:48:07PM +0200, Daniel Vetter wrote:
> > On Tue, Apr 22, 2014 at 05:09:32PM +0200, Thierry Reding wrote:
> > > From: Thierry Reding <treding@nvidia.com>
> > > 
> > > Add a helper function that allows drivers to statically set the unique
> > > name of the device. This will allow platform and USB drivers to get rid
> > > of their DRM bus implementations and directly use drm_dev_alloc() and
> > > drm_dev_register().
> > > 
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > ---
> > >  drivers/gpu/drm/drm_ioctl.c | 37 +++++++++++++++++++++++++++++++------
> > >  drivers/gpu/drm/drm_stub.c  |  1 +
> > >  include/drm/drmP.h          |  3 +++
> > >  3 files changed, 35 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
> > > index 2dd3a6d8382b..371db3bef60c 100644
> > > --- a/drivers/gpu/drm/drm_ioctl.c
> > > +++ b/drivers/gpu/drm/drm_ioctl.c
> > > @@ -42,6 +42,20 @@
> > >  #include <asm/mtrr.h>
> > >  #endif
> > >  
> > > +int drm_set_unique(struct drm_device *dev, const char *fmt, ...)
> > 
> > Can you please add a bit of kerneldoc for this? drm_ioctl.c isn't yet
> > pulled into the drm reference docbook, but better to have it there
> > already.
> 
> On second thought, wouldn't this be better located in drm_stub.c? It
> isn't really related to the IOCTL code except that one of the IOCTLs now
> uses the information set by this function. Logically I think it belongs
> with the likes of drm_dev_alloc() and drm_dev_register().

Yeah makes sense. Tbh the entire split-up of these core drm functions is
still a bit messy, so I don't mind if it's a bit inconsistent really. We
can do the suffling when someone bothers with the kerneldoc for all of
them and pulls it into the drm docbook.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
