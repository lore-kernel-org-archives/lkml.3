Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3JBPwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:52:50 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:48469 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3JBPws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:52:48 -0400
Date: Wed, 2 Oct 2013 16:52:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, broonie@kernel.org, linus.walleij@linaro.org,
        akpm@linux-foundation.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, rtc-linux@googlegroups.com,
        rob.herring@calxeda.com, mark.rutland@arm.com, pawel.moll@arm.com,
        swarren@wwwdotorg.org, rob@landley.net, ijc+devicetree@hellion.org.uk,
        grant.likely@linaro.org, Florian Lobmaier <florian.lobmaier@ams.com>
Subject: Re: [PATCH V4 1/3] mfd: add support for ams AS3722 PMIC
Message-ID: <20131002155241.GN9048@lee--X1>
References: <1380729030-25896-1-git-send-email-ldewangan@nvidia.com>
 <1380729030-25896-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380729030-25896-2-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Oct 2013, Laxman Dewangan wrote:

> The ams AS3722 is a compact system PMU suitable for mobile phones,
> tablets etc. It has 4 DC/DC step-down regulators, 3 DC/DC step-down
> controller, 11 LDOs, RTC, automatic battery, temperature and
> over-current monitoring, 8 GPIOs, ADC and a watchdog.
> 
> Add MFD core driver for the AS3722 to support core functionality.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>
> ---
> Changes from V1:
> - Remove compatible string from DT for subnode.
> - Nit cleanups in driver and use module_i2c_driver
>         
> Changes from V2:
> - Change DT file to reflect the changes in gpio/pincntrl driver.
>   Now there is no extra subnode.
> 
> Changes from V3:
> - Combine DT of pincontrol and regulator to mfd.
> - Nits cleanups.
> - AMS to ams.
> 
>  Documentation/devicetree/bindings/mfd/as3722.txt |  174 +++++++++
>  drivers/mfd/Kconfig                              |   12 +
>  drivers/mfd/Makefile                             |    1 +
>  drivers/mfd/as3722.c                             |  449 ++++++++++++++++++++++
>  include/linux/mfd/as3722.h                       |  423 ++++++++++++++++++++
>  5 files changed, 1059 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/as3722.txt
>  create mode 100644 drivers/mfd/as3722.c
>  create mode 100644 include/linux/mfd/as3722.h

<snip>

> +Required properties:
> +-------------------
> +- compatible: Must be "ams,as3722".
> +- reg: I2C device address.
> +- interrupt-controller: AS3722 has internal interrupt controller which takes the
> +  interrupt request from  internal sub-blocks like RTC, regulators,

Silly nit: Attention to detail 'from..internal'.

> GPIOs as well

>80 chars

> +  as external input.
> +- #interrupt-cells: Should be set to 2 for IRQ number and flags.
> +  The first cell is the IRQ number.
> +  The second cell is the flags, encoded as the trigger masks from binding document

>80 chars

<snip>

> +Optional properties:
> +-------------------
> +The input supply of regulators are the optional properties on the
> +regulator node. The input supply of these regulators are provided
> +through following properties:
> +vsup-sd2-supply: Input supply for SD2.
> +vsup-sd3-supply: Input supply for SD3.
> +vsup-sd4-supply: Input supply for SD4.
> +vsup-sd5-supply: Input supply for SD5.
> +vin-ldo0-supply: Input supply for LDO0.
> +vin-ldo1-6-supply: Input supply for LDO1 and LDO6.
> +vin-ldo2-5-7-supply: Input supply for LDO2, LDO5 and LDO7.
> +vin-ldo3-4-supply: Input supply for LDO3 and LDO4.
> +vin-ldo9-10-supply: Input supply for LDO9 and LDO10.
> +vin-ldo11-supply: Input supply for LDO11.

Perhaps some indentation would be good here.

> +Optional sub nodes:
> +-----------------
> +	The subnodes name is the name of regulator and it must be one of:
> +	sd[0-6], ldo[0-7], ldo[9-11]
> +
> +	Each sub-node should contain the constraints and initialization
> +	information for that regulator. See regulator.txt for a description
> +	of standard properties for these sub-nodes.
> +	Additional custom properties  are listed below.

Silly nit: Attention to detail 'properties..are'.

<snip>

Besides all that stuff that's actually not all that important, the
code looks pretty good to me.

For the !DT MFD stuff:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
