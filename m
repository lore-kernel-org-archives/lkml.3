Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaLEIaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:30:07 -0500
Received: from gloria.sntech.de ([95.129.55.99]:55374 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbaLEIaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:30:04 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Dave Airlie <airlied@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Mark Yao <mark.yao@rock-chips.com>,
        Mark Rutland <mark.rutland@arm.com>, linux-doc@vger.kernel.org,
        Kever Yang <kever.yang@rock-chips.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        simon xue <xxm@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Dominik Behr <dbehr@chromium.org>,
        =?utf-8?B?6Zer5a2d5Yab?= <yxj@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        =?ISO-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
        Rom Lemarchand <romlem@google.com>, xw@rock-chips.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Douglas Anderson <dianders@chromium.org>,
        Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v15 0/3] Add drm driver for Rockchip Socs
Date: Fri, 05 Dec 2014 09:33:56 +0100
Message-ID: <1435911.OORE5v4bbE@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <CAPM=9tzcB0XaenK1RjJoOBpJjrq84atJP59=kh6WMA2-OcFpEA@mail.gmail.com>
References: <1417511600-7054-1-git-send-email-mark.yao@rock-chips.com> <CAGS+omAqkQaK99OX_uAf2Z6-fep2Euwn112Oj5gFpRca8ZAgew@mail.gmail.com> <CAPM=9tzcB0XaenK1RjJoOBpJjrq84atJP59=kh6WMA2-OcFpEA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Am Freitag, 5. Dezember 2014, 17:26:04 schrieb Dave Airlie:
> On 5 December 2014 at 05:29, Daniel Kurtz <djkurtz@chromium.org> wrote:
> > I thought the recommended solution for this was to fix OMAP3 to not
> > select  ARM_DMA_USE_IOMMU and OMAP_IOMMU, not to drop the 'depends on'
> > in drm/rockchip?
> 
> Lets fix that up once we get this merged, if I had a tree based on the
> iommu I'd have
> it -next now.
> 
> can I get a pull for that?

Mark sent a pull on tuesday as reply to the cover-letter.
Message-ID: <547D88D7.5080005@rock-chips.com>

Replicated here, if you don't want to search.


Heiko

---------------- 8< -------------------------------------

Hi Dave

The following changes since commit 656d7077d8ffd1c2492d4a0a354367ab2e545059:

   dt-bindings: iommu: Add documentation for rockchip iommu (2014-11-03 
17:29:09 +0100)

are available in the git repository at:

   https://github.com/markyzq/kernel-drm-rockchip.git drm_iommu_v15

for you to fetch changes up to 5ac4837b12f533de5d9f8f66b45494c58e805536:

   dt-bindings: video: Add documentation for rockchip vop (2014-12-02 
17:29:33 +0800)

----------------------------------------------------------------
Mark Yao (3):
       drm: rockchip: Add basic drm driver
       dt-bindings: video: Add for rockchip display subsytem
       dt-bindings: video: Add documentation for rockchip vop

  .../devicetree/bindings/video/rockchip-drm.txt     |   19 +
  .../devicetree/bindings/video/rockchip-vop.txt     |   58 +
  drivers/gpu/drm/Kconfig                            |    2 +
  drivers/gpu/drm/Makefile                           |    1 +
  drivers/gpu/drm/rockchip/Kconfig                   |   17 +
  drivers/gpu/drm/rockchip/Makefile                  |    8 +
  drivers/gpu/drm/rockchip/rockchip_drm_drv.c        |  551 ++++++++
  drivers/gpu/drm/rockchip/rockchip_drm_drv.h        |   68 +
  drivers/gpu/drm/rockchip/rockchip_drm_fb.c         |  201 +++
  drivers/gpu/drm/rockchip/rockchip_drm_fb.h         |   28 +
  drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c      |  210 +++
  drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h      |   21 +
  drivers/gpu/drm/rockchip/rockchip_drm_gem.c        |  294 ++++
  drivers/gpu/drm/rockchip/rockchip_drm_gem.h        |   54 +
  drivers/gpu/drm/rockchip/rockchip_drm_vop.c        | 1455 ++++++++++++++++++++
  drivers/gpu/drm/rockchip/rockchip_drm_vop.h        |  201 +++
  16 files changed, 3188 insertions(+)
  create mode 100644 Documentation/devicetree/bindings/video/rockchip-drm.txt
  create mode 100644 Documentation/devicetree/bindings/video/rockchip-vop.txt
  create mode 100644 drivers/gpu/drm/rockchip/Kconfig
  create mode 100644 drivers/gpu/drm/rockchip/Makefile
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.c
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.h
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.c
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.h
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.c
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.h
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.c
  create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.h


