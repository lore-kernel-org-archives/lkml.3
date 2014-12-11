Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbaLKEgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 23:36:40 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:49992 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaLKEgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 23:36:38 -0500
MIME-Version: 1.0
In-Reply-To: <1417761259-17429-1-git-send-email-andy.yan@rock-chips.com>
References: <1417760564-16858-1-git-send-email-andy.yan@rock-chips.com> <1417761259-17429-1-git-send-email-andy.yan@rock-chips.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 10 Dec 2014 20:36:17 -0800
X-Google-Sender-Auth: W4E2SkdYNPjyOcA-nx_0t5YNqCc
Message-ID: <CAGS+omA1Gf8yqrd4Bu=Pm1OBdsJBHg0gt+TP_6vi88Zz+O3jHA@mail.gmail.com>
Subject: Re: [PATCH v18 12/12] drm: bridge/dw_hdmi: add rockchip rk3288 support
To: Andy Yan <andy.yan@rock-chips.com>
Cc: David Airlie <airlied@linux.ie>, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        fabio.estevam@freescale.com, rmk+kernel@arm.linux.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>,
        Yakir Yang <ykk@rock-chips.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        devel@driverdev.osuosl.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Xu Jianqun <jay.xu@rock-chips.com>, Pawel Moll <pawel.moll@arm.com>,
        "mark.yao@rock-chips.com" <mark.yao@rock-chips.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, vladimir_zapolskiy@mentor.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

This driver adds HDMI to rockchip/drm.  The fact that rockchip's hdmi
uses dw_hdmi is an implementation detail.  I do not think that the names
used for rk3288-hdmi should include "dw" in them.

See inline for what I mean...

