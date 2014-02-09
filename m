Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaBINeo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:34:44 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:55580 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaBINen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:34:43 -0500
MIME-Version: 1.0
In-Reply-To: <1391780716-21896-5-git-send-email-sagar.a.kamble@intel.com>
References: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
	<1391780716-21896-5-git-send-email-sagar.a.kamble@intel.com>
Date: Sun, 9 Feb 2014 08:34:43 -0500
Message-ID: <CAF6AEGu9i2i0TStPQsy7YFbode_WHnEeo7vn5tHsigHkmbi72w@mail.gmail.com>
Subject: Re: [PATCH v4 04/11] drm/omap: Switch omapdrm over to drm_mode_create_rotation_property()
From: Rob Clark <robdclark@gmail.com>
To: sagar.a.kamble@intel.com
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        vijay.a.purushothaman@intel.com, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        Archit Taneja <archit@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, joe@perches.com,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 7, 2014 at 8:45 AM,  <sagar.a.kamble@intel.com> wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
>
> Use the new drm_mode_create_rotation_property() in omapdrm.
>
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

Reviewed-by: Rob Clark <robdclark@gmail.com>

> ---
>  drivers/gpu/drm/omapdrm/omap_plane.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/gpu/drm/omapdrm/omap_plane.c b/drivers/gpu/drm/omapdrm/omap_plane.c
> index 046d5e6..fee8f35 100644
> --- a/drivers/gpu/drm/omapdrm/omap_plane.c
> +++ b/drivers/gpu/drm/omapdrm/omap_plane.c
> @@ -300,16 +300,13 @@ void omap_plane_install_properties(struct drm_plane *plane,
>         if (priv->has_dmm) {
>                 prop = priv->rotation_prop;
>                 if (!prop) {
> -                       const struct drm_prop_enum_list props[] = {
> -                                       { DRM_ROTATE_0,   "rotate-0" },
> -                                       { DRM_ROTATE_90,  "rotate-90" },
> -                                       { DRM_ROTATE_180, "rotate-180" },
> -                                       { DRM_ROTATE_270, "rotate-270" },
> -                                       { DRM_REFLECT_X,  "reflect-x" },
> -                                       { DRM_REFLECT_Y,  "reflect-y" },
> -                       };
> -                       prop = drm_property_create_bitmask(dev, 0, "rotation",
> -                                       props, ARRAY_SIZE(props));
> +                       prop = drm_mode_create_rotation_property(dev,
> +                                                                BIT(DRM_ROTATE_0) |
> +                                                                BIT(DRM_ROTATE_90) |
> +                                                                BIT(DRM_ROTATE_180) |
> +                                                                BIT(DRM_ROTATE_270) |
> +                                                                BIT(DRM_REFLECT_X) |
> +                                                                BIT(DRM_REFLECT_Y));
>                         if (prop == NULL)
>                                 return;
>                         priv->rotation_prop = prop;
> --
> 1.8.5
>
