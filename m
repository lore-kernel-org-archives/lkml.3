Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbaHSQrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:47:41 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:35425 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbaHSQrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:47:36 -0400
MIME-Version: 1.0
In-Reply-To: <1408415512-17275-1-git-send-email-addy.ke@rock-chips.com>
References: <1407995360-26009-1-git-send-email-addy.ke@rock-chips.com>
	<1408415512-17275-1-git-send-email-addy.ke@rock-chips.com>
Date: Tue, 19 Aug 2014 09:47:35 -0700
X-Google-Sender-Auth: 5j2y9q61lch_8PTpze8sjlZVc8o
Message-ID: <CAD=FV=V_LMm_xKhanwqQLK5nV3WvyvpdOdBN-z5b9jGd2=TgGw@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: dts: Add sdio0 and sdio1 to the rk3288
From: Doug Anderson <dianders@chromium.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, han jiang <hj@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        "zhenfu.fang" <zhenfu.fang@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addy,

On Mon, Aug 18, 2014 at 7:31 PM, Addy Ke <addy.ke@rock-chips.com> wrote:
> This patch requires that <https://patchwork.kernel.org/patch/4701721/>
> land in order to compile.
>
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
> Changes in v2:
> - repost patch to match what's in Heiko's "wip/v3.18-next/dts" tree
>   for the other dwmmc controllers
> - add "cd" and "int" line, suggested by Doug Anderson
> - fix up sdio1 configuration error
>
>  arch/arm/boot/dts/rk3288.dtsi | 86 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 86 insertions(+)
>
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 36be7bb..91576ae 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -88,6 +88,26 @@
>                 status = "disabled";
>         };
>
> +       sdio0: dwmmc@ff0d0000 {
> +               compatible = "rockchip,rk3288-dw-mshc";
> +               clocks = <&cru HCLK_SDIO0>, <&cru SCLK_SDIO0>;
> +               clock-names = "biu", "ciu";
> +               fifo-depth = <0x100>;
> +               interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
> +               reg = <0xff0d0000 0x4000>;
> +               status = "disabled";
> +       };
> +
> +       sdio1: dwmmc@ff0e0000 {
> +               compatible = "rockchip,rk3288-dw-mshc";
> +               clocks = <&cru HCLK_SDIO1>, <&cru SCLK_SDIO1>;
> +               clock-names = "biu", "ciu";
> +               fifo-depth = <0x100>;
> +               interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>;
> +               reg = <0xff0e0000 0x4000>;
> +               status = "disabled";
> +       };
> +
>         emmc: dwmmc@ff0f0000 {
>                 compatible = "rockchip,rk3288-dw-mshc";
>                 clocks = <&cru HCLK_EMMC>, <&cru SCLK_EMMC>;
> @@ -508,6 +528,72 @@
>                         };
>                 };
>
> +               sdio0 {
> +                       sdio0_clk: sdio0-clk {
> +                               rockchip,pins = <4 25 RK_FUNC_1 &pcfg_pull_none>;
> +                       };
> +
> +                       sdio0_cmd: sdio0-cmd {
> +                               rockchip,pins = <4 24 RK_FUNC_1 &pcfg_pull_up>;
> +                       };
> +
> +                       sdio0_cd: sdio0-cd {
> +                               rockchip,pins = <4 26 RK_FUNC_1 &pcfg_pull_up>;
> +                       };
> +
> +                       sdio0_pwr: sdio0-pwr {
> +                               rockchip,pins = <4 28 RK_FUNC_1 &pcfg_pull_up>;
> +                       };
> +
> +                       sdio0_int: sdio0-int {
> +                               rockchip,pins = <4 30 RK_FUNC_1 &pcfg_pull_up>;
> +                       };
> +
> +                       sdio0_bus1: sdio0-bus1 {
> +                               rockchip,pins = <4 20 RK_FUNC_1 &pcfg_pull_up>;
> +                       };
> +
> +                       sdio0_bus4: sdio0-bus4 {
> +                               rockchip,pins = <4 20 RK_FUNC_1 &pcfg_pull_up>,
> +                                               <4 21 RK_FUNC_1 &pcfg_pull_up>,
> +                                               <4 22 RK_FUNC_1 &pcfg_pull_up>,
> +                                               <4 23 RK_FUNC_1 &pcfg_pull_up>;
> +                       };

Can you make sure to include all of the sdio0 pins?  I think you're
still missing gpio4d3 (write protect).  You're also missing gpio4d5
(bkpwr), not that I know what that actually is.

Also: I know that sdmmc isn't sorted properly (should probably fix
that), but can you sort sdio0 and sdio1 by pin number?  So list data
lines first, then cmd, then clock, then detect, then write protect,
...


Same comments apply to sdio1.

> +               };
> +
> +               sdio1 {
> +                       sdio1_clk: sdio1-clk {
> +                               rockchip,pins = <4 7 RK_FUNC_4 &pcfg_pull_none>;
> +                       };
> +
> +                       sdio1_cmd: sdio1-cmd {
> +                               rockchip,pins = <4 6 RK_FUNC_4 &pcfg_pull_up>;
> +                       };
> +
> +                       sdio1_cd: sdio1-cd {
> +                               rockchip,pins = <3 28 RK_FUNC_4 &pcfg_pull_up>;
> +                       };
> +
> +                       sdio1_pwr: sdio1-pwr {
> +                               rockchip,pins = <4 9 RK_FUNC_4 &pcfg_pull_up>;
> +                       };
> +
> +                       sdio1_int: sdio1-int {
> +                               rockchip,pins = <3 31 RK_FUNC_4 &pcfg_pull_up>;
> +                       };
> +
> +                       sdio1_bus1: sdio1-bus1 {
> +                               rockchip,pins = <3 24 RK_FUNC_4 &pcfg_pull_up>;
> +                       };
> +
> +                       sdio1_bus4: sdio1-bus4 {
> +                               rockchip,pins = <3 24 RK_FUNC_4 &pcfg_pull_up>,
> +                                               <3 25 RK_FUNC_4 &pcfg_pull_up>,
> +                                               <3 26 RK_FUNC_4 &pcfg_pull_up>,
> +                                               <3 27 RK_FUNC_4 &pcfg_pull_up>;
> +                       };
> +               };
> +
>                 emmc {
>                         emmc_clk: emmc-clk {
>                                 rockchip,pins = <3 18 RK_FUNC_2 &pcfg_pull_none>;
> --
> 1.8.3.2
>
>
