Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaJQGZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 02:25:14 -0400
Received: from gloria.sntech.de ([95.129.55.99]:48077 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaJQGZL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 02:25:11 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mark yao <mark.yao@rock-chips.com>
Cc: Dave Airlie <airlied@gmail.com>,
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
        linux-rockchip@lists.infradead.org, dianders@chromium.org,
        =?ISO-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
        dbehr@chromium.org, Olof Johansson <olof@lixom.net>,
        djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com,
        cym@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com,
        xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com,
        yxj@rock-chips.com, wxt@rock-chips.com, xw@rock-chips.com
Subject: Re: [PATCH v11 0/3] Add drm driver for Rockchip Socs
Date: Fri, 17 Oct 2014 08:24:42 +0200
Message-ID: <282711393.zuCWIeu2Oz@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <5440999D.5010601@rock-chips.com>
References: <1412763781-31533-1-git-send-email-mark.yao@rock-chips.com> <CAPM=9twVrmni_BRV_9-QLk+JUbcgXEjAM0g-tYH6su8=sDQ35g@mail.gmail.com> <5440999D.5010601@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Am Freitag, 17. Oktober 2014, 12:22:53 schrieb Mark yao:
> On 2014年10月17日 08:46, Dave Airlie wrote:
> > On 17 October 2014 10:40, Mark yao <mark.yao@rock-chips.com> wrote:
> >> Hi
> >> I think Rockchip drm driver is ready now, can it land?
> > 
> > I probably want to wait until -rc1 though I suppose since its a new
> > driver and self contained we might be able to see if Linus is
> > interested in squeezing it in.
> > 
> > Can you send me a git pull request for it against drm-next or even 3.17.
> > 
> > Dave.
> 
> Hi, Dave
>      the git pull request:
> 
> The following changes since commit 4db36870b92cdf5a79615aeabc68efc97df13918:

I think this needs a fix. Your commit 4db36870b is the pending iommu driver. 
Which isn't part of neither the mainline kernel nor the drm tree Dave meant.

What Dave meant was to base your patches on top of his "drm-next" branch or 
the raw 3.17 release.

So either base the branch on drm-next from
	http://cgit.freedesktop.org/~airlied/linux/log/?h=drm-next

or the 3.17 release tag from Linus Torvalds. Apply your patches on top and 
create pull from there.

I've just checked ... your drm patches apply cleanly against 3.17, so your 
branch to be pulled should probably look something like
	https://github.com/mmind/linux-rockchip/commits/tmp/drmtest


Heiko

> 
>    FROMLIST: iommu/rockchip: rk3288 iommu driver (2014-10-17 10:26:18 +0800)
> 
> are available in the git repository at:
> 
>    https://github.com/markyzq/kernel-drm-rockchip.git mydrm
> 
> for you to fetch changes up to 0db2be88bea08ab8afe5e3d13f8a2c9e637a9514:
> 
>    dt-bindings: video: Add documentation for rockchip vop (2014-10-17
> 10:27:15 +0800)
> 
> ----------------------------------------------------------------
> Mark yao (3):
>        drm: rockchip: Add basic drm driver
>        dt-bindings: video: Add for rockchip display subsytem
>        dt-bindings: video: Add documentation for rockchip vop
> 
>   .../devicetree/bindings/video/rockchip-drm.txt     |   19 +
>   .../devicetree/bindings/video/rockchip-vop.txt     |   58 +
>   drivers/gpu/drm/Kconfig                            |    2 +
>   drivers/gpu/drm/Makefile                           |    1 +
>   drivers/gpu/drm/rockchip/Kconfig                   |   17 +
>   drivers/gpu/drm/rockchip/Makefile                  |    8 +
>   drivers/gpu/drm/rockchip/rockchip_drm_drv.c        |  449 ++++++
>   drivers/gpu/drm/rockchip/rockchip_drm_drv.h        |   54 +
>   drivers/gpu/drm/rockchip/rockchip_drm_fb.c         |  200 +++
>   drivers/gpu/drm/rockchip/rockchip_drm_fb.h         |   28 +
>   drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c      |  210 +++
>   drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h      |   20 +
>   drivers/gpu/drm/rockchip/rockchip_drm_gem.c        |  293 ++++
>   drivers/gpu/drm/rockchip/rockchip_drm_gem.h        |   54 +
>   drivers/gpu/drm/rockchip/rockchip_drm_vop.c        | 1427
> ++++++++++++++++++++
>   drivers/gpu/drm/rockchip/rockchip_drm_vop.h        |  196 +++
>   16 files changed, 3036 insertions(+)
>   create mode 100644
> Documentation/devicetree/bindings/video/rockchip-drm.txt
>   create mode 100644
> Documentation/devicetree/bindings/video/rockchip-vop.txt
>   create mode 100644 drivers/gpu/drm/rockchip/Kconfig
>   create mode 100644 drivers/gpu/drm/rockchip/Makefile
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.c
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.h
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.c
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.h
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.c
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.h
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.c
>   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.h

