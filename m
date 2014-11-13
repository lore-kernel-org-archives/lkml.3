Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303AbaKMR3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:29:44 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:44882 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbaKMR3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:29:39 -0500
MIME-Version: 1.0
In-Reply-To: <1415829690-20236-3-git-send-email-caesar.wang@rock-chips.com>
References: <1415829690-20236-1-git-send-email-caesar.wang@rock-chips.com>
	<1415829690-20236-3-git-send-email-caesar.wang@rock-chips.com>
Date: Thu, 13 Nov 2014 09:29:37 -0800
X-Google-Sender-Auth: vNmrgqWNH-Y7SoBLFn71Zlptatc
Message-ID: <CAD=FV=XHcpT8VaBeytJ2mYJ-fg96uvdDrbVna6md=Ne2y=dN=Q@mail.gmail.com>
Subject: Re: [PATCH v11 2/3] power-domain: rockchip: add power doamin driver
From: Doug Anderson <dianders@chromium.org>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        ZhenFu Fang <fzf@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Jack Dai <jack.dai@rock-chips.com>,
        "jinkun.hong" <jinkun.hong@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Nov 12, 2014 at 2:01 PM, Caesar Wang <caesar.wang@rock-chips.com> wrote:
> In order to meet high performance and low power requirements, a power
> management unit is designed or saving power when RK3288 in low power mode.
> The RK3288 PMU is dedicated for managing the power ot the whole chip.
>
> Signed-off-by: Jack Dai <jack.dai@rock-chips.com>
> Signed-off-by: jinkun.hong <jinkun.hong@rock-chips.com>
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
>
> ---
>
> Changes in v11:
>     - fix pm_genpd_init(&pd->genpd, NULL, false);
>
> Changes in v10:
>     - this switches over domain infos to use masks instead of recomputing
>       them each time and also gets rid of custom domain translator and
>       uses standard onecell on.
>
> Changes in v9:
>     - fix v8 changes as follows:
>     - This reconciles the v2 and v7 code so that we power domain have
>       lists of clocks they toggle on and off during power transitions and
>       independently from power domains clocks we attach clocks to devices
>       comprising power domain and prepare them so they are turn on and off
>       by runtime PM.
>     - add rockchip_pm_add_one_domain() to control domains.
>     - add pd_start/pd_stop interface to control clocks
>
> Changes in v8:
>     - This reconciles the v2 and v7 code so that we power domain have
>       lists of clocks they toggle on and off during power transitions and
>       independently from power domains clocks we attach clocks to devices
>       comprising power domain and prepare them so they are turn on and off
>       by runtime PM.
>
> Changes in v7:
>     - Delete unused variables
>
> Changes in v6:
>     - delete pmu_lock
>     - modify dev_lock using mutex
>     - pm_clk_resume(pd->dev) change to pm_clk_resume(ed->dev)
>     - pm_clk_suspend(pd->dev) change to pm_clk_suspend(ed->dev)
>     - add devm_kfree(pd->dev, de) in rockchip_pm_domain_detach_dev
>
> Changes in v5:
>     - delete idle_lock
>     - add timeout in rockchip_pmu_set_idle_request()
>
> Changes in v4:
>     - use list storage dev
>
> Changes in v3:
>     - change use pm_clk_resume() and pm_clk_suspend()
>
> Changes in v2:
>     - remove the "pd->pd.of_node = np"
>
>  arch/arm/mach-rockchip/Kconfig            |   1 +
>  arch/arm/mach-rockchip/Makefile           |   1 +
>  arch/arm/mach-rockchip/pm_domains.c       | 471 ++++++++++++++++++++++++++++++
>  include/dt-bindings/power-domain/rk3288.h |  11 +
>  4 files changed, 484 insertions(+)

This was discussed offlist, but just to make sure it's also included here:

This patch will need to be spun to deal with the fact that (c16561e PM
/ Domains: Change prototype for the attach and detach callbacks) has
landed.

-Doug
