Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322Ab3HSUPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:15:20 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:60891 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3HSUPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:15:16 -0400
Message-ID: <52127CC1.7030005@elopez.com.ar>
Date: Mon, 19 Aug 2013 17:14:57 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Mike Turquette <mturquette@linaro.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 3/4] clk: sunxi: Add A31 clocks support
References: <1375735381-18214-1-git-send-email-maxime.ripard@free-electrons.com> <1375735381-18214-4-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1375735381-18214-4-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

El 05/08/13 17:43, Maxime Ripard escribió:
> The A31 has a mostly different clock set compared to the other older
> SoCs currently supported in the Allwinner clock driver.
>
> Add support for the basic useful clocks. The other ones will come in
> eventually.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

I had another quick look at it and overall it looks good to go,

Reviewed-by: Emilio López <emilio@elopez.com.ar>

> ---
>   Documentation/devicetree/bindings/clock/sunxi.txt  |   6 +
>   .../bindings/clock/sunxi/sun6i-a31-gates.txt       |  83 ++++++++++++++
>   drivers/clk/sunxi/clk-sunxi.c                      | 124 +++++++++++++++++++++
>   3 files changed, 213 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun6i-a31-gates.txt
>
> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
> index b24de10..c383d12 100644
> --- a/Documentation/devicetree/bindings/clock/sunxi.txt
> +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> @@ -8,6 +8,7 @@ Required properties:
>   - compatible : shall be one of the following:
>   	"allwinner,sun4i-osc-clk" - for a gatable oscillator
>   	"allwinner,sun4i-pll1-clk" - for the main PLL clock
> +	"allwinner,sun6i-a31-pll1-clk" - for the main PLL clock on A31
>   	"allwinner,sun4i-cpu-clk" - for the CPU multiplexer clock
>   	"allwinner,sun4i-axi-clk" - for the AXI clock
>   	"allwinner,sun4i-axi-gates-clk" - for the AXI gates
> @@ -15,6 +16,8 @@ Required properties:
>   	"allwinner,sun4i-ahb-gates-clk" - for the AHB gates on A10
>   	"allwinner,sun5i-a13-ahb-gates-clk" - for the AHB gates on A13
>   	"allwinner,sun5i-a10s-ahb-gates-clk" - for the AHB gates on A10s
> +	"allwinner,sun6i-a31-ahb1-mux-clk" - for the AHB1 multiplexer on A31
> +	"allwinner,sun6i-a31-ahb1-gates-clk" - for the AHB1 gates on A31
>   	"allwinner,sun4i-apb0-clk" - for the APB0 clock
>   	"allwinner,sun4i-apb0-gates-clk" - for the APB0 gates on A10
>   	"allwinner,sun5i-a13-apb0-gates-clk" - for the APB0 gates on A13
> @@ -24,6 +27,9 @@ Required properties:
>   	"allwinner,sun4i-apb1-gates-clk" - for the APB1 gates on A10
>   	"allwinner,sun5i-a13-apb1-gates-clk" - for the APB1 gates on A13
>   	"allwinner,sun5i-a10s-apb1-gates-clk" - for the APB1 gates on A10s
> +	"allwinner,sun6i-a31-apb1-gates-clk" - for the APB1 gates on A31
> +	"allwinner,sun6i-a31-apb2-div-clk" - for the APB2 gates on A31
> +	"allwinner,sun6i-a31-apb2-gates-clk" - for the APB2 gates on A31
>
>   Required properties for all clocks:
>   - reg : shall be the control register address for the clock.
> diff --git a/Documentation/devicetree/bindings/clock/sunxi/sun6i-a31-gates.txt b/Documentation/devicetree/bindings/clock/sunxi/sun6i-a31-gates.txt
> new file mode 100644
> index 0000000..fe44932
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/sunxi/sun6i-a31-gates.txt
> @@ -0,0 +1,83 @@
> +Gate clock outputs
> +------------------
> +
> +  * AHB1 gates ("allwinner,sun6i-a31-ahb1-gates-clk")
> +
> +    MIPI DSI					1
> +
> +    SS						5
> +    DMA						6
> +
> +    MMC0					8
> +    MMC1					9
> +    MMC2					10
> +    MMC3					11
> +
> +    NAND1					12
> +    NAND0					13
> +    SDRAM					14
> +
> +    GMAC					17
> +    TS						18
> +    HSTIMER					19
> +    SPI0					20
> +    SPI1					21
> +    SPI2					22
> +    SPI3					23
> +    USB_OTG					24
> +
> +    EHCI0					26
> +    EHCI1					27
> +
> +    OHCI0					29
> +    OHCI1					30
> +    OHCI2					31
> +    VE						32
> +
> +    LCD0					36
> +    LCD1					37
> +
> +    CSI						40
> +
> +    HDMI					43
> +    DE_BE0					44
> +    DE_BE1					45
> +    DE_FE1					46
> +    DE_FE1					47
> +
> +    MP						50
> +
> +    GPU						52
> +
> +    DEU0					55
> +    DEU1					56
> +    DRC0					57
> +    DRC1					58
> +
> +  * APB1 gates ("allwinner,sun6i-a31-apb1-gates-clk")
> +
> +    CODEC					0
> +
> +    DIGITAL MIC					4
> +    PIO						5
> +
> +    DAUDIO0					12
> +    DAUDIO1					13
> +
> +  * APB2 gates ("allwinner,sun6i-a31-apb2-gates-clk")
> +
> +    I2C0					0
> +    I2C1					1
> +    I2C2					2
> +    I2C3					3
> +
> +    UART0					16
> +    UART1					17
> +    UART2					18
> +    UART3					19
> +    UART4					20
> +    UART5					21
> +
> +Notation:
> + [*]:  The datasheet didn't mention these, but they are present on AW code
> + [**]: The datasheet had this marked as "NC" but they are used on AW code

