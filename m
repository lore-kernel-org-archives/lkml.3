Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbbAVDwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 22:52:09 -0500
Received: from m12-18.163.com ([220.181.12.18]:36358 "EHLO m12-18.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067AbbAVDvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 22:51:42 -0500
Message-ID: <54C07301.4010003@163.com>
Date: Thu, 22 Jan 2015 11:48:17 +0800
From: Caesar Wang <sasukewxt@163.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Yao <mark.yao@rock-chips.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Rob Clark <robdclark@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Daniel Kurtz <djkurtz@chromium.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH] drm/rockchip: vop: fix vop vsync/hsync polarity
References: <1421896502-9943-1-git-send-email-mark.yao@rock-chips.com>
In-Reply-To: <1421896502-9943-1-git-send-email-mark.yao@rock-chips.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowEC5zbIBc8BUIx+0Ag--.2152S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7uF1xtw1rJw1kur4UZF1DWrg_yoW8Gw1Dpw
	srCryIvrWIkFWqvFWkJF9xAFWrK3Z0k3yIqrs8Ja1a9FsFgrn7t3Z3XrnxJryaqF17CrW0
	gF9rGasxG3W3urUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UKksgUUUUU=
X-Originating-IP: [221.224.159.162]
X-CM-SenderInfo: 5vdv3yhhz03qqrwthudrp/1tbiSgOJlVO-rUItZwAAsc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

在 2015年01月22日 11:15, Mark Yao 写道:
> Vop set wrong vsync/hsync polarity, it may cause some
> display problem. known problem is that caused HDMI hdcp
> authenticate failed, caused pixel offset with hdmi display.
> the polarity description at RK3288 TRM doc:
>    dsp_vsync_pol
>      VSYNC polarity
>        1'b0 : negative
>        1'b1 : positive
>        dsp_hsync_pol
>      HSYNC polarity
>        1'b0 : negative
>        1'b1 : positive
>
> Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
> ---
>   drivers/gpu/drm/rockchip/rockchip_drm_vop.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> index 9a5c571..2b145ba5 100644
> --- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> @@ -874,8 +874,8 @@ static int vop_crtc_mode_set(struct drm_crtc *crtc,
>   	VOP_CTRL_SET(vop, out_mode, vop->connector_out_mode);
>   
>   	val = 0x8;
> -	val |= (adjusted_mode->flags & DRM_MODE_FLAG_NHSYNC) ? 1 : 0;
> -	val |= (adjusted_mode->flags & DRM_MODE_FLAG_NVSYNC) ? (1 << 1) : 0;
> +	val |= (adjusted_mode->flags & DRM_MODE_FLAG_NHSYNC) ? 0 : 1;
> +	val |= (adjusted_mode->flags & DRM_MODE_FLAG_NVSYNC) ? 0 : (1 << 1);
Tested-by: Caesar Wang <wxt@rock-chips.com>
>   	VOP_CTRL_SET(vop, pin_pol, val);
>   
>   	VOP_CTRL_SET(vop, htotal_pw, (htotal << 16) | hsync_len);


