Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052AbaGPNTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:19:46 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:44026 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044AbaGPNTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:19:44 -0400
Message-ID: <53C67BF1.1070407@cogentembedded.com>
Date: Wed, 16 Jul 2014 17:19:45 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, balbi@ti.com,
        gregkh@linuxfoundation.org
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v3 2/4] usb: dwc3: dwc3-omap: Add dwc3_omap_map_offset()
 function
References: <1405516028-26500-1-git-send-email-george.cherian@ti.com> <1405516028-26500-3-git-send-email-george.cherian@ti.com>
In-Reply-To: <1405516028-26500-3-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/16/2014 05:07 PM, George Cherian wrote:

> Move map offset to its own seperate function.

    /seperate/separate/.

> Improve code readability, decrease the dwc3_probe() size.

> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   drivers/usb/dwc3/dwc3-omap.c | 33 ++++++++++++++++++++-------------
>   1 file changed, 20 insertions(+), 13 deletions(-)

> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
> index 999bdc8..09918ac 100644
> --- a/drivers/usb/dwc3/dwc3-omap.c
> +++ b/drivers/usb/dwc3/dwc3-omap.c
> @@ -378,6 +378,25 @@ static int dwc3_omap_vbus_notifier(struct notifier_block *nb,
>   	return NOTIFY_DONE;
>   }
>
> +static void dwc3_omap_map_offset(struct dwc3_omap *omap)
> +{
> +	struct device_node	*node = omap->dev->of_node;
> +
> +	/* Differentiate between OMAP5 and AM437x.
> +	 * For OMAP5(ES2.0) and AM437x wrapper revision is same  even

   I don't think removing comma before "even" was correct.

> +	 * though there are changes in wrapper register offsets.
> +	 * Using dt compatible to differentiate  AM437x.

    s/dt/DT/.

> +	 */
> +
> +	if (of_device_is_compatible(node, "ti,am437x-dwc3")) {
> +		omap->irq_eoi_offset = USBOTGSS_EOI_OFFSET;
> +		omap->irq0_offset = USBOTGSS_IRQ0_OFFSET;
> +		omap->irqmisc_offset = USBOTGSS_IRQMISC_OFFSET;
> +		omap->utmi_otg_offset = USBOTGSS_UTMI_OTG_OFFSET;
> +		omap->debug_offset = USBOTGSS_DEBUG_OFFSET;
> +	}
> +}
> +
>   static int dwc3_omap_probe(struct platform_device *pdev)
>   {
>   	struct device_node	*node = pdev->dev.of_node;
> @@ -442,19 +461,7 @@ static int dwc3_omap_probe(struct platform_device *pdev)
>   		goto err0;
>   	}
>
> -	/* Differentiate between OMAP5 and AM437x.
> -	 * For OMAP5(ES2.0) and AM437x wrapper revision is same, even
> -	 * though there are changes in wrapper register offsets.
> -	 * Using dt compatible to differentiate  AM437x.
> -	 */
> -
> -	if (of_device_is_compatible(node, "ti,am437x-dwc3")) {
> -		omap->irq_eoi_offset = USBOTGSS_EOI_OFFSET;
> -		omap->irq0_offset = USBOTGSS_IRQ0_OFFSET;
> -		omap->irqmisc_offset = USBOTGSS_IRQMISC_OFFSET;
> -		omap->utmi_otg_offset = USBOTGSS_UTMI_OTG_OFFSET;
> -		omap->debug_offset = USBOTGSS_DEBUG_OFFSET;
> -	}
> +	dwc3_omap_map_offset(omap);

WBR, Sergei

