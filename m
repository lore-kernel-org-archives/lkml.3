Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaC0Ijk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 04:39:40 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:57976 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbaC0IjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 04:39:11 -0400
Message-ID: <5333E3A8.3050405@gmail.com>
Date: Thu, 27 Mar 2014 09:39:04 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Boris BREZILLON <brezillonboris@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
CC: devicetree@vger.kernel.org, Kevin Hilman <khilman@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: imx6/dt: add ccm dependency upon ckil, ckih1 and
 osc clocks
References: <5333DA13.2080505@gmail.com> <1395907913-23808-1-git-send-email-b.brezillon.dev@gmail.com>
In-Reply-To: <1395907913-23808-1-git-send-email-b.brezillon.dev@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 27/03/2014 09:11, Boris BREZILLON a écrit :
> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
> ---
>   arch/arm/boot/dts/imx6qdl.dtsi |    4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
> index cfc85be..060e94c 100644
> --- a/arch/arm/boot/dts/imx6qdl.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> @@ -62,16 +62,19 @@
>   
>   		ckil {
Oops.
You'll have to change this line into the line below in order to be able 
to reference this clk.

                           ckil: ckil {
>   			compatible = "fsl,imx-ckil", "fixed-clock";
> +			#clock-cells = <0>;
>   			clock-frequency = <32768>;
>   		};
>   
>   		ckih1 {
ditto
>   			compatible = "fsl,imx-ckih1", "fixed-clock";
> +			#clock-cells = <0>;
>   			clock-frequency = <0>;
>   		};
>   
>   		osc {
ditto
>   			compatible = "fsl,imx-osc", "fixed-clock";
> +			#clock-cells = <0>;
>   			clock-frequency = <24000000>;
>   		};
>   	};
> @@ -489,6 +492,7 @@
>   				interrupts = <0 87 IRQ_TYPE_LEVEL_HIGH>,
>   					     <0 88 IRQ_TYPE_LEVEL_HIGH>;
>   				#clock-cells = <1>;
> +				clocks = <&ckil &ckih1 &osc>;
>   			};
>   
>   			anatop: anatop@020c8000 {

