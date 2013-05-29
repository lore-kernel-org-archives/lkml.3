Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317Ab3E2Pw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:52:56 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:60709 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3E2Pwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:52:55 -0400
Date: Wed, 29 May 2013 16:52:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Subject: Re: [PATCH 2/4] ARM: u8540: Add device tree support for lp5521 leds
Message-ID: <20130529155249.GF3012@gmail.com>
References: <1369834407-30762-1-git-send-email-gabriel.fernandez.st@gmail.com>
 <1369834407-30762-3-git-send-email-gabriel.fernandez.st@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369834407-30762-3-git-send-email-gabriel.fernandez.st@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013, Gabriel Fernandez wrote:

> From: Gabriel Fernandez <gabriel.fernandez@st.com>
> 
> This patch adds DT probing of lp5521 leds for u8540.
> 
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
> ---
>  arch/arm/boot/dts/ccu8540-uib-v3.dts | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/ccu8540-uib-v3.dts b/arch/arm/boot/dts/ccu8540-uib-v3.dts
> index 4b4982e..422a292 100644
> --- a/arch/arm/boot/dts/ccu8540-uib-v3.dts
> +++ b/arch/arm/boot/dts/ccu8540-uib-v3.dts
> @@ -14,3 +14,25 @@
>  / {
>  	model = "ST-Ericsson U8540 platform with device tree UIB v3";
>  };
> +
> +&i2c2 {

I'm really not a fan of this syntax.

I only see it lending itself to more abstraction and obfuscation.

> +
> +	lp5521@32 {
> +		compatible = "national,lp5521";
> +		reg = <0x32>;
> +		label = "lp5521_pri";
> +		clock-mode = /bits/ 8 <2>;
> +		chan0 {
> +			led-cur = /bits/ 8 <0x2f>;
> +			max-cur = /bits/ 8 <0x5f>;
> +		};
> +		chan1 {
> +			led-cur = /bits/ 8 <0x2f>;
> +			max-cur = /bits/ 8 <0x5f>;
> +		};
> +		chan2 {
> +			led-cur = /bits/ 8 <0x2f>;
> +			max-cur = /bits/ 8 <0x5f>;
> +		};
> +	};
> +};

More odd tabbing above.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
