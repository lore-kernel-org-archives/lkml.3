Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbaG3Mxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:53:46 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42169 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbaG3Mxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:53:44 -0400
Date: Wed, 30 Jul 2014 14:53:48 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: Re: [PATCH v5 11/11] drm: sti: Add DRM driver itself
Message-ID: <20140730125348.GO4747@phenom.ffwll.local>
Mail-Followup-To: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, airlied@linux.ie
References: <1403081488-13114-1-git-send-email-benjamin.gaignard@linaro.org>
 <1403081488-13114-12-git-send-email-benjamin.gaignard@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403081488-13114-12-git-send-email-benjamin.gaignard@linaro.org>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 10:51:28AM +0200, Benjamin Gaignard wrote:
> Make the link between all the hardware drivers and DRM/KMS interface.
> Create the driver itself and make it register all the sub-components.
> Use GEM CMA helpers for buffer allocation.
> 
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> ---
>  drivers/gpu/drm/sti/Kconfig          |   8 +
>  drivers/gpu/drm/sti/Makefile         |   6 +-
>  drivers/gpu/drm/sti/sti_compositor.c |  16 +-
>  drivers/gpu/drm/sti/sti_drm_crtc.c   | 419 +++++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/sti/sti_drm_crtc.h   |  21 ++
>  drivers/gpu/drm/sti/sti_drm_drv.c    | 244 ++++++++++++++++++++
>  drivers/gpu/drm/sti/sti_drm_drv.h    |  29 +++
>  drivers/gpu/drm/sti/sti_drm_plane.c  | 192 ++++++++++++++++
>  drivers/gpu/drm/sti/sti_drm_plane.h  |  17 ++
>  9 files changed, 949 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/gpu/drm/sti/sti_drm_crtc.c
>  create mode 100644 drivers/gpu/drm/sti/sti_drm_crtc.h
>  create mode 100644 drivers/gpu/drm/sti/sti_drm_drv.c
>  create mode 100644 drivers/gpu/drm/sti/sti_drm_drv.h
>  create mode 100644 drivers/gpu/drm/sti/sti_drm_plane.c
>  create mode 100644 drivers/gpu/drm/sti/sti_drm_plane.h
> 
> diff --git a/drivers/gpu/drm/sti/Kconfig b/drivers/gpu/drm/sti/Kconfig
> index 1013570..bb48696 100644
> --- a/drivers/gpu/drm/sti/Kconfig
> +++ b/drivers/gpu/drm/sti/Kconfig

[snip]

> +int sti_drm_crtc_init(struct drm_device *drm_dev, struct sti_mixer *mixer)
> +{
> +	struct drm_crtc *crtc = &mixer->drm_crtc;
> +	int res;
> +
> +	res = drm_crtc_init(drm_dev, crtc, &sti_crtc_funcs);

We now have universal planes where the primary plane is no longer part of
the crtc, but cut out as a separate plane. In 3.17 this is enabled so
userspace can use it, so I think new drivers should be converted to this
from the go.

It looks like your platform already has universal planes on the hw side,
so removing that fake disdinction for primary planes should help quite a
bit.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