If you have to respin this, I suppose you could drop the notation block, 
as it's not being used. But don't worry otherwise.

> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index cd07169..bd01a02 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -125,7 +125,89 @@ static void sun4i_get_pll1_factors(u32 *freq, u32 parent_rate,
>   	*n = div / 4;
>   }
>
> +/**
> + * sun6i_a31_get_pll1_factors() - calculates n, k and m factors for PLL1
> + * PLL1 rate is calculated as follows
> + * rate = parent_rate * (n + 1) * (k + 1) / (m + 1);
> + * parent_rate should always be 24MHz
> + */
> +static void sun6i_a31_get_pll1_factors(u32 *freq, u32 parent_rate,
> +				       u8 *n, u8 *k, u8 *m, u8 *p)
> +{
> +	/*
> +	 * We can operate only on MHz, this will make our life easier
> +	 * later.
> +	 */
> +	u32 freq_mhz = *freq / 1000000;
> +	u32 parent_freq_mhz = parent_rate / 1000000;
> +
> +	/*
> +	 * Round down the frequency to the closest multiple of either
> +	 * 6 or 16
> +	 */
> +	u32 round_freq_6 = round_down(freq_mhz, 6);
> +	u32 round_freq_16 = round_down(freq_mhz, 16);
> +
> +	if (round_freq_6 > round_freq_16)
> +		freq_mhz = round_freq_6;
> +	else
> +		freq_mhz = round_freq_16;
>
> +	*freq = freq_mhz * 1000000;
> +
> +	/*
> +	 * If the factors pointer are null, we were just called to
> +	 * round down the frequency.
> +	 * Exit.
> +	 */
> +	if (n == NULL)
> +		return;
> +
> +	/* If the frequency is a multiple of 32 MHz, k is always 3 */
> +	if (!(freq_mhz % 32))
> +		*k = 3;
> +	/* If the frequency is a multiple of 9 MHz, k is always 2 */
> +	else if (!(freq_mhz % 9))
> +		*k = 2;
> +	/* If the frequency is a multiple of 8 MHz, k is always 1 */
> +	else if (!(freq_mhz % 8))
> +		*k = 1;
> +	/* Otherwise, we don't use the k factor */
> +	else
> +		*k = 0;
> +
> +	/*
> +	 * If the frequency is a multiple of 2 but not a multiple of
> +	 * 3, m is 3. This is the first time we use 6 here, yet we
> +	 * will use it on several other places.
> +	 * We use this number because it's the lowest frequency we can
> +	 * generate (with n = 0, k = 0, m = 3), so every other frequency
> +	 * somehow relates to this frequency.
> +	 */
> +	if ((freq_mhz % 6) == 2 || (freq_mhz % 6) == 4)
> +		*m = 2;
> +	/*
> +	 * If the frequency is a multiple of 6MHz, but the factor is
> +	 * odd, m will be 3
> +	 */
> +	else if ((freq_mhz / 6) & 1)
> +		*m = 3;
> +	/* Otherwise, we end up with m = 1 */
> +	else
> +		*m = 1;
> +
> +	/* Calculate n thanks to the above factors we already got */
> +	*n = freq_mhz * (*m + 1) / ((*k + 1) * parent_freq_mhz) - 1;
> +
> +	/*
> +	 * If n end up being outbound, and that we can still decrease
> +	 * m, do it.
> +	 */
> +	if ((*n + 1) > 31 && (*m + 1) > 1) {
> +		*n = (*n + 1) / 2 - 1;
> +		*m = (*m + 1) / 2 - 1;
> +	}
> +}
>

