Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbaKUMGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:06:21 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:44980 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbaKUMGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:06:19 -0500
MIME-Version: 1.0
In-Reply-To: <5464152E.7040209@rock-chips.com>
References: <1415109789-7046-1-git-send-email-addy.ke@rock-chips.com>
	<1415678573-6093-1-git-send-email-addy.ke@rock-chips.com>
	<CAPDyKFqUoBjhsbz8rkLa9PY_dpgMxnimz3k7OoA5WVhi7MacPQ@mail.gmail.com>
	<CAD=FV=VQHZ6YmcoeAb1OEVLYRrYBnc_dM5Kjt1TZX_CQJC=EfA@mail.gmail.com>
	<5464152E.7040209@rock-chips.com>
Date: Fri, 21 Nov 2014 13:06:18 +0100
Message-ID: <CAPDyKFrzGfDew0eLLEcA+_iS_mo-O2bFU58fjirfXXA8AJ9UYQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: try pick the exact same voltage as vmmc for vqmmc
From: Ulf Hansson <ulf.hansson@linaro.org>
To: addy ke <addy.ke@rock-chips.com>
Cc: Doug Anderson <dianders@chromium.org>, Rob Herring <robh+dt@kernel.org>,
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
        linux-rockchip@lists.infradead.org,
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

[...]

> Sure
> If the first card is sd2.0 since startup, dw_mci_switch_voltage will not be called,

That can't be right. mmc_power_up() should trigger
dw_mci_switch_voltage() to be invoked.

> and card can be identified. But if UHS card is pulgged in first, the vqmmc will be down to 1.8v.
>
> when sd2.0 card is pulgged in, mmc core will call dw_mci_switch_voltage to change vqmmc to 3.3v
> (MMC_SINGLE_VOTAGE_330). So vqmmc will be set 2.7v, if we request 2.7-3.6v.
>
> But vmmc is always 3.3v,becuase it be set min_volt = max_volt = 3.3v in dt tables.
>
> So the result:
> vmmc = 3.3v and vqmmc = 2.7v, and sd2.0 card is failed to identify in my test.

Hmm. I wonder why it works the first time? Could it be that your
regulator have voltage ramp up time that isn't properly considered?

Kind regards
Uffe
