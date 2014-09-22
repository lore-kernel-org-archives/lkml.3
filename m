Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaIVBcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 21:32:31 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:49743 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaIVBc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 21:32:28 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: robdclark@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <3ef829fbfc7445ead3b5be53fe2c45f3>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <541F7C23.8000103@rock-chips.com>
Date: Mon, 22 Sep 2014 09:32:19 +0800
From: Mark yao <mark.yao@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rob Clark <robdclark@gmail.com>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
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
        =?UTF-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu@chromium.org>,
        dbehr@chromium.org, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>, Jianqun Xu <xjq@rock-chips.com>,
        kfx@rock-chips.com, jeff chen <cym@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Chris Zhong <zyw@rock-chips.com>,
        xxm@rock-chips.com, Tao Huang <huangtao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>, yxj@rock-chips.com,
        wxt@rock-chips.com, xw@rock-chips.com
Subject: Re: [PATCH v3 1/5] drm/rockchip: Add basic drm driver
References: <1411105668-32722-1-git-send-email-mark.yao@rock-chips.com>	<1411105668-32722-2-git-send-email-mark.yao@rock-chips.com> <CAF6AEGsPoj6+PdKCJk5BPPzHS51Tz1FGqS2SjpartaRw7i=Pxg@mail.gmail.com>
In-Reply-To: <CAF6AEGsPoj6+PdKCJk5BPPzHS51Tz1FGqS2SjpartaRw7i=Pxg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年09月20日 08:03, Rob Clark wrote:
> On Fri, Sep 19, 2014 at 1:47 AM, Mark yao <mark.yao@rock-chips.com> wrote:
>> diff --git a/include/uapi/drm/rockchip_drm.h b/include/uapi/drm/rockchip_drm.h
>> new file mode 100644
>> index 0000000..8f8e60e
>> --- /dev/null
>> +++ b/include/uapi/drm/rockchip_drm.h
>> @@ -0,0 +1,97 @@
>> +/*
>> + *
>> + * Copyright (c) Fuzhou Rockchip Electronics Co.Ltd
>> + * Authors:
>> + *       Mark Yao <yzq@rock-chips.com>
>> + *
>> + * base on exynos_drm.h
>> + *
>> + * This program is free software; you can redistribute  it and/or modify it
>> + * under  the terms of  the GNU General  Public License as published by the
>> + * Free Software Foundation;  either version 2 of the  License, or (at your
>> + * option) any later version.
>> + */
>> +
>> +#ifndef _UAPI_ROCKCHIP_DRM_H
>> +#define _UAPI_ROCKCHIP_DRM_H
>> +
>> +#include <drm/drm.h>
>> +
>> +/**
>> + * User-desired buffer creation information structure.
>> + *
>> + * @size: user-desired memory allocation size.
>> + * @flags: user request for setting memory type or cache attributes.
>> + * @handle: returned a handle to created gem object.
>> + *     - this handle will be set by gem module of kernel side.
>> + */
>> +struct drm_rockchip_gem_create {
>> +       uint64_t size;
>> +       uint32_t flags;
>> +       uint32_t handle;
>> +};
>> +
>> +/**
>> + * A structure for getting buffer offset.
>> + *
>> + * @handle: a pointer to gem object created.
>> + * @pad: just padding to be 64-bit aligned.
>> + * @offset: relatived offset value of the memory region allocated.
>> + *     - this value should be set by user.
>> + */
>> +struct drm_rockchip_gem_map_off {
>> +       uint32_t handle;
>> +       uint32_t pad;
>> +       uint64_t offset;
>> +};
>> +
>> +/**
>> + * A structure for mapping buffer.
>> + *
>> + * @handle: a handle to gem object created.
>> + * @pad: just padding to be 64-bit aligned.
>> + * @size: memory size to be mapped.
>> + * @mapped: having user virtual address mmaped.
>> + *      - this variable would be filled by rockchip gem module
>> + *      of kernel side with user virtual address which is allocated
>> + *      by do_mmap().
>> + */
>> +struct drm_rockchip_gem_mmap {
>> +       uint32_t handle;
>> +       uint32_t pad;
>> +       uint64_t size;
>> +       uint64_t mapped;
>> +};
> Could we do without the mmap ioctl?  It has been a source of problems
> in other drivers, and the ioctl to get mmap offset, plus normal mmap()
> on drm device file should be sufficient
>
> BR,
> -R
OK, I will try to move the special mmap ioctl and use drm generic mmap 
interface.
>
>> +/**
>> + * A structure to gem information.
>> + *
>> + * @handle: a handle to gem object created.
>> + * @flags: flag value including memory type and cache attribute and
>> + *      this value would be set by driver.
>> + * @size: size to memory region allocated by gem and this size would
>> + *      be set by driver.
>> + */
>> +struct drm_rockchip_gem_info {
>> +       uint32_t handle;
>> +       uint32_t flags;
>> +       uint64_t size;
>> +};
>> +
>> +#define DRM_ROCKCHIP_GEM_CREATE                0x00
>> +#define DRM_ROCKCHIP_GEM_MAP_OFFSET    0x01
>> +#define DRM_ROCKCHIP_GEM_MMAP          0x02
>> +#define DRM_ROCKCHIP_GEM_GET           0x04
>> +
>> +#define DRM_IOCTL_ROCKCHIP_GEM_CREATE  DRM_IOWR(DRM_COMMAND_BASE + \
>> +               DRM_ROCKCHIP_GEM_CREATE, struct drm_rockchip_gem_create)
>> +
>> +#define DRM_IOCTL_ROCKCHIP_GEM_MAP_OFFSET      DRM_IOWR(DRM_COMMAND_BASE + \
>> +               DRM_ROCKCHIP_GEM_MAP_OFFSET, struct drm_rockchip_gem_map_off)
>> +
>> +#define DRM_IOCTL_ROCKCHIP_GEM_MMAP    DRM_IOWR(DRM_COMMAND_BASE + \
>> +               DRM_ROCKCHIP_GEM_MMAP, struct drm_rockchip_gem_mmap)
>> +
>> +#define DRM_IOCTL_ROCKCHIP_GEM_GET     DRM_IOWR(DRM_COMMAND_BASE + \
>> +               DRM_ROCKCHIP_GEM_GET, struct drm_rockchip_gem_info)
>> +#endif /* _UAPI_ROCKCHIP_DRM_H */
>
>


