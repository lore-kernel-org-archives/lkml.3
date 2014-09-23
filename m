Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbaIWIA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:00:57 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:37399 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbaIWIAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:00:53 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: robdclark@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <41db7f6e75903054f0cf50356b741a87>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <542128AB.5030905@rock-chips.com>
Date: Tue, 23 Sep 2014 16:00:43 +0800
From: Mark yao <mark.yao@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rob Clark <robdclark@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        linux-doc@vger.kernel.org, Kever Yang <kever.yang@rock-chips.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jianqun Xu <xjq@rock-chips.com>, Chris Zhong <zyw@rock-chips.com>,
        linux-api@vger.kernel.org, jeff chen <cym@rock-chips.com>,
        linux-rockchip@lists.infradead.org, kfx@rock-chips.com,
        Grant Likely <grant.likely@linaro.org>, wxt@rock-chips.com,
        Tao Huang <huangtao@rock-chips.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, yxj@rock-chips.com,
        Eddie Cai <cf@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu@chromium.org>,
        xxm@rock-chips.com, xw@rock-chips.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, dianders@chromium.org,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v3 1/5] drm/rockchip: Add basic drm driver
References: <1411105668-32722-1-git-send-email-mark.yao@rock-chips.com> <1411105668-32722-2-git-send-email-mark.yao@rock-chips.com> <CAF6AEGsPoj6+PdKCJk5BPPzHS51Tz1FGqS2SjpartaRw7i=Pxg@mail.gmail.com> <541F7C23.8000103@rock-chips.com> <20140923074831.GR15734@phenom.ffwll.local>
In-Reply-To: <20140923074831.GR15734@phenom.ffwll.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年09月23日 15:48, Daniel Vetter wrote:
> On Mon, Sep 22, 2014 at 09:32:19AM +0800, Mark yao wrote:
>> On 2014年09月20日 08:03, Rob Clark wrote:
>>> On Fri, Sep 19, 2014 at 1:47 AM, Mark yao <mark.yao@rock-chips.com> wrote:
>>>> diff --git a/include/uapi/drm/rockchip_drm.h b/include/uapi/drm/rockchip_drm.h
>>>> new file mode 100644
>>>> index 0000000..8f8e60e
>>>> --- /dev/null
>>>> +++ b/include/uapi/drm/rockchip_drm.h
>>>> @@ -0,0 +1,97 @@
>>>> +/*
>>>> + *
>>>> + * Copyright (c) Fuzhou Rockchip Electronics Co.Ltd
>>>> + * Authors:
>>>> + *       Mark Yao <yzq@rock-chips.com>
>>>> + *
>>>> + * base on exynos_drm.h
>>>> + *
>>>> + * This program is free software; you can redistribute  it and/or modify it
>>>> + * under  the terms of  the GNU General  Public License as published by the
>>>> + * Free Software Foundation;  either version 2 of the  License, or (at your
>>>> + * option) any later version.
>>>> + */
>>>> +
>>>> +#ifndef _UAPI_ROCKCHIP_DRM_H
>>>> +#define _UAPI_ROCKCHIP_DRM_H
>>>> +
>>>> +#include <drm/drm.h>
>>>> +
>>>> +/**
>>>> + * User-desired buffer creation information structure.
>>>> + *
>>>> + * @size: user-desired memory allocation size.
>>>> + * @flags: user request for setting memory type or cache attributes.
>>>> + * @handle: returned a handle to created gem object.
>>>> + *     - this handle will be set by gem module of kernel side.
>>>> + */
>>>> +struct drm_rockchip_gem_create {
>>>> +       uint64_t size;
>>>> +       uint32_t flags;
>>>> +       uint32_t handle;
>>>> +};
>>>> +
>>>> +/**
>>>> + * A structure for getting buffer offset.
>>>> + *
>>>> + * @handle: a pointer to gem object created.
>>>> + * @pad: just padding to be 64-bit aligned.
>>>> + * @offset: relatived offset value of the memory region allocated.
>>>> + *     - this value should be set by user.
>>>> + */
>>>> +struct drm_rockchip_gem_map_off {
>>>> +       uint32_t handle;
>>>> +       uint32_t pad;
>>>> +       uint64_t offset;
>>>> +};
>>>> +
>>>> +/**
>>>> + * A structure for mapping buffer.
>>>> + *
>>>> + * @handle: a handle to gem object created.
>>>> + * @pad: just padding to be 64-bit aligned.
>>>> + * @size: memory size to be mapped.
>>>> + * @mapped: having user virtual address mmaped.
>>>> + *      - this variable would be filled by rockchip gem module
>>>> + *      of kernel side with user virtual address which is allocated
>>>> + *      by do_mmap().
>>>> + */
>>>> +struct drm_rockchip_gem_mmap {
>>>> +       uint32_t handle;
>>>> +       uint32_t pad;
>>>> +       uint64_t size;
>>>> +       uint64_t mapped;
>>>> +};
>>> Could we do without the mmap ioctl?  It has been a source of problems
>>> in other drivers, and the ioctl to get mmap offset, plus normal mmap()
>>> on drm device file should be sufficient
>>>
>>> BR,
>>> -R
>> OK, I will try to move the special mmap ioctl and use drm generic mmap
>> interface.
> Actually you probably should drop all this and just implement the dummy
> object support for now. Until you have proper hw accel there's no reason
> to expose a driver-private gem create/mmap interface at all.
>
> A pure kms driver really shouldn't have it's on uapi/foo_drm.h file.
> -Daniel
right, I will try to do it.



