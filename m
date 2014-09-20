Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbaITADN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 20:03:13 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:65188 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485AbaITADL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 20:03:11 -0400
MIME-Version: 1.0
In-Reply-To: <1411105668-32722-2-git-send-email-mark.yao@rock-chips.com>
References: <1411105668-32722-1-git-send-email-mark.yao@rock-chips.com>
	<1411105668-32722-2-git-send-email-mark.yao@rock-chips.com>
Date: Fri, 19 Sep 2014 20:03:09 -0400
Message-ID: <CAF6AEGsPoj6+PdKCJk5BPPzHS51Tz1FGqS2SjpartaRw7i=Pxg@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] drm/rockchip: Add basic drm driver
From: Rob Clark <robdclark@gmail.com>
To: Mark yao <mark.yao@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org,
        dianders@chromium.org,
        =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
        dbehr@chromium.org, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>, Jianqun Xu <xjq@rock-chips.com>,
        kfx@rock-chips.com, jeff chen <cym@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Chris Zhong <zyw@rock-chips.com>,
        xxm@rock-chips.com, Tao Huang <huangtao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>, yxj@rock-chips.com,
        wxt@rock-chips.com, xw@rock-chips.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 1:47 AM, Mark yao <mark.yao@rock-chips.com> wrote:
> diff --git a/include/uapi/drm/rockchip_drm.h b/include/uapi/drm/rockchip_drm.h
> new file mode 100644
> index 0000000..8f8e60e
> --- /dev/null
> +++ b/include/uapi/drm/rockchip_drm.h
> @@ -0,0 +1,97 @@
> +/*
> + *
> + * Copyright (c) Fuzhou Rockchip Electronics Co.Ltd
> + * Authors:
> + *       Mark Yao <yzq@rock-chips.com>
> + *
> + * base on exynos_drm.h
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef _UAPI_ROCKCHIP_DRM_H
> +#define _UAPI_ROCKCHIP_DRM_H
> +
> +#include <drm/drm.h>
> +
> +/**
> + * User-desired buffer creation information structure.
> + *
> + * @size: user-desired memory allocation size.
> + * @flags: user request for setting memory type or cache attributes.
> + * @handle: returned a handle to created gem object.
> + *     - this handle will be set by gem module of kernel side.
> + */
> +struct drm_rockchip_gem_create {
> +       uint64_t size;
> +       uint32_t flags;
> +       uint32_t handle;
> +};
> +
> +/**
> + * A structure for getting buffer offset.
> + *
> + * @handle: a pointer to gem object created.
> + * @pad: just padding to be 64-bit aligned.
> + * @offset: relatived offset value of the memory region allocated.
> + *     - this value should be set by user.
> + */
> +struct drm_rockchip_gem_map_off {
> +       uint32_t handle;
> +       uint32_t pad;
> +       uint64_t offset;
> +};
> +
> +/**
> + * A structure for mapping buffer.
> + *
> + * @handle: a handle to gem object created.
> + * @pad: just padding to be 64-bit aligned.
> + * @size: memory size to be mapped.
> + * @mapped: having user virtual address mmaped.
> + *      - this variable would be filled by rockchip gem module
> + *      of kernel side with user virtual address which is allocated
> + *      by do_mmap().
> + */
> +struct drm_rockchip_gem_mmap {
> +       uint32_t handle;
> +       uint32_t pad;
> +       uint64_t size;
> +       uint64_t mapped;
> +};

Could we do without the mmap ioctl?  It has been a source of problems
in other drivers, and the ioctl to get mmap offset, plus normal mmap()
on drm device file should be sufficient

BR,
-R


> +/**
> + * A structure to gem information.
> + *
> + * @handle: a handle to gem object created.
> + * @flags: flag value including memory type and cache attribute and
> + *      this value would be set by driver.
> + * @size: size to memory region allocated by gem and this size would
> + *      be set by driver.
> + */
> +struct drm_rockchip_gem_info {
> +       uint32_t handle;
> +       uint32_t flags;
> +       uint64_t size;
> +};
> +
> +#define DRM_ROCKCHIP_GEM_CREATE                0x00
> +#define DRM_ROCKCHIP_GEM_MAP_OFFSET    0x01
> +#define DRM_ROCKCHIP_GEM_MMAP          0x02
> +#define DRM_ROCKCHIP_GEM_GET           0x04
> +
> +#define DRM_IOCTL_ROCKCHIP_GEM_CREATE  DRM_IOWR(DRM_COMMAND_BASE + \
> +               DRM_ROCKCHIP_GEM_CREATE, struct drm_rockchip_gem_create)
> +
> +#define DRM_IOCTL_ROCKCHIP_GEM_MAP_OFFSET      DRM_IOWR(DRM_COMMAND_BASE + \
> +               DRM_ROCKCHIP_GEM_MAP_OFFSET, struct drm_rockchip_gem_map_off)
> +
> +#define DRM_IOCTL_ROCKCHIP_GEM_MMAP    DRM_IOWR(DRM_COMMAND_BASE + \
> +               DRM_ROCKCHIP_GEM_MMAP, struct drm_rockchip_gem_mmap)
> +
> +#define DRM_IOCTL_ROCKCHIP_GEM_GET     DRM_IOWR(DRM_COMMAND_BASE + \
> +               DRM_ROCKCHIP_GEM_GET, struct drm_rockchip_gem_info)
> +#endif /* _UAPI_ROCKCHIP_DRM_H */
