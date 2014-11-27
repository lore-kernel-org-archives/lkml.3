Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750870AbaK0HIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:08:44 -0500
Received: from regular1.263xmail.com ([211.150.99.132]:53216 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaK0HIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:08:42 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: airlied@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <67f69c6ea75343e2e8bed17e74e0c89b>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5476CDF7.60208@rock-chips.com>
Date: Thu, 27 Nov 2014 15:08:39 +0800
From: Mark yao <mark.yao@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Joerg Roedel <jroedel@suse.de>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
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
        linux-rockchip@lists.infradead.org,
        Douglas Anderson <dianders@chromium.org>,
        =?UTF-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu@chromium.org>,
        dbehr@chromium.org, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>, Eddie Cai <cf@rock-chips.com>,
        simon xue <xxm@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>, yxj@rock-chips.com,
        xw@rock-chips.com
Subject: Re: [PATCH v14 0/3] Add drm driver for Rockchip Socs
References: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com>	<23617908.6oA5uRuO3l@diego>	<CAPM=9tzvvb5U+8KaCO+K6CJi=rwWOkoW+4ZSFW_Oo9gTncvkWA@mail.gmail.com>	<1557742.FTdLsE0bVs@diego>	<20141126073430.GD3156@suse.de>	<CAPM=9tzhZLShA5=ShGTKhyZR6ddKycQDUWBZxXpUBb+1tGp-mQ@mail.gmail.com>	<54768107.2090402@rock-chips.com> <CAPM=9tyZpDEPcipYDq2_qdQ9zK2bnPFYTUL2qDvAd7QoUOm-QQ@mail.gmail.com>
In-Reply-To: <CAPM=9tyZpDEPcipYDq2_qdQ9zK2bnPFYTUL2qDvAd7QoUOm-QQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年11月27日 10:12, Dave Airlie wrote:
>>>
>> Hi Dave
>>      Do you mean that I need send you a branch, based on drm-next, merge with
>> iommu tree and rockchip drm?
> Yes, grab drm-next, git pull the arm/rockchip branch from Joerg's
> tree, put rockchip drm
> patches on top, send me pull request.
>
> I'll validate it then.
>
> Dave.
>
Hi Dave
     I have send a pull request to you, with Joerg's iommu arm/rockchip 
branch.

     I got a same problem when use "make multi_v7_defconfig" as Heiko said:
         drivers/video/fbdev/Kconfig:5:error: recursive dependency detected!
         drivers/video/fbdev/Kconfig:5:    symbol FB is selected by 
DRM_KMS_FB_HELPER
         drivers/gpu/drm/Kconfig:34:    symbol DRM_KMS_FB_HELPER is 
selected by DRM_ROCKCHIP
         drivers/gpu/drm/rockchip/Kconfig:1:    symbol DRM_ROCKCHIP 
depends on ARM_DMA_USE_IOMMU
         arch/arm/Kconfig:95:    symbol ARM_DMA_USE_IOMMU is selected by 
VIDEO_OMAP3
         drivers/media/platform/Kconfig:96:    symbol VIDEO_OMAP3 
depends on VIDEO_V4L2
         drivers/media/v4l2-core/Kconfig:6:    symbol VIDEO_V4L2 depends 
on I2C
         drivers/i2c/Kconfig:7:    symbol I2C is selected by FB_DDC
         drivers/video/fbdev/Kconfig:59:    symbol FB_DDC is selected by 
FB_CYBER2000_DDC
         drivers/video/fbdev/Kconfig:374:    symbol FB_CYBER2000_DDC 
depends on FB_CYBER2000
         drivers/video/fbdev/Kconfig:362:    symbol FB_CYBER2000 depends 
on FB

     I was confused how to solve the recursive dependency, remove 
depends on ARM_DMA_USE_IOMMU & IOMMU_API?

- Mark



