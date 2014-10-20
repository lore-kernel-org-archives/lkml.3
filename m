Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaJTOz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:55:28 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37028 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaJTOz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:55:26 -0400
Message-ID: <54452259.4000402@gmail.com>
Date: Mon, 20 Oct 2014 16:55:21 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.1.2
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: berlin: Add GPIO leds to Google Chromecast
References: <1412351697-4079-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1412351697-4079-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2014 05:54 PM, Sebastian Hesselbarth wrote:
> With GPIO support for Marvell Berlin, now add the two gpio-connected
> LEDs on Google Chromecast.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Applied to berlin/dt.

> ---
>   arch/arm/boot/dts/berlin2cd-google-chromecast.dts | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
>
> diff --git a/arch/arm/boot/dts/berlin2cd-google-chromecast.dts b/arch/arm/boot/dts/berlin2cd-google-chromecast.dts
> index bcd81ffc495d..0816890a5c0d 100644
> --- a/arch/arm/boot/dts/berlin2cd-google-chromecast.dts
> +++ b/arch/arm/boot/dts/berlin2cd-google-chromecast.dts
> @@ -11,6 +11,7 @@
>   /dts-v1/;
>
>   #include "berlin2cd.dtsi"
> +#include <dt-bindings/gpio/gpio.h>
>
>   / {
>   	model = "Google Chromecast";
> @@ -24,6 +25,22 @@
>   		device_type = "memory";
>   		reg = <0x00000000 0x20000000>; /* 512 MB */
>   	};
> +
> +	leds {
> +		compatible = "gpio-leds";
> +
> +		white {
> +			label = "white";
> +			gpios = <&portc 1 GPIO_ACTIVE_HIGH>;
> +			default-state = "keep";
> +		};
> +
> +		red {
> +			label = "red";
> +			gpios = <&portc 2 GPIO_ACTIVE_HIGH>;
> +			default-state = "keep";
> +		};
> +	};
>   };
>
>   &uart0 { status = "okay"; };
>
