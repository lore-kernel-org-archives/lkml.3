Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbaKYF3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 00:29:33 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:45124 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaKYF3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 00:29:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAPDyKFqt4rrwi940KAPyPONpjixK1730QmHEsN27V97jyHH+Qw@mail.gmail.com>
References: <1415109789-7046-1-git-send-email-addy.ke@rock-chips.com>
	<1415678573-6093-1-git-send-email-addy.ke@rock-chips.com>
	<CAPDyKFqUoBjhsbz8rkLa9PY_dpgMxnimz3k7OoA5WVhi7MacPQ@mail.gmail.com>
	<CAD=FV=VQHZ6YmcoeAb1OEVLYRrYBnc_dM5Kjt1TZX_CQJC=EfA@mail.gmail.com>
	<5464152E.7040209@rock-chips.com>
	<CAPDyKFrzGfDew0eLLEcA+_iS_mo-O2bFU58fjirfXXA8AJ9UYQ@mail.gmail.com>
	<CAD=FV=Ve1TY4+8quq1=18A1YOFvOWuFGrBmHLwMCwdWBSqzxOw@mail.gmail.com>
	<CAD=FV=UJT5zBkcj2a03Y_RWxad9+Pu83G_z79Xzzn74V=eRqww@mail.gmail.com>
	<CAPDyKFqt4rrwi940KAPyPONpjixK1730QmHEsN27V97jyHH+Qw@mail.gmail.com>
Date: Mon, 24 Nov 2014 21:29:28 -0800
X-Google-Sender-Auth: f7dAc0dkfwTNFtnEKWxmHmF1rxg
Message-ID: <CAD=FV=UZT91rp2rgPCh5mY5s+g8J3iOrDsHKjuXAgEqoye5goQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: try pick the exact same voltage as vmmc for vqmmc
From: Doug Anderson <dianders@chromium.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: addy ke <addy.ke@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Dinh Nguyen <dinguyen@altera.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Alexandru Stan <amstan@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "zhenfu.fang" <zhenfu.fang@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, lintao <lintao@rock-chips.com>,
        chenfen <chenfen@rock-chips.com>, zyf <zyf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris Zhong <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Lin Huang <hl@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulf,

On Mon, Nov 24, 2014 at 5:29 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> 2. Several people I've talked to have expressed concerns that our
>> minimum value is 2.7V.  Apparently that's really on the edge and makes
>> EEs a little nervous.  The quick sample of cards sitting on my desk
>> shows that they seem to claim 0x00ff8000, which doesn't include 2.7V.
>
> 0x00ff8000 states what values of VDD levels the device supports. Not VIO.

Yup, I was just pointing out that possibly others were trying to get a
little bit of margin (not going all the way down to 2.7V) too.

>> Both of the above make me feel like dw_mmc should try its best to pick
>> a value for vqmmc that is closest to the value of vmmc (and >= 2.7V).
>> That also happens to make us work exactly like hosts where vmmc and
>> vqmmc are supplied by the same supply.
>
> I do see your point. And I agree that it would be nice to achieve
> something like this.
>
> The question is how to do this. For sure, we need to involve the mmc
> core to handle this correctly.

You could add a function to the core that we could call from
dw_mci_switch_voltage() and it would do all the work except trying to
set the UHS register.  That would certainly make it easy.  That could
try to set the highest voltage that is <= vmmc when we're at
MMC_SIGNAL_VOLTAGE_330.

-Doug
