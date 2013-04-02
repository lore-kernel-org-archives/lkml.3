Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764Ab3DBMyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 08:54:16 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37731 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760365Ab3DBMyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 08:54:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130331113844.GG16352@chmeee.dyndns.org>
References: <20130331113844.GG16352@chmeee.dyndns.org>
Date: Tue, 2 Apr 2013 14:54:13 +0200
Message-ID: <CAMeQTsbn_TDUBjgg_GYVeW38W_NCotHTL7bQLbfSyqKJgSXnew@mail.gmail.com>
Subject: Re: [PATCH] gma500: Make VGA and HDMI connector hotpluggable
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Kero <kero@chello.nl>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 31, 2013 at 1:38 PM, Kero <kero@chello.nl> wrote:
> From: Kero van Gelder <kero@chello.nl>
>
> Both VGA and HDMI connectors are available on my Asus EeePC X101CH.
> This patch will cause output to be shown on either when plugged in.
> For both, it shows the leftmost 800x600, of the 1024x600 on LVDS.
>
> Signed-off-by: Kero van Gelder <kero@chello.nl>
> ---
> diff --git a/drivers/gpu/drm/gma500/cdv_intel_crt.c b/drivers/gpu/drm/gma500/cdv_intel_crt.c
> index 8c17534..7b8386f 100644
> --- a/drivers/gpu/drm/gma500/cdv_intel_crt.c
> +++ b/drivers/gpu/drm/gma500/cdv_intel_crt.c
> @@ -276,6 +276,7 @@ void cdv_intel_crt_init(struct drm_device *dev,
>                 goto failed_connector;
>
>         connector = &psb_intel_connector->base;
> +       connector->polled = DRM_CONNECTOR_POLL_HPD;
>         drm_connector_init(dev, connector,
>                 &cdv_intel_crt_connector_funcs, DRM_MODE_CONNECTOR_VGA);
>
> diff --git a/drivers/gpu/drm/gma500/cdv_intel_hdmi.c b/drivers/gpu/drm/gma500/cdv_intel_hdmi.c
> index e223b50..464153d 100644
> --- a/drivers/gpu/drm/gma500/cdv_intel_hdmi.c
> +++ b/drivers/gpu/drm/gma500/cdv_intel_hdmi.c
> @@ -319,6 +319,7 @@ void cdv_hdmi_init(struct drm_device *dev,
>                 goto err_priv;
>
>         connector = &psb_intel_connector->base;
> +       connector->polled = DRM_CONNECTOR_POLL_HPD;
>         encoder = &psb_intel_encoder->base;
>         drm_connector_init(dev, connector,
>                            &cdv_hdmi_connector_funcs,
> --

Your patch has been applied to:
https://github.com/patjak/drm-gma500.git gma500-next

We might also consider polling if this causes problems for people, but for now
this is fine. No biggie, but your tabs where converted to spaces so I recommend
running checkpatch.pl before submitting.

Thanks
Patrik Jakobsson
