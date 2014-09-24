Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbaIXLGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:06:12 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:52127 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbaIXLGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:06:08 -0400
Date: Wed, 24 Sep 2014 12:06:02 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Johannes Pointner <johannes.pointner@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, AnilKumar Ch <anilkumar@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tps65217: add compatible string for subdevices
Message-ID: <20140924110602.GI19999@lee--X1>
References: <5439652.jHp5aCCfrZ@lenovobook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5439652.jHp5aCCfrZ@lenovobook>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014, Johannes Pointner wrote:

> The TPS65217 is missing of_compatible string in the mfd_cell for its
> subdevices. This compatible string is necessary to use functions like
> of_find_backlight_by_node in backlight.c.
> 
> Signed-off-by: Johannes Pointner <johannes.pointner@br-automation.com>
> ---
>  Documentation/devicetree/bindings/regulator/tps65217.txt            | 5 ++++-
>  .../devicetree/bindings/video/backlight/tps65217-backlight.txt      | 6 +++---
>  drivers/mfd/tps65217.c                                              | 2 ++
>  3 files changed, 9 insertions(+), 4 deletions(-)

[...]

> diff --git a/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt b/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
> index 5fb9279..c3fb649 100644
> --- a/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
> +++ b/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
> @@ -7,18 +7,18 @@ Required properties:
>  - compatible: "ti,tps65217"
>  - reg: I2C slave address
>  - backlight: node for specifying WLED1 and WLED2 lines in TPS65217
> +- compatible: "ti,tps65217-bl"

This is now confusing.  Please make it clear that this part of the
documentation is now referencing the sub-node.

>  - isel: selection bit, valid values: 1 for ISEL1 (low-level) and 2 for ISEL2 (high-level)
>  - fdim: PWM dimming frequency, valid values: 100, 200, 500, 1000
>  - default-brightness: valid values: 0-100
>  
> -Each regulator is defined using the standard binding for regulators.
> -
>  Example:
>  
>  	tps: tps@24 {
>  		reg = <0x24>;
>  		compatible = "ti,tps65217";
> -		backlight {
> +		tps_bl: backlight {
> +			compatible = "ti,tps65217-bl";
>  			isel = <1>;  /* 1 - ISET1, 2 ISET2 */
>  			fdim = <100>; /* TPS65217_BL_FDIM_100HZ */
>  			default-brightness = <50>;
> diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c

This shouldn't be in this patch.

Please adhere to: Documentation/devicetree/bindings/submitting-patches.txt

> index 3cc4c70..77708f9 100644
> --- a/drivers/mfd/tps65217.c
> +++ b/drivers/mfd/tps65217.c
> @@ -33,9 +33,11 @@
>  static const struct mfd_cell tps65217s[] = {
>  	{
>  		.name = "tps65217-pmic",
> +		.of_compatible = "ti,tps65217-pmic",
>  	},
>  	{
>  		.name = "tps65217-bl",
> +		.of_compatible = "ti,tps65217-bl",
>  	},
>  };
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
