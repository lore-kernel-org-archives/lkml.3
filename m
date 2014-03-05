Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaCEGW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 01:22:26 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:29015
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568AbaCEGWY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 01:22:24 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz98dIc89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097hz2dh87h2a8h839h947hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 5 Mar 2014 14:22:19 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@freescale.com>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH] ARM: dts: imx6qdl-sabresd.dtsi: Add heartbeat led
Message-ID: <20140305062216.GI8784@S2101-09.ap.freescale.net>
References: <1393943685-32579-1-git-send-email-vincent.stehle@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1393943685-32579-1-git-send-email-vincent.stehle@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 03:34:45PM +0100, Vincent Stehlé wrote:
> Use the red gpio led for heartbeat.

Some people think it's annoying to have a LED blinking all the time.
Since it's a user defined LED, let's leave it to users for their
particular use case.

Shawn

> 
> Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Sascha Hauer <kernel@pengutronix.de>
> ---
> 
> Hi,
> 
> This has been tested on Sabre SD i.MX6 Quad board, with linux v3.14-rc5+ and
> imx_v6_v7_defconfig.
> 
> As a side note, checkpatch.pl complains about gpio-leds being undocumented, but
> I am not sure what to do about that.
> 
> Best regards,
> 
> V.
> 
>  arch/arm/boot/dts/imx6qdl-sabresd.dtsi | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> index e75e11b..cf4d736 100644
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
> +		heartbeat-led {
> +		        label = "Heartbeat";
> +		        gpios = <&gpio1 2 0>;
> +		        linux,default-trigger = "heartbeat";
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
>  			>;
>  		};
>  	};
> -- 
> 1.9.0
> 
> 

