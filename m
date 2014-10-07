Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaJGOLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:11:30 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33500 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbaJGOL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:11:27 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-31-5433f48c9188
Message-id: <5433F48B.8060306@samsung.com>
Date: Tue, 07 Oct 2014 16:11:23 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        "open list:DRM DRIVERS FOR E..." <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, m.szyprowski@samsung.com
Subject: Re: [PATCH] drm/exynos: remove explicit encoder/connector
 de-initialization
References: <1411378248-17479-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1411378248-17479-1-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/xK7o9X4xDDPb+sbHoPXeSyeLK1/ds
	FpPuT2CxeHHvIotF74KrbBZnm96wW1zeNYfNYsb5fUwWa4/cZbeYMfklmwOXx/ZvD1g97ncf
	Z/Lo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujL9HrrAVNCpUtHZPZG1g/CXVxcjJISFgIvH3
	4jFGCFtM4sK99WxdjFwcQgJLGSWObZ3DCuF8YpToOHKRBaSKV0BLYv7912AdLAKqEtsn/2YH
	sdkENCX+br7JBmKLCkRInLy7hx2iXlDix+R7YL0iAsoSq/a1s4MMZRZYzCxxZsp2sAZhgTCJ
	5ZOeg9lCAs4Sr349YwWxOQVcJH7sbgJq4ABq0JO4f1ELJMwsIC+xec1b5gmMArOQrJiFUDUL
	SdUCRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCGB/2UH4+JjVocYBTgYlXh4Nxgahwix
	JpYVV+YeYpTgYFYS4Z3yHijEm5JYWZValB9fVJqTWnyIkYmDU6qBceGK1XJtNwRe+T0suJ7x
	xjhxYevMdMnlVy63xObsW5276oT04qNeguF6prnLb+czRsdq+2pz+TLM0tOZq+hzXPfBwdZ3
	/KKPwyZver1nvenKBU13Qj2dNt6OY/h1j835+2QdDpYclmUPft1huhzcv3NmQYOdR+7jtVUr
	F/GEzfmz0+xGMuO7q0osxRmJhlrMRcWJAAMVi0xaAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Inki,

Another gently ping :)

Andrzej

On 09/22/2014 11:30 AM, Andrzej Hajda wrote:
> All KMS objects are destroyed by drm_mode_config_cleanup in proper order
> so component drivers should not care about it.
>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
> Hi Inki,
>
> This is another spin-off of exynos_drm tests regarding your
> component support update.
> The patch is based as usual on the latest exynos-drm-next branch.
>
> Regards
> Andrzej
> ---
>  drivers/gpu/drm/exynos/exynos_dp_core.c  | 5 -----
>  drivers/gpu/drm/exynos/exynos_drm_dpi.c  | 4 ----
>  drivers/gpu/drm/exynos/exynos_drm_dsi.c  | 4 ----
>  drivers/gpu/drm/exynos/exynos_drm_vidi.c | 3 ---
>  drivers/gpu/drm/exynos/exynos_hdmi.c     | 6 ------
>  5 files changed, 22 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_dp_core.c b/drivers/gpu/drm/exynos/exynos_dp_core.c
> index cd50ece..6adb1e5 100644
> --- a/drivers/gpu/drm/exynos/exynos_dp_core.c
> +++ b/drivers/gpu/drm/exynos/exynos_dp_core.c
> @@ -1355,13 +1355,8 @@ static void exynos_dp_unbind(struct device *dev, struct device *master,
>  				void *data)
>  {
>  	struct exynos_drm_display *display = dev_get_drvdata(dev);
> -	struct exynos_dp_device *dp = display->ctx;
> -	struct drm_encoder *encoder = dp->encoder;
>  
>  	exynos_dp_dpms(display, DRM_MODE_DPMS_OFF);
> -
> -	exynos_dp_connector_destroy(&dp->connector);
> -	encoder->funcs->destroy(encoder);
>  }
>  
>  static const struct component_ops exynos_dp_ops = {
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_dpi.c b/drivers/gpu/drm/exynos/exynos_drm_dpi.c
> index 96c87db..3dc678e 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_dpi.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_dpi.c
> @@ -338,14 +338,10 @@ err_del_component:
>  
>  int exynos_dpi_remove(struct device *dev)
>  {
> -	struct drm_encoder *encoder = exynos_dpi_display.encoder;
>  	struct exynos_dpi *ctx = exynos_dpi_display.ctx;
>  
>  	exynos_dpi_dpms(&exynos_dpi_display, DRM_MODE_DPMS_OFF);
>  
> -	exynos_dpi_connector_destroy(&ctx->connector);
> -	encoder->funcs->destroy(encoder);
> -
>  	if (ctx->panel)
>  		drm_panel_detach(ctx->panel);
>  
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
> index 24741d8..acf7e9e 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
> @@ -1660,13 +1660,9 @@ static void exynos_dsi_unbind(struct device *dev, struct device *master,
>  				void *data)
>  {
>  	struct exynos_dsi *dsi = exynos_dsi_display.ctx;
> -	struct drm_encoder *encoder = dsi->encoder;
>  
>  	exynos_dsi_dpms(&exynos_dsi_display, DRM_MODE_DPMS_OFF);
>  
> -	exynos_dsi_connector_destroy(&dsi->connector);
> -	encoder->funcs->destroy(encoder);
> -
>  	mipi_dsi_host_unregister(&dsi->dsi_host);
>  }
>  
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_vidi.c b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
> index d565207..9395e85 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
> @@ -639,9 +639,6 @@ static int vidi_remove(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> -	encoder->funcs->destroy(encoder);
> -	drm_connector_cleanup(&ctx->connector);
> -
>  	return 0;
>  }
>  
> diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
> index 7910fb3..563a19e 100644
> --- a/drivers/gpu/drm/exynos/exynos_hdmi.c
> +++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
> @@ -2312,12 +2312,6 @@ static int hdmi_bind(struct device *dev, struct device *master, void *data)
>  
>  static void hdmi_unbind(struct device *dev, struct device *master, void *data)
>  {
> -	struct exynos_drm_display *display = get_hdmi_display(dev);
> -	struct drm_encoder *encoder = display->encoder;
> -	struct hdmi_context *hdata = display->ctx;
> -
> -	hdmi_connector_destroy(&hdata->connector);
> -	encoder->funcs->destroy(encoder);
>  }
>  
>  static const struct component_ops hdmi_component_ops = {

