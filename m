Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbaAJPIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:08:48 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:46011 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaAJPIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:08:47 -0500
X-Auth-Info: oE77gCJ6hFmyV3gMzyi9DIB98Q06e+1hEyWDK0Uug8A=
Date: Fri, 10 Jan 2014 16:08:36 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: poeschel@lemonage.de, robh+dt@kernel.org, linus.walleij@linaro.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, rob@landley.net, galak@codeaurora.org,
        gnurou@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH v2] gpio: mcp23s08: Add irq functionality for i2c chips
Message-ID: <20140110150836.GZ20094@book.gsilab.sittig.org>
References: <1389363750-25989-1-git-send-email-larsi@wh2.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389363750-25989-1-git-send-email-larsi@wh2.tu-dresden.de>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 15:22 +0100, Lars Poeschel wrote:
> 
> --- a/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> +++ b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> @@ -38,12 +38,37 @@ Required device specific properties (only for SPI chips):
>      removed.
>  - spi-max-frequency = The maximum frequency this chip is able to handle
>  
> -Example I2C:
> +Optional properties:
> +- #interrupt-cells : Should be two.
> +  - first cell is the pin number
> +  - second cell is used to specify flags.
> +- interrupt-controller: Marks the device node as a interrupt controller.
> +NOTE: The interrupt functionality is only supported for i2c versions of the
> +chips yet.

Is this "IRQ feature for I2C chips only" limitation specific to
the hardware or an implementation detail of the Linux driver?  I
could not determine this from either the binding text nor the
driver source.

If it's just the status of the Linux driver, then it should not
be in the binding document.  If it's a limitation of the
hardware, then it's appropriate in the binding but I suggest to
adjust the text to avoid the next person to ask the same
question. :)


> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -697,6 +697,7 @@ config GPIO_MCP23S08
>  	  SPI/I2C driver for Microchip MCP23S08/MCP23S17/MCP23008/MCP23017
>  	  I/O expanders.
>  	  This provides a GPIO interface supporting inputs and outputs.
> +	  The I2C versions of the chips can be used as interrupt-controller.
>  
>  config GPIO_MC33880
>  	tristate "Freescale MC33880 high-side/low-side switch"
> diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
> index 2deb0c5..1346ea6 100644
> --- a/drivers/gpio/gpio-mcp23s08.c
> +++ b/drivers/gpio/gpio-mcp23s08.c
> @@ -1,5 +1,10 @@
>  /*
> - * MCP23S08 SPI/GPIO gpio expander driver
> + * MCP23S08 SPI/I2C GPIO gpio expander driver
> + *
> + * The inputs and outputs of the mcp23s08, mcp23s17, mcp23008 and mcp23017 are
> + * supported.
> + * For the I2C versions of the chips (mcp23008 and mcp23017) generation of
> + * interrupts is also supported.
>   */

Adjust these as well to reflect whether it's hardware or software
which limits the feature.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
