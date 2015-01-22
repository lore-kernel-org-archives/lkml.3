Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbbAVDeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 22:34:24 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58553 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbbAVDeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 22:34:17 -0500
MIME-Version: 1.0
In-Reply-To: <1421896502-9943-1-git-send-email-mark.yao@rock-chips.com>
References: <1421896502-9943-1-git-send-email-mark.yao@rock-chips.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 22 Jan 2015 11:33:56 +0800
X-Google-Sender-Auth: TqaEXghrxWYoFYGwrT7FfOqgdhA
Message-ID: <CAGS+omAG0GpxO+bSuS_fZQSpcXJzeXqGQn9hWUBOODXzJ82H5g@mail.gmail.com>
Subject: Re: [PATCH] drm/rockchip: vop: fix vop vsync/hsync polarity
To: Mark Yao <mark.yao@rock-chips.com>
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 11:15 AM, Mark Yao <mark.yao@rock-chips.com> wrote:
> Vop set wrong vsync/hsync polarity, it may cause some
> display problem. known problem is that caused HDMI hdcp
> authenticate failed, caused pixel offset with hdmi display.
> the polarity description at RK3288 TRM doc:
>   dsp_vsync_pol
>     VSYNC polarity
>       1'b0 : negative
>       1'b1 : positive
>       dsp_hsync_pol
>     HSYNC polarity
>       1'b0 : negative
>       1'b1 : positive
>
> Signed-off-by: Mark Yao <mark.yao@rock-chips.com>

Looks good!

Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>

> ---
>  drivers/gpu/drm/rockchip/rockchip_drm_vop.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> index 9a5c571..2b145ba5 100644
> --- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> @@ -874,8 +874,8 @@ static int vop_crtc_mode_set(struct drm_crtc *crtc,
>         VOP_CTRL_SET(vop, out_mode, vop->connector_out_mode);
>
>         val = 0x8;
> -       val |= (adjusted_mode->flags & DRM_MODE_FLAG_NHSYNC) ? 1 : 0;
> -       val |= (adjusted_mode->flags & DRM_MODE_FLAG_NVSYNC) ? (1 << 1) : 0;
> +       val |= (adjusted_mode->flags & DRM_MODE_FLAG_NHSYNC) ? 0 : 1;
> +       val |= (adjusted_mode->flags & DRM_MODE_FLAG_NVSYNC) ? 0 : (1 << 1);
>         VOP_CTRL_SET(vop, pin_pol, val);
>
>         VOP_CTRL_SET(vop, htotal_pw, (htotal << 16) | hsync_len);
> --
> 1.7.9.5
>
>
