Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaK0TF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 14:05:29 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:58544 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaK0TFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 14:05:22 -0500
MIME-Version: 1.0
In-Reply-To: <5476CDF7.60208@rock-chips.com>
References: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com>
 <23617908.6oA5uRuO3l@diego> <CAPM=9tzvvb5U+8KaCO+K6CJi=rwWOkoW+4ZSFW_Oo9gTncvkWA@mail.gmail.com>
 <1557742.FTdLsE0bVs@diego> <20141126073430.GD3156@suse.de>
 <CAPM=9tzhZLShA5=ShGTKhyZR6ddKycQDUWBZxXpUBb+1tGp-mQ@mail.gmail.com>
 <54768107.2090402@rock-chips.com> <CAPM=9tyZpDEPcipYDq2_qdQ9zK2bnPFYTUL2qDvAd7QoUOm-QQ@mail.gmail.com>
 <5476CDF7.60208@rock-chips.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 27 Nov 2014 14:05:00 -0500
X-Google-Sender-Auth: g-4oWyOhmaNZxGAkR7REIbRfhPc
Message-ID: <CAGS+omDDAYtx+02ZBMGnLXygWpfBa283pCU00vP-sahwNnoyFA@mail.gmail.com>
Subject: Re: [PATCH v14 0/3] Add drm driver for Rockchip Socs
To: Mark yao <mark.yao@rock-chips.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Dave Airlie <airlied@gmail.com>, Joerg Roedel <jroedel@suse.de>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>, linux-api@vger.kernel.org,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Douglas Anderson <dianders@chromium.org>,
        =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
        Dominik Behr <dbehr@chromium.org>, Olof Johansson <olof@lixom.net>,
        Eddie Cai <cf@rock-chips.com>, simon xue <xxm@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        =?UTF-8?B?6Zer5a2d5Yab?= <yxj@rock-chips.com>, xw@rock-chips.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 2:08 AM, Mark yao <mark.yao@rock-chips.com> wrote:
>
> On 2014年11月27日 10:12, Dave Airlie wrote:
>>>>
>>>>
>>> Hi Dave
>>>      Do you mean that I need send you a branch, based on drm-next, merge with
>>> iommu tree and rockchip drm?
>>
>> Yes, grab drm-next, git pull the arm/rockchip branch from Joerg's
>> tree, put rockchip drm
>> patches on top, send me pull request.
>>
>> I'll validate it then.
>>
>> Dave.
>>
> Hi Dave
>     I have send a pull request to you, with Joerg's iommu arm/rockchip branch.
>
>     I got a same problem when use "make multi_v7_defconfig" as Heiko said:
>         drivers/video/fbdev/Kconfig:5:error: recursive dependency detected!
>         drivers/video/fbdev/Kconfig:5:    symbol FB is selected by DRM_KMS_FB_HELPER
>         drivers/gpu/drm/Kconfig:34:    symbol DRM_KMS_FB_HELPER is selected by DRM_ROCKCHIP
>         drivers/gpu/drm/rockchip/Kconfig:1:    symbol DRM_ROCKCHIP depends on ARM_DMA_USE_IOMMU
>         arch/arm/Kconfig:95:    symbol ARM_DMA_USE_IOMMU is selected by VIDEO_OMAP3
>         drivers/media/platform/Kconfig:96:    symbol VIDEO_OMAP3 depends on VIDEO_V4L2
>         drivers/media/v4l2-core/Kconfig:6:    symbol VIDEO_V4L2 depends on I2C
>         drivers/i2c/Kconfig:7:    symbol I2C is selected by FB_DDC
>         drivers/video/fbdev/Kconfig:59:    symbol FB_DDC is selected by FB_CYBER2000_DDC
>         drivers/video/fbdev/Kconfig:374:    symbol FB_CYBER2000_DDC depends on FB_CYBER2000
>         drivers/video/fbdev/Kconfig:362:    symbol FB_CYBER2000 depends on FB
>
>     I was confused how to solve the recursive dependency, remove depends on ARM_DMA_USE_IOMMU & IOMMU_API?

The "depends on ARM_DMA_USE_IOMMU & IOMMU_API" was suggested by Arnd
Bergmann during code review (originally they were selected).

Removing them definitely fixes the dependency recursion.
Also, since they are both already selected by ROCKCHIP_IOMMU,
everything will build correctly.
So, this sounds good to me, but I am no expert on Kconfig.

-Dan

>
> - Mark
