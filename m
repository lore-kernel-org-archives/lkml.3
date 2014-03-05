Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaCELmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:42:38 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:13991
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755787AbaCELme convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:42:34 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz98dIc89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz8275ch1de098h17326ah8275bh8275dh1de097h186068hz2dh87h2a8h839h947hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 5 Mar 2014 19:42:28 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@freescale.com>
CC: Sascha Hauer <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2] ARM: dts: imx6qdl-sabresd.dtsi: Add red led
Message-ID: <20140305114223.GN8784@S2101-09.ap.freescale.net>
References: <20140305062216.GI8784@S2101-09.ap.freescale.net>
 <1394007383-21874-1-git-send-email-vincent.stehle@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1394007383-21874-1-git-send-email-vincent.stehle@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 09:16:23AM +0100, Vincent Stehlé wrote:
> Make the red gpio led available to the user.
> 
> This can be toggled with the sysfs for example, or used as a heartbeat or mmc
> activity light by changing the trigger.
> 
> Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Sascha Hauer <kernel@pengutronix.de>
> 
> ---
> 
> Hi Shawn,
> 
> Thanks for your feedback.
> 
> If you don't want to make the led a heartbeat by default, here is v2 of the
> patch, which only makes the led available to the user. One is then free to use
> it as a heartbeat, or something else. Do you prefer it this way?
> 
> Best regards,
> 
> V.
> 
> 
> Changes since v1:
> - Do not make it a heartbeat by default.
> 
>  arch/arm/boot/dts/imx6qdl-sabresd.dtsi | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> index e75e11b..210a8df 100644
> --- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> @@ -88,6 +88,16 @@
>  		default-brightness-level = <7>;
>  		status = "okay";
>  	};
> +
> +	leds {
> +		compatible = "gpio-leds";
> +
> +		red {
> +		        gpios = <&gpio1 2 0>;
> +		        linux,default-trigger = "none";

Per Documentation/devicetree/bindings/leds/common.txt, 'none' is not a
valid value of property 'linux,default-trigger'.  I suggest you simply
drop the property.

> +		        default-state = "on";
> +		};
> +	};
>  };
>  
>  &audmux {
> @@ -182,6 +192,7 @@
>  				MX6QDL_PAD_ENET_TXD1__GPIO1_IO29 0x80000000
>  				MX6QDL_PAD_EIM_D22__GPIO3_IO22  0x80000000
>  				MX6QDL_PAD_ENET_CRS_DV__GPIO1_IO25 0x80000000
> +				MX6QDL_PAD_GPIO_2__GPIO1_IO02 0x80000000

It's not a hog pin, so shouldn't be added here.  (Right, most of the
existing pins shouldn't be here from the beginning)

The patch from Liu Ying [1] could be a good example on this regard.

Shawn

[1] http://www.spinics.net/lists/arm-kernel/msg308999.html

>  			>;
>  		};
>  	};
> -- 
> 1.9.0
> 
> 

