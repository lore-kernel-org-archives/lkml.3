Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbbAZRpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:45:13 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:54328 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbbAZRpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:45:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAPDyKFp=5epMggHu0+u_LU7ETujcoeP2xOpB7iD6JF2bs8BnEA@mail.gmail.com>
References: <1422271175-19445-1-git-send-email-addy.ke@rock-chips.com>
	<1422271175-19445-2-git-send-email-addy.ke@rock-chips.com>
	<CAPDyKFp=5epMggHu0+u_LU7ETujcoeP2xOpB7iD6JF2bs8BnEA@mail.gmail.com>
Date: Mon, 26 Jan 2015 09:45:07 -0800
X-Google-Sender-Auth: cIIGk7qfcTGxfbNxY3drYE5mhFQ
Message-ID: <CAD=FV=X9x0gW5TyLi4ERm8nxixQB__Y=5bRAtOax-_w+T33rCg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: core: use card pointer as the first parameter of execute_tuning()
From: Doug Anderson <dianders@chromium.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Addy Ke <addy.ke@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?Q?Pawe=C5=82_Moll?= <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
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
        Han Jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Lin Huang <hl@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulf,

On Mon, Jan 26, 2015 at 7:15 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 26 January 2015 at 12:19, Addy Ke <addy.ke@rock-chips.com> wrote:
>> We need to take the card pointer in execute_tuning() for mmc_send_status(),
>
> mmc_send_status() is an mmc core function, not intended for host's to call.
>
>> but mmc->card is NULL in tuning state. So we need change the first parameter
>> of execute_tuning() to card pointer(struct mmc_card * card).
>
> So, why do we need this?

I asked Addy to post upstream against mmc_send_tuning(), but I guess
he didn't (he posted against Alex's NAKed patch instead).

...when I talked to him about it, Addy was asserting that when tuning
fails it is important (at least on dw_mmc on rk3288) that we wait for
the card to stop being busy and that the way to detect was using
mmc_send_status().

That would mean that against upstream you'd need to change
mmc_send_tuning() to take in the card as well (or move the "host->card
= card" assignment to before UHS init, which seems less desirable?)

What do you think about that?  Is there a better solution?

-Doug
