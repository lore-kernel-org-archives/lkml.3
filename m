Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaHLVGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:06:15 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:37901 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbaHLVGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:06:12 -0400
MIME-Version: 1.0
In-Reply-To: <1407344984-14176-2-git-send-email-dianders@chromium.org>
References: <1407344984-14176-1-git-send-email-dianders@chromium.org>
	<1407344984-14176-2-git-send-email-dianders@chromium.org>
Date: Tue, 12 Aug 2014 14:06:11 -0700
X-Google-Sender-Auth: JngNwX4fNXtiECvi_Q_1qwflQNg
Message-ID: <CAD=FV=Wsc-Pkvg9jumdg9i1oO+T1=jtZTfbc+qE5RDrCXaaezA@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] ARM: dts: Add emmc and sdmmc to the rk3288 device tree
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Addy Ke <addy.ke@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Doug Anderson <dianders@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

On Wed, Aug 6, 2014 at 10:09 AM, Doug Anderson <dianders@chromium.org> wrote:
> This adds support for the sdmmc and emmc ports on the rk3288 using the
> currently posted driver from Addy at:
>   https://patchwork.kernel.org/patch/4653631/
>
> Note:
> * This is not baesd on Jaehoon's patch series removing the slot node,
>   but it does use new syntax like putting the bus width at the top
>   level and using the new cap-mmc-highspeed / cap-sd-highspeed.  A
>   future patch will modify this one to remove the slot node.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Changes in v3: None
> Changes in v2:
> - New patchwork link for Addy's patch
>
>  arch/arm/boot/dts/rk3288.dtsi | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index e7cb008..dc98a5b 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -78,6 +78,28 @@
>                 clock-frequency = <24000000>;
>         };
>
> +       sdmmc: dwmmc@ff0c0000 {
> +               compatible = "rockchip,rk3288-dw-mshc";
> +               clocks = <&cru HCLK_SDMMC>, <&cru SCLK_SDMMC>;
> +               clock-names = "biu", "ciu";
> +               fifo-depth = <0x100>;
> +               interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
> +               reg = <0xff0c0000 0x4000>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;

When doing other testing I realized that I missed a:
  status = "disabled";

...from both of these two nodes.  I'm happy to repost with this fix or
I'm happy if you want to add to the patch when applying.

Let me know.  Thanks!


> +       };
> +
> +       emmc: dwmmc@ff0f0000 {
> +               compatible = "rockchip,rk3288-dw-mshc";
> +               clocks = <&cru HCLK_EMMC>, <&cru SCLK_EMMC>;
> +               clock-names = "biu", "ciu";
> +               fifo-depth = <0x100>;
> +               interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
> +               reg = <0xff0f0000 0x4000>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +       };
> +
>         i2c1: i2c@ff140000 {
>                 compatible = "rockchip,rk3288-i2c";
>                 reg = <0xff140000 0x1000>;
> --
> 2.0.0.526.g5318336
>
