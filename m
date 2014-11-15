Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaKOKM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 05:12:56 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41021 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751374AbaKOKMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 05:12:54 -0500
Date: Sat, 15 Nov 2014 10:12:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>,
        Andy Yan <andy.yan@rock-chips.com>, David Airlie <airlied@linux.ie>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        fabio.estevam@freescale.com, Mark Rutland <mark.rutland@arm.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Yakir Yang <ykk@rock-chips.com>, devel@driverdev.osuosl.org,
        Arnd Bergmann <arnd@arndb.de>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, Xu Jianqun <jay.xu@rock-chips.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Sean Paul <seanpaul@chromium.org>,
        "mark.yao@rock-chips.com" <mark.yao@rock-chips.com>,
        Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v10 05/11] drm: bridge/dw_hdmi:split some phy
 configuration to platform driver
Message-ID: <20141115101218.GI4042@n2100.arm.linux.org.uk>
References: <1415934583-16290-1-git-send-email-andy.yan@rock-chips.com>
 <1415935631-16826-1-git-send-email-andy.yan@rock-chips.com>
 <5465D73C.9030507@imgtec.com>
 <5465DF0C.50301@rock-chips.com>
 <5465DFB2.8060601@imgtec.com>
 <5465E2BB.1070507@rock-chips.com>
 <5465E3DF.6050307@imgtec.com>
 <CAGS+omANityD4ZbqLzgrbro6WSTWozXS9fvdwof=Mv_X8OpHRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGS+omANityD4ZbqLzgrbro6WSTWozXS9fvdwof=Mv_X8OpHRg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2014 at 06:07:50PM +0800, Daniel Kurtz wrote:
> On Fri, Nov 14, 2014 at 7:13 PM, Zubair Lutfullah Kakakhel
> <Zubair.Kakakhel@imgtec.com> wrote:
> >
> >
> > On 14/11/14 11:08, Andy Yan wrote:
> >>
> >> On 2014年11月14日 18:55, Zubair Lutfullah Kakakhel wrote:
> >>>
> >>> On 14/11/14 10:53, Andy Yan wrote:
> >>>> Hi ZubairLK:
> >>>>     Thanks for your review.
> >>>> On 2014年11月14日 18:19, Zubair Lutfullah Kakakhel wrote:
> >>>>> Hi Andy,
> >>>>>
> >>>>> Nice work on this patch series. Its getting better and better :).
> >>>>>
> >>>>> On 14/11/14 03:27, Andy Yan wrote:
> >>>>>> hdmi phy clock symbol and transmission termination value
> >>>>>> can adjust platform specific to get the best SI
> >>>>>                          ^Is this signal integrity?
> >>>>     yes , SI  is signal integrity, such as eye diagram measurement
> >>>>> Are these two disjoint features in separate patches?
> >>>>>
> >>>>>> also add mode_valid interface for some platform may not support
> >>>>>> all the display mode
> >>>>> Sounds like another separate patch to me. :)
> >>>>     they can seperate
> >>>>> Also, This series is becoming quite large. With major changes and fixes mixed together.
> >>>>>
> >>>>> Patch 3 splits imx-drm.
> >>>>> Patch 4 moves dw-drm out of imx-drm folder.
> >>>>> Patch 7 adds binding
> >>>>> Patch 9 converts to drm bridge.
> >>>>>
> >>>>> Can these be placed together easily?
> >>>>> And in the start. i.e. patch 1, 2, 3, 4,
> >>>>>
> >>>>> Then all fixes etc can come afterwards?
> >>>>>
> >>>>> It helps when checking histories later as to how a driver was made and how fixes happened.
> >>>>>
> >>>>> Especially when file moves happen..
> >>>>    Do you mean we can rearrange the patch series?
> >>>>    put patch 3, 4 ,7, 9 together  one bye one
> >>>>    than followed by the fixes patches  5 ,6, 8, 11 ?
> >>> Yes. Rearrange so that the split imx-drm/imx-hdmi and conversion to drm-bridge is at the start of the series.
> >>> Then the rest are bug fixes and feature additions.
> >>   Can I put patch#1(make checkpatch happy) and patch#2 (defer probe) as the first two patch.
> >>   Daniel from Google chromium think it's better to put the two slightly changes in the front for easy review.
> 
> Sorry, I didn't see this conversation before my earlier emails.
> 
> I was suggesting to Andy to arrange his patches like this:
>  (1) fixes that directly apply to imx-drm as it is today.
>  (2) split out the "generic dw_hdmi" parts from imx-hdmi into dw_hdmi.c
>  (3) convert dw_hdmi.c to a drm_bridge
>  (4) move the dw_hdmi.c bridge implementation to drm/bridge
>  (5) modifications to dw_hdmi.c required to support hdmi on rk3288
>  (5) add rk3288-hdmi.c to drm/rockchip (at least whenever drm/rockchip lands)
> 
> The idea being that we can start landing the patches for (1) even
> while we are still debating / reviewing (2)+ upstream.
> 
> > Sure.
> >
> > I am not the maintainer. They have to make the final decision.
> 
> imx-drm is still in staging.  I do not see anyone listed explicitly
> under MAINTAINERS for drivers/staging/imx-drm, so by default I guess
> it falls back to gregkh (drivers/staging/)?
> The "Commit" field in git log seems to back this up.
> 
> Although, based on Author, I think we also want the opinions of
> Philipp Zabel and Russel King.

Once the wranglings on the patch series are complete, I do intend to test
it on the platforms I have - and remember that I do have the ALSA based
audio and CEC bits as well, some of which will probably need a little bit
of re-work.

All in all, I welcome the renaming of this to include a reference to
DesignWare - I've always thought it's a mistake that the HDMI interface
in iMX6 was not named with a "dw" prefix as the docs contain references
to it being a DesignWare IP module.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
