Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab3AaUvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 15:51:40 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:64918 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab3AaUvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 15:51:37 -0500
MIME-Version: 1.0
In-Reply-To: <1359647903-15801-2-git-send-email-larsi@wh2.tu-dresden.de>
References: <1359647903-15801-1-git-send-email-larsi@wh2.tu-dresden.de>
	<1359647903-15801-2-git-send-email-larsi@wh2.tu-dresden.de>
Date: Thu, 31 Jan 2013 21:51:36 +0100
Message-ID: <CACRpkda_HjzWNMD1H_a_fsWtbRWuTDsutS8kndb9jY31qf7Yyg@mail.gmail.com>
Subject: Re: [PATCH RFC 1/1] gpio: mcp23s08: convert driver to DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: poeschel@lemonage.de, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, w.sang@pengutronix.de,
        ben-linux@fluff.org, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 4:58 PM, Lars Poeschel <larsi@wh2.tu-dresden.de> wrote:

> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> @@ -0,0 +1,27 @@
> +Microchip MCP2308/MCP23S08/MCP23017/MCP23S17 driver for
> +8-/16-bit I/O expander with serial interface (I2C/SPI)
> +
> +Required properties:
> +- compatible : Should be "mcp,mcp23s08-gpio", "mcp,mcp23s17-gpio",
> +                       "mcp,mcp23008-gpio" or "mcp,mcp23017-gpio"
> +- base : The first gpio number that should be assigned by this chip.

No. We do not tie the global GPIO numbers into the device tree.

In the DT GPIOs are referenced by ampersand <&gpio0 1 2>
notation referring to the instance, so as you realize DT itself
has no need for that number.

Further it is not OS-neutral.

You have to find another way to handle this in the driver code.
In worst case: use AUXDATA.

Yours,
Linus Walleij
