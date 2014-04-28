Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbaD1Om1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:42:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47367 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaD1OmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:42:23 -0400
Message-ID: <535E689D.7010204@ti.com>
Date: Mon, 28 Apr 2014 20:11:33 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: =?UTF-8?B?R3VpZG8gTWFydMOtbmV6?= <guido@vanguardiasur.com.ar>,
        LKML <linux-kernel@vger.kernel.org>, <bcousson@baylibre.com>,
        <tony@atomide.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?B?RXplcXVpZWwgR2FyY8OtYQ==?= 
	<ezequiel@vanguardiasur.com.ar>
Subject: Re: [PATCH 1/4] ARM: dts: am335x-bone-common: use phandles for USB
 and DMA refs
References: <1398693512-5355-1-git-send-email-guido@vanguardiasur.com.ar>
In-Reply-To: <1398693512-5355-1-git-send-email-guido@vanguardiasur.com.ar>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/2014 7:28 PM, Guido Martínez wrote:
> Use phandles instead of unit adresses to reference usb and dma nodes.
> This makes the DT more robust and readable.
The series will give dtb build errors
Error: arch/arm/boot/dts/am335x-bone-common.dtsi:186.2-15 syntax error
FATAL ERROR: Unable to parse input tree
Error: arch/arm/boot/dts/am335x-evmsk.dts:367.2-15 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [arch/arm/boot/dts/am335x-bone.dtb] Error 1
make[1]: *** Waiting for unfinished jobs....
Error: arch/arm/boot/dts/am335x-evm.dts:334.2-15 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [arch/arm/boot/dts/am335x-evmsk.dtb] Error 1
make[1]: *** [arch/arm/boot/dts/am335x-evm.dtb] Error 1
Error: arch/arm/boot/dts/am335x-igep0033.dtsi:204.2-15 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [arch/arm/boot/dts/am335x-base0033.dtb] Error 1
Error: arch/arm/boot/dts/am335x-bone-common.dtsi:186.2-15 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [arch/arm/boot/dts/am335x-boneblack.dtb] Error 1
make: *** [dtbs] Error 2

>
> Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
> ---
>   arch/arm/boot/dts/am335x-bone-common.dtsi | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
> index 2e7d932..b95bc9a 100644
> --- a/arch/arm/boot/dts/am335x-bone-common.dtsi
> +++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
> @@ -183,28 +183,28 @@
>   &usb {
>   	status = "okay";
>   
> -	control@44e10620 {
> +	&usb_ctrl_mod {
>   		status = "okay";
>   	};
>   
> -	usb-phy@47401300 {
> +	&usb0_phy {
>   		status = "okay";
>   	};
>   
> -	usb-phy@47401b00 {
> +	&usb1_phy {
>   		status = "okay";
>   	};
>   
> -	usb@47401000 {
> +	&usb0 {
>   		status = "okay";
>   	};
>   
> -	usb@47401800 {
> +	&usb1 {
>   		status = "okay";
>   		dr_mode = "host";
>   	};
>   
> -	dma-controller@47402000  {
> +	&cppi41dma  {
>   		status = "okay";
>   	};
>   };
Instead the patch should be

      diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi 
b/arch/arm/boot/dts/am335x-bone-common.dtsi
      index 2e7d932..06be20a 100644
      --- a/arch/arm/boot/dts/am335x-bone-common.dtsi
      +++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
      @@ -182,31 +182,30 @@

       &usb {
              status = "okay";
      +};
      +&usb_ctrl_mod {
      +       status = "okay";
      +};

      -       control@44e10620 {
      -               status = "okay";
      -       };
      -
      -       usb-phy@47401300 {
      -               status = "okay";
      -       };
      +&usb0_phy {
      +       status = "okay";
      +};

      -       usb-phy@47401b00 {
      -               status = "okay";
      -       };
      +&usb1_phy {
      +       status = "okay";
      +};

      -       usb@47401000 {
      -               status = "okay";
      -       };
      +&usb {
      +       status = "okay";
      +};

      -       usb@47401800 {
      -               status = "okay";
      -               dr_mode = "host";
      -       };
      +&usb1 {
      +       status = "okay";
      +       dr_mode = "host";
      +};

      -       dma-controller@47402000  {
      -               status = "okay";
      -       };
      +&cppi41dma  {
      +       status = "okay";
       };



-- 
-George

