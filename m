Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab3D0Jtk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 05:49:40 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:58699 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab3D0Jti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 05:49:38 -0400
Date: Sat, 27 Apr 2013 11:49:22 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: airlied@linux.ie, swarren@wwwdotorg.org, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drm/tegra: Include header drm/drm.h
Message-ID: <20130427094922.GA6348@debian>
References: <1366998591-8508-1-git-send-email-emilgoode@gmail.com>
 <20130426192208.GA2945@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426192208.GA2945@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

I don't know this code well but the drm/drm.h has an #if def so that
either linux/types.h is included or the __[us]* types are defined in
a different way with the comment "One of the BSDs".
Also I sent a patch last year to include linux/types.h in exynos_drm.h
but it now includes drm/drm.h instead.

Best regards,

Emil Goode


On Fri, Apr 26, 2013 at 09:22:08PM +0200, Thierry Reding wrote:
> On Fri, Apr 26, 2013 at 07:49:51PM +0200, Emil Goode wrote:
> > Include definitions of used types by including drm/drm.h
> > 
> > Sparse output:
> > /usr/include/drm/tegra_drm.h:21:
> > 	found __[us]{8,16,32,64} type without
> > 	#include <linux/types.h>
> > 
> > Signed-off-by: Emil Goode <emilgoode@gmail.com>
> > ---
> >  include/uapi/drm/tegra_drm.h |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/include/uapi/drm/tegra_drm.h b/include/uapi/drm/tegra_drm.h
> > index 6e132a2..73bde4e 100644
> > --- a/include/uapi/drm/tegra_drm.h
> > +++ b/include/uapi/drm/tegra_drm.h
> > @@ -17,6 +17,8 @@
> >  #ifndef _UAPI_TEGRA_DRM_H_
> >  #define _UAPI_TEGRA_DRM_H_
> >  
> > +#include <drm/drm.h>
> > +
> 
> sparse complains about linux/types.h not being included, so I wonder if
> it makes more sense to include that instead of drm/drm.h. In fact I have
> a fix that does exactly that in a local branch and was going to put that
> into my fixes branch. It's a bit more lightweight.
> 
> On the other hand, some drivers already include drm/drm.h in the public
> header so I don't really have any objections to this patch.
> 
> Thierry