And again, I'm purely nitpicking, but it'd be good to keep the space 
between functions consistent.

>   /**
>    * sun4i_get_apb1_factors() - calculates m, p factors for APB1
> @@ -190,6 +272,15 @@ static struct clk_factors_config sun4i_pll1_config = {
>   	.pwidth = 2,
>   };
>
> +static struct clk_factors_config sun6i_a31_pll1_config = {
> +	.nshift	= 8,
> +	.nwidth = 5,
> +	.kshift = 4,
> +	.kwidth = 2,
> +	.mshift = 0,
> +	.mwidth = 2,
> +};
> +
>   static struct clk_factors_config sun4i_apb1_config = {
>   	.mshift = 0,
>   	.mwidth = 5,
> @@ -202,6 +293,11 @@ static const __initconst struct factors_data sun4i_pll1_data = {
>   	.getter = sun4i_get_pll1_factors,
>   };
>
> +static const __initconst struct factors_data sun6i_a31_pll1_data = {
> +	.table = &sun6i_a31_pll1_config,
> +	.getter = sun6i_a31_get_pll1_factors,
> +};
> +
>   static const __initconst struct factors_data sun4i_apb1_data = {
>   	.table = &sun4i_apb1_config,
>   	.getter = sun4i_get_apb1_factors,
> @@ -244,6 +340,10 @@ static const __initconst struct mux_data sun4i_cpu_mux_data = {
>   	.shift = 16,
>   };
>
> +static const __initconst struct mux_data sun6i_a31_ahb1_mux_data = {
> +	.shift = 12,
> +};
> +
>   static const __initconst struct mux_data sun4i_apb1_mux_data = {
>   	.shift = 24,
>   };
> @@ -302,6 +402,12 @@ static const __initconst struct div_data sun4i_apb0_data = {
>   	.width	= 2,
>   };
>
> +static const __initconst struct div_data sun6i_a31_apb2_div_data = {
> +	.shift	= 0,
> +	.pow	= 0,
> +	.width	= 4,
> +};
> +
>   static void __init sunxi_divider_clk_setup(struct device_node *node,
>   					   struct div_data *data)
>   {
> @@ -352,6 +458,10 @@ static const __initconst struct gates_data sun5i_a13_ahb_gates_data = {
>   	.mask = {0x107067e7, 0x185111},
>   };
>
> +static const __initconst struct gates_data sun6i_a31_ahb1_gates_data = {
> +	.mask = {0xEDFE7F62, 0x794F931},
> +};
> +
>   static const __initconst struct gates_data sun4i_apb0_gates_data = {
>   	.mask = {0x4EF},
>   };
> @@ -376,6 +486,14 @@ static const __initconst struct gates_data sun5i_a13_apb1_gates_data = {
>   	.mask = {0xa0007},
>   };
>
> +static const __initconst struct gates_data sun6i_a31_apb1_gates_data = {
> +	.mask = {0x3031},
> +};
> +
> +static const __initconst struct gates_data sun6i_a31_apb2_gates_data = {
> +	.mask = {0x3F000F},
> +};
> +
>   static void __init sunxi_gates_clk_setup(struct device_node *node,
>   					 struct gates_data *data)
>   {
> @@ -428,6 +546,7 @@ static void __init sunxi_gates_clk_setup(struct device_node *node,
>   /* Matches for factors clocks */
>   static const __initconst struct of_device_id clk_factors_match[] = {
>   	{.compatible = "allwinner,sun4i-pll1-clk", .data = &sun4i_pll1_data,},
> +	{.compatible = "allwinner,sun6i-a31-pll1-clk", .data = &sun6i_a31_pll1_data,},
>   	{.compatible = "allwinner,sun4i-apb1-clk", .data = &sun4i_apb1_data,},
>   	{}
>   };
> @@ -437,6 +556,7 @@ static const __initconst struct of_device_id clk_div_match[] = {
>   	{.compatible = "allwinner,sun4i-axi-clk", .data = &sun4i_axi_data,},
>   	{.compatible = "allwinner,sun4i-ahb-clk", .data = &sun4i_ahb_data,},
>   	{.compatible = "allwinner,sun4i-apb0-clk", .data = &sun4i_apb0_data,},
> +	{.compatible = "allwinner,sun6i-a31-apb2-div-clk", .data = &sun6i_a31_apb2_div_data,},
>   	{}
>   };
>
> @@ -444,6 +564,7 @@ static const __initconst struct of_device_id clk_div_match[] = {
>   static const __initconst struct of_device_id clk_mux_match[] = {
>   	{.compatible = "allwinner,sun4i-cpu-clk", .data = &sun4i_cpu_mux_data,},
>   	{.compatible = "allwinner,sun4i-apb1-mux-clk", .data = &sun4i_apb1_mux_data,},
> +	{.compatible = "allwinner,sun6i-a31-ahb1-mux-clk", .data = &sun6i_a31_ahb1_mux_data,},
>   	{}
>   };
>
> @@ -453,12 +574,15 @@ static const __initconst struct of_device_id clk_gates_match[] = {
>   	{.compatible = "allwinner,sun4i-ahb-gates-clk", .data = &sun4i_ahb_gates_data,},
>   	{.compatible = "allwinner,sun5i-a10s-ahb-gates-clk", .data = &sun5i_a10s_ahb_gates_data,},
>   	{.compatible = "allwinner,sun5i-a13-ahb-gates-clk", .data = &sun5i_a13_ahb_gates_data,},
> +	{.compatible = "allwinner,sun6i-a31-ahb1-gates-clk", .data = &sun6i_a31_ahb1_gates_data,},
>   	{.compatible = "allwinner,sun4i-apb0-gates-clk", .data = &sun4i_apb0_gates_data,},
>   	{.compatible = "allwinner,sun5i-a10s-apb0-gates-clk", .data = &sun5i_a10s_apb0_gates_data,},
>   	{.compatible = "allwinner,sun5i-a13-apb0-gates-clk", .data = &sun5i_a13_apb0_gates_data,},
>   	{.compatible = "allwinner,sun4i-apb1-gates-clk", .data = &sun4i_apb1_gates_data,},
>   	{.compatible = "allwinner,sun5i-a10s-apb1-gates-clk", .data = &sun5i_a10s_apb1_gates_data,},
>   	{.compatible = "allwinner,sun5i-a13-apb1-gates-clk", .data = &sun5i_a13_apb1_gates_data,},
> +	{.compatible = "allwinner,sun6i-a31-apb1-gates-clk", .data = &sun6i_a31_apb1_gates_data,},
> +	{.compatible = "allwinner,sun6i-a31-apb2-gates-clk", .data = &sun6i_a31_apb2_gates_data,},
>   	{}
>   };
>
>

Thanks for working on this!

Emilio
