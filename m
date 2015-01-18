Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbbARMy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 07:54:26 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:49949 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbbARMyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 07:54:23 -0500
Date: Sun, 18 Jan 2015 12:54:15 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/12] mfd: syscon: Add Atmel SMC binding doc
Message-ID: <20150118125415.GZ3574@x1>
References: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421252524-24452-5-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421252524-24452-5-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015, Alexandre Belloni wrote:

> From: Boris Brezillon <boris.brezillon@free-electrons.com>
> 
> The SMC registers are used to configure Atmel EBI (External Bus Interface)
> to interface with standard memory devices (NAND, NOR, SRAM or specialized
> devices like FPGAs).
> 
> Declare this memory region as a syscon, so that different drivers can
> configure the SMC interface (mostly timing configuration) according to
> their need.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>  Documentation/devicetree/bindings/mfd/atmel-smc.txt | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/atmel-smc.txt

Applied, thanks.
 
> diff --git a/Documentation/devicetree/bindings/mfd/atmel-smc.txt b/Documentation/devicetree/bindings/mfd/atmel-smc.txt
> new file mode 100644
> index 000000000000..26eeed373934
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/atmel-smc.txt
> @@ -0,0 +1,19 @@
> +* Device tree bindings for Atmel SMC (Static Memory Controller)
> +
> +The SMC registers are used to configure Atmel EBI (External Bus Interface)
> +to interface with standard memory devices (NAND, NOR, SRAM or specialized
> +devices like FPGAs).
> +
> +Required properties:
> +- compatible:		Should be one of the following
> +			"atmel,at91sam9260-smc", "syscon"
> +			"atmel,sama5d3-smc", "syscon"
> +- reg:			Contains offset/length value of the SMC memory
> +			region.
> +
> +Example:
> +
> +smc: smc@ffffc000 {
> +	compatible = "atmel,sama5d3-smc", "syscon";
> +	reg = <0xffffc000 0x1000>;
> +};

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
