Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaLRNjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 08:39:48 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:37620 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaLRNjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 08:39:47 -0500
Message-ID: <5492D91D.1060200@atmel.com>
Date: Thu, 18 Dec 2014 14:39:41 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Josh Wu <josh.wu@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/3] ARM: at91: Add Special Function Registers binding
 documentation
References: <1418895952-18186-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1418895952-18186-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 18/12/2014 10:45, Alexandre Belloni a écrit :
> The special function registers gather some registers that allow to tweak
> features provided by IPs controlled through another register range.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

It seems okay. For the whole series:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

And stacked on top of at91-3.20-dt.

But I will modify the size of the reg property to 0x60.

Thanks, bye.

> ---
> Changes in v4:
>  - corrected the chip list
> 
>  Documentation/devicetree/bindings/arm/atmel-at91.txt | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.txt b/Documentation/devicetree/bindings/arm/atmel-at91.txt
> index 562cda9d86d9..f39e312531f0 100644
> --- a/Documentation/devicetree/bindings/arm/atmel-at91.txt
> +++ b/Documentation/devicetree/bindings/arm/atmel-at91.txt
> @@ -136,3 +136,20 @@ Example:
>  		compatible = "atmel,at91sam9260-rstc";
>  		reg = <0xfffffd00 0x10>;
>  	};
> +
> +Special Function Registers (SFR)
> +
> +Special Function Registers (SFR) manage specific aspects of the integrated
> +memory, bridge implementations, processor and other functionality not controlled
> +elsewhere.
> +
> +required properties:
> +- compatible: Should be "atmel,<chip>-sfr", "syscon".
> +  <chip> can be "sama5d3" or "sama5d4".
> +- reg: Should contain registers location and length
> +
> +	sfr@f0038000 {
> +		compatible = "atmel,sama5d3-sfr", "syscon";
> +		reg = <0xf0038000 0x4000>;
> +	};
> +
> 


-- 
Nicolas Ferre
