Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab3HSVJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:09:56 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:60901 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3HSVJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:09:54 -0400
Message-ID: <52128995.1080200@elopez.com.ar>
Date: Mon, 19 Aug 2013 18:09:41 -0300
From: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Mike Turquette <mturquette@linaro.org>,
        "kevin.z.m.zh" <kevin.z.m.zh@gmail.com>,
        =?UTF-8?B?5a2Z5b2m6YKm?= <sunny@allwinnertech.com>,
        =?UTF-8?B?5ZC05Lmm6ICV?= <shuge@allwinnertech.com>,
        "Mailing List, Arm" <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] clk: sunxi: Add Allwinner A20 gates
References: <1376766523-9107-1-git-send-email-maxime.ripard@free-electrons.com> <1376766523-9107-2-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1376766523-9107-2-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

El 17/08/13 16:08, Maxime Ripard escribió:
> The Allwinner A20 is almost identical to the earlier A10 SoC from
> Allwinner on many aspects, including the clocks tree. However, since the
> A20 has some additionnal IPs compared to the A10, the clock tree isn't
> exactly the same, especially when it comes to the gated clocks
> available. We thus need to register different clock gates for the A20.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Code wise it looks good to me, I just have some small comments.

Reviewed-by: Emilio López <emilio@elopez.com.ar>

> ---
>   Documentation/devicetree/bindings/clock/sunxi.txt  |  3 +
>   .../bindings/clock/sunxi/sun7i-a20-gates.txt       | 98 ++++++++++++++++++++++
>   drivers/clk/sunxi/clk-sunxi.c                      | 15 ++++
>   3 files changed, 116 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun7i-a20-gates.txt
>
> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
> index c383d12..00a5c264 100644
> --- a/Documentation/devicetree/bindings/clock/sunxi.txt
> +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> @@ -16,18 +16,21 @@ Required properties:
>   	"allwinner,sun4i-ahb-gates-clk" - for the AHB gates on A10
>   	"allwinner,sun5i-a13-ahb-gates-clk" - for the AHB gates on A13
>   	"allwinner,sun5i-a10s-ahb-gates-clk" - for the AHB gates on A10s
> +	"allwinner,sun7i-a20-ahb-gates-clk" - for the AHB gates on A20
>   	"allwinner,sun6i-a31-ahb1-mux-clk" - for the AHB1 multiplexer on A31
>   	"allwinner,sun6i-a31-ahb1-gates-clk" - for the AHB1 gates on A31
>   	"allwinner,sun4i-apb0-clk" - for the APB0 clock
>   	"allwinner,sun4i-apb0-gates-clk" - for the APB0 gates on A10
>   	"allwinner,sun5i-a13-apb0-gates-clk" - for the APB0 gates on A13
>   	"allwinner,sun5i-a10s-apb0-gates-clk" - for the APB0 gates on A10s
> +	"allwinner,sun7i-a20-apb0-gates-clk" - for the APB0 gates on A20
>   	"allwinner,sun4i-apb1-clk" - for the APB1 clock
>   	"allwinner,sun4i-apb1-mux-clk" - for the APB1 clock muxing
>   	"allwinner,sun4i-apb1-gates-clk" - for the APB1 gates on A10
>   	"allwinner,sun5i-a13-apb1-gates-clk" - for the APB1 gates on A13
>   	"allwinner,sun5i-a10s-apb1-gates-clk" - for the APB1 gates on A10s
>   	"allwinner,sun6i-a31-apb1-gates-clk" - for the APB1 gates on A31
> +	"allwinner,sun7i-a20-apb1-gates-clk" - for the APB1 gates on A20
>   	"allwinner,sun6i-a31-apb2-div-clk" - for the APB2 gates on A31
>   	"allwinner,sun6i-a31-apb2-gates-clk" - for the APB2 gates on A31
>
> diff --git a/Documentation/devicetree/bindings/clock/sunxi/sun7i-a20-gates.txt b/Documentation/devicetree/bindings/clock/sunxi/sun7i-a20-gates.txt
> new file mode 100644
> index 0000000..357f4fd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/sunxi/sun7i-a20-gates.txt
> @@ -0,0 +1,98 @@
> +Gate clock outputs
> +------------------
> +
> +  * AXI gates ("allwinner,sun4i-axi-gates-clk")
> +
> +    DRAM					0
> +
> +  * AHB gates ("allwinner,sun7i-a20-ahb-gates-clk")
> +
> +    USB0					0
> +    EHCI0					1
> +    OHCI0					2
> +    EHCI1					3
> +    OHCI1					4
> +    SS						5
> +    DMA						6
> +    BIST					7
> +    MMC0					8
> +    MMC1					9
> +    MMC2					10
> +    MMC3					11
> +    MS						12
> +    NAND					13
> +    SDRAM					14
> +
> +    ACE						16
> +    EMAC					17
> +    TS						18
> +
> +    SPI0					20
> +    SPI1					21
> +    SPI2					22
> +    SPI3					23
> +
> +    SATA					25
> +
> +    HSTIMER					28
> +
> +    VE						32
> +    TVD						33
> +    TVE0					34
> +    TVE1					35
> +    LCD0					36
> +    LCD1					37
> +
> +    CSI0					40
> +    CSI1					41
> +
> +    HDMI1					42
> +    HDMI0					43
> +    DE_BE0					44
> +    DE_BE1					45
> +    DE_FE1					46
> +    DE_FE1					47
> +
> +    GMAC					49
> +    MP						50
> +
> +    MALI400					52
> +
> +  * APB0 gates ("allwinner,sun7i-a20-apb0-gates-clk")
> +
> +    CODEC					0
> +    SPDIF					1
> +    AC97					2
> +    IIS0					3
> +    IIS1					4
> +    PIO						5
> +    IR0						6
> +    IR1						7
> +    IIS2					8
> +
> +    KEYPAD					10
> +
> +  * APB1 gates ("allwinner,sun7i-a20-apb1-gates-clk")
> +
> +    I2C0					0
> +    I2C1					1
> +    I2C2					2
> +    I2C3					3
> +    CAN						4
> +    SCR						5
> +    PS20					6
> +    PS21					7
> +
> +    I2C4					15
> +    UART0					16
> +    UART1					17
> +    UART2					18
> +    UART3					19
> +    UART4					20
> +    UART5					21
> +    UART6					22
> +    UART7					23
> +
> +Notation:
> + [*]:  The datasheet didn't mention these, but they are present on AW code
> + [**]: The datasheet had this marked as "NC" but they are used on AW code

