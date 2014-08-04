Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaHDOqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:46:38 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:53249 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaHDOqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:46:36 -0400
Date: Mon, 4 Aug 2014 16:46:43 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: mark yao <yzq@rock-chips.com>
Cc: heiko@sntech.de, Rob Clark <robdclark@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>, huangtao@rock-chips.com,
        devicetree@vger.kernel.org, zwl@rock-chips.com, cym@rock-chips.com,
        linux-doc@vger.kernel.org, xw@rock-chips.com,
        linux-api@vger.kernel.org, zyw@rock-chips.com,
        zhangqing@rock-chips.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kever.yang@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, xxm@rock-chips.com,
        yxj@rock-chips.com, wxt@rock-chips.com, kfx@rock-chips.com
Subject: Re: [PATCH 1/9] drm: Add drm driver for Rockchip Socs
Message-ID: <20140804144643.GV8727@phenom.ffwll.local>
Mail-Followup-To: mark yao <yzq@rock-chips.com>, heiko@sntech.de,
	Rob Clark <robdclark@gmail.com>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	David Airlie <airlied@linux.ie>,
	Grant Likely <grant.likely@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	John Stultz <john.stultz@linaro.org>,
	Rom Lemarchand <romlem@google.com>, huangtao@rock-chips.com,
	devicetree@vger.kernel.org, zwl@rock-chips.com, cym@rock-chips.com,
	linux-doc@vger.kernel.org, xw@rock-chips.com,
	linux-api@vger.kernel.org, zyw@rock-chips.com,
	zhangqing@rock-chips.com, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, kever.yang@rock-chips.com,
	cf@rock-chips.com, xjq@rock-chips.com, xxm@rock-chips.com,
	yxj@rock-chips.com, wxt@rock-chips.com, kfx@rock-chips.com
References: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
 <1407127507-1612-1-git-send-email-yzq@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407127507-1612-1-git-send-email-yzq@rock-chips.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 12:45:07PM +0800, mark yao wrote:
> This patch is a DRM Driver for Rockchip Socs, driver provides an abstraction
> for the graphics hardware, such as lcd controller and connector interface.
> 
> Signed-off-by: mark yao <yzq@rock-chips.com>
> ---

Just a quick drive-by comment below, don't consider this a full review by
far ;-)

> +static int lcdc_bind(struct device *dev, struct device *master, void *data)
> +{
> +	struct drm_device *drm_dev = data;
> +	struct rockchip_drm_private *private = drm_dev->dev_private;
> +	struct lcdc_context *ctx = dev_get_drvdata(dev);
> +	struct drm_crtc *crtc;
> +
> +	ctx->drm_dev = drm_dev;
> +
> +	ctx->pipe = rockchip_drm_pipe_get(dev);
> +	ctx->dpms = DRM_MODE_DPMS_OFF;
> +	crtc = &ctx->crtc;
> +
> +	private->crtc[ctx->pipe] = crtc;
> +	ctx->plane = rockchip_plane_init(drm_dev, 1 << ctx->pipe, true);
> +	drm_crtc_init(drm_dev, crtc, &rockchip_crtc_funcs);

This function is deprecated, please use the _with_planes versions so that
this new driver supports universal planes properly.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
