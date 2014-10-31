Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbaJaSDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:03:50 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:54681 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbaJaSDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:03:47 -0400
MIME-Version: 1.0
In-Reply-To: <1414135761-3406-1-git-send-email-jinkun.hong@rock-chips.com>
References: <1414135761-3406-1-git-send-email-jinkun.hong@rock-chips.com>
Date: Fri, 31 Oct 2014 11:03:46 -0700
X-Google-Sender-Auth: x6wgHELQLvgF5YQfawgdMjhrOyI
Message-ID: <CAD=FV=UzgS2JtNhUB+0gbMvpW76C=12=y+ij0p6Xpbk_vAs0ww@mail.gmail.com>
Subject: Re: [PATCH v7 0/3] ARM: rk3288 : Add PM Domain support
From: Doug Anderson <dianders@chromium.org>
To: "jinkun.hong" <jinkun.hong@rock-chips.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
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
        Heiko Stuebner <heiko@sntech.de>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kever Yang <kever.yang@rock-chips.com>, Chris <zyw@rock-chips.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jinkun,

On Fri, Oct 24, 2014 at 12:29 AM, jinkun.hong
<jinkun.hong@rock-chips.com> wrote:
> From: "jinkun.hong" <jinkun.hong@rock-chips.com>
>
> Add power domain drivers based on generic power domain for Rockchip platform,
> and support RK3288.
>
> https://chromium-review.googlesource.com/#/c/220253/9
> This is the GPU driver, add the following information in DT,
> and it can support the PMDOMAIN.
>
> gpu: gpu@ffa30000 {
>         compatible = "arm,malit764",
>                      "arm,malit76x",
>                      "arm,malit7xx",
>                      "arm,mali-midgard";
>         reg = <0xffa30000 0x10000>;
>         interrupts = <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>,
>                      <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
>                      <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
>         interrupt-names = "JOB", "MMU", "GPU";
>         clocks = <&cru ACLK_GPU>;
>         clock-names = "aclk_gpu";
>         operating-points = <
>                 /* KHz uV */
>                 100000 800000
>                 200000 850000
>                 300000 950000
>                 400000 1000000
>                 600000 1150000
>         >;
>         power-domains = <&gpu_power>;
>         status = "disabled";
> };
>
> Based on:
> - [PATCH v1 1/4] PM / clock_ops: Add pm_clk_add_clk()
>   http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg735599.html
>
> Changes in v7:
> - Delete unused variables
>
> Changes in v6:
> - delete pmu_lock
> - modify dev_lock using mutex
> - pm_clk_resume(pd->dev) change to pm_clk_resume(ed->dev)
> - pm_clk_suspend(pd->dev) change to pm_clk_suspend(ed->dev)
> - add devm_kfree(pd->dev, de) in rockchip_pm_domain_detach_dev
>
> Changes in v5:
> - delete idle_lock
> - add timeout in rockchip_pmu_set_idle_request()
>
> Changes in v4:
> - use list storage dev
>
> Changes in v3:
> - change use pm_clk_resume() and pm_clk_suspend()
> - DT structure has changed
> - Decomposition power-controller, changed to multiple controller
>    (gpu-power-controller, hevc-power-controller)
>
> Changes in v2:
> - remove the "pd->pd.of_node = np"
> - move clocks to "optional"
> - make pd_vio clocks all one entry per line and alphabetize.
> - power: power-controller move back to pinctrl: pinctrl.
>
> jinkun.hong (3):
>   power-domain: add power domain drivers for Rockchip platform
>   dt-bindings: add document of Rockchip power domain
>   ARM: dts: add rk3288 power-domain node
>
>  .../bindings/arm/rockchip/power_domain.txt         |   46 +++
>  arch/arm/boot/dts/rk3288.dtsi                      |   24 ++
>  arch/arm/mach-rockchip/Kconfig                     |    1 +
>  arch/arm/mach-rockchip/Makefile                    |    1 +
>  arch/arm/mach-rockchip/pm_domains.c                |  355 ++++++++++++++++++++
>  5 files changed, 427 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/rockchip/power_domain.txt
>  create mode 100644 arch/arm/mach-rockchip/pm_domains.c

I haven't been following all of the changes here, but I'll say that I
just spent a bunch of time figuring out why my system wasn't properly
going into suspend using your patchset after I picked up Kever's patch
to disable unused clocks
(https://patchwork.kernel.org/patch/5202291/).

It turns out that if I go back to patch v2 of your series that suspend
works great.  ...but not with v7.

I got to this point because I started bisecting clocks.  I realized
that I needed to leave on "aclk_vepu", "aclk_vdpu", "aclk_rga_pre",
"sclk_rga", "aclk_hevc", ..., ...  As I kept finding more clocks they
kept looking more and more like your list from the v2 dtsi and it
became obvious.


I guess that things are not properly being turned off properly due to
the reason you stated in <https://lkml.org/lkml/2014/10/28/1279>.
Specifically we need all the relevant clocks on in order to power
things on and off.


I'll let you guys hash out how you want to make this work, but I
figured I'd at least point out what I was seeing.  ;)


NOTE: I'll upload something before EOD California today into our
chromeos-3.14 tree that shows how I am testing on rk3288-pinky.  I
know that's not terribly useful to everyone upstream, but not all
patches for S2R have landed upstream so that's the best I can do.  I'm
currently testing "deep" suspend (with SDRAM in self refresh mode)
which we have no way to resume from ATM.  I'm measuring "success" by
looking at total system power as reported by the battery.  With v2 I
get down to very low power.  With v7 I don't.



-Doug
