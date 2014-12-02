Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaLBRrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:47:25 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:43071 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbaLBRrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:47:19 -0500
MIME-Version: 1.0
In-Reply-To: <547D6F36.50103@rock-chips.com>
References: <1415970338-2637-1-git-send-email-addy.ke@rock-chips.com>
	<1416903008-4160-1-git-send-email-addy.ke@rock-chips.com>
	<CAD=FV=UmG1okxJ5JV-1cuRRQJi7EEPXc7Q90sWjfMWBqb7VSMw@mail.gmail.com>
	<547D6F36.50103@rock-chips.com>
Date: Tue, 2 Dec 2014 09:47:18 -0800
X-Google-Sender-Auth: H7za1kIGC9bBoeGF-49d80C6TGc
Message-ID: <CAD=FV=V3BF8qv17n4_T5Lys1BnKsqE9NqOTB-6OwX0VOviWRrw@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: dw_mmc: add quirk for broken data transfer over scheme
From: Doug Anderson <dianders@chromium.org>
To: addy ke <addy.ke@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Alexandru Stan <amstan@chromium.org>,
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

Addy,

On Mon, Dec 1, 2014 at 11:50 PM, addy ke <addy.ke@rock-chips.com> wrote:
> We don't know why we have this problem,
> but this problem is really exist, and we need patch to fix this problem now.
> I will post a follow up change when we find the root cause.

To me that seems reasonable.  Certainly I would prefer to have this
patch while waiting for the root cause, but it's up to Ulf.


> And there is a little probability of this problem on RK SoC, such as RK3188, RK3066,
> when worse card inserted in.
> Maybe the other SoCs have the similar problem.
>
> So I will add this quirk in rockchip code(dw_mmc-rockchip.c) as follows:
> static int dw_mci_rockchip_parse_dt(struct dw_mci *host)
> {
>         host->quirk |= DW_MCI_QUIRK_BROKEN_DTO;
>
>         return 0;
> }
>
> ......
>         .parse_dt = dw_mci_rockchip_parse_dt,
> ......
>
> is right?

When you added "sdio_id0" you got feedback that you should use
dw_mci_rockchip_init().  Why not do the same thing here?
