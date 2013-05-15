Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab3EOPYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:24:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44921 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758029Ab3EOPYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:24:22 -0400
Message-ID: <5193A875.1020000@ti.com>
Date: Wed, 15 May 2013 17:23:33 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 3/3] arm: dts: add bandgap entry for OMAP4460 devices
References: <1368629928-6723-1-git-send-email-eduardo.valentin@ti.com> <1368629928-6723-4-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1368629928-6723-4-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

On 05/15/2013 04:58 PM, Eduardo Valentin wrote:
> Include bandgap devices for OMAP4460 devices.
> 
> Cc: "Benoît Cousson" <b-cousson@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-omap@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  arch/arm/boot/dts/omap4460.dtsi | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/omap4460.dtsi b/arch/arm/boot/dts/omap4460.dtsi
> index 2cf227c..e5bfbfe 100644
> --- a/arch/arm/boot/dts/omap4460.dtsi
> +++ b/arch/arm/boot/dts/omap4460.dtsi
> @@ -29,4 +29,13 @@
>  			     <0 55 0x4>;
>  		ti,hwmods = "debugss";
>  	};
> +
> +	bandgap {
> +		reg = <0x4a002260 0x4
> +			0x4a00232C 0x4
> +			0x4a002378 0x18>;
> +		compatible = "ti,omap4460-bandgap";
> +		interrupts = <0 126 4>; /* talert */
> +		ti,tshut-gpio = <86>;

Why do you need a custom attribute for GPIO? Cannot you use the standard
one?

Where is the gpio controller phandle?

Usually it looks like this:

	gpios = <&gpio1 8 0>;


Regards,
Benoit

