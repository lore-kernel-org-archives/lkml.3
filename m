Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbaDXVSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:18:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37543 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbaDXVSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:18:35 -0400
Date: Thu, 24 Apr 2014 16:18:04 -0500
From: Darren Etheridge <detheridge@ti.com>
To: Rob Clark <robdclark@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, David Airlie <airlied@linux.ie>,
        "airlied@redhat.com" <airlied@redhat.com>,
        Benoit Parrot <bparrot@ti.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/tilcdc increase allowable supported resolution
Message-ID: <20140424211804.GA4101@ti.com>
References: <1393873738-27327-1-git-send-email-balbi@ti.com>
 <CAF6AEGuE2MvN9SrO-R2_DnWtHtxwuFLwH6kUe4vrwcREsG5XDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAF6AEGuE2MvN9SrO-R2_DnWtHtxwuFLwH6kUe4vrwcREsG5XDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Clark <robdclark@gmail.com> wrote on Thu [2014-Apr-24 16:51:04 -0400]:
> On Mon, Mar 3, 2014 at 2:08 PM, Felipe Balbi <balbi@ti.com> wrote:
> > From: Darren Etheridge <detheridge@ti.com>
> >
> > 1680x1050 appears to also be within the bandwidth capabilities
> > of the device and memory infrastructure.
> 
> For this one, is 1680x1050 possible on all devices w/ tilcdc (like 1st
> gen beaglebone (white), etc)?  If not, maybe better to keep the
> default conservative and override the default in devicetree..
> 
Fair point Rob, I didn't test BeagleBone White at that resolution, only
BeagleBone Black.  I'll redo this patch as a BBB specific dts change
given we already have a max-bandwidth DT binding in place for tilcdc.

Thanks for reviewing it.

Darren

> BR,
> -R
> 
> > Signed-off-by: Darren Etheridge <detheridge@ti.com>
> > ---
> >  drivers/gpu/drm/tilcdc/tilcdc_drv.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.h b/drivers/gpu/drm/tilcdc/tilcdc_drv.h
> > index 5bb64e3..b47ec24 100644
> > --- a/drivers/gpu/drm/tilcdc/tilcdc_drv.h
> > +++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.h
> > @@ -43,7 +43,7 @@
> >   * with optimized DDR & EMIF settings tweaked 1920x1080@24 appears to
> >   * be supportable
> >   */
> > -#define TILCDC_DEFAULT_MAX_BANDWIDTH  (1280*1024*60)
> > +#define TILCDC_DEFAULT_MAX_BANDWIDTH  (1680*1050*60)
> >
> >
> >  struct tilcdc_drm_private {
> > --
> > 1.9.0
> >