On Thu, Dec 4, 2014 at 10:34 PM, Andy Yan <andy.yan@rock-chips.com> wrote:
> Rockchip RK3288 hdmi is compatible with dw_hdmi
>
> this patch is depend on patch by Mark Yao
> drm: rockchip: Add basic drm driver
> see https://lkml.org/lkml/2014/12/2/161
>
> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
>
> ---
>
> Changes in v18: None
> Changes in v17:
> - parse resource and irq in platform driver
>
> Changes in v16: None
> Changes in v15:
> - remove THIS_MODULE in platform driver
>
> Changes in v14: None
> Changes in v13: None
> Changes in v12:
> - add comment for the depend on patch
>
> Changes in v11: None
> Changes in v10:
> - add more display mode support mpll configuration for rk3288
>
> Changes in v9:
> - move some phy configuration to platform driver
>
> Changes in v8: None
> Changes in v7: None
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
>
>  drivers/gpu/drm/bridge/dw_hdmi.c            |   3 +
>  drivers/gpu/drm/rockchip/Kconfig            |  10 +
>  drivers/gpu/drm/rockchip/Makefile           |   2 +
>  drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c | 341 ++++++++++++++++++++++++++++
>  include/drm/bridge/dw_hdmi.h                |   1 +
>  5 files changed, 357 insertions(+)
>  create mode 100644 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
>
> diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
> index cecc46a..01c95a8 100644
> --- a/drivers/gpu/drm/bridge/dw_hdmi.c
> +++ b/drivers/gpu/drm/bridge/dw_hdmi.c
> @@ -852,6 +852,9 @@ static int hdmi_phy_configure(struct dw_hdmi *hdmi, unsigned char prep,
>         dw_hdmi_phy_gen2_txpwron(hdmi, 1);
>         dw_hdmi_phy_gen2_pddq(hdmi, 0);
>
> +       if (hdmi->dev_type == RK3288_HDMI)
> +               dw_hdmi_phy_enable_spare(hdmi, 1);
> +
>         /*Wait for PHY PLL lock */
>         msec = 5;
>         do {
> diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockchip/Kconfig
> index ca9f085..6ebebe8 100644
> --- a/drivers/gpu/drm/rockchip/Kconfig
> +++ b/drivers/gpu/drm/rockchip/Kconfig
> @@ -15,3 +15,13 @@ config DRM_ROCKCHIP
>           management to userspace. This driver does not provide
>           2D or 3D acceleration; acceleration is performed by other
>           IP found on the SoC.
> +
> +config ROCKCHIP_DW_HDMI

I would rather call this ROCKCHIP_HDMI, since this driver implements
the HDMI for Rockchip.  The fact that it uses dw_hdmi is an
implementation detail.

> +        bool "Rockchip specific extensions for Synopsys DW HDMI"
> +        depends on DRM_ROCKCHIP
> +        select DRM_DW_HDMI
> +        help
> +         This selects support for Rockchip SoC specific extensions
> +         for the Synopsys DesignWare HDMI driver. If you want to
> +         enable HDMI on RK3288 based SoC, you should selet this
> +         option.

This could become simply:

  Select this option to enable HDMI support for Rockchip SoCs.


> diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/rockchip/Makefile
> index 2cb0672..beed7df 100644
> --- a/drivers/gpu/drm/rockchip/Makefile
> +++ b/drivers/gpu/drm/rockchip/Makefile
> @@ -5,4 +5,6 @@
>  rockchipdrm-y := rockchip_drm_drv.o rockchip_drm_fb.o rockchip_drm_fbdev.o \
>                 rockchip_drm_gem.o
>
> +rockchipdrm-$(CONFIG_ROCKCHIP_DW_HDMI) += dw_hdmi-rockchip.o
> +
>  obj-$(CONFIG_DRM_ROCKCHIP) += rockchipdrm.o rockchip_drm_vop.o
> diff --git a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
> new file mode 100644
> index 0000000..11d54b0
> --- /dev/null
> +++ b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c

Similarly, I'd rather this file be called drm_rockchip_hdmi.c to be
consistent with the rest of the files in drm/rockchip.

> @@ -0,0 +1,341 @@
> +/*
> + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
> +#include <drm/drm_of.h>
> +#include <drm/drmP.h>
> +#include <drm/drm_crtc_helper.h>
> +#include <drm/drm_edid.h>
> +#include <drm/drm_encoder_slave.h>
> +#include <drm/bridge/dw_hdmi.h>
> +
> +#include "rockchip_drm_drv.h"
> +#include "rockchip_drm_vop.h"
> +
> +#define GRF_SOC_CON6                    0x025c
> +#define HDMI_SEL_VOP_LIT                (1 << 4)
> +
> +struct rockchip_hdmi {
> +       struct device *dev;
> +       struct regmap *regmap;
> +       struct drm_encoder encoder;
> +};
> +
> +#define to_rockchip_hdmi(x)    container_of(x, struct rockchip_hdmi, x)
> +
> +static const struct dw_hdmi_mpll_config rockchip_mpll_cfg[] = {

Let's stick to mpll_config.  Not much value to abbreviate an abbreviation.

> +       {
> +               27000000, {
> +                       { 0x00b3, 0x0000},

space before all of these '}'.

> +                       { 0x2153, 0x0000},
> +                       { 0x40f3, 0x0000}
> +               },
> +       }, {
> +               36000000, {
> +                       { 0x00b3, 0x0000},
> +                       { 0x2153, 0x0000},
> +                       { 0x40f3, 0x0000}
> +               },
> +       }, {
> +               40000000, {
> +                       { 0x00b3, 0x0000},
> +                       { 0x2153, 0x0000},
> +                       { 0x40f3, 0x0000}
> +               },
> +       }, {
> +               54000000, {
> +                       { 0x0072, 0x0001},
> +                       { 0x2142, 0x0001},
> +                       { 0x40a2, 0x0001},
> +               },
> +       }, {
> +               65000000, {
> +                       { 0x0072, 0x0001},
> +                       { 0x2142, 0x0001},
> +                       { 0x40a2, 0x0001},
> +               },
> +       }, {
> +               66000000, {
> +                       { 0x013e, 0x0003},
> +                       { 0x217e, 0x0002},
> +                       { 0x4061, 0x0002}
> +               },
> +       }, {
> +               74250000, {
> +                       { 0x0072, 0x0001},
> +                       { 0x2145, 0x0002},
> +                       { 0x4061, 0x0002}
> +               },
> +       }, {
> +               83500000, {
> +                       { 0x0072, 0x0001},
> +               },
> +       }, {
> +               108000000, {
> +                       { 0x0051, 0x0002},
> +                       { 0x2145, 0x0002},
> +                       { 0x4061, 0x0002}
> +               },
> +       }, {
> +               106500000, {
> +                       { 0x0051, 0x0002},
> +                       { 0x2145, 0x0002},
> +                       { 0x4061, 0x0002}
> +               },
> +       }, {
> +               146250000, {
> +                       { 0x0051, 0x0002},
> +                       { 0x2145, 0x0002},
> +                       { 0x4061, 0x0002}
> +               },
> +       }, {
> +               148500000, {
> +                       { 0x0051, 0x0003},
> +                       { 0x214c, 0x0003},
> +                       { 0x4064, 0x0003}
> +               },
> +       }, {
> +               ~0UL, {
> +                       { 0x00a0, 0x000a },
> +                       { 0x2001, 0x000f },
> +                       { 0x4002, 0x000f },
> +               },
> +       }
> +};
> +
> +static const struct dw_hdmi_curr_ctrl rockchip_cur_ctr[] = {
> +       /*      pixelclk    bpp8    bpp10   bpp12 */
> +       {
> +               40000000,  { 0x0018, 0x0018, 0x0018 },
> +       }, {
> +               65000000,  { 0x0028, 0x0028, 0x0028 },
> +       }, {
> +               66000000,  { 0x0038, 0x0038, 0x0038 },
> +       }, {
> +               74250000,  { 0x0028, 0x0038, 0x0038 },
> +       }, {
> +               83500000,  { 0x0028, 0x0038, 0x0038 },
> +       }, {
> +               146250000, { 0x0038, 0x0038, 0x0038 },
> +       }, {
> +               148500000, { 0x0000, 0x0038, 0x0038 },
> +       }, {
> +               ~0UL,      { 0x0000, 0x0000, 0x0000},
> +       }
> +};
> +
> +static const struct dw_hdmi_sym_term rockchip_sym_term[] = {
> +       /*pixelclk   symbol   term*/
> +       { 74250000,  0x8009, 0x0004 },
> +       { 148500000, 0x8029, 0x0004 },
> +       { 297000000, 0x8039, 0x0005 },
> +       { ~0UL,      0x0000, 0x0000 }
> +};
> +
> +static int rockchip_hdmi_parse_dt(struct rockchip_hdmi *hdmi)
> +{
> +       struct device_node *np = hdmi->dev->of_node;
> +
> +       hdmi->regmap = syscon_regmap_lookup_by_phandle(np, "rockchip,grf");
> +       if (IS_ERR(hdmi->regmap)) {
> +               dev_err(hdmi->dev, "Unable to get rockchip,grf\n");
> +               return PTR_ERR(hdmi->regmap);
> +       }
> +
> +       return 0;
> +}
> +
> +static enum drm_mode_status
> +dw_hdmi_rockchip_mode_valid(struct drm_connector *connector,

Similarly, I would rename these function names to start with
rockchip_hdmi (or maybe rk_hdmi for brevity).
Especially the ones for the module & driver: (bind/unbind/probe/remove).

> +                           struct drm_display_mode *mode)
> +{
> +       const struct dw_hdmi_mpll_config *mpll_cfg = rockchip_mpll_cfg;
> +       int pclk = mode->clock * 1000;
> +       bool valid = false;
> +       int i;
> +
> +       for (i = 0; mpll_cfg[i].mpixelclock != (~0UL); i++) {
> +               if (pclk == mpll_cfg[i].mpixelclock) {
> +                       valid = true;

Perhaps you can simplify this a bit:

     for (i = 0; mpll_cfg[i].mpixelclock != (~0UL); i++)
               if (pclk == mpll_cfg[i].mpixelclock)
                  return MODE_OK;
     return MODE_BAD;

> +}
> +
> +static struct drm_encoder_funcs dw_hdmi_rockchip_encoder_funcs = {
> +       .destroy = drm_encoder_cleanup,
> +};
> +
> +static void dw_hdmi_rockchip_encoder_disable(struct drm_encoder *encoder)
> +{
> +}
> +
> +static bool
> +dw_hdmi_rockchip_encoder_mode_fixup(struct drm_encoder *encoder,
> +                                   const struct drm_display_mode *mode,
> +                                   struct drm_display_mode *adj_mode)
> +{
> +       return true;
> +}
> +
> +static void dw_hdmi_rockchip_encoder_mode_set(struct drm_encoder *encoder,
> +                                             struct drm_display_mode *mode,
> +                                             struct drm_display_mode *adj_mode)
> +{
> +}
> +
> +static void dw_hdmi_rockchip_encoder_commit(struct drm_encoder *encoder)
> +{
> +       struct rockchip_hdmi *hdmi = to_rockchip_hdmi(encoder);
> +       u32 val;
> +       int mux;
> +
> +       mux = rockchip_drm_encoder_get_mux_id(hdmi->dev->of_node, encoder);
> +       if (mux)
> +               val = HDMI_SEL_VOP_LIT | (HDMI_SEL_VOP_LIT << 16);
> +       else
> +               val = HDMI_SEL_VOP_LIT << 16;
> +
> +       regmap_write(hdmi->regmap, GRF_SOC_CON6, val);
> +       dev_dbg(hdmi->dev, "vop %s output to hdmi\n",
> +               (mux) ? "LIT" : "BIG");
> +}
> +
> +static void dw_hdmi_rockchip_encoder_prepare(struct drm_encoder *encoder)
> +{
> +       rockchip_drm_crtc_mode_config(encoder->crtc, DRM_MODE_CONNECTOR_HDMIA,
> +                                     ROCKCHIP_OUT_MODE_AAAA);
> +}
> +
> +static struct drm_encoder_helper_funcs dw_hdmi_rockchip_encoder_helper_funcs = {

"static const" here and for the other function tables.

> +       .mode_fixup = dw_hdmi_rockchip_encoder_mode_fixup,
> +       .mode_set   = dw_hdmi_rockchip_encoder_mode_set,
> +       .prepare    = dw_hdmi_rockchip_encoder_prepare,
> +       .commit     = dw_hdmi_rockchip_encoder_commit,
> +       .disable    = dw_hdmi_rockchip_encoder_disable,
> +};
> +
> +static const struct dw_hdmi_plat_data rockchip_hdmi_drv_data = {
> +       .mode_valid = dw_hdmi_rockchip_mode_valid,
> +       .mpll_cfg   = rockchip_mpll_cfg,
> +       .cur_ctr    = rockchip_cur_ctr,
> +       .sym_term   = rockchip_sym_term,
> +       .dev_type   = RK3288_HDMI,
> +};
> +
> +static const struct of_device_id dw_hdmi_rockchip_ids[] = {
> +       { .compatible = "rockchip,rk3288-dw-hdmi",

.compatible = "rockchip,rk3288-hdmi",


> +         .data = &rockchip_hdmi_drv_data
> +       },
> +       {},
> +};
> +MODULE_DEVICE_TABLE(of, dw_hdmi_rockchip_dt_ids);
> +
> +static int dw_hdmi_rockchip_bind(struct device *dev, struct device *master,
> +                                void *data)
> +{
> +       struct platform_device *pdev = to_platform_device(dev);
> +       const struct dw_hdmi_plat_data *plat_data;
> +       const struct of_device_id *match;
> +       struct drm_device *drm = data;
> +       struct drm_encoder *encoder;
> +       struct rockchip_hdmi *hdmi;
> +       struct resource *iores;
> +       int irq;
> +       int ret;
> +
> +       if (!pdev->dev.of_node)
> +               return -ENODEV;
> +
> +       hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
> +       if (!hdmi)
> +               return -ENOMEM;
> +
> +       match = of_match_node(dw_hdmi_rockchip_ids, pdev->dev.of_node);
> +       plat_data = match->data;
> +       hdmi->dev = &pdev->dev;
> +       encoder = &hdmi->encoder;
> +
> +       irq = platform_get_irq(pdev, 0);
> +       if (irq < 0)
> +               return irq;
> +
> +       iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!iores)
> +               return -ENXIO;
> +
> +       platform_set_drvdata(pdev, hdmi);
> +
> +       encoder->possible_crtcs = drm_of_find_possible_crtcs(drm, dev->of_node);
> +       /*
> +        * If we failed to find the CRTC(s) which this encoder is
> +        * supposed to be connected to, it's because the CRTC has
> +        * not been registered yet.  Defer probing, and hope that
> +        * the required CRTC is added later.

Nit: it looks like the text lines for this comment could be longer

> +        */
> +       if (encoder->possible_crtcs == 0)
> +               return -EPROBE_DEFER;
> +
> +       ret = rockchip_hdmi_parse_dt(hdmi);
> +       if (ret) {
> +               dev_err(hdmi->dev, "Unable to parse OF data\n");
> +               return ret;
> +       }
> +
> +       drm_encoder_helper_add(encoder, &dw_hdmi_rockchip_encoder_helper_funcs);
> +       drm_encoder_init(drm, encoder, &dw_hdmi_rockchip_encoder_funcs,
> +                        DRM_MODE_ENCODER_TMDS);
> +
> +       return dw_hdmi_bind(dev, master, data, encoder, iores, irq, plat_data);
> +}
> +
> +static void dw_hdmi_rockchip_unbind(struct device *dev, struct device *master,
> +                                   void *data)
> +{
> +       return dw_hdmi_unbind(dev, master, data);
> +}
> +
> +static const struct component_ops dw_hdmi_rockchip_ops = {
> +       .bind   = dw_hdmi_rockchip_bind,
> +       .unbind = dw_hdmi_rockchip_unbind,
> +};
> +
> +static int dw_hdmi_rockchip_probe(struct platform_device *pdev)
> +{
> +       return component_add(&pdev->dev, &dw_hdmi_rockchip_ops);
> +}
> +
> +static int dw_hdmi_rockchip_remove(struct platform_device *pdev)
> +{
> +       component_del(&pdev->dev, &dw_hdmi_rockchip_ops);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver dw_hdmi_rockchip_pltfm_driver = {
> +       .probe  = dw_hdmi_rockchip_probe,
> +       .remove = dw_hdmi_rockchip_remove,
> +       .driver = {
> +               .name = "dwhdmi-rockchip",

"rockchip-hdmi"

> +               .of_match_table = dw_hdmi_rockchip_ids,
> +       },
> +};
> +
> +module_platform_driver(dw_hdmi_rockchip_pltfm_driver);
> +
> +MODULE_AUTHOR("Andy Yan <andy.yan@rock-chips.com>");
> +MODULE_AUTHOR("Yakir Yang <ykk@rock-chips.com>");
> +MODULE_DESCRIPTION("Rockchip Specific DW-HDMI Driver Extension");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:dwhdmi-rockchip");

Why do we need this alias?

> diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
> index b64e58a..5a4f490 100644
> --- a/include/drm/bridge/dw_hdmi.h
> +++ b/include/drm/bridge/dw_hdmi.h
> @@ -22,6 +22,7 @@ enum {
>  enum dw_hdmi_devtype {
>         IMX6Q_HDMI,
>         IMX6DL_HDMI,
> +       RK3288_HDMI,
>  };
>
>  struct dw_hdmi_mpll_config {
> --
> 1.9.1
>
>
