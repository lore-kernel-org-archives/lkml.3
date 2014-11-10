Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaKJJzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:55:11 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38893 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaKJJzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:55:08 -0500
Date: Mon, 10 Nov 2014 09:55:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/11] mfd: syscon: Add Atmel SMC binding doc
Message-ID: <20141110095502.GH21424@x1>
References: <1415203287-21517-1-git-send-email-boris.brezillon@free-electrons.com>
 <1415203287-21517-5-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415203287-21517-5-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Nov 2014, Boris Brezillon wrote:

> The SMC registers are used to configure Atmel EBI (External Bus Interface)
> to interface with standard memory devices (NAND, NOR, SRAM or specialized
> devices like FPGAs).
> 
> Declare this memory region as a syscon, so that different drivers can
> configure the SMC interface (mostly timing configuration) according to
> their need.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  Documentation/devicetree/bindings/mfd/atmel-smc.txt | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/atmel-smc.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/atmel-smc.txt b/Documentation/devicetree/bindings/mfd/atmel-smc.txt
> new file mode 100644
> index 0000000..0c0cc3d
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
> +- compatible:		should be one of the following
> +			"atmel,at91sam9260-smc", "syscon"
> +			"atmel,sama5d3-smc", "syscon"
> +- reg:			contains offset/length value of the SMC memory
> +			region.

I'd be happier if the sentences started with uppercase letters, but
nothing too offensive or controversial here:

Acked-by: Lee Jones <lee.jones@linaro.org>

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
