Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbaELO71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:59:27 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:14643 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579AbaELO7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:59:25 -0400
Message-ID: <5370E1CA.8070707@atmel.com>
Date: Mon, 12 May 2014 16:59:22 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91: sam9260: fix compilation issues
References: <1399484748-32718-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1399484748-32718-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2014 19:45, Alexandre Belloni :
> Use the hexadecimal values for the triggers to match what is done for the device
> tree. This also fixes compilation issues as the defines have been moved
> elsewhere.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Ok, as anyway these files will disappear at some point...

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Added to at91-3.16-cleanup2. Thanks,

> ---
> I believe that at some point, we may want to reintroduce defines for those
> values but we should probably do that in a dt-bindings include and choose better
> names as the meaning differ between SoCs.
> 
>  arch/arm/mach-at91/at91sam9260_devices.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
> index fffcd09ac878..a8d0d9cb1bca 100644
> --- a/arch/arm/mach-at91/at91sam9260_devices.c
> +++ b/arch/arm/mach-at91/at91sam9260_devices.c
> @@ -1307,19 +1307,19 @@ static struct platform_device at91_adc_device = {
>  static struct at91_adc_trigger at91_adc_triggers[] = {
>  	[0] = {
>  		.name = "timer-counter-0",
> -		.value = AT91_ADC_TRGSEL_TC0 | AT91_ADC_TRGEN,
> +		.value = 0x1,
>  	},
>  	[1] = {
>  		.name = "timer-counter-1",
> -		.value = AT91_ADC_TRGSEL_TC1 | AT91_ADC_TRGEN,
> +		.value = 0x3,
>  	},
>  	[2] = {
>  		.name = "timer-counter-2",
> -		.value = AT91_ADC_TRGSEL_TC2 | AT91_ADC_TRGEN,
> +		.value = 0x5,
>  	},
>  	[3] = {
>  		.name = "external",
> -		.value = AT91_ADC_TRGSEL_EXTERNAL | AT91_ADC_TRGEN,
> +		.value = 0xd,
>  		.is_external = true,
>  	},
>  };
> 


-- 
Nicolas Ferre
