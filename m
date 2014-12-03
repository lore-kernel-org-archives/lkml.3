Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaLCOcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:32:55 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:14123 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbaLCOcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:32:54 -0500
Message-ID: <547F1F11.5090803@atmel.com>
Date: Wed, 3 Dec 2014 15:32:49 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH v3 02/11] mfd: syscon: Add Atmel Matrix bus DT binding
 documentation
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com> <1417429647-3419-3-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1417429647-3419-3-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 01/12/2014 11:27, Boris Brezillon a écrit :
> The Matrix registers are provided to configure internal bus behavior on
> at91 SoCs.
> Some registers might be access by several drivers (e.g. to configure
> external memory bus timings), hence we declare this register set as a
> syscon device.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>  .../devicetree/bindings/mfd/atmel-matrix.txt       | 24 ++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/atmel-matrix.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/atmel-matrix.txt b/Documentation/devicetree/bindings/mfd/atmel-matrix.txt
> new file mode 100644
> index 0000000..e56e27a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/atmel-matrix.txt
> @@ -0,0 +1,24 @@
> +* Device tree bindings for Atmel Bus Matrix
> +
> +The Bus Matrix registers are used to configure Atmel SoCs internal bus
> +behavior (master/slave priorities, undefined burst length type, ...)
> +
> +Required properties:
> +- compatible:		Should be one of the following
> +			"atmel,at91sam9260-matrix", "syscon"
> +			"atmel,at91sam9261-matrix", "syscon"
> +			"atmel,at91sam9263-matrix", "syscon"
> +			"atmel,at91sam9263-matrix", "syscon"

Same string as the preceding one: shouldn't it be at91sam9rl?


> +			"atmel,at91sam9g45-matrix", "syscon"
> +			"atmel,at91sam9n12-matrix", "syscon"
> +			"atmel,at91sam9x5-matrix", "syscon"
> +			"atmel,sama5d3-matrix", "syscon"
> +- reg:			Contains offset/length value of the Bus Matrix
> +			memory region.
> +
> +Example:
> +
> +matrix: matrix@ffffec00 {
> +	compatible = "atmel,sama5d3-matrix", "syscon";
> +	reg = <0xffffec00 0x200>;
> +};
> 


-- 
Nicolas Ferre
