Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaKJJ4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:56:11 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:58774 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbaKJJ4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:56:07 -0500
Date: Mon, 10 Nov 2014 09:55:59 +0000
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
Subject: Re: [PATCH v2 02/11] mfd: syscon: Add Atmel Matrix bus DT binding
 documentation
Message-ID: <20141110095559.GI21424@x1>
References: <1415203287-21517-1-git-send-email-boris.brezillon@free-electrons.com>
 <1415203287-21517-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415203287-21517-3-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Nov 2014, Boris Brezillon wrote:

> The Matrix registers are provided to configure internal bus behavior on
> at91 SoCs.
> Some registers might be access by several drivers (e.g. to configure
> external memory bus timings), hence we declare this register set as a
> syscon device.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  .../devicetree/bindings/mfd/atmel-matrix.txt       | 24 ++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/atmel-matrix.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/atmel-matrix.txt b/Documentation/devicetree/bindings/mfd/atmel-matrix.txt
> new file mode 100644
> index 0000000..405cac9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/atmel-matrix.txt
> @@ -0,0 +1,24 @@
> +* Device tree bindings for Atmel Bus Matrix
> +
> +The Bus Matrix registers are used to configure Atmel SoCs internal bus
> +behavior (master/slave priorities, undefined burst length type, ...)
> +
> +Required properties:
> +- compatible:		should be one of the following
> +			"atmel,at91sam9260-matrix", "syscon"
> +			"atmel,at91sam9261-matrix", "syscon"
> +			"atmel,at91sam9263-matrix", "syscon"
> +			"atmel,at91sam9263-matrix", "syscon"
> +			"atmel,at91sam9g45-matrix", "syscon"
> +			"atmel,at91sam9n12-matrix", "syscon"
> +			"atmel,at91sam9x5-matrix", "syscon"
> +			"atmel,sama5d3-matrix", "syscon"
> +- reg:			contains offset/length value of the Bus Matrix
> +			memory region.

Same comments as before:

Acked-by: Lee Jones <lee.jones@linaro.org>

> +Example:
> +
> +matrix: matrix@ffffec00 {
> +	compatible = "atmel,sama5d3-matrix", "syscon";
> +	reg = <0xffffec00 0x200>;
> +};

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
