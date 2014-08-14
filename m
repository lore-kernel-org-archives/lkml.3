Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbaHNPr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:47:27 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:47671 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbaHNPrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:47:25 -0400
MIME-Version: 1.0
In-Reply-To: <1407995360-26009-1-git-send-email-addy.ke@rock-chips.com>
References: <1407995360-26009-1-git-send-email-addy.ke@rock-chips.com>
Date: Thu, 14 Aug 2014 08:47:23 -0700
X-Google-Sender-Auth: Z2th-F5vg4vhnH0zne9rv3qUOW0
Message-ID: <CAD=FV=XxF0zTVtV75FRDbiVq1MCrWpXak-vkP0iofPXXtE_OHg@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: Add sdio0 and sdio1 to the rk3288
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
        Lin Huang <hl@rock-chips.com>, wei.luo@rock-chips.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addy,

On Wed, Aug 13, 2014 at 10:49 PM, Addy Ke <addy.ke@rock-chips.com> wrote:
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
>  arch/arm/boot/dts/rk3288.dtsi | 76 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 76 insertions(+)
>
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 7a9173d..a440869 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -120,6 +120,32 @@
>                 //fifo-depth = <0x100>;
>         };
>
> +       sdio0: dwmmc@ff0d0000 {
> +               compatible = "rockchip,rk3288-dw-mshc";
> +               reg = <0xff0d0000 0x4000>;
> +               interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               clocks = <&cru HCLK_SDIO0>, <&cru SCLK_SDIO0>;
> +               clock-names = "biu", "ciu";
> +
> +               fifo-depth = <0x100>;
> +       };

Please repost and match what's in Heiko's "wip/v3.18-next/dts" tree
for the other dwmmc controllers.  Specifically:

* No more #address-cells and #size-cells.
* By default status = "disabled".
* Sort properties alphabetically.


> +
> +       sdio1: dwmmc@ff0e0000 {
> +               compatible = "rockchip,rk3288-dw-mshc";
> +               reg = <0xff0e0000 0x4000>;
> +               interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               clocks = <&cru HCLK_SDIO1>, <&cru SCLK_SDIO1>;
> +               clock-names = "biu", "ciu";
> +
> +               fifo-depth = <0x100>;
> +       };
> +
>         emmc: dwmmc@ff0f0000 {
>                 compatible = "rockchip,rk3288-dw-mshc";
>                 reg = <0xff0f0000 0x4000>;
> @@ -589,6 +615,56 @@
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
> +                       sdio0_pwr: sdio0-pwr {
> +                               rockchip,pins = <4 28 RK_FUNC_1 &pcfg_pull_up>;
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

Can you add the card detect line here?  How about the write protect
line?  What about the "bkpwr" and "int" lines?


> +               };
> +
> +               sdio1 {
> +                       sdio1_clk: sdio1-clk {
> +                               rockchip,pins = <4 7 RK_FUNC_4 &pcfg_pull_none>;

This requires that <https://patchwork.kernel.org/patch/4701721/> land
in order to compile.  Since that hasn't landed you should explicitly
reference it.



> +                       };
> +
> +                       sdio1_cmd: sdio1-cmd {
> +                               rockchip,pins = <4 6 RK_FUNC_4 &pcfg_pull_up>;
> +                       };
> +
> +                       sdio1_pwr: sdio1-pwr {
> +                               rockchip,pins = <4 9 RK_FUNC_4 &pcfg_pull_up>;
> +                       };
> +
> +                       sdio1_bus1: sdio1-bus1 {
> +                               rockchip,pins = <4 24 RK_FUNC_4 &pcfg_pull_up>;

This is probably wrong and should be <3 24 ...>, not <4 24 ...>.

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
