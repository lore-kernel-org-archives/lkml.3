Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaIYX4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 19:56:39 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:58388 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaIYX4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 19:56:36 -0400
MIME-Version: 1.0
In-Reply-To: <1411524746-14635-1-git-send-email-mark.yao@rock-chips.com>
References: <1411524672-14524-1-git-send-email-mark.yao@rock-chips.com>
	<1411524746-14635-1-git-send-email-mark.yao@rock-chips.com>
Date: Thu, 25 Sep 2014 19:56:34 -0400
Message-ID: <CAF6AEGu+EBtYyfpthk8NaPuh6cAQXDc+=hnNORRZqb4t=yO00g@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] drm/rockchip: Add basic drm driver
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
        Douglas Anderson <dianders@chromium.org>,
        =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
        dbehr@chromium.org, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>, Jianqun Xu <xjq@rock-chips.com>,
        kfx@rock-chips.com, jeff chen <cym@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Chris Zhong <zyw@rock-chips.com>,
        simon xue <xxm@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>, yxj@rock-chips.com,
        =?UTF-8?B?546L5pmT6IW+?= <wxt@rock-chips.com>, xw@rock-chips.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 10:12 PM, Mark yao <mark.yao@rock-chips.com> wrote:
> This patch adds the basic structure of a DRM Driver for Rockchip Socs.
>
> Signed-off-by: Mark yao <mark.yao@rock-chips.com>

Looks like my comments are addressed, so:

Reviewed-by: Rob Clark <robdclark@gmail.com>

> ---
> Changes in v2:
> - use the component framework to defer main drm driver probe
>   until all VOP devices have been probed.
> - use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mapping by
>   master device and each vop device can shared the drm dma mapping.
> - use drm_crtc_init_with_planes and drm_universal_plane_init.
> - remove unnecessary middle layers.
> - add cursor set, move funcs to rockchip drm crtc.
> - use vop reset at first init
> - reference framebuffer when used and unreference when swap out vop
>
> Changes in v3:
> - change "crtc->fb" to "crtc->primary-fb"
> Adviced by Daniel Vetter
> - init cursor plane with universal api, remove unnecessary cursor set,move
>
> Changes in v4:
> Adviced by David Herrmann
> - remove drm_platform_*() usage, use register drm device directly.
> Adviced by Rob Clark
> - remove special mmap ioctl, do userspace mmap with normal mmap() or mmap offset
>
> Changes in v5:
> Adviced by Arnd Bergmann
> - doing DMA start with a 32-bit masks with dma_mask and dma_coherent_mark
> - fix some incorrect dependencies.
> Adviced by Boris BREZILLON
> - fix some mistake and bugs.
> Adviced by Daniel Vetter
> - drop all special ioctl and use generic kms ioctl instead.
> Adviced by Rob Clark
> - use unlocked api for drm_fb_helper_restore_fbdev_mode.
> - remove unused rockchip_gem_prime_import_sg_table.
>
>  drivers/gpu/drm/Kconfig                       |    2 +
>  drivers/gpu/drm/Makefile                      |    1 +
>  drivers/gpu/drm/rockchip/Kconfig              |   17 +
>  drivers/gpu/drm/rockchip/Makefile             |    8 +
>  drivers/gpu/drm/rockchip/rockchip_drm_drv.c   |  509 +++++++++
>  drivers/gpu/drm/rockchip/rockchip_drm_drv.h   |  120 +++
>  drivers/gpu/drm/rockchip/rockchip_drm_fb.c    |  201 ++++
>  drivers/gpu/drm/rockchip/rockchip_drm_fb.h    |   28 +
>  drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c |  230 +++++
>  drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h |   20 +
>  drivers/gpu/drm/rockchip/rockchip_drm_gem.c   |  341 ++++++
>  drivers/gpu/drm/rockchip/rockchip_drm_gem.h   |   55 +
>  drivers/gpu/drm/rockchip/rockchip_drm_vop.c   | 1373 +++++++++++++++++++++++++
>  drivers/gpu/drm/rockchip/rockchip_drm_vop.h   |  187 ++++
>  14 files changed, 3092 insertions(+)
>  create mode 100644 drivers/gpu/drm/rockchip/Kconfig
>  create mode 100644 drivers/gpu/drm/rockchip/Makefile
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.c
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.h
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.c
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.h
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.c
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.h
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.c
>  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.h
