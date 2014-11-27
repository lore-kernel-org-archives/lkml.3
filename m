Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaK0V5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:57:30 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:56241 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaK0V51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:57:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Mark yao <mark.yao@rock-chips.com>, Dave Airlie <airlied@gmail.com>,
        Joerg Roedel <jroedel@suse.de>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
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
        =?ISO-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
        Dominik Behr <dbehr@chromium.org>, Olof Johansson <olof@lixom.net>,
        Eddie Cai <cf@rock-chips.com>, simon xue <xxm@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        =?utf-8?B?6Zer5a2d5Yab?= <yxj@rock-chips.com>, xw@rock-chips.com
Subject: Re: [PATCH v14 0/3] Add drm driver for Rockchip Socs
Date: Thu, 27 Nov 2014 22:56:32 +0100
Message-ID: <3124625.mkxyU0zW0C@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAGS+omDDAYtx+02ZBMGnLXygWpfBa283pCU00vP-sahwNnoyFA@mail.gmail.com>
References: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com> <5476CDF7.60208@rock-chips.com> <CAGS+omDDAYtx+02ZBMGnLXygWpfBa283pCU00vP-sahwNnoyFA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:qupwlQKePKSVRgtcseww4xC5uqCel9YQfp6oqfyXeSj
 nAozG81u3IY3JjUtJUR+xHy853yB4gFdScpSE0GJIuuHPWRq7L
 RwIjQP65+QtbVH2F5UgUecCL9Z5MITpshQ0Ej2Z6a0xEW4GP9G
 p6vj9cwarvZjqEEbuHZs2ec3MfKYmXQUj7Zcmbo1LsAlL1xRmQ
 0IEsJKIfz6oKhdv4ZQ+Lq2FLYqkoRMhJoPauNN3p1TkmJCFz3r
 WIHev+trGfGNtD7boHwp0NRI7GYm9Tkgo80xI2KujcDSO80pKm
 tztH8gsuNy/6RKX6fsphcXU9k3EnrLfHDWNpMPiteF1QKi36RR
 2MKWcc3iQpmp2GcX9/AU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 14:05:00 Daniel Kurtz wrote:
> On Thu, Nov 27, 2014 at 2:08 AM, Mark yao <mark.yao@rock-chips.com> wrote:
> >
> > On 2014年11月27日 10:12, Dave Airlie wrote:
> >>>>
> >>>>
> >>> Hi Dave
> >>>      Do you mean that I need send you a branch, based on drm-next, merge with
> >>> iommu tree and rockchip drm?
> >>
> >> Yes, grab drm-next, git pull the arm/rockchip branch from Joerg's
> >> tree, put rockchip drm
> >> patches on top, send me pull request.
> >>
> >> I'll validate it then.
> >>
> >> Dave.
> >>
> > Hi Dave
> >     I have send a pull request to you, with Joerg's iommu arm/rockchip branch.
> >
> >     I got a same problem when use "make multi_v7_defconfig" as Heiko said:
> >         drivers/video/fbdev/Kconfig:5:error: recursive dependency detected!
> >         drivers/video/fbdev/Kconfig:5:    symbol FB is selected by DRM_KMS_FB_HELPER
> >         drivers/gpu/drm/Kconfig:34:    symbol DRM_KMS_FB_HELPER is selected by DRM_ROCKCHIP
> >         drivers/gpu/drm/rockchip/Kconfig:1:    symbol DRM_ROCKCHIP depends on ARM_DMA_USE_IOMMU
> >         arch/arm/Kconfig:95:    symbol ARM_DMA_USE_IOMMU is selected by VIDEO_OMAP3
> >         drivers/media/platform/Kconfig:96:    symbol VIDEO_OMAP3 depends on VIDEO_V4L2
> >         drivers/media/v4l2-core/Kconfig:6:    symbol VIDEO_V4L2 depends on I2C
> >         drivers/i2c/Kconfig:7:    symbol I2C is selected by FB_DDC
> >         drivers/video/fbdev/Kconfig:59:    symbol FB_DDC is selected by FB_CYBER2000_DDC
> >         drivers/video/fbdev/Kconfig:374:    symbol FB_CYBER2000_DDC depends on FB_CYBER2000
> >         drivers/video/fbdev/Kconfig:362:    symbol FB_CYBER2000 depends on FB
> >
> >     I was confused how to solve the recursive dependency, remove depends on ARM_DMA_USE_IOMMU & IOMMU_API?
> 
> The "depends on ARM_DMA_USE_IOMMU & IOMMU_API" was suggested by Arnd
> Bergmann during code review (originally they were selected).
> 
> Removing them definitely fixes the dependency recursion.
> Also, since they are both already selected by ROCKCHIP_IOMMU,
> everything will build correctly.
> So, this sounds good to me, but I am no expert on Kconfig.
> 

I think the problem here is VIDEO_OMAP3 (among others), it should do the
same as rockchips and use 'depends on' instead of 'select'.

Another problem is the 'select I2C' in FB_DDC, but that would be much harder
to fix.

	Arnd
