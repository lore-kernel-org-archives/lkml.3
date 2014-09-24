Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaIXLUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:20:51 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:65218 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaIXLUr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:20:47 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <54228F7B.2050608@rock-chips.com>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com>
	<1411382934-1763-1-git-send-email-mark.yao@rock-chips.com>
	<20140924082037.GJ15734@phenom.ffwll.local>
	<54228F7B.2050608@rock-chips.com>
Date: Wed, 24 Sep 2014 13:20:47 +0200
X-Google-Sender-Auth: xdhTUtEXJJU-kStuxYC0nc-6t5c
Message-ID: <CAKMK7uHiQFDH-qyPBsyVa953F5SY2UgSv7Nbsu73AKvjqUm1jw@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] drm/rockchip: Add basic drm driver
From: Daniel Vetter <daniel@ffwll.ch>
To: Mark yao <mark.yao@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>, linux-doc@vger.kernel.org,
        Kever Yang <kever.yang@rock-chips.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Douglas Anderson <dianders@chromium.org>,
        Jianqun Xu <xjq@rock-chips.com>, Chris Zhong <zyw@rock-chips.com>,
        jeff chen <cym@rock-chips.com>, linux-rockchip@lists.infradead.org,
        kfx@rock-chips.com, =?UTF-8?B?546L5pmT6IW+?= <wxt@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        yxj@rock-chips.com,
        =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
        simon xue <xxm@rock-chips.com>, xw@rock-chips.com,
        linux-api@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eddie Cai <cf@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:31 AM, Mark yao <mark.yao@rock-chips.com> wrote:
> On 2014年09月24日 16:20, Daniel Vetter wrote:
>>
>> On Mon, Sep 22, 2014 at 06:48:54PM +0800, Mark yao wrote:
>>>
>>> This patch adds the basic structure of a DRM Driver for Rockchip Socs.
>>>
>>> Signed-off-by: Mark yao <mark.yao@rock-chips.com>
>>> ---
>>> Changes in v2:
>>> - use the component framework to defer main drm driver probe
>>>    until all VOP devices have been probed.
>>> - use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mapping by
>>>    master device and each vop device can shared the drm dma mapping.
>>> - use drm_crtc_init_with_planes and drm_universal_plane_init.
>>> - remove unnecessary middle layers.
>>> - add cursor set, move funcs to rockchip drm crtc.
>>> - use vop reset at first init
>>> - reference framebuffer when used and unreference when swap out vop
>>>
>>> Changes in v3:
>>> - change "crtc->fb" to "crtc->primary-fb"
>>> Adviced by Daniel Vetter
>>> - init cursor plane with universal api, remove unnecessary cursor
>>> set,move
>>>
>>> Changes in v4:
>>> Adviced by David Herrmann
>>> - remove drm_platform_*() usage, use register drm device directly.
>>> Adviced by Rob Clark
>>> - remove special mmap ioctl, do userspace mmap with normal mmap() or mmap
>>> offset
>>>
>>>   drivers/gpu/drm/Kconfig                       |    2 +
>>>   drivers/gpu/drm/Makefile                      |    1 +
>>>   drivers/gpu/drm/rockchip/Kconfig              |   19 +
>>>   drivers/gpu/drm/rockchip/Makefile             |   10 +
>>>   drivers/gpu/drm/rockchip/rockchip_drm_drv.c   |  524 ++++++++++
>>>   drivers/gpu/drm/rockchip/rockchip_drm_drv.h   |  120 +++
>>>   drivers/gpu/drm/rockchip/rockchip_drm_fb.c    |  201 ++++
>>>   drivers/gpu/drm/rockchip/rockchip_drm_fb.h    |   28 +
>>>   drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c |  231 +++++
>>>   drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h |   20 +
>>>   drivers/gpu/drm/rockchip/rockchip_drm_gem.c   |  404 ++++++++
>>>   drivers/gpu/drm/rockchip/rockchip_drm_gem.h   |   72 ++
>>>   drivers/gpu/drm/rockchip/rockchip_drm_vop.c   | 1372
>>> +++++++++++++++++++++++++
>>>   drivers/gpu/drm/rockchip/rockchip_drm_vop.h   |  187 ++++
>>>   include/uapi/drm/rockchip_drm.h               |   75 ++
>>
>> uapi is still here ... Was this an oversight?
>> -Daniel
>>
> Hi, Daniel
> this version is old, newest is v5. and I remove uapi at v5.
> you can see v5 patch at:
> https://lkml.org/lkml/2014/9/23/1061
> thanks

This version doesn't seem to be cc'ed to dri-devel, at least it didn't
yet show up. Can you please double-check?

Thanks, Daniel
