Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaFDIpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 04:45:34 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:49678 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750742AbaFDIpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 04:45:30 -0400
Message-ID: <538EDC98.2080700@atmel.com>
Date: Wed, 4 Jun 2014 16:45:12 +0800
From: Josh Wu <josh.wu@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: at91: #if 0 out ISI code for AT91SAM9263
References: <1400142868.20469.12.camel@x220>	 <F4C251BF-666E-4E89-A6F7-3D96A669A8D8@jcrosoft.com> <1400845814.31526.29.camel@x220>
In-Reply-To: <1400845814.31526.29.camel@x220>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Paul

On 5/23/2014 7:50 PM, Paul Bolle wrote:
> In v2.6.25 code was added for an Image Sensor Interface (ISI) for
> AT91SAM9263. That code depended on the Kconfig macro
> CONFIG_VIDEO_AT91_ISI and its MODULE variant. The related Kconfig symbol
> has never been added to the tree. The net effect of this was that
> at91_add_device_isi() was a NOP. No one noticed because no callers of
> that function were added to the tree at that time.
>
> The first caller of a function with that name was added in v3.4. But
> that caller apparently only called the function defined for AT91SAM9G45.
> (that function was also added in v3.4). So even then AT91SAM9263's NOP
> version of at91_add_device_isi() remained unused.
>
> This means that the ISI code for AT91SAM9263 could be removed. But,
> since it can be useful for future reference, let's "#if 0" it instead.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> v2: Jean-Christophe would like to keep the information currently hidden
> behind "#if defined(CONFIG_VIDEO_AT91_ISI) [...]". I'd like the
> reference to that Kconfig macro dropped. Using "#if 0" will do both, so
> that makes for a nice compromise, I'd say.

I think we can keep the #if 0 as a reference so far. When the devices 
file is finally removed. We will add the ISI resouces to DT file.
So I am ok with this.

Hi, J.C.

What do you think of this patch?

Best Regards,
Josh Wu
>
> Josh verified that this definition of at91_add_device_isi() never will
> be called. Thanks!
>
> Still untested!
>
>   arch/arm/mach-at91/at91sam9263_devices.c | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
> index 43d53d6156dd..30af3048ade5 100644
> --- a/arch/arm/mach-at91/at91sam9263_devices.c
> +++ b/arch/arm/mach-at91/at91sam9263_devices.c
> @@ -900,8 +900,7 @@ void __init at91_add_device_lcdc(struct atmel_lcdfb_pdata *data) {}
>    *  Image Sensor Interface
>    * -------------------------------------------------------------------- */
>   
> -#if defined(CONFIG_VIDEO_AT91_ISI) || defined(CONFIG_VIDEO_AT91_ISI_MODULE)
> -
> +#if 0 /* keep for future reference */
>   struct resource isi_resources[] = {
>   	[0] = {
>   		.start	= AT91SAM9263_BASE_ISI,
> @@ -947,9 +946,6 @@ void __init at91_add_device_isi(struct isi_platform_data *data,
>   		/* TODO: register the PCK for ISI_MCK and set its parent */
>   	}
>   }
> -#else
> -void __init at91_add_device_isi(struct isi_platform_data *data,
> -		bool use_pck_as_mck) {}
>   #endif
>   
>   

