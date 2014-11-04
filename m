Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaKDVcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 16:32:51 -0500
Received: from mail-oi0-f50.google.com ([209.85.218.50]:54334 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaKDVcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 16:32:50 -0500
MIME-Version: 1.0
In-Reply-To: <1414747777-12625-1-git-send-email-kever.yang@rock-chips.com>
References: <1414747777-12625-1-git-send-email-kever.yang@rock-chips.com>
Date: Tue, 4 Nov 2014 13:32:49 -0800
X-Google-Sender-Auth: 7xdtH7pxeM8W-us5idYxBcePkH4
Message-ID: <CAD=FV=VByf=YKw7q4L2493C-z9uJ3dTSk9WZyCFdOkSjD2XoDw@mail.gmail.com>
Subject: Re: [PATCH] clk: rockchip: change hierarchy for some clocks
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, han jiang <hj@rock-chips.com>,
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

Kever

On Fri, Oct 31, 2014 at 2:29 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> This patch change the hierarchy for some clocks, to met the following
> bus hierarchy:
> hclk_usb_peri is bus clock for
> |- hclk_otg0,
> |- hclk_host0,
> |- hclk_host1,
> |- hclk_hsic
>
> hclk_emem is bus clock for
> |- hclk_nandc0
> |- hclk_nandc1
>
> hclk_mem is bus clock for
> |- hclk_sdmmc
> |- hclk_sdio0
> |- hclk_sdio1
> |- hclk_emmc

So as I understand it the "parent" clocks aren't really parents but
are actually peer clocks.  That is if "hclk_usb_peri" is gated
"hclk_otg0" continues to run.  ...but the OTG periperhal is useless
without "hclk_usb_peri" also being enabled.

There doesn't seem to be any real downside to modeling thing as you
have done it, though it's not quite a true representation of the
world.  A slightly more true representation would be to make it so
that whenever "hclk_otg0" is enabled/disabled that it makes an
enable/disable call to "hclk_usb_peri".  I think you'd have to
subclass the gate clock and patch your stuff in the "enable" function.

I'm personally OK with things landing as you've described it (I can
see no downside), but it seems like this at least deserves a comment
(either in the code or the commit message).

If Mike T. thinks that we should use a more truthful model or if
there's some better way to express this, you should of course listen
to him and not to me.


-Doug
