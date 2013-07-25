Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3GYMeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 08:34:21 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17989 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab3GYMeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 08:34:18 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-f0-51f11b489cd7
Message-id: <51F11B46.7010900@samsung.com>
Date: Thu, 25 Jul 2013 14:34:14 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Chao Xie <xiechao.mail@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v5 4/5] clk: add CLK_SET_RATE_NO_REPARENT flag
References: <1371139562-305-1-git-send-email-james.hogan@imgtec.com>
 <1371139562-305-5-git-send-email-james.hogan@imgtec.com>
In-reply-to: <1371139562-305-5-git-send-email-james.hogan@imgtec.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02RXUiTYRiGefd9fvvByefSeDOwGEhhZS6CXkZKRNEbjtIDEbO0pUslN2VT
	yYhcWCpr07kcxvyrOUVtak00LQ2dqAeZusaWoimR1gp1+QdSKjnXgWcX93M9z33wsAheHxnE
	SpdlS+QycQaf4pAftocdJ/DB5ZjwoplQtKUbYiJ3gxqgjw39FPr+ao1ElsJFgMZbz6ClGheB
	1oanKdSs797Jvzl9kP1tFYWejb1noCk7F3VYegk0r7VRSFvRQiJdix6gydrbaGPkCYn6bGUU
	+tVfSKJ3TSYSNdm2dlxLE3kOYnONGeBHBWoK//2jA7ik3EHhSqWNxPYSDQNvLl3CcxYbwN2G
	L0ys7h4BeNrZQ+F2Uz7WFCxRuHQrHK9agvHr6tho+hrnbIokIz1XIj8ZeZOT1mk2MrNe+t/t
	dLooJejhqgCLBenTsGMCqwB7B/fD8Zk2SgU4LB5dD6D1zTzpGfDoFQCrNL4e5tKhsL220cez
	S9IhsHY1xRNTtABqBkuAhwPpaFhnGmV6dX+48XRm90wAfRSaP2kYHiboCSYc/Cny8D76PFSV
	FRHeqnz4o7R312HTF+H0ouO/fwTqaoyElw/BdvMioQW0YU+FYY9m2KM9B0QzCJTkJGcpbqVK
	BWEKsVSRI0sNS86UWoD362tdoG5IaAU0C/B9uTHr7hiejzhXkSe1Asgi+AHcKLgcw+OmiPPu
	SeSZSfKcDInCChgsdpASXFY7B2I39YlxlQwjiIqbMmX5GSdErsnw+nVXXXZiPNruW6aNotmE
	O7/twlOaVr/PDeak9GBHribiQELF18N+90Wih8Rsb0J5o4B6ASLZhi69NuK68LFbQ1ZXjRmq
	lccJYepK4oa7+MLV4mMLCwOZbZJ82ZUHN0Linfa5UT6pSBMLQgm5QvwPS7OW9NMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On 06/13/2013 06:06 PM, James Hogan wrote:
> Add a CLK_SET_RATE_NO_REPARENT clock flag, which will prevent muxes
> being reparented during clk_set_rate.
> 
> To avoid breaking existing platforms, all callers of clk_register_mux()
> are adjusted to pass the new flag. Platform maintainers are encouraged
> to remove the flag if they wish to allow mux reparenting on set_rate.
[..]
> Changes in v3:
> 
> * rename/invert CLK_SET_RATE_REMUX to CLK_SET_RATE_NO_REPARENT and move
>   to this new patch.
> * patch 3: add CLK_SET_RATE_NO_REPARENT flag to all callers of
>   clk_register_mux. If you don't mind your clocks being reparented in
>   response to set_rate please let me know and I'll drop the relevant
>   portion of the patch.

Why is this better to change current behaviour of the clock core
and modify all drivers instead of having, e.g. CLK_SET_RATE_REPARENT
set in drivers of hardware that supports clock re-parenting while
setting clock rate ?

Is there intention to just have the automatic clock re-parenting
as a default feature in the common clock API ?
My apologies if this has already been answered, I haven't been
following this thread.

Thanks,
Sylwester

>  arch/arm/mach-imx/clk.h              |   5 +-
>  drivers/clk/mmp/clk-mmp2.c           |  39 +++++---
>  drivers/clk/mmp/clk-pxa168.c         |  40 +++++---
>  drivers/clk/mmp/clk-pxa910.c         |  31 +++---
>  drivers/clk/mxs/clk.h                |   4 +-
>  drivers/clk/samsung/clk.h            |   2 +-
>  drivers/clk/spear/spear1310_clock.c  | 179 ++++++++++++++++++-----------------
>  drivers/clk/spear/spear1340_clock.c  |  97 ++++++++++---------
>  drivers/clk/spear/spear3xx_clock.c   |  57 +++++++----
>  drivers/clk/spear/spear6xx_clock.c   |  35 +++----
>  drivers/clk/sunxi/clk-sunxi.c        |   3 +-
>  drivers/clk/tegra/clk-tegra114.c     |  36 ++++---
>  drivers/clk/tegra/clk-tegra20.c      |   6 +-
>  drivers/clk/tegra/clk-tegra30.c      |  33 ++++---
>  drivers/clk/versatile/clk-vexpress.c |   4 +-
>  include/linux/clk-provider.h         |   1 +
>  16 files changed, 334 insertions(+), 238 deletions(-)

-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
