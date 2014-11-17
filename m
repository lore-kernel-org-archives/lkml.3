Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaKQT4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:56:25 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:41391 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaKQT4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:56:24 -0500
MIME-Version: 1.0
In-Reply-To: <20141117193902.25314.97687@quantum>
References: <1416009604-31545-1-git-send-email-amstan@chromium.org>
 <1416009604-31545-2-git-send-email-amstan@chromium.org> <20141117193902.25314.97687@quantum>
From: Alexandru Stan <amstan@chromium.org>
Date: Mon, 17 Nov 2014 11:50:51 -0800
Message-ID: <CAHNYxRwGWqbznVybmE+tpyghEoQwVFK_V2ubFRKXasvsPS+R7Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] clk: rockchip: add bindings for the mmc clock phases
To: Mike Turquette <mturquette@linaro.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Doug Anderson <dianders@chromium.org>,
        addy ke <addy.ke@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Kever Yang <kever.yang@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mark.yao@rock-chips.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for my previous mail, I sent it as HTML and also top posted.
Here it goes again:

On Mon, Nov 17, 2014 at 11:39 AM, Mike Turquette <mturquette@linaro.org> wrote:
> It looks like you are adding new clocks to handle the phase requirement.
> Is that the right thing to do? Don't these clks already exist (e.g.
> SCLK_SDMMC)?
I actually need to control 2 phases, one of them is used when
outputting data, the other when sampling. Sunxi does something
similar: http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/273273.html

Another reason it wouldn't work is because the upstream clock(eg
SCLK_SDMMC) is twice as fast as the real clock(see RK3288_CLKGEN_DIV
in drivers/mmc/host/dw_mmc-rockchip.c), since that clock goes to a /2
divider to be able to do the 90 degree clock phases.

Alexandru Stan
