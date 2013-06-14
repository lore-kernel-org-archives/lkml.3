Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3FNSKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 14:10:05 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:60141 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab3FNSKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 14:10:03 -0400
Message-ID: <51BB5C6D.5070308@elopez.com.ar>
Date: Fri, 14 Jun 2013 15:09:49 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin@allwinnertech.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com
Subject: Re: [linux-sunxi] [PATCH 5/6] ARM: sunxi: Add Olimex A10s-Olinuxino-micro
 device tree
References: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com> <1370795767-9769-6-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1370795767-9769-6-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

El 09/06/13 13:36, Maxime Ripard escribió:
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts | 75 ++++++++++++++++++++++++
>  1 file changed, 75 insertions(+)
>  create mode 100644 arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts

Please add this on the sunxi target in arch/arm/boot/dts/Makefile so it
gets built on make dtbs.

(snip)

> +	leds {
> +		compatible = "gpio-leds";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&led_pins_olinuxino>;
> +
> +		power {
> +			gpios = <&pio 4 3 0>;
> +			default-state = "on";
> +		};

Also, as discussed on IRC, I think it would be wise to change the name
on the LED node. The schematics have a 'power' led already that is
hard-wired to 3.3v, and this led node that you are declaring is referred
as 'led1' there. I suppose 'green' would be a suitable name to keep
consistency with other sunxi boards (namely cubieboard).

Other than that, my OLinuXino worked just fine after applying this
patchset, so

Tested-by: Emilio López <emilio@elopez.com.ar>

Thanks!

Emilio
