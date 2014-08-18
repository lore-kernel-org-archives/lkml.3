Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaHRSqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:46:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33243 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbaHRSqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:46:15 -0400
Message-ID: <53F249F3.9070402@ti.com>
Date: Mon, 18 Aug 2014 13:46:11 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <inux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: DRA7: fix interrupt-cells for GPIO
References: <1406748032-19417-1-git-send-email-nm@ti.com>
In-Reply-To: <1406748032-19417-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 02:20 PM, Nishanth Menon wrote:
> GPIO modules are also interrupt sources. However, they require both the
> GPIO number and IRQ type to function properly.
> 
> By declaring that GPIO uses interrupt-cells=<1>, we essentially do not
> allow users of the nodes to use the interrupt property appropritely.
> 
> With this change, the following now works:
> 
> interrupt-parent = <&gpio6>;
> interrupts = <5 IRQ_TYPE_LEVEL_LOW>;
> 
> Fixes: 6e58b8f1daaf ('ARM: dts: DRA7: Add the dts files for dra7 SoC and dra7-evm board')
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> Based on v3.16-rc7
> 
>  arch/arm/boot/dts/dra7.dtsi |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Tony,
Gentle ping. we still have this issue on 3.17-rc1. any suggestions on
if we can pick this up during RC?

> 
> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index 8012763..f21ef39 100644
> --- a/arch/arm/boot/dts/dra7.dtsi
> +++ b/arch/arm/boot/dts/dra7.dtsi
> @@ -172,7 +172,7 @@
>  			gpio-controller;
>  			#gpio-cells = <2>;
>  			interrupt-controller;
> -			#interrupt-cells = <1>;
> +			#interrupt-cells = <2>;
>  		};
>  
>  		gpio2: gpio@48055000 {
> @@ -183,7 +183,7 @@
>  			gpio-controller;
>  			#gpio-cells = <2>;
>  			interrupt-controller;
> -			#interrupt-cells = <1>;
> +			#interrupt-cells = <2>;
>  		};
>  
>  		gpio3: gpio@48057000 {
> @@ -194,7 +194,7 @@
>  			gpio-controller;
>  			#gpio-cells = <2>;
>  			interrupt-controller;
> -			#interrupt-cells = <1>;
> +			#interrupt-cells = <2>;
>  		};
>  
>  		gpio4: gpio@48059000 {
> @@ -205,7 +205,7 @@
>  			gpio-controller;
>  			#gpio-cells = <2>;
>  			interrupt-controller;
> -			#interrupt-cells = <1>;
> +			#interrupt-cells = <2>;
>  		};
>  
>  		gpio5: gpio@4805b000 {
> @@ -216,7 +216,7 @@
>  			gpio-controller;
>  			#gpio-cells = <2>;
>  			interrupt-controller;
> -			#interrupt-cells = <1>;
> +			#interrupt-cells = <2>;
>  		};
>  
>  		gpio6: gpio@4805d000 {
> @@ -227,7 +227,7 @@
>  			gpio-controller;
>  			#gpio-cells = <2>;
>  			interrupt-controller;
> -			#interrupt-cells = <1>;
> +			#interrupt-cells = <2>;
>  		};
>  
>  		gpio7: gpio@48051000 {
> @@ -238,7 +238,7 @@
>  			gpio-controller;
>  			#gpio-cells = <2>;
>  			interrupt-controller;
> -			#interrupt-cells = <1>;
> +			#interrupt-cells = <2>;
>  		};
>  
>  		gpio8: gpio@48053000 {
> @@ -249,7 +249,7 @@
>  			gpio-controller;
>  			#gpio-cells = <2>;
>  			interrupt-controller;
> -			#interrupt-cells = <1>;
> +			#interrupt-cells = <2>;
>  		};
>  
>  		uart1: serial@4806a000 {
> 


-- 
Regards,
Nishanth Menon
