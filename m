Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab3HWOY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 10:24:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:32895 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753947Ab3HWOY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 10:24:27 -0400
Date: Fri, 23 Aug 2013 15:24:21 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: "poeschel@lemonage.de" <poeschel@lemonage.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 1/2] gpio: mcp23s08: rename the device tree property
Message-ID: <20130823142421.GK25856@e106331-lin.cambridge.arm.com>
References: <1377165378-9589-1-git-send-email-larsi@wh2.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377165378-9589-1-git-send-email-larsi@wh2.tu-dresden.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 10:56:17AM +0100, Lars Poeschel wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
> 
> The device tree property should be more descriptive.
> microchip seems more reasonable than mcp. As there are no
> in tree users of this property, so the rename can still be
> done without pain.

Are there definitely no users? I see there are no dts with a
"mcp,mcp23***" compatible string, but are there any boards already out
there with this hardware that someone might be using and a currently
release kernel supports?

With the bcm/broadcom => brcm change, we marked the old vendor prefix as
deprecated (but left the support code).

If we can 100% guarantee no-one's using the compatible string, I'm happy
to change it. Otherwise we just have to mark the old string as
deprecated.

Thanks,
Mark.

> 
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> ---
>  .../devicetree/bindings/gpio/gpio-mcp23s08.txt         |   16 ++++++++--------
>  drivers/gpio/gpio-mcp23s08.c                           |   14 +++++++++-----
>  2 files changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> index 629d0ef..f207b7c 100644
> --- a/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> +++ b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> @@ -3,10 +3,10 @@ Microchip MCP2308/MCP23S08/MCP23017/MCP23S17 driver for
>  
>  Required properties:
>  - compatible : Should be
> -    - "mcp,mcp23s08" for  8 GPIO SPI version
> -    - "mcp,mcp23s17" for 16 GPIO SPI version
> -    - "mcp,mcp23008" for  8 GPIO I2C version or
> -    - "mcp,mcp23017" for 16 GPIO I2C version of the chip
> +    - "microchip,mcp23s08" for  8 GPIO SPI version
> +    - "microchip,mcp23s17" for 16 GPIO SPI version
> +    - "microchip,mcp23008" for  8 GPIO I2C version or
> +    - "microchip,mcp23017" for 16 GPIO I2C version of the chip
>  - #gpio-cells : Should be two.
>    - first cell is the pin number
>    - second cell is used to specify flags. Flags are currently unused.
> @@ -15,10 +15,10 @@ Required properties:
>          SPI uses this to specify the chipselect line which the chip is
>          connected to. The driver and the SPI variant of the chip support
>          multiple chips on the same chipselect. Have a look at
> -        mcp,spi-present-mask below.
> +        microchip,spi-present-mask below.
>  
>  Required device specific properties (only for SPI chips):
> -- mcp,spi-present-mask : This is a present flag, that makes only sense for SPI
> +- microchip,spi-present-mask : This is a present flag, that makes only sense for SPI
>          chips - as the name suggests. Multiple SPI chips can share the same
>          SPI chipselect. Set a bit in bit0-7 in this mask to 1 if there is a
>          chip connected with the corresponding spi address set. For example if
> @@ -30,7 +30,7 @@ Required device specific properties (only for SPI chips):
>  
>  Example I2C:
>  gpiom1: gpio@20 {
> -        compatible = "mcp,mcp23017";
> +        compatible = "microchip,mcp23017";
>          gpio-controller;
>          #gpio-cells = <2>;
>          reg = <0x20>;
> @@ -38,7 +38,7 @@ gpiom1: gpio@20 {
>  
>  Example SPI:
>  gpiom1: gpio@0 {
> -        compatible = "mcp,mcp23s17";
> +        compatible = "microchip,mcp23s17";
>          gpio-controller;
>          #gpio-cells = <2>;
>          spi-present-mask = <0x01>;
> diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
> index 6a4470b..73cf236 100644
> --- a/drivers/gpio/gpio-mcp23s08.c
> +++ b/drivers/gpio/gpio-mcp23s08.c
> @@ -483,10 +483,12 @@ fail:
>  #ifdef CONFIG_SPI_MASTER
>  static struct of_device_id mcp23s08_spi_of_match[] = {
>  	{
> -		.compatible = "mcp,mcp23s08", .data = (void *) MCP_TYPE_S08,
> +		.compatible = "microchip,mcp23s08",
> +		.data = (void *) MCP_TYPE_S08,
>  	},
>  	{
> -		.compatible = "mcp,mcp23s17", .data = (void *) MCP_TYPE_S17,
> +		.compatible = "microchip,mcp23s17",
> +		.data = (void *) MCP_TYPE_S17,
>  	},
>  	{ },
>  };
> @@ -496,10 +498,12 @@ MODULE_DEVICE_TABLE(of, mcp23s08_spi_of_match);
>  #if IS_ENABLED(CONFIG_I2C)
>  static struct of_device_id mcp23s08_i2c_of_match[] = {
>  	{
> -		.compatible = "mcp,mcp23008", .data = (void *) MCP_TYPE_008,
> +		.compatible = "microchip,mcp23008",
> +		.data = (void *) MCP_TYPE_008,
>  	},
>  	{
> -		.compatible = "mcp,mcp23017", .data = (void *) MCP_TYPE_017,
> +		.compatible = "microchip,mcp23017",
> +		.data = (void *) MCP_TYPE_017,
>  	},
>  	{ },
>  };
> @@ -621,7 +625,7 @@ static int mcp23s08_probe(struct spi_device *spi)
>  	if (match) {
>  		type = (int)match->data;
>  		status = of_property_read_u32(spi->dev.of_node,
> -				"mcp,spi-present-mask", &spi_present_mask);
> +			    "microchip,spi-present-mask", &spi_present_mask);
>  		if (status) {
>  			dev_err(&spi->dev, "DT has no spi-present-mask\n");
>  			return -ENODEV;
> -- 
> 1.7.10.4
> 
> 
