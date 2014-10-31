Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbaJaPzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:55:17 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:56838 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaJaPzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:55:13 -0400
MIME-Version: 1.0
In-Reply-To: <54534C17.7050703@samsung.com>
References: <1414666240-16782-1-git-send-email-addy.ke@rock-chips.com>
	<1414727409-6765-1-git-send-email-addy.ke@rock-chips.com>
	<54534C17.7050703@samsung.com>
Date: Fri, 31 Oct 2014 08:55:12 -0700
X-Google-Sender-Auth: WmZHoz5It_ipOkPLlLBDzL1CJdU
Message-ID: <CAD=FV=Wmb0ZhB1WmK9SPg28LWB3zv9oNj0peTx3Ybt_KMSv7bw@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: dw_mmc: add support for the other bit of sdio interrupt
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Addy Ke <addy.ke@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Seungwon Jeon <tgih.jun@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "zhenfu.fang" <zhenfu.fang@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, lintao <lintao@rock-chips.com>,
        chenfen <chenfen@rock-chips.com>, zyf <zyf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Lin Huang <hl@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaehoon,

On Fri, Oct 31, 2014 at 1:45 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> Hi, Addy.
>
> On 10/31/2014 12:50 PM, Addy Ke wrote:
>> The bit of sdio interrupt is 16 in designware implementation,
>> but it is 24 in RK3288. This patch add sdio_id0 for the number
>> of slot0 in the SDIO interrupt registers, which can be set in
>> platform DT table, such as:
>> - rockchip,sdio-interrupt-slot0 = <8>;
>
> I have a question. (It's not important question)
> You mentioned the sdio-irq bit used from 24 to 31, right?
> Then what interrupts are used from 16 to 23 at RK3288? Just reserved?

In my TRM 16 shows as "data_nobusy".  A quick search doesn't show any
documentation for what this means.  17-23 and 25-31 are reserved.

Note that (of course) there's no actual support for more than one slot
on rk3288, so claiming that "24-31" is SDIO INT is a little silly, but
I agree that it's probably is the best way to fit into the existing
code until someone gets around to removing the whole multi-slot cruft.
