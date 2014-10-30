Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaJ3EV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 00:21:26 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:40409 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaJ3EVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 00:21:25 -0400
MIME-Version: 1.0
In-Reply-To: <54519019.6010903@rock-chips.com>
References: <1414577167-25666-1-git-send-email-kever.yang@rock-chips.com>
	<CAD=FV=Vnt7Pg9V_cE0S8u-2X2hDsPN8huwy8xKv1UwvWEo-Hyw@mail.gmail.com>
	<13348555.zj6gsMcCpK@diego>
	<54519019.6010903@rock-chips.com>
Date: Wed, 29 Oct 2014 21:21:24 -0700
X-Google-Sender-Auth: qG-mvmvSAdCVyaRQF6o6MUASxKQ
Message-ID: <CAD=FV=XSqW1nNYfkXTRrWxVWL5qexisjwb77rNeczKsn0-md6A@mail.gmail.com>
Subject: Re: [PATCH] clk: rockchip: disable unused clocks
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>,
        =?UTF-8?B?5oi05YWL6ZyWIChKYWNrKQ==?= <dkl@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Wed, Oct 29, 2014 at 6:10 PM, Kever Yang <kever.yang@rock-chips.com> wrote:
>>> I'll also say that when I applied this atop my local tree that USB
>>> stopped working.  I just see:
>>>
>>> [ 1647.626747] hub 2-1:1.0: hub_port_status failed (err = -110)
>>> [ 1657.626746] hub 2-1:1.0: hub_port_status failed (err = -110)
>>>
>>> ...over and over and over again.
>>
>> maybe Kever's dwc2 clock-handling patch [0] might help there, as the
>> dwc2-host
>> currently does not seem to do any clock handling at all.
>
> I think Heiko is right, I test in my evb with following change and dwc2
> works well:
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c
> @@ -654,8 +654,8 @@ static struct rockchip_clk_branch rk3288_clk_branches[]
> __initdata = {
>
>         /* hclk_peri gates */
>         GATE(0, "hclk_peri_matrix", "hclk_peri", CLK_IGNORE_UNUSED,
> RK3288_CLKGATE_CON(6), 0, GFLAGS),
> -       GATE(HCLK_OTG0, "hclk_otg0", "hclk_peri", 0, RK3288_CLKGATE_CON(7),
> 4, GFLAGS),
> -       GATE(HCLK_USBHOST0, "hclk_host0", "hclk_peri", 0,
> RK3288_CLKGATE_CON(7), 6, GFLAGS),
> +       GATE(HCLK_OTG0, "hclk_otg0", "hclk_peri", CLK_IGNORE_UNUSED,
> RK3288_CLKGATE_CON(7), 4, GFLAGS),
> +       GATE(HCLK_USBHOST0, "hclk_host0", "hclk_peri", CLK_IGNORE_UNUSED,
> RK3288_CLKGATE_CON(7), 6, GFLAGS),
>         GATE(HCLK_USBHOST1, "hclk_host1", "hclk_peri", 0,
> RK3288_CLKGATE_CON(7), 7, GFLAGS),
>         GATE(HCLK_HSIC, "hclk_hsic", "hclk_peri", 0, RK3288_CLKGATE_CON(7),
> 8, GFLAGS),
>         GATE(0, "hclk_usb_peri", "hclk_peri", CLK_IGNORE_UNUSED,
> RK3288_CLKGATE_CON(7), 9, GFLAGS),

Yeah, that fixes it for me.  Since the USB patches are still RFC-level
I assume you'll add these to your next version.
