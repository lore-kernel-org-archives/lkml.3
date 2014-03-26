Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaCZE2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 00:28:07 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:33393 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaCZE2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 00:28:05 -0400
MIME-Version: 1.0
In-Reply-To: <1395650554-31925-13-git-send-email-acourbot@nvidia.com>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
	<1395650554-31925-13-git-send-email-acourbot@nvidia.com>
Date: Wed, 26 Mar 2014 14:28:04 +1000
Message-ID: <CACAvsv561r73CmL0rf_bvM9JVMV+E7J_VT3ZDuwyCxviJBa8Cw@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 12/12] drm/nouveau: support for probing GK20A
From: Ben Skeggs <skeggsb@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 6:42 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Set the correct subdev/engine classes when GK20A (0xea) is probed.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/nouveau/core/engine/device/nve0.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/drivers/gpu/drm/nouveau/core/engine/device/nve0.c b/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
> index 987edbc30a09..8509dd57de1f 100644
> --- a/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
> +++ b/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
> @@ -156,6 +156,26 @@ nve0_identify(struct nouveau_device *device)
>                 device->oclass[NVDEV_ENGINE_PPP    ] = &nvc0_ppp_oclass;
>                 device->oclass[NVDEV_ENGINE_PERFMON] = &nve0_perfmon_oclass;
>                 break;
> +       case 0xea:
> +               device->cname = "GK20A";
> +               device->oclass[NVDEV_SUBDEV_MC     ] =  nvc3_mc_oclass;
> +               device->oclass[NVDEV_SUBDEV_BUS    ] =  nvc0_bus_oclass;
> +               device->oclass[NVDEV_SUBDEV_TIMER  ] = &nv04_timer_oclass;
As per note on the PTIMER patch, can just switch this to
"gk20a_timer_oclass" on the latest code.

> +               device->oclass[NVDEV_SUBDEV_FB     ] =  nvea_fb_oclass;
> +               device->oclass[NVDEV_SUBDEV_IBUS   ] = &nvea_ibus_oclass;
> +               device->oclass[NVDEV_SUBDEV_INSTMEM] = nv50_instmem_oclass;
> +               device->oclass[NVDEV_SUBDEV_VM     ] = &nvc0_vmmgr_oclass;
> +               device->oclass[NVDEV_SUBDEV_BAR    ] = &nvc0_bar_oclass;
> +               device->oclass[NVDEV_ENGINE_DMAOBJ ] = &nvd0_dmaeng_oclass;
> +               device->oclass[NVDEV_ENGINE_FIFO   ] =  nvea_fifo_oclass;
> +               /* TODO will need an implementation for this at some point... */
> +#if 0
> +               device->oclass[NVDEV_ENGINE_SW     ] =  nvc0_software_oclass;
> +#endif
> +               device->oclass[NVDEV_ENGINE_GR     ] =  nvea_graph_oclass;
> +               device->oclass[NVDEV_ENGINE_COPY2  ] = &nve0_copy2_oclass;
> +               device->oclass[NVDEV_ENGINE_PERFMON] = &nve0_perfmon_oclass;
> +               break;
>         case 0xf0:
>                 device->cname = "GK110";
>                 device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
> --
> 1.9.1
>
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/nouveau
