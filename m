Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab3FYNFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:05:10 -0400
Received: from multi.imgtec.com ([194.200.65.239]:21784 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab3FYNFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:05:09 -0400
Message-ID: <51C99581.2010403@imgtec.com>
Date: Tue, 25 Jun 2013 14:05:05 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/4] pinctrl: remove slew-rate parameter from tz1090
References: <201306251455.01540.heiko@sntech.de> <201306251456.36499.heiko@sntech.de>
In-Reply-To: <201306251456.36499.heiko@sntech.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_25_14_05_06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On 25/06/13 13:56, Heiko Stübner wrote:
> As the binding for slew-rate is under discussion and seems to need
> more tought it will get removed for now, so it doesn't get an offical

s/tought/thought/
s/offical/official/

> release.
> 
> Therefore remove it again from the only current user, tz1090.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---

<snip>

> diff --git a/drivers/pinctrl/pinctrl-tz1090-pdc.c b/drivers/pinctrl/pinctrl-tz1090-pdc.c
> index 12e4808..d4f12cc 100644
> --- a/drivers/pinctrl/pinctrl-tz1090-pdc.c
> +++ b/drivers/pinctrl/pinctrl-tz1090-pdc.c
> @@ -809,11 +809,6 @@ static int tz1090_pdc_pinconf_group_reg(struct pinctrl_dev *pctldev,
>  		*width = 1;
>  		*map = tz1090_pdc_boolean_map;
>  		break;
> -	case PIN_CONFIG_SLEW_RATE:
> -		*shift = REG_GPIO_CONTROL2_PDC_SR_S;
> -		*width = 1;
> -		*map = tz1090_pdc_boolean_map;
> -		break;
>  	case PIN_CONFIG_DRIVE_STRENGTH:
>  		*shift = REG_GPIO_CONTROL2_PDC_DR_S;
>  		*width = 2;
> diff --git a/drivers/pinctrl/pinctrl-tz1090.c b/drivers/pinctrl/pinctrl-tz1090.c
> index 02ff3a2..4edae08 100644
> --- a/drivers/pinctrl/pinctrl-tz1090.c
> +++ b/drivers/pinctrl/pinctrl-tz1090.c
> @@ -1834,11 +1834,6 @@ static int tz1090_pinconf_group_reg(struct pinctrl_dev *pctldev,
>  		*width = 1;
>  		*map = tz1090_boolean_map;
>  		break;
> -	case PIN_CONFIG_SLEW_RATE:
> -		*reg = REG_PINCTRL_SR;
> -		*width = 1;
> -		*map = tz1090_boolean_map;
> -		break;
>  	case PIN_CONFIG_DRIVE_STRENGTH:
>  		*reg = REG_PINCTRL_DR;
>  		*width = 2;
> 

I don't see the harm in keeping the handling of PIN_CONFIG_SLEW_RATE,
since PIN_CONFIG_SLEW_RATE is still present and you only seem to be
removing the device tree bindings (which is the only important bit from
the DT ABI point of view).

Cheers
James

