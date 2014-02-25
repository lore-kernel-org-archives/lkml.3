Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaBYNUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 08:20:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.131]:49359 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaBYNUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 08:20:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
Subject: Re: [PATCH v8 1/6] dt-bindings: sram: describe option to reserve parts of the memory
Date: Tue, 25 Feb 2014 14:19:30 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        arm@kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>, devicetree@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Sachin Kamat <sachin.kamat@linaro.org>
References: <21117503.1c6iOkvYSr@phil> <126672712.tufE5adZWC@phil>
In-Reply-To: <126672712.tufE5adZWC@phil>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201402251419.31151.arnd@arndb.de>
X-Provags-ID: V02:K0:QsJ4CnxIZGugB/KrTrTrQh1sD4qPNrOiVs9HPkhDQ2X
 0oO1MXNSABuvVQePMT8rH1NA1dgt3I03z7AYdGrHLW67vXrZHo
 Do0lc7gknRNo2rpajYJ3WQyZm297gP18FAWI+ZjhVtr3vu0wii
 LWV3K5S49rK7FuugN1zywSDS7anH03bKyTfqHGr7rLqTea8Gsi
 pai70wiChJaJ8F62gFVVcB5mgjmU8ZbY8S39IPct7N5c8yr9yW
 QccrqSV7OuhHt6r8mBWMaVo1hIGPefxYPD/XpE9eeB3t9aKFOD
 nXtpgYRF0QgFxcMWevuce/HB/4o8EziYrzLYeqJmDcrrAhm5L9
 fsSaDlifg5uvcU+yolSw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 February 2014, Heiko Stübner wrote:
> Some SoCs need parts of their sram for special purposes. So while being part
> of the peripheral, it should not be part of the genpool controlling the sram.
> 
> Therefore add the option to define reserved regions as subnodes of the
> sram-node similar to defining reserved global memory regions.

[adding Sachin Kamat to Cc, he just had the same issue]

> Originally
> Suggested-by: Rob Herring <robherring2@gmail.com>
> 
> Using subnodes for reserved regions
> Suggested-by: Grant Likely <grant.likely@linaro.org>
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Tested-by: Ulrich Prinz <ulrich.prinz@googlemail.com>
> ---
>  Documentation/devicetree/bindings/misc/sram.txt | 33 +++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/misc/sram.txt b/Documentation/devicetree/bindings/misc/sram.txt
> index 4d0a00e..2d83758 100644
> --- a/Documentation/devicetree/bindings/misc/sram.txt
> +++ b/Documentation/devicetree/bindings/misc/sram.txt
> @@ -8,9 +8,42 @@ Required properties:
>  
>  - reg : SRAM iomem address range
>  
> +Reserving sram areas:
> +---------------------
> +
> +Each child of the sram node specifies a region of reserved memory. Each
> +child node should use a 'reg' property to specify a specific range of
> +reserved memory.
> +
> +Following the generic-names recommended practice, node names should
> +reflect the purpose of the node. Unit address (@<address>) should be
> +appended to the name.
> +
> +Required properties in the sram node:
> +
> +- #address-cells, #size-cells : should use the same values as the root node
> +- ranges : standard definition, should be empty

I think we should rather define the 'ranges' property to translate from
addresses within the sram to bus addresses.

> +Required properties in the area nodes:
> +
> +- reg : iomem address range
> +
> +Optional properties in the area nodes:
> +
> +- compatible : standard definition
> +

Is this enough? Normally we should define a list of "compatible" strings
that people can add to, but not have an anything-allowed option.

>  Example:
>  
>  sram: sram@5c000000 {
>  	compatible = "mmio-sram";
>  	reg = <0x5c000000 0x40000>; /* 256 KiB SRAM at address 0x5c000000 */
> +
> +	#adress-cells = <1>;
> +	#size-cells = <1>;
> +	ranges;
> +
> +	smp-sram@5c000100 {
> +		compatible = "socvendor,smp-sram";
> +		reg = <0x5c000100 0x50>;
> +	};
>  };


