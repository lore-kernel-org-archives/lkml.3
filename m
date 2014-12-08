Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbaLHQSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:18:08 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:57694
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbaLHQSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:18:06 -0500
X-IronPort-AV: E=Sophos;i="5.07,539,1413237600"; 
   d="scan'208";a="92403780"
Date: Mon, 8 Dec 2014 17:17:57 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Alex Deucher <alexdeucher@gmail.com>
cc: Alex Deucher <alexander.deucher@amd.com>, kernel-janitors@vger.kernel.org,
        linux@rasmusvillemoes.dk, LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Joe Perches <joe@perches.com>,
        =?ISO-8859-15?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH 20/20] drm/radeon: fix misspelling of current function
 in string
In-Reply-To: <CADnq5_PW=xeQ=DxdoNxwvVxYjkav1qx1wL13OF92QwY6uX3gGg@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1412081716380.2560@hadrien>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr> <1417980062-25151-21-git-send-email-Julia.Lawall@lip6.fr> <CADnq5_PW=xeQ=DxdoNxwvVxYjkav1qx1wL13OF92QwY6uX3gGg@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2014, Alex Deucher wrote:

> On Sun, Dec 7, 2014 at 2:21 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> > Replace a misspelled function name by %s and then __func__.
> >
> > This was done using Coccinelle, including the use of Levenshtein distance,
> > as proposed by Rasmus Villemoes.
> >
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Looks fine to me.  For consistency, any chance you'd want to fix up
> the other places that use function names directly with this style
> patch?

I will try to do that soon.

julia

>
> Alex
>
> >
> > ---
> > The semantic patch is difficult to summarize, but is available in the cover
> > letter of this patch series.
> >
> >  drivers/gpu/drm/radeon/cik.c |   16 ++++++++++------
> >  1 file changed, 10 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
> > index 6dcde37..24d5e43 100644
> > --- a/drivers/gpu/drm/radeon/cik.c
> > +++ b/drivers/gpu/drm/radeon/cik.c
> > @@ -7367,34 +7367,38 @@ int cik_irq_set(struct radeon_device *rdev)
> >         }
> >         if (atomic_read(&rdev->irq.ring_int[CAYMAN_RING_TYPE_CP1_INDEX])) {
> >                 struct radeon_ring *ring = &rdev->ring[CAYMAN_RING_TYPE_CP1_INDEX];
> > -               DRM_DEBUG("si_irq_set: sw int cp1\n");
> > +               DRM_DEBUG("%s: sw int cp1\n", __func__);
> >                 if (ring->me == 1) {
> >                         switch (ring->pipe) {
> >                         case 0:
> >                                 cp_m1p0 |= TIME_STAMP_INT_ENABLE;
> >                                 break;
> >                         default:
> > -                               DRM_DEBUG("si_irq_set: sw int cp1 invalid pipe %d\n", ring->pipe);
> > +                               DRM_DEBUG("%s: sw int cp1 invalid pipe %d\n",
> > +                                         __func__, ring->pipe);
> >                                 break;
> >                         }
> >                 } else {
> > -                       DRM_DEBUG("si_irq_set: sw int cp1 invalid me %d\n", ring->me);
> > +                       DRM_DEBUG("%s: sw int cp1 invalid me %d\n", __func__,
> > +                                 ring->me);
> >                 }
> >         }
> >         if (atomic_read(&rdev->irq.ring_int[CAYMAN_RING_TYPE_CP2_INDEX])) {
> >                 struct radeon_ring *ring = &rdev->ring[CAYMAN_RING_TYPE_CP2_INDEX];
> > -               DRM_DEBUG("si_irq_set: sw int cp2\n");
> > +               DRM_DEBUG("%s: sw int cp2\n", __func__);
> >                 if (ring->me == 1) {
> >                         switch (ring->pipe) {
> >                         case 0:
> >                                 cp_m1p0 |= TIME_STAMP_INT_ENABLE;
> >                                 break;
> >                         default:
> > -                               DRM_DEBUG("si_irq_set: sw int cp2 invalid pipe %d\n", ring->pipe);
> > +                               DRM_DEBUG("%s: sw int cp2 invalid pipe %d\n",
> > +                                         __func__, ring->pipe);
> >                                 break;
> >                         }
> >                 } else {
> > -                       DRM_DEBUG("si_irq_set: sw int cp2 invalid me %d\n", ring->me);
> > +                       DRM_DEBUG("%s: sw int cp2 invalid me %d\n", __func__,
> > +                                 ring->me);
> >                 }
> >         }
> >
> >
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > http://lists.freedesktop.org/mailman/listinfo/dri-devel
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
