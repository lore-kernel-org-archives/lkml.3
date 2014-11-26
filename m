Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaKZAed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:34:33 -0500
Received: from gloria.sntech.de ([95.129.55.99]:39821 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbaKZAeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:34:31 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Dave Airlie <airlied@gmail.com>, Joerg Roedel <jroedel@suse.de>
Cc: Mark Yao <mark.yao@rock-chips.com>,
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
        =?ISO-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
        dbehr@chromium.org, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>, Eddie Cai <cf@rock-chips.com>,
        simon xue <xxm@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>, yxj@rock-chips.com,
        xw@rock-chips.com
Subject: Re: [PATCH v14 0/3] Add drm driver for Rockchip Socs
Date: Wed, 26 Nov 2014 01:37:51 +0100
Message-ID: <1557742.FTdLsE0bVs@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <CAPM=9tzvvb5U+8KaCO+K6CJi=rwWOkoW+4ZSFW_Oo9gTncvkWA@mail.gmail.com>
References: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com> <23617908.6oA5uRuO3l@diego> <CAPM=9tzvvb5U+8KaCO+K6CJi=rwWOkoW+4ZSFW_Oo9gTncvkWA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg, Dave,

Am Mittwoch, 26. November 2014, 09:12:56 schrieb Dave Airlie:
> On 26 November 2014 at 02:38, Heiko Stübner <heiko@sntech.de> wrote:
> > Mark,
> > 
> > Am Donnerstag, 20. November 2014, 09:46:34 schrieb Mark Yao:
> >> This a series of patches is a DRM Driver for Rockchip Socs, add support
> >> for vop devices. Future patches will add additional encoders/connectors,
> >> such as eDP, HDMI.
> >> 
> >> The basic "crtc" for rockchip is a "VOP" - Video Output Processor.
> >> the vop devices found on Rockchip rk3288 Soc, rk3288 soc have two similar
> >> Vop devices. Vop devices support iommu mapping, we use dma-mapping API
> >> with
> >> ARM_DMA_USE_IOMMU.
> > 
> > it looks like everybody is more or less happy with this version - in past
> > versions responses voicing concerns where quite swift.
> > 
> > As David requested a pull request the last time, it might be time to do
> > so, so that we maybe still reach 3.19.
> 
> I need the iommu changes the drm driver depends on in a stable
> maintainer git tree,
> I'm not pulling in code I can't build.

Joerg, is your arm/rockchip branch [0] considered stable?

[0] https://git.kernel.org/cgit/linux/kernel/git/joro/iommu.git/log/?h=arm/rockchip


> I'm happy if the rockchip drm pull stays static and I can pull it in
> once the iommu bits
> are done.

While testing this I noticed a quite big kconfig warning
(on both 3.18-rc1 and 3.18-rc6):

drivers/video/fbdev/Kconfig:5:error: recursive dependency detected!
drivers/video/fbdev/Kconfig:5:  symbol FB is selected by DRM_KMS_FB_HELPER
drivers/gpu/drm/Kconfig:34:     symbol DRM_KMS_FB_HELPER is selected by DRM_ROCKCHIP
drivers/gpu/drm/rockchip/Kconfig:1:     symbol DRM_ROCKCHIP depends on ARM_DMA_USE_IOMMU
arch/arm/Kconfig:95:    symbol ARM_DMA_USE_IOMMU is selected by VIDEO_OMAP3
drivers/media/platform/Kconfig:96:      symbol VIDEO_OMAP3 depends on VIDEO_V4L2
drivers/media/v4l2-core/Kconfig:6:      symbol VIDEO_V4L2 depends on I2C
drivers/i2c/Kconfig:7:  symbol I2C is selected by FB_DDC
drivers/video/fbdev/Kconfig:59: symbol FB_DDC is selected by FB_CYBER2000_DDC
drivers/video/fbdev/Kconfig:374:        symbol FB_CYBER2000_DDC depends on FB_CYBER2000
drivers/video/fbdev/Kconfig:362:        symbol FB_CYBER2000 depends on FB

It looks like the VIDEO_OMAP3 is selecting ARM_DMA_USE_IOMMU and
OMAP_IOMMU instead of depending on it.

I'm not sure which driver should change but looking at the exynos drm
driver it is also depends on the iommu parts instead of selecting them
[like the rockchip drm currently does]


Heiko
