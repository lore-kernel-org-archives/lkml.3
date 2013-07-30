Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab3G3THX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 15:07:23 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:42130 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3G3THV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 15:07:21 -0400
Message-ID: <51F80EE9.30801@cogentembedded.com>
Date: Tue, 30 Jul 2013 23:07:21 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: linux-arm-kernel@lists.infradead.org, Emilio Lopez <emilio@elopez.com.ar>,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com
Subject: Re: [PATCH 08/10] ARM: sun7i: DT: Add UART muxing options to the
 DTSI
References: <1375196394-21138-1-git-send-email-maxime.ripard@free-electrons.com> <1375196394-21138-9-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1375196394-21138-9-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/30/2013 06:59 PM, Maxime Ripard wrote:

> The UARTs on the A20 can be muxed to several pins. Add a few options to
> the DTSI so that we can start using them in the boards' DT.

> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>   arch/arm/boot/dts/sun7i-a20.dtsi | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)

> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
> index 704fca9..9f45e8d 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -70,6 +70,27 @@
>   			#address-cells = <1>;
>   			#size-cells = <0>;
>   			#gpio-cells = <3>;
> +
> +			uart0_pins_a: uart0@0 {

    Why have address part of the node name if there's not "reg" property?
And the preferred node name is "serial", not "uart", according to the ePAPR 
spec (http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf).

> +				allwinner,pins = "PB22", "PB23";
> +				allwinner,function = "uart0";
> +				allwinner,drive = <0>;
> +				allwinner,pull = <0>;
> +			};
> +
> +			uart6_pins_a: uart6@0 {
> +				allwinner,pins = "PI12", "PI13";
> +				allwinner,function = "uart6";
> +				allwinner,drive = <0>;
> +				allwinner,pull = <0>;
> +			};
> +
> +			uart7_pins_a: uart7@0 {
> +				allwinner,pins = "PI20", "PI21";
> +				allwinner,function = "uart7";
> +				allwinner,drive = <0>;
> +				allwinner,pull = <0>;
> +			};

WBR, Sergei