Same comment as on the other series, this can probably be dropped as 
you're not using it, but it's not a deal breaker as it might come in 
handy in the future.

> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index bd01a02..c359775 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -462,6 +462,10 @@ static const __initconst struct gates_data sun6i_a31_ahb1_gates_data = {
>   	.mask = {0xEDFE7F62, 0x794F931},
>   };
>
> +static const __initconst struct gates_data sun7i_a20_ahb_gates_data = {
> +	.mask = { 0x12f77fff, 0x16ff3f },
> +};
> +
>   static const __initconst struct gates_data sun4i_apb0_gates_data = {
>   	.mask = {0x4EF},
>   };
> @@ -474,6 +478,10 @@ static const __initconst struct gates_data sun5i_a13_apb0_gates_data = {
>   	.mask = {0x61},
>   };
>
> +static const __initconst struct gates_data sun7i_a20_apb0_gates_data = {
> +	.mask = { 0x4ff },
> +};
> +
>   static const __initconst struct gates_data sun4i_apb1_gates_data = {
>   	.mask = {0xFF00F7},
>   };
> @@ -494,6 +502,10 @@ static const __initconst struct gates_data sun6i_a31_apb2_gates_data = {
>   	.mask = {0x3F000F},
>   };
>
> +static const __initconst struct gates_data sun7i_a20_apb1_gates_data = {
> +	.mask = { 0xff80ff },
> +};
> +

I believe we discussed this already on another series :) I'd rather see 
A20 support merged than having it stalled because of a style issue though.

>   static void __init sunxi_gates_clk_setup(struct device_node *node,
>   					 struct gates_data *data)
>   {
> @@ -575,13 +587,16 @@ static const __initconst struct of_device_id clk_gates_match[] = {
>   	{.compatible = "allwinner,sun5i-a10s-ahb-gates-clk", .data = &sun5i_a10s_ahb_gates_data,},
>   	{.compatible = "allwinner,sun5i-a13-ahb-gates-clk", .data = &sun5i_a13_ahb_gates_data,},
>   	{.compatible = "allwinner,sun6i-a31-ahb1-gates-clk", .data = &sun6i_a31_ahb1_gates_data,},
> +	{.compatible = "allwinner,sun7i-a20-ahb-gates-clk", .data = &sun7i_a20_ahb_gates_data,},
>   	{.compatible = "allwinner,sun4i-apb0-gates-clk", .data = &sun4i_apb0_gates_data,},
>   	{.compatible = "allwinner,sun5i-a10s-apb0-gates-clk", .data = &sun5i_a10s_apb0_gates_data,},
>   	{.compatible = "allwinner,sun5i-a13-apb0-gates-clk", .data = &sun5i_a13_apb0_gates_data,},
> +	{.compatible = "allwinner,sun7i-a20-apb0-gates-clk", .data = &sun7i_a20_apb0_gates_data,},
>   	{.compatible = "allwinner,sun4i-apb1-gates-clk", .data = &sun4i_apb1_gates_data,},
>   	{.compatible = "allwinner,sun5i-a10s-apb1-gates-clk", .data = &sun5i_a10s_apb1_gates_data,},
>   	{.compatible = "allwinner,sun5i-a13-apb1-gates-clk", .data = &sun5i_a13_apb1_gates_data,},
>   	{.compatible = "allwinner,sun6i-a31-apb1-gates-clk", .data = &sun6i_a31_apb1_gates_data,},
> +	{.compatible = "allwinner,sun7i-a20-apb1-gates-clk", .data = &sun7i_a20_apb1_gates_data,},
>   	{.compatible = "allwinner,sun6i-a31-apb2-gates-clk", .data = &sun6i_a31_apb2_gates_data,},
>   	{}
>   };
>

Once again, thank you for working on this :) Hopefully I'll have an A20 
device to do tests on soon.

Cheers,

Emilio
