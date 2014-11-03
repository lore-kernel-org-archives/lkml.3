Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaKCRHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:07:38 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:44094 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaKCRHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:07:37 -0500
MIME-Version: 1.0
In-Reply-To: <1414845873-26351-1-git-send-email-kever.yang@rock-chips.com>
References: <1414845873-26351-1-git-send-email-kever.yang@rock-chips.com>
Date: Mon, 3 Nov 2014 09:07:36 -0800
X-Google-Sender-Auth: YFGdWGBRTqG-YPBoVCotBM6mp9U
Message-ID: <CAD=FV=WrtDYaQqRsx7tfhfvvZzewFmhqRPt0vAF-i0vke5ZaFQ@mail.gmail.com>
Subject: Re: [PATCH v4] clk: rockchip: disable unused clocks
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>,
        =?UTF-8?B?5oi05YWL6ZyWIChKYWNrKQ==?= <dkl@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Sat, Nov 1, 2014 at 5:44 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> -       COMPOSITE(SCLK_EMMC, "sclk_emmc", mux_mmc_src_p, 0,
> +       COMPOSITE(SCLK_EMMC, "sclk_emmc", mux_mmc_src_p, CLK_IGNORE_UNUSED,

Is there a reason why this is needed?  I took it out (AKA let eMMC get
disabled when unused) and my system booted w/ eMMC as the root
filesystem.


> -       GATE(PCLK_UART2, "pclk_uart2", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 9, GFLAGS),
> +       GATE(PCLK_UART2, "pclk_uart2", "pclk_cpu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(11), 9, GFLAGS),

Is there a reason why this is needed?  I took it out (AKA let UART2
get disabled) and my system booted.

The console-related bits in my cmdline are:
  earlyprintk=ttyS2,115200n8 console=tty1 console=ttyS2,115200n8 kgdboc=ttyS2

Do you have a different cmdline where it's failing?


Other than the two above this looks sane to me (only looked at
rk3288).  At some point soon we should definitely fix the PWM and the
USB ones and then start looking at the others and see if there are any
others that can be fixed.  ...but this seems like it's moving us in
the right direction and I'd like to see it landed.


So with the above two fixes, you can add my Reviewed-by and Tested-by.
I tested this in the chromeos-3.14 tree (which has tons of backports)
on rk3288-pinky.  I tested:
* System continues to work normally (including graphics).
* WIP Suspend / Resume patches work better with this patch than
without (both normal and deep modes).


-Doug
